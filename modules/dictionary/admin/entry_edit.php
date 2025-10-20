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

$page_title = $nv_Lang->getModule('edit');

// Get entry ID from both GET and POST
$id = $nv_Request->get_int('id', 'get,post', 0);

if ($id <= 0) {
    nv_redirect_location(
        NV_BASE_ADMINURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name
        . '&' . NV_OP_VARIABLE . '=main'
    );
}

// Fetch existing entry (including audio_file)
$sql = 'SELECT * FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE id = :id';
$stmt = $db->prepare($sql);
$stmt->bindParam(':id', $id, PDO::PARAM_INT);
$stmt->execute();
$data = $stmt->fetch();

// Store original audio filename for potential deletion
$original_audio = isset($data['audio_file']) ? $data['audio_file'] : '';

if (!$data) {
    nv_redirect_location(
        NV_BASE_ADMINURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name
        . '&' . NV_OP_VARIABLE . '=main'
    );
}

// Fetch existing examples (including audio_file)
$sql = 'SELECT * FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples WHERE entry_id = :entry_id ORDER BY sort ASC';
$stmt = $db->prepare($sql);
$stmt->bindParam(':entry_id', $id, PDO::PARAM_INT);
$stmt->execute();
$existing_examples = $stmt->fetchAll();

// Store original example audio files for potential deletion
$original_example_audios = [];
foreach ($existing_examples as $ex) {
    if (!empty($ex['audio_file'])) {
        $original_example_audios[] = $ex['audio_file'];
    }
}

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

    // If there are validation errors, store in session and redirect (PRG pattern)
    if (!empty($errors)) {
        $_SESSION['dictionary_form_errors'] = $errors;
        $_SESSION['dictionary_form_data'] = $data;
        nv_redirect_location(
            NV_BASE_ADMINURL . 'index.php?'
            . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
            . '&' . NV_NAME_VARIABLE . '=' . $module_name
            . '&' . NV_OP_VARIABLE . '=entry_edit&id=' . $id
        );
    }

    // Generate slug if empty
    if ($data['slug'] === '' && $data['headword'] !== '') {
        $data['slug'] = change_alias($data['headword']);
    }
    // Normalize slug
    $data['slug'] = strtolower($data['slug']);

    // Handle audio file upload and deletion
    $new_audio_filename = $original_audio; // Default to keeping existing audio
    $delete_audio = $nv_Request->get_int('delete_audio', 'post', 0);

    // Check if user wants to delete existing audio
    if ($delete_audio === 1 && !empty($original_audio)) {
        $audio_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $original_audio;
        if (file_exists($audio_path)) {
            @unlink($audio_path);
        }
        $new_audio_filename = '';
    }

    // Check if new audio file uploaded
    if (isset($_FILES['audio']) && $_FILES['audio']['error'] === UPLOAD_ERR_OK) {
        $allowed_types = ['audio/mpeg', 'audio/wav', 'audio/mp3'];
        $max_size = 5 * 1024 * 1024; // 5MB

        $file_type = $_FILES['audio']['type'];
        $file_size = $_FILES['audio']['size'];

        // Validate MIME type
        if (!in_array($file_type, $allowed_types, true)) {
            $errors[] = $nv_Lang->getModule('error_audio_type');
        }

        // Validate size
        if ($file_size > $max_size) {
            $errors[] = $nv_Lang->getModule('error_audio_size');
        }

        if (empty($errors)) {
            // Delete old audio file if replacing
            if (!empty($original_audio)) {
                $old_audio_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $original_audio;
                if (file_exists($old_audio_path)) {
                    @unlink($old_audio_path);
                }
            }

            // Generate unique filename
            $ext = pathinfo($_FILES['audio']['name'], PATHINFO_EXTENSION);
            $safe_headword = preg_replace('/[^a-z0-9_-]/i', '_', $data['headword']);
            $new_audio_filename = $id . '_' . $safe_headword . '.' . $ext;
            $upload_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $new_audio_filename;

            if (!move_uploaded_file($_FILES['audio']['tmp_name'], $upload_path)) {
                $errors[] = $nv_Lang->getModule('error_audio_upload');
                $new_audio_filename = $original_audio; // Revert to original on failure
            }
        }
    }

    // Ensure slug unique (excluding current entry)
    if ($data['slug'] !== '') {
        $base_slug = $data['slug'];
        $i = 1;
        $stmt = $db->prepare('SELECT COUNT(*) FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE slug = :slug AND id != :id');
        while (true) {
            $stmt->bindValue(':slug', $data['slug'], PDO::PARAM_STR);
            $stmt->bindValue(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $exists = (int) $stmt->fetchColumn();
            if ($exists === 0) {
                break;
            }
            $data['slug'] = $base_slug . '-' . $i;
            $i++;
        }
    }

    // Proceed with updating
    if (true) {
        try {
            $updated_at = NV_CURRENTTIME;

            // Update entry
            $sql = 'UPDATE ' . NV_DICTIONARY_GLOBALTABLE . '_entries SET
                headword = :headword,
                slug = :slug,
                pos = :pos,
                phonetic = :phonetic,
                meaning_vi = :meaning_vi,
                notes = :notes,
                audio_file = :audio_file,
                updated_at = :updated_at
                WHERE id = :id';
            $stmt = $db->prepare($sql);
            $stmt->bindParam(':headword', $data['headword'], PDO::PARAM_STR);
            $stmt->bindParam(':slug', $data['slug'], PDO::PARAM_STR);
            $stmt->bindParam(':pos', $data['pos'], PDO::PARAM_STR);
            $stmt->bindParam(':phonetic', $data['phonetic'], PDO::PARAM_STR);
            $stmt->bindParam(':meaning_vi', $data['meaning_vi'], PDO::PARAM_STR);
            $stmt->bindParam(':notes', $data['notes'], PDO::PARAM_STR);
            $stmt->bindValue(':audio_file', $new_audio_filename !== '' ? $new_audio_filename : null, PDO::PARAM_STR);
            $stmt->bindParam(':updated_at', $updated_at, PDO::PARAM_INT);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();

            // Delete old examples and their audio files
            foreach ($original_example_audios as $old_audio) {
                $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $old_audio;
                if (file_exists($old_path)) {
                    @unlink($old_path);
                }
            }
            $db->query('DELETE FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples WHERE entry_id = ' . $id);

            // Insert new examples (if provided) with audio handling
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

                    // Handle audio upload for this example
                    $example_audio_filename = null;
                    if (isset($_FILES['ex_audio']['name'][$idx]) && $_FILES['ex_audio']['error'][$idx] === UPLOAD_ERR_OK) {
                        $allowed_types = ['audio/mpeg', 'audio/wav', 'audio/mp3'];
                        $max_size = 5 * 1024 * 1024; // 5MB

                        $file_type = $_FILES['ex_audio']['type'][$idx];
                        $file_size = $_FILES['ex_audio']['size'][$idx];

                        if (in_array($file_type, $allowed_types, true) && $file_size <= $max_size) {
                            $ext = pathinfo($_FILES['ex_audio']['name'][$idx], PATHINFO_EXTENSION);
                            $safe_sentence = preg_replace('/[^a-z0-9_-]/i', '_', substr($sentence, 0, 30));
                            $example_audio_filename = $id . '_example_' . $sort . '_' . $safe_sentence . '.' . $ext;
                            $upload_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $example_audio_filename;

                            if (!move_uploaded_file($_FILES['ex_audio']['tmp_name'][$idx], $upload_path)) {
                                $example_audio_filename = null;
                            }
                        }
                    }

                    $stmt_ex->bindParam(':entry_id', $id, PDO::PARAM_INT);
                    $stmt_ex->bindParam(':sentence_en', $sentence, PDO::PARAM_STR);
                    $stmt_ex->bindParam(':translation_vi', $translation, PDO::PARAM_STR);
                    $stmt_ex->bindValue(':audio_file', $example_audio_filename, PDO::PARAM_STR);
                    $stmt_ex->bindParam(':sort', $sort, PDO::PARAM_INT);
                    $stmt_ex->bindParam(':created_at', $updated_at, PDO::PARAM_INT);
                    $stmt_ex->execute();
                }
            }

            // Store success message in session to show toast on next page
            $_SESSION['dictionary_success_message'] = sprintf(
                $nv_Lang->getModule('entry_updated_success'),
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
                . '&' . NV_OP_VARIABLE . '=entry_edit&id=' . $id
            );
        }
    }
}

