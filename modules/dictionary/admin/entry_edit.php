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

// Store original example audio files mapped by example ID for proper tracking
$original_example_audios = [];
$original_examples_map = [];
foreach ($existing_examples as $ex) {
    $original_examples_map[$ex['id']] = $ex;
    if (!empty($ex['audio_file'])) {
        $original_example_audios[$ex['id']] = $ex['audio_file'];
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

    // ===== AUDIO UPLOAD AND DELETION HANDLING (Task 2.1-2.7) =====
    // Instantiate Upload class for audio files
    // Use 'audio' section from mime.ini which includes mp3, wav, and other audio formats
    $upload = new \NukeViet\Files\Upload(
        ['audio'],
        $global_config['forbid_extensions'],
        $global_config['forbid_mimes'],
        5 * 1024 * 1024 // 5MB max
    );
    $upload->setLanguage(\NukeViet\Core\Language::$lang_global);

    // Task 5.2 & 5.3: Handle headword audio with comprehensive debug logging and error handling
    $new_audio_filename = $original_audio; // Default to keeping existing audio
    $delete_audio = $nv_Request->get_int('delete_audio', 'post', 0);
    
    // Task 5.3: Debug logging for audio deletion request
    error_log('[Dictionary Upload Debug] delete_audio value: ' . $delete_audio . ', original_audio: ' . $original_audio);
    error_log('[Dictionary Upload Debug] POST data: ' . print_r($_POST, true));
    
    if ($delete_audio === 1 && !empty($original_audio)) {
        $audio_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $original_audio;
        error_log('[Dictionary Upload Debug] Attempting to delete: ' . $audio_path);
        if (file_exists($audio_path)) {
            if (!nv_deletefile($audio_path)) {
                trigger_error('[Dictionary Upload] Failed to delete audio: ' . basename($audio_path), E_USER_NOTICE);
                error_log('[Dictionary Upload Debug] Delete failed!');
            } else {
                error_log('[Dictionary Upload Debug] Delete successful!');
            }
        } else {
            error_log('[Dictionary Upload Debug] Audio file not found for deletion: ' . $audio_path);
        }
        $new_audio_filename = '';
    } else {
        error_log('[Dictionary Upload Debug] Skipping deletion - delete_audio: ' . $delete_audio . ', original_audio: ' . var_export($original_audio, true));
    }

    // Task 2.3: Task 2.3: Validate and process new headword audio file (if uploaded)
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

    // Task 2.5: Validate and process example audio files (if uploaded)
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
            . '&' . NV_OP_VARIABLE . '=entry_edit&id=' . $id
        );
    }

    // Generate slug if empty
    if ($data['slug'] === '' && $data['headword'] !== '') {
        $data['slug'] = change_alias($data['headword']);
    }
    // Normalize slug
    $data['slug'] = strtolower($data['slug']);

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

    // ===== DATABASE OPERATIONS =====
    try {
        $updated_at = NV_CURRENTTIME;

        // Task 5.3: Handle headword audio replacement with comprehensive error handling and logging
        if ($headword_audio_temp_file !== null) {
            $targetDir = NV_ROOTDIR . '/uploads/' . $module_name . '/audio';
            if (!is_dir($targetDir)) {
                if (!is_dir(NV_ROOTDIR . '/uploads/' . $module_name)) {
                    nv_mkdir(NV_ROOTDIR . '/uploads', $module_name);
                }
                nv_mkdir(NV_ROOTDIR . '/uploads/' . $module_name, 'audio');
            }

            $file_ext = strtolower(pathinfo($headword_audio_temp_file, PATHINFO_EXTENSION));
            $final_filename = $id . '_' . nv_genpass(8) . '.' . $file_ext;
            $final_path = $targetDir . '/' . $final_filename;
            
            // Task 5.3: Log source and destination paths before rename
            error_log('[Dictionary Upload Debug] Headword audio move - source: ' . $headword_audio_temp_file . ', destination: ' . $final_path);
            error_log('[Dictionary Upload Debug] Source file exists: ' . (file_exists($headword_audio_temp_file) ? 'YES' : 'NO'));
            error_log('[Dictionary Upload Debug] Destination directory writable: ' . (is_writable(dirname($final_path)) ? 'YES' : 'NO'));
            
            // Task 5.3: Defensive checks
            if (empty($headword_audio_temp_file)) {
                $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
                error_log('[Dictionary Upload Debug] ERROR: Empty headword audio temp file path');
            } elseif (!file_exists($headword_audio_temp_file)) {
                $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
                error_log('[Dictionary Upload Debug] ERROR: Headword audio file does not exist at path: ' . $headword_audio_temp_file);
            } elseif (!is_writable(dirname($final_path))) {
                $errors[] = $nv_Lang->getModule('error_audio_directory_not_writable');
                error_log('[Dictionary Upload Debug] ERROR: Destination directory not writable: ' . dirname($final_path));
            } else {
                // Task 5.3: Comprehensive error handling for rename
                $rename_success = rename($headword_audio_temp_file, $final_path);
                error_log('[Dictionary Upload Debug] Headword audio rename result: ' . ($rename_success ? 'SUCCESS' : 'FAILED'));
                
                if ($rename_success) {
                    // Task 5.3: Verify destination file exists after rename
                    if (file_exists($final_path)) {
                        error_log('[Dictionary Upload Debug] Destination file verified at: ' . $final_path);
                        // File moved successfully, update new_audio_filename
                        $new_audio_filename = $final_filename;
                        
                        // Task 5.6 & 5.7: Delete old audio file if it exists (after new file is saved)
                        if (!empty($original_audio)) {
                            $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $original_audio;
                            if (file_exists($old_path)) {
                                if (!nv_deletefile($old_path)) {
                                    trigger_error('[Dictionary Upload] Failed to delete old audio: ' . basename($old_path), E_USER_NOTICE);
                                    error_log('[Dictionary Upload Debug] WARNING: Failed to delete old audio file: ' . $old_path);
                                } else {
                                    error_log('[Dictionary Upload Debug] Old audio file deleted successfully: ' . $old_path);
                                }
                            } else {
                                error_log('[Dictionary Upload Debug] Old audio file not found: ' . $old_path);
                            }
                        }
                    } else {
                        $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
                        error_log('[Dictionary Upload Debug] ERROR: Destination file does not exist after successful rename: ' . $final_path);
                    }
                } else {
                    // Task 5.3: Get detailed error information
                    $last_error = error_get_last();
                    $error_msg = $last_error['message'] ?? 'Unknown error';
                    $errors[] = $nv_Lang->getModule('error_audio_upload_failed') . ': ' . $error_msg;
                    error_log('[Dictionary Upload Debug] Headword audio rename FAILED: ' . $error_msg);
                    // Keep temp file for debugging
                    error_log('[Dictionary Upload Debug] Temp file kept for debugging at: ' . $headword_audio_temp_file);
                }
            }
            
            // Clean up temp file if we encountered errors (but not on successful rename - already moved)
            if (!empty($errors) && file_exists($headword_audio_temp_file)) {
                nv_deletefile($headword_audio_temp_file);
            }
        }

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
        if ($new_audio_filename !== '') {
            $stmt->bindValue(':audio_file', $new_audio_filename, PDO::PARAM_STR);
        } else {
            $stmt->bindValue(':audio_file', null, PDO::PARAM_NULL);
        }
        $stmt->bindParam(':updated_at', $updated_at, PDO::PARAM_INT);
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();

        // Task 5.4 & 5.5: Handle example updates with comprehensive audio file management and error handling
        // Get submitted example IDs to track which examples are being kept
        $submitted_example_ids = isset($_POST['ex_id']) && is_array($_POST['ex_id']) ? $_POST['ex_id'] : [];

        // Delete examples that are not in the submitted list and their audio files
        $keep_audio_files = [];
        foreach ($existing_examples as $ex) {
            if (!in_array($ex['id'], $submitted_example_ids)) {
                // Example was removed - delete its audio file
                if (!empty($ex['audio_file'])) {
                    $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $ex['audio_file'];
                    if (file_exists($old_path)) {
                        if (!nv_deletefile($old_path)) {
                            trigger_error('[Dictionary Upload] Failed to delete removed example audio: ' . basename($old_path), E_USER_NOTICE);
                            error_log('[Dictionary Upload Debug] WARNING: Failed to delete removed example audio: ' . $old_path);
                        } else {
                            error_log('[Dictionary Upload Debug] Removed example audio deleted: ' . $old_path);
                        }
                    } else {
                        error_log('[Dictionary Upload Debug] Removed example audio file not found: ' . $old_path);
                    }
                }
            } else {
                // Example is being kept - track its existing audio
                if (!empty($ex['audio_file'])) {
                    $keep_audio_files[$ex['id']] = $ex['audio_file'];
                }
            }
        }

        // Delete all old examples from database (we'll re-insert them)
        $db->query('DELETE FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples WHERE entry_id = ' . $id);

        // Re-insert examples with proper audio handling
        $ex_sentences = isset($_POST['ex_sentence_en']) && is_array($_POST['ex_sentence_en']) ? $_POST['ex_sentence_en'] : [];
        $ex_trans = isset($_POST['ex_translation_vi']) && is_array($_POST['ex_translation_vi']) ? $_POST['ex_translation_vi'] : [];
        $ex_ids = isset($_POST['ex_id']) && is_array($_POST['ex_id']) ? $_POST['ex_id'] : [];
        $ex_delete_audio = isset($_POST['ex_delete_audio']) && is_array($_POST['ex_delete_audio']) ? $_POST['ex_delete_audio'] : [];
        
        // Task 5.5: Log what we received for example audio deletion
        error_log('[Dictionary Upload Debug] ex_delete_audio array: ' . print_r($ex_delete_audio, true));

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
                
                // Determine which audio file to use for this example
                $example_audio_filename = null;
                $old_example_id = isset($ex_ids[$idx]) && !empty($ex_ids[$idx]) ? (int)$ex_ids[$idx] : 0;
                
                // Check if new audio was uploaded for this example
                if (isset($example_audio_temp_files[$idx]) && $example_audio_temp_files[$idx] !== null) {
                    // New audio uploaded - use it and delete old one if exists
                    $targetDir = NV_ROOTDIR . '/uploads/' . $module_name . '/audio';
                    if (!is_dir($targetDir)) {
                        if (!is_dir(NV_ROOTDIR . '/uploads/' . $module_name)) {
                            nv_mkdir(NV_ROOTDIR . '/uploads', $module_name);
                        }
                        nv_mkdir(NV_ROOTDIR . '/uploads/' . $module_name, 'audio');
                    }

                    $file_ext = strtolower(pathinfo($example_audio_temp_files[$idx], PATHINFO_EXTENSION));
                    $final_filename = $id . '_ex_' . $sort . '_' . nv_genpass(8) . '.' . $file_ext;
                    $final_path = $targetDir . '/' . $final_filename;
                    
                    // Task 5.5: Log source and destination paths before rename
                    error_log('[Dictionary Upload Debug] Example #' . $sort . ' audio move - source: ' . $example_audio_temp_files[$idx] . ', destination: ' . $final_path);
                    error_log('[Dictionary Upload Debug] Source file exists: ' . (file_exists($example_audio_temp_files[$idx]) ? 'YES' : 'NO'));
                    error_log('[Dictionary Upload Debug] Destination directory writable: ' . (is_writable(dirname($final_path)) ? 'YES' : 'NO'));
                    
                    // Task 5.5: Defensive checks
                    if (empty($example_audio_temp_files[$idx])) {
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_upload_failed') . ' (Example #%d)', $sort);
                        error_log('[Dictionary Upload Debug] ERROR: Empty example audio temp file path for example #' . $sort);
                    } elseif (!file_exists($example_audio_temp_files[$idx])) {
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_file_not_found') . ' (Example #%d)', $sort);
                        error_log('[Dictionary Upload Debug] ERROR: Example #' . $sort . ' audio file does not exist at path: ' . $example_audio_temp_files[$idx]);
                    } elseif (!is_writable(dirname($final_path))) {
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_directory_not_writable') . ' (Example #%d)', $sort);
                        error_log('[Dictionary Upload Debug] ERROR: Example #' . $sort . ' destination directory not writable: ' . dirname($final_path));
                    } else {
                        // Task 5.5: Comprehensive error handling for rename
                        $rename_success = rename($example_audio_temp_files[$idx], $final_path);
                        error_log('[Dictionary Upload Debug] Example #' . $sort . ' audio rename result: ' . ($rename_success ? 'SUCCESS' : 'FAILED'));
                        
                        if ($rename_success) {
                            // Task 5.5: Verify destination file exists after rename
                            if (file_exists($final_path)) {
                                error_log('[Dictionary Upload Debug] Example #' . $sort . ' destination file verified at: ' . $final_path);
                                // New audio file moved successfully
                                $example_audio_filename = $final_filename;
                                
                                // Delete old audio file if it exists
                                if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                                    $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $keep_audio_files[$old_example_id];
                                    if (file_exists($old_path)) {
                                        if (!nv_deletefile($old_path)) {
                                            trigger_error('[Dictionary Upload] Failed to delete old example audio: ' . basename($old_path), E_USER_NOTICE);
                                            error_log('[Dictionary Upload Debug] WARNING: Failed to delete old example audio: ' . $old_path);
                                        } else {
                                            error_log('[Dictionary Upload Debug] Old example audio deleted: ' . $old_path);
                                        }
                                    } else {
                                        error_log('[Dictionary Upload Debug] Old example audio file not found: ' . $old_path);
                                    }
                                    unset($keep_audio_files[$old_example_id]);
                                }
                            } else {
                                $errors[] = sprintf($nv_Lang->getModule('error_audio_file_not_found') . ' (Example #%d)', $sort);
                                error_log('[Dictionary Upload Debug] ERROR: Example #' . $sort . ' destination file does not exist after successful rename: ' . $final_path);
                            }
                        } else {
                            // Task 5.5: Get detailed error information
                            $last_error = error_get_last();
                            $error_msg = $last_error['message'] ?? 'Unknown error';
                            $errors[] = sprintf($nv_Lang->getModule('error_example_audio_failed') . ': ' . $error_msg, $sort);
                            error_log('[Dictionary Upload Debug] Example #' . $sort . ' audio rename FAILED: ' . $error_msg);
                            // Keep temp file for debugging
                            error_log('[Dictionary Upload Debug] Example #' . $sort . ' temp file kept for debugging at: ' . $example_audio_temp_files[$idx]);
                            
                            // Fall back to keeping old audio if exists
                            if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                                $example_audio_filename = $keep_audio_files[$old_example_id];
                            }
                        }
                    }
                    
                    // Clean up temp file if we encountered errors (but not on successful rename - already moved)
                    if (!empty($errors) && file_exists($example_audio_temp_files[$idx])) {
                        nv_deletefile($example_audio_temp_files[$idx]);
                    }
                } else {
                    // No new audio uploaded - check if user wants to delete existing audio
                    $delete_this_audio = isset($ex_delete_audio[$idx]) && (int)$ex_delete_audio[$idx] === 1;
                    
                    error_log('[Dictionary Upload Debug] Example idx=' . $idx . ', delete_audio=' . (int)($ex_delete_audio[$idx] ?? 0) . ', should_delete=' . ($delete_this_audio ? 'YES' : 'NO'));
                    
                    if ($delete_this_audio && $old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                        // User clicked "Remove" - delete the audio file
                        $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $keep_audio_files[$old_example_id];
                        error_log('[Dictionary Upload Debug] Deleting example audio: ' . $old_path);
                        if (file_exists($old_path)) {
                            if (!nv_deletefile($old_path)) {
                                trigger_error('[Dictionary Upload] Failed to delete example audio: ' . basename($old_path), E_USER_NOTICE);
                                error_log('[Dictionary Upload Debug] WARNING: Failed to delete example audio: ' . $old_path);
                            } else {
                                error_log('[Dictionary Upload Debug] Example audio deleted: ' . $old_path);
                            }
                        } else {
                            error_log('[Dictionary Upload Debug] Example audio file not found for deletion: ' . $old_path);
                        }
                        unset($keep_audio_files[$old_example_id]);
                        $example_audio_filename = null; // No audio for this example
                    } elseif ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                        // Preserve existing audio
                        $example_audio_filename = $keep_audio_files[$old_example_id];
                        // Remove from tracking so it's not deleted as orphaned
                        unset($keep_audio_files[$old_example_id]);
                    }
                }
                
                // Insert example with appropriate audio file
                $stmt_ex->bindParam(':entry_id', $id, PDO::PARAM_INT);
                $stmt_ex->bindParam(':sentence_en', $sentence, PDO::PARAM_STR);
                $stmt_ex->bindParam(':translation_vi', $translation, PDO::PARAM_STR);
                if ($example_audio_filename !== null) {
                    $stmt_ex->bindValue(':audio_file', $example_audio_filename, PDO::PARAM_STR);
                } else {
                    $stmt_ex->bindValue(':audio_file', null, PDO::PARAM_NULL);
                }
                $stmt_ex->bindParam(':sort', $sort, PDO::PARAM_INT);
                $stmt_ex->bindParam(':created_at', $updated_at, PDO::PARAM_INT);
                $stmt_ex->execute();
            }
            
            // Clean up any orphaned audio files (examples that were removed but had audio)
            foreach ($keep_audio_files as $unused_audio) {
                $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $unused_audio;
                if (file_exists($old_path)) {
                    if (!nv_deletefile($old_path)) {
                        trigger_error('[Dictionary Upload] Failed to delete orphaned audio file: ' . basename($old_path), E_USER_NOTICE);
                        error_log('[Dictionary Upload Debug] WARNING: Failed to delete orphaned audio file: ' . $old_path);
                    } else {
                        error_log('[Dictionary Upload Debug] Orphaned audio file deleted: ' . $old_path);
                    }
                } else {
                    error_log('[Dictionary Upload Debug] Orphaned audio file not found: ' . $old_path);
                }
            }
        }

        // Task 5.8: Use different success message based on whether audio was uploaded or modified
        if ($new_audio_filename !== $original_audio || !empty(array_filter($example_audio_temp_files)) || $delete_audio === 1) {
            $_SESSION['dictionary_success_message'] = sprintf(
                $nv_Lang->getModule('entry_updated_success_with_audio'),
                $data['headword']
            );
        } else {
            $_SESSION['dictionary_success_message'] = sprintf(
                $nv_Lang->getModule('entry_updated_success'),
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
        $errors[] = $nv_Lang->getModule('errorsave') . ': ' . $e->getMessage();
        // Task 2.7: Clean up temp files on error
        if ($headword_audio_temp_file !== null) {
            nv_deletefile($headword_audio_temp_file);
        }
        foreach ($example_audio_temp_files as $temp_file) {
            if ($temp_file !== null) {
                nv_deletefile($temp_file);
            }
        }
        
        trigger_error('[Dictionary Upload] Database error during entry edit: ' . $e->getMessage(), E_USER_WARNING);
        
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

// Prefill data (avoid passing null to htmlspecialchars)
foreach ($data as $k => $v) {
    $safeValue = $v === null ? '' : (string) $v;
    $xtpl->assign(strtoupper($k), htmlspecialchars($safeValue, ENT_QUOTES, 'UTF-8'));
}

// Handle existing audio file display
if (!empty($data['audio_file'])) {
    $xtpl->assign('AUDIO_URL', NV_BASE_SITEURL . 'uploads/' . $module_name . '/audio/' . $data['audio_file']);
    $xtpl->assign('AUDIO_FILE', htmlspecialchars($data['audio_file'], ENT_QUOTES, 'UTF-8'));
    $xtpl->parse('main.current_audio');
    $xtpl->parse('main.delete_audio');
} else {
    // Parse no_audio block when no audio exists
    $xtpl->parse('main.no_audio');
}

// Render existing examples
if (!empty($existing_examples)) {
    foreach ($existing_examples as $idx => $example) {
        $xtpl->assign('EXAMPLE', [
            'id' => $example['id'],
            'num' => $idx + 1,
            'sentence_en' => htmlspecialchars((string) ($example['sentence_en'] ?? ''), ENT_QUOTES, 'UTF-8'),
            'translation_vi' => htmlspecialchars((string) ($example['translation_vi'] ?? ''), ENT_QUOTES, 'UTF-8'),
            'audio_file' => !empty($example['audio_file']) ? htmlspecialchars((string) $example['audio_file'], ENT_QUOTES, 'UTF-8') : '',
            'audio_url' => !empty($example['audio_file']) ? NV_BASE_SITEURL . 'uploads/' . $module_name . '/audio/' . $example['audio_file'] : ''
        ]);
        if (!empty($example['audio_file'])) {
            $xtpl->parse('main.example.current_example_audio');
        } else {
            $xtpl->parse('main.example.no_example_audio');
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
