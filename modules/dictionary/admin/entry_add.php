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
        // Task 1.1: Debug log to show what Upload class returned
        error_log('[Dictionary Upload Debug] Headword audio upload result: ' . print_r($upload_info, true));
        if (empty($upload_info['error'])) {
            $headword_audio_temp_file = $upload_info['name'];
            // Task 2.1: Defensive check - if upload_info['name'] is empty/null, log error and add to errors
            if (empty($headword_audio_temp_file)) {
                error_log('[Dictionary Upload Debug] ERROR: Upload class returned empty/null filename for headword audio');
                $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
            } else {
                // Task 1.2: Debug log showing the constructed temp file path
                error_log('[Dictionary Upload Debug] Headword temp file path: ' . $headword_audio_temp_file);
                
                // Task 2.2: File existence check - verify the file exists immediately after upload
                if (!file_exists($headword_audio_temp_file)) {
                    error_log('[Dictionary Upload Debug] ERROR: Headword audio file does not exist at path: ' . $headword_audio_temp_file);
                    $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
                    $headword_audio_temp_file = null; // Reset to prevent further processing
                }
            }
        } else {
            $errors[] = $upload_info['error'];
        }
        nv_deletefile($_FILES['audio']['tmp_name']);
    }

    // Task 1.3: Validate and process example audio files (if uploaded)
    $example_audio_temp_files = [];
    // Task 3.5: Track which example audio uploads succeed vs fail
    $example_audio_status = [];
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
            // Task 3.1: Apply same file existence checks as headword audio
            if (empty($upload_info['error'])) {
                $example_audio_temp_files[$idx] = $upload_info['name'];
                // Defensive check for empty/null filename
                if (empty($example_audio_temp_files[$idx])) {
                    error_log('[Dictionary Upload Debug] ERROR: Upload class returned empty/null filename for example #' . ($idx + 1) . ' audio');
                    $errors[] = sprintf($nv_Lang->getModule('error_audio_upload_failed') . ' (Example #%d)', $idx + 1);
                    $example_audio_temp_files[$idx] = null;
                    $example_audio_status[$idx] = 'upload_failed';
                } else {
                    // File existence check immediately after upload
                    if (!file_exists($example_audio_temp_files[$idx])) {
                        error_log('[Dictionary Upload Debug] ERROR: Example #' . ($idx + 1) . ' audio file does not exist at path: ' . $example_audio_temp_files[$idx]);
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_file_not_found') . ' (Example #%d)', $idx + 1);
                        $example_audio_temp_files[$idx] = null;
                        $example_audio_status[$idx] = 'file_not_found';
                    } else {
                        $example_audio_status[$idx] = 'uploaded';
                    }
                }
            } else {
                $errors[] = sprintf($nv_Lang->getModule('error_audio_upload_failed') . ' (Example #%d)', $idx + 1);
                $example_audio_status[$idx] = 'upload_failed';
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
            
            // Task 1.4: Debug logging before rename operation
            error_log('[Dictionary Upload Debug] Headword audio rename - Source: ' . $headword_audio_temp_file);
            error_log('[Dictionary Upload Debug] Headword audio rename - Destination: ' . $final_path);
            error_log('[Dictionary Upload Debug] Headword audio rename - Source exists: ' . (file_exists($headword_audio_temp_file) ? 'YES' : 'NO'));
            error_log('[Dictionary Upload Debug] Headword audio rename - Destination dir writable: ' . (is_writable(dirname($final_path)) ? 'YES' : 'NO'));
            
            // Task 2.3: Before attempting rename, check if source file exists
            if (!file_exists($headword_audio_temp_file)) {
                error_log('[Dictionary Upload Debug] ERROR: Source headword audio file does not exist before rename: ' . $headword_audio_temp_file);
                $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
                // Skip the rename operation
                $rename_result = false;
            } else {
                // Task 2.4: Before rename, add directory writability check
                if (!is_writable(dirname($final_path))) {
                    error_log('[Dictionary Upload Debug] ERROR: Destination directory is not writable: ' . dirname($final_path));
                    $errors[] = $nv_Lang->getModule('error_audio_directory_not_writable');
                    $rename_result = false;
                } else {
                    // Task 2.5: Replace simple rename() check with comprehensive error handling
                    $rename_result = rename($headword_audio_temp_file, $final_path);
                    error_log('[Dictionary Upload Debug] Headword audio rename - Result: ' . ($rename_result ? 'SUCCESS' : 'FAILED'));
                    
                    if (!$rename_result) {
                        $last_error = error_get_last();
                        if ($last_error) {
                            error_log('[Dictionary Upload Debug] Headword audio rename - Last error: ' . $last_error['message']);
                        }
                        $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
                    }
                }
            }
            // Task 1.5: Debug logging after rename operation
            error_log('[Dictionary Upload Debug] Headword audio rename - Result: ' . ($rename_result ? 'SUCCESS' : 'FAILED'));
            error_log('[Dictionary Upload Debug] Headword audio rename - Destination exists after rename: ' . (file_exists($final_path) ? 'YES' : 'NO'));
            
            if ($rename_result) {
                // Task 2.6: After successful rename, verify destination file exists before updating database
                if (file_exists($final_path)) {
                    error_log('[Dictionary Upload Debug] Headword audio verification - File exists at destination: ' . $final_path);
                    // File moved successfully, update database with final filename
                    $sql_update = 'UPDATE ' . NV_DICTIONARY_GLOBALTABLE . '_entries SET audio_file = :audio_file WHERE id = :id';
                    $stmt_update = $db->prepare($sql_update);
                    $stmt_update->bindParam(':audio_file', $final_filename, PDO::PARAM_STR);
                    $stmt_update->bindParam(':id', $entry_id, PDO::PARAM_INT);
                    $stmt_update->execute();
                    error_log('[Dictionary Upload Debug] Headword audio - Database updated successfully with filename: ' . $final_filename);
                } else {
                    error_log('[Dictionary Upload Debug] ERROR: Headword audio file does not exist at destination after rename: ' . $final_path);
                    $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
                }
            } else {
                // Task 2.8: File move failed - DON'T delete temp file immediately, keep for debugging
                error_log('[Dictionary Upload Debug] Headword audio - Rename failed, temp file kept for debugging at: ' . $headword_audio_temp_file);
                trigger_error('[Dictionary Upload] Failed to move headword audio from ' . basename($headword_audio_temp_file) . ' to final location', E_USER_WARNING);
                // Don't delete temp file immediately - keep it for debugging
                // nv_deletefile($headword_audio_temp_file); // Commented out for debugging
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
                    
                    // Task 1.6: Debug logging for example audio rename operation
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Source: ' . $example_audio_temp_files[$idx]);
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Destination: ' . $final_path);
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Source exists: ' . (file_exists($example_audio_temp_files[$idx]) ? 'YES' : 'NO'));
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Destination dir writable: ' . (is_writable(dirname($final_path)) ? 'YES' : 'NO'));
                    
                    // Task 3.2: Before rename, add source file existence check and directory writability check
                    $example_rename_result = false;
                    if (!file_exists($example_audio_temp_files[$idx])) {
                        error_log('[Dictionary Upload Debug] ERROR: Source example #' . ($idx + 1) . ' audio file does not exist before rename: ' . $example_audio_temp_files[$idx]);
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_file_not_found') . ' (Example #%d)', $idx + 1);
                    } elseif (!is_writable(dirname($final_path))) {
                        error_log('[Dictionary Upload Debug] ERROR: Destination directory is not writable for example #' . ($idx + 1) . ': ' . dirname($final_path));
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_directory_not_writable') . ' (Example #%d)', $idx + 1);
                    } else {
                        $example_rename_result = rename($example_audio_temp_files[$idx], $final_path);
                    }
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Result: ' . ($example_rename_result ? 'SUCCESS' : 'FAILED'));
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Destination exists after rename: ' . (file_exists($final_path) ? 'YES' : 'NO'));
                    
                    // Task 3.3: Replace simple rename() with comprehensive error handling
                    if (!$example_rename_result) {
                        $last_error = error_get_last();
                        if ($last_error) {
                            error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio rename - Last error: ' . $last_error['message']);
                        }
                        // Task 3.7: Add comprehensive error messages that specify which example number failed
                        $errors[] = sprintf($nv_Lang->getModule('error_example_audio_failed'), $idx + 1);
                    }
                    
                    if ($example_rename_result) {
                        // Task 3.4: After successful rename, verify destination file exists before updating database
                        if (file_exists($final_path)) {
                            error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio verification - File exists at destination: ' . $final_path);
                            // File moved successfully
                            $example_audio_filename = $final_filename;
                            $example_audio_status[$idx] = 'success';
                        } else {
                            error_log('[Dictionary Upload Debug] ERROR: Example #' . ($idx + 1) . ' audio file does not exist at destination after rename: ' . $final_path);
                            $errors[] = sprintf($nv_Lang->getModule('error_example_audio_failed'), $idx + 1);
                            $example_audio_filename = null;
                            $example_audio_status[$idx] = 'verification_failed';
                        }
                    } else {
                        // Task 3.8: Don't delete temp file immediately on error - keep for debugging
                        error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' audio - Rename failed, temp file kept for debugging at: ' . $example_audio_temp_files[$idx]);
                        // File move failed - log but set audio_file to NULL
                        trigger_error('[Dictionary Upload] Failed to move example audio from ' . basename($example_audio_temp_files[$idx]) . ' to final location', E_USER_WARNING);
                        // Don't delete temp file immediately - keep for debugging
                        // nv_deletefile($example_audio_temp_files[$idx]); // Commented out for debugging
                        $example_audio_filename = null;
                        $example_audio_status[$idx] = 'rename_failed';
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

        // Task 2.9: After all audio processing, check if errors array is not empty
        if (!empty($errors)) {
            error_log('[Dictionary Upload Debug] Audio processing completed with errors: ' . implode(', ', $errors));
            // Use PRG pattern: store errors in session and redirect back to add page
            $_SESSION['dictionary_form_errors'] = $errors;
            $_SESSION['dictionary_form_data'] = $data;
            nv_redirect_location(
                NV_BASE_ADMINURL . 'index.php?'
                . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
                . '&' . NV_NAME_VARIABLE . '=' . $module_name
                . '&' . NV_OP_VARIABLE . '=entry_add'
            );
        }

        // Task 2.10: Only show success message if NO errors occurred
        // Task 4.11: Update success message to use new language key if audio was uploaded
        $has_audio = ($headword_audio_temp_file !== null) || !empty(array_filter($example_audio_temp_files));
        if ($has_audio) {
            $_SESSION['dictionary_success_message'] = sprintf(
                $nv_Lang->getModule('entry_added_success_with_audio'),
                $data['headword']
            );
        } else {
            $_SESSION['dictionary_success_message'] = sprintf(
                $nv_Lang->getModule('entry_added_success'),
                $data['headword']
            );
        }

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
        // Task 3.8: Ensure ALL example audio temp files are cleaned up, not just successfully moved ones
        foreach ($example_audio_temp_files as $idx => $temp_file) {
            if ($temp_file !== null) {
                error_log('[Dictionary Upload Debug] Cleaning up example #' . ($idx + 1) . ' temp file: ' . $temp_file);
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