// Render form
$xtpl = new XTemplate(
    'entry_edit.tpl',
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
$xtpl->assign('OP', 'entry_edit');
$xtpl->assign('ID', $id);
$xtpl->assign('CHECKSS', md5(NV_CHECK_SESSION));

// Prefill data
foreach ($data as $k => $v) {
    $xtpl->assign(strtoupper($k), htmlspecialchars($v, ENT_QUOTES, 'UTF-8'));
}

// Handle existing audio file display
if (!empty($data['audio_file'])) {
    $xtpl->assign('AUDIO_URL', NV_BASE_SITEURL . 'uploads/' . $module_name . '/audio/' . $data['audio_file']);
    $xtpl->assign('AUDIO_FILE', htmlspecialchars($data['audio_file'], ENT_QUOTES, 'UTF-8'));
    $xtpl->parse('main.current_audio');
    $xtpl->parse('main.delete_audio');
}

// Render existing examples
if (!empty($existing_examples)) {
    foreach ($existing_examples as $idx => $example) {
        $xtpl->assign('EXAMPLE', [
            'id' => $example['id'],
            'num' => $idx + 1,
            'sentence_en' => htmlspecialchars($example['sentence_en'], ENT_QUOTES, 'UTF-8'),
            'translation_vi' => htmlspecialchars($example['translation_vi'], ENT_QUOTES, 'UTF-8'),
            'audio_file' => isset($example['audio_file']) ? htmlspecialchars($example['audio_file'], ENT_QUOTES, 'UTF-8') : '',
            'audio_url' => !empty($example['audio_file']) ? NV_BASE_SITEURL . 'uploads/' . $module_name . '/audio/' . $example['audio_file'] : ''
        ]);
        if (!empty($example['audio_file'])) {
            $xtpl->parse('main.example.current_example_audio');
        }
        $xtpl->parse('main.example');
    }
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
