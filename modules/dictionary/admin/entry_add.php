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

    // Validate headword audio file (if uploaded)
    $headword_audio_filename = null;
    if (isset($_FILES['audio']) && $_FILES['audio']['error'] !== UPLOAD_ERR_NO_FILE) {
        if ($_FILES['audio']['error'] === UPLOAD_ERR_OK) {
            $allowed_mime_types = ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav'];
            $max_file_size = 5 * 1024 * 1024; // 5MB
            
            $file_mime = $_FILES['audio']['type'];
            $file_size = $_FILES['audio']['size'];
            
            // Validate MIME type
            if (!in_array($file_mime, $allowed_mime_types, true)) {
                $errors[] = $nv_Lang->getModule('error_audio_type');
            }
            
            // Validate file size
            if ($file_size > $max_file_size) {
                $errors[] = $nv_Lang->getModule('error_audio_size');
            }
        } else {
            $errors[] = $nv_Lang->getModule('error_audio_upload');
        }
    }

    // Validate example audio files (if uploaded)
    $example_audio_files = [];
    if (isset($_FILES['ex_audio']) && is_array($_FILES['ex_audio']['name'])) {
        $allowed_mime_types = ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav'];
        $max_file_size = 5 * 1024 * 1024; // 5MB
        
        foreach ($_FILES['ex_audio']['error'] as $idx => $error) {
            if ($error === UPLOAD_ERR_NO_FILE) {
                $example_audio_files[$idx] = null;
                continue;
            }
            
            if ($error === UPLOAD_ERR_OK) {
                $file_mime = $_FILES['ex_audio']['type'][$idx];
                $file_size = $_FILES['ex_audio']['size'][$idx];
                
                // Validate MIME type
                if (!in_array($file_mime, $allowed_mime_types, true)) {
                    $errors[] = sprintf($nv_Lang->getModule('error_audio_type') . ' (Example #%d)', $idx + 1);
                    $example_audio_files[$idx] = null;
                    continue;
                }
                
                // Validate file size
                if ($file_size > $max_file_size) {
                    $errors[] = sprintf($nv_Lang->getModule('error_audio_size') . ' (Example #%d)', $idx + 1);
                    $example_audio_files[$idx] = null;
                    continue;
                }
                
                $example_audio_files[$idx] = true; // Mark as valid for processing
            } else {
                $errors[] = sprintf($nv_Lang->getModule('error_audio_upload') . ' (Example #%d)', $idx + 1);
                $example_audio_files[$idx] = null;
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

    // Proceed with saving (validation already passed)
    if (true) {
        try {
            $created_at = NV_CURRENTTIME;
            $updated_at = NV_CURRENTTIME;
            
            // Handle headword audio file upload BEFORE insert
            $headword_audio_filename = null;
            if (isset($_FILES['audio']) && $_FILES['audio']['error'] === UPLOAD_ERR_OK) {
                // Ensure upload directories exist
                $targetDir = NV_ROOTDIR . '/uploads/' . $module_name . '/audio';
                if (!is_dir($targetDir)) {
                    if (!is_dir(NV_ROOTDIR . '/uploads/' . $module_name)) {
                        nv_mkdir(NV_ROOTDIR . '/uploads', $module_name);
                    }
                    nv_mkdir(NV_ROOTDIR . '/uploads/' . $module_name, 'audio');
                }

                $file_ext = strtolower(pathinfo($_FILES['audio']['name'], PATHINFO_EXTENSION));
                // Use timestamp + random for temporary filename until we get entry_id
                $temp_filename = 'temp_' . time() . '_' . mt_rand(1000, 9999) . '.' . $file_ext;
                $temp_upload_path = $targetDir . '/' . $temp_filename;
                
                if (move_uploaded_file($_FILES['audio']['tmp_name'], $temp_upload_path)) {
                    $headword_audio_filename = $temp_filename; // Will be renamed after INSERT
                } else {
                    $errors[] = $nv_Lang->getModule('error_audio_upload');
                }
            }

            // Insert entry WITH audio_file
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
            $stmt->bindParam(':audio_file', $headword_audio_filename, PDO::PARAM_STR);
            $stmt->bindParam(':created_at', $created_at, PDO::PARAM_INT);
            $stmt->bindParam(':updated_at', $updated_at, PDO::PARAM_INT);
            $stmt->execute();

            $entry_id = (int) $db->lastInsertId();
            
            // Rename headword audio file to proper name with entry_id
            if ($headword_audio_filename !== null) {
                $targetDir = NV_ROOTDIR . '/uploads/' . $module_name . '/audio';
                $old_path = $targetDir . '/' . $headword_audio_filename;
                $file_ext = strtolower(pathinfo($headword_audio_filename, PATHINFO_EXTENSION));
                $final_filename = $entry_id . '_headword.' . $file_ext;
                $new_path = $targetDir . '/' . $final_filename;
                
                if (rename($old_path, $new_path)) {
                    // Update database with final filename
                    $sql_update = 'UPDATE ' . NV_DICTIONARY_GLOBALTABLE . '_entries SET audio_file = :audio_file WHERE id = :id';
                    $stmt_update = $db->prepare($sql_update);
                    $stmt_update->bindParam(':audio_file', $final_filename, PDO::PARAM_STR);
                    $stmt_update->bindParam(':id', $entry_id, PDO::PARAM_INT);
                    $stmt_update->execute();
                } else {
                    // If rename fails, keep the temp filename - it's already in DB and works
                    error_log("Failed to rename audio file from $old_path to $new_path");
                }
            }

            // Insert examples (if provided)
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
                    
                    // Handle example audio file upload
                    $example_audio_filename = null;
                    if (isset($example_audio_files[$idx]) && $example_audio_files[$idx] === true) {
                        if (isset($_FILES['ex_audio']['tmp_name'][$idx]) && $_FILES['ex_audio']['error'][$idx] === UPLOAD_ERR_OK) {
                            $file_ext = strtolower(pathinfo($_FILES['ex_audio']['name'][$idx], PATHINFO_EXTENSION));
                            $example_audio_filename = $entry_id . '_example_' . $sort . '.' . $file_ext;
                            $upload_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $example_audio_filename;
                            
                            if (!move_uploaded_file($_FILES['ex_audio']['tmp_name'][$idx], $upload_path)) {
                                $example_audio_filename = null;
                            }
                        }
                    }
                    
                    $stmt_ex->bindParam(':entry_id', $entry_id, PDO::PARAM_INT);
                    $stmt_ex->bindParam(':sentence_en', $sentence, PDO::PARAM_STR);
                    $stmt_ex->bindParam(':translation_vi', $translation, PDO::PARAM_STR);
                    $stmt_ex->bindParam(':audio_file', $example_audio_filename, PDO::PARAM_STR);
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
            $errors[] = $nv_Lang->getModule('errorsave') . ': ' . $e->getMessage();
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

