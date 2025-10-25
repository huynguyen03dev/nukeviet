<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_DICTIONARY_ADMIN')) {
    exit('Stop!!!');
}

$page_title = $nv_Lang->getModule('add');

// Default form data
$data = [
    'headword' => '',
    'slug' => '',
    'pos' => '',
    'phonetic' => '',
    'meaning_vi' => '',
    'notes' => ''
];

$errors = [];

// Check for errors from redirect (PRG pattern)
if (isset($_SESSION['dictionary_form_errors'])) {
    $errors = $_SESSION['dictionary_form_errors'];
    unset($_SESSION['dictionary_form_errors']);
}

// Check for form data from redirect (PRG pattern)
if (isset($_SESSION['dictionary_form_data'])) {
    $data = array_merge($data, $_SESSION['dictionary_form_data']);
    unset($_SESSION['dictionary_form_data']);
}

// Handle submit
if ($nv_Request->isset_request('submit', 'post')) {
    $checkss = $nv_Request->get_title('checkss', 'post', '');
    if ($checkss !== md5(NV_CHECK_SESSION)) {
        $errors[] = $nv_Lang->getGlobal('security_error');
    }

    $data['headword'] = trim($nv_Request->get_title('headword', 'post', ''));
    $data['slug'] = trim($nv_Request->get_title('slug', 'post', ''));
    $data['pos'] = trim($nv_Request->get_title('pos', 'post', ''));
    $data['phonetic'] = trim($nv_Request->get_title('phonetic', 'post', ''));
    $data['meaning_vi'] = trim($nv_Request->get_string('meaning_vi', 'post', ''));
    $data['notes'] = trim($nv_Request->get_string('notes', 'post', ''));

    // Validation
    if ($data['headword'] === '') {
        $errors[] = $nv_Lang->getModule('error_empty_headword');
    }
    if ($data['meaning_vi'] === '') {
        $errors[] = $nv_Lang->getModule('error_empty_meaning');
    }

    // ===== AUDIO UPLOAD HANDLING (Task 1.1-1.3) =====
    // Instantiate Upload class for audio files
    // Use 'audio' section from mime.ini which includes mp3, wav, and other audio formats
    $upload = new \NukeViet\Files\Upload(
        ['audio'],
        $global_config['forbid_extensions'],
        $global_config['forbid_mimes'],
        5 * 1024 * 1024 // 5MB max
    );
    $upload->setLanguage(\NukeViet\Core\Language::$lang_global);

    // Task 1.2: Validate and process headword audio file (if uploaded)
    $headword_audio_temp_file = null;
    if (isset($_FILES['audio']) && $_FILES['audio']['error'] !== UPLOAD_ERR_NO_FILE) {
        $upload_info = $upload->save_file($_FILES['audio'], NV_ROOTDIR . '/' . NV_TEMP_DIR, false);
        if (empty($upload_info['error'])) {
            $headword_audio_temp_file = $upload_info['name'];
        } else {
            $errors[] = $upload_info['error'];
        }
        nv_deletefile($_FILES['audio']['tmp_name']);
    }

    // Task 1.3: Validate and process example audio files (if uploaded)
    $example_audio_temp_files = [];
    if (isset($_FILES['ex_audio']) && is_array($_FILES['ex_audio']['name'])) {
        foreach ($_FILES['ex_audio']['error'] as $idx => $error) {
            if ($error === UPLOAD_ERR_NO_FILE) {
                $example_audio_temp_files[$idx] = null;
                continue;
            }

            // Restructure multiple file array to single file format for Upload class
            $single_file = [
                'name' => $_FILES['ex_audio']['name'][$idx],
                'type' => $_FILES['ex_audio']['type'][$idx],
                'tmp_name' => $_FILES['ex_audio']['tmp_name'][$idx],
                'error' => $_FILES['ex_audio']['error'][$idx],
                'size' => $_FILES['ex_audio']['size'][$idx]
            ];

            $upload_info = $upload->save_file($single_file, NV_ROOTDIR . '/' . NV_TEMP_DIR, false);
            if (empty($upload_info['error'])) {
                $example_audio_temp_files[$idx] = $upload_info['name'];
            } else {
                $errors[] = sprintf($nv_Lang->getModule('error_audio_upload_failed') . ' (Example #%d)', $idx + 1);
            }
            if (isset($_FILES['ex_audio']['tmp_name'][$idx])) {
                nv_deletefile($_FILES['ex_audio']['tmp_name'][$idx]);
            }
        }
    }

    // If there are validation errors, store in session and redirect (PRG pattern)
    if (!empty($errors)) {
        $_SESSION['dictionary_form_errors'] = $errors;
        $_SESSION['dictionary_form_data'] = $data;
        nv_redirect_location(
            NV_BASE_ADMINURL . 'index.php?'
            . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
            . '&' . NV_NAME_VARIABLE . '=' . $module_name
            . '&' . NV_OP_VARIABLE . '=entry_add'
        );
    }

    // Generate slug if empty
    if ($data['slug'] === '' && $data['headword'] !== '') {
        $data['slug'] = change_alias($data['headword']);
    }
    // Normalize slug
    $data['slug'] = strtolower($data['slug']);

    // Ensure slug unique
    if ($data['slug'] !== '') {
        $base_slug = $data['slug'];
        $i = 1;
        $stmt = $db->prepare('SELECT COUNT(*) FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE slug = :slug');
        while (true) {
            $stmt->bindValue(':slug', $data['slug'], PDO::PARAM_STR);
            $stmt->execute();
            $exists = (int) $stmt->fetchColumn();
            if ($exists === 0) {
                break;
            }
            $data['slug'] = $base_slug . '-' . $i;
            $i++;
        }
    }

    // ===== DATABASE OPERATIONS =====
    try {
        $created_at = NV_CURRENTTIME;
        $updated_at = NV_CURRENTTIME;
        
        // Step 1: Insert entry WITHOUT audio_file first (will update after file is moved)
        $sql = 'INSERT INTO ' . NV_DICTIONARY_GLOBALTABLE . '_entries
            (headword, slug, pos, phonetic, meaning_vi, notes, audio_file, created_at, updated_at)
            VALUES (:headword, :slug, :pos, :phonetic, :meaning_vi, :notes, :audio_file, :created_at, :updated_at)';
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':headword', $data['headword'], PDO::PARAM_STR);
        $stmt->bindParam(':slug', $data['slug'], PDO::PARAM_STR);
        $stmt->bindParam(':pos', $data['pos'], PDO::PARAM_STR);
        $stmt->bindParam(':phonetic', $data['phonetic'], PDO::PARAM_STR);
        $stmt->bindParam(':meaning_vi', $data['meaning_vi'], PDO::PARAM_STR);
        $stmt->bindParam(':notes', $data['notes'], PDO::PARAM_STR);
        $stmt->bindValue(':audio_file', null, PDO::PARAM_NULL);
        $stmt->bindParam(':created_at', $created_at, PDO::PARAM_INT);
        $stmt->bindParam(':updated_at', $updated_at, PDO::PARAM_INT);
        $stmt->execute();

        $entry_id = (int) $db->lastInsertId();
        
        // Task 1.4: Handle headword audio file move logic after database INSERT
        if ($headword_audio_temp_file !== null) {
            $targetDir = NV_ROOTDIR . '/uploads/' . $module_name . '/audio';
            if (!is_dir($targetDir)) {
                if (!is_dir(NV_ROOTDIR . '/uploads/' . $module_name)) {
                    nv_mkdir(NV_ROOTDIR . '/uploads', $module_name);
                }
                nv_mkdir(NV_ROOTDIR . '/uploads/' . $module_name, 'audio');
            }

            $file_ext = strtolower(pathinfo($headword_audio_temp_file, PATHINFO_EXTENSION));
            $final_filename = $entry_id . '_' . nv_genpass(8) . '.' . $file_ext;
            $final_path = $targetDir . '/' . $final_filename;
            
            if (rename($headword_audio_temp_file, $final_path)) {
                // File moved successfully, update database with final filename
                $sql_update = 'UPDATE ' . NV_DICTIONARY_GLOBALTABLE . '_entries SET audio_file = :audio_file WHERE id = :id';
                $stmt_update = $db->prepare($sql_update);
                $stmt_update->bindParam(':audio_file', $final_filename, PDO::PARAM_STR);
                $stmt_update->bindParam(':id', $entry_id, PDO::PARAM_INT);
                $stmt_update->execute();
            } else {
                // File move failed - log error but don't block operation
                trigger_error('[Dictionary Upload] Failed to move headword audio from ' . basename($headword_audio_temp_file) . ' to final location', E_USER_WARNING);
                nv_deletefile($headword_audio_temp_file);
            }
        }

        // Step 2: Insert examples (if provided)
        $ex_sentences = isset($_POST['ex_sentence_en']) && is_array($_POST['ex_sentence_en']) ? $_POST['ex_sentence_en'] : [];
        $ex_trans = isset($_POST['ex_translation_vi']) && is_array($_POST['ex_translation_vi']) ? $_POST['ex_translation_vi'] : [];

        if (!empty($ex_sentences)) {
            $sql_ex = 'INSERT INTO ' . NV_DICTIONARY_GLOBALTABLE . '_examples
                (entry_id, sentence_en, translation_vi, audio_file, sort, created_at)
                VALUES (:entry_id, :sentence_en, :translation_vi, :audio_file, :sort, :created_at)';
            $stmt_ex = $db->prepare($sql_ex);

            $sort = 0;
            foreach ($ex_sentences as $idx => $sentence) {
                $sentence = trim($sentence);
                $translation = isset($ex_trans[$idx]) ? trim($ex_trans[$idx]) : '';
                if ($sentence === '') {
                    continue;
                }
                $sort++;
                
                // Task 1.5: Handle example audio file move logic
                $example_audio_filename = null;
                if (isset($example_audio_temp_files[$idx]) && $example_audio_temp_files[$idx] !== null) {
                    $targetDir = NV_ROOTDIR . '/uploads/' . $module_name . '/audio';
                    if (!is_dir($targetDir)) {
                        if (!is_dir(NV_ROOTDIR . '/uploads/' . $module_name)) {
                            nv_mkdir(NV_ROOTDIR . '/uploads', $module_name);
                        }
                        nv_mkdir(NV_ROOTDIR . '/uploads/' . $module_name, 'audio');
                    }

                    $file_ext = strtolower(pathinfo($example_audio_temp_files[$idx], PATHINFO_EXTENSION));
                    $final_filename = $entry_id . '_ex_' . $sort . '_' . nv_genpass(8) . '.' . $file_ext;
                    $final_path = $targetDir . '/' . $final_filename;
                    
                    if (rename($example_audio_temp_files[$idx], $final_path)) {
                        // File moved successfully
                        $example_audio_filename = $final_filename;
                    } else {
                        // File move failed - log but set audio_file to NULL
                        trigger_error('[Dictionary Upload] Failed to move example audio from ' . basename($example_audio_temp_files[$idx]) . ' to final location', E_USER_WARNING);
                        nv_deletefile($example_audio_temp_files[$idx]);
                        $example_audio_filename = null;
                    }
                }
                
                $stmt_ex->bindParam(':entry_id', $entry_id, PDO::PARAM_INT);
                $stmt_ex->bindParam(':sentence_en', $sentence, PDO::PARAM_STR);
                $stmt_ex->bindParam(':translation_vi', $translation, PDO::PARAM_STR);
                if ($example_audio_filename !== null) {
                    $stmt_ex->bindValue(':audio_file', $example_audio_filename, PDO::PARAM_STR);
                } else {
                    $stmt_ex->bindValue(':audio_file', null, PDO::PARAM_NULL);
                }
                $stmt_ex->bindParam(':sort', $sort, PDO::PARAM_INT);
                $stmt_ex->bindParam(':created_at', $created_at, PDO::PARAM_INT);
                $stmt_ex->execute();
            }
        }

        // Store success message in session to show toast on next page
        $_SESSION['dictionary_success_message'] = sprintf(
            $nv_Lang->getModule('entry_added_success'),
            $data['headword']
        );

        // Clear any session data
        unset($_SESSION['dictionary_form_errors']);
        unset($_SESSION['dictionary_form_data']);

        // Redirect to main (which can route to list)
        nv_redirect_location(
            NV_BASE_ADMINURL . 'index.php?'
            . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
            . '&' . NV_NAME_VARIABLE . '=' . $module_name
            . '&' . NV_OP_VARIABLE . '=main'
        );
    } catch (Throwable $e) {
        // Task 1.7: Clean up temp files on error
        if ($headword_audio_temp_file !== null) {
            nv_deletefile($headword_audio_temp_file);
        }
        foreach ($example_audio_temp_files as $temp_file) {
            if ($temp_file !== null) {
                nv_deletefile($temp_file);
            }
        }
        
        $errors[] = $nv_Lang->getModule('errorsave') . ': ' . $e->getMessage();
        trigger_error('[Dictionary Upload] Database error during entry add: ' . $e->getMessage(), E_USER_WARNING);
        
        // Store error in session and redirect
        $_SESSION['dictionary_form_errors'] = $errors;
        $_SESSION['dictionary_form_data'] = $data;
        nv_redirect_location(
            NV_BASE_ADMINURL . 'index.php?'
            . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
            . '&' . NV_NAME_VARIABLE . '=' . $module_name
            . '&' . NV_OP_VARIABLE . '=entry_add'
        );
    }
}

// Render form
$xtpl = new XTemplate(
    'entry_add.tpl',
    NV_ROOTDIR . '/themes/' . $global_config['admin_theme'] . '/modules/' . $module_file
);
$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
$xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
$xtpl->assign('ACTION', NV_BASE_ADMINURL . 'index.php');
$xtpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$xtpl->assign('NV_LANG_DATA', NV_LANG_DATA);
$xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$xtpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$xtpl->assign('MODULE_NAME', $module_name);
$xtpl->assign('OP', 'entry_add');
$xtpl->assign('CHECKSS', md5(NV_CHECK_SESSION));

// Prefill data
foreach ($data as $k => $v) {
    $xtpl->assign(strtoupper($k), htmlspecialchars($v, ENT_QUOTES, 'UTF-8'));
}

if (!empty($errors)) {
    foreach ($errors as $err) {
        $xtpl->assign('ERROR', $err);
        $xtpl->parse('main.errors.loop');
    }
    $xtpl->parse('main.errors');
}

$xtpl->parse('main');
$contents = $xtpl->text('main');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';

