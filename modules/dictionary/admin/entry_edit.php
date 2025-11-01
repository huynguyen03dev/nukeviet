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

    // Task 2.2: Handle audio deletion request
    $new_audio_filename = $original_audio; // Default to keeping existing audio
    $delete_audio = $nv_Request->get_int('delete_audio', 'post', 0);
    
    // DEBUG: Log what we received
    error_log('[Dictionary Debug] delete_audio value: ' . $delete_audio . ', original_audio: ' . $original_audio);
    error_log('[Dictionary Debug] POST data: ' . print_r($_POST, true));
    
    if ($delete_audio === 1 && !empty($original_audio)) {
        $audio_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $original_audio;
        error_log('[Dictionary Debug] Attempting to delete: ' . $audio_path);
        if (!nv_deletefile($audio_path)) {
            trigger_error('[Dictionary Upload] Failed to delete audio: ' . basename($audio_path), E_USER_NOTICE);
            error_log('[Dictionary Debug] Delete failed!');
        } else {
            error_log('[Dictionary Debug] Delete successful!');
        }
        $new_audio_filename = '';
    } else {
        error_log('[Dictionary Debug] Skipping deletion - delete_audio: ' . $delete_audio . ', original_audio: ' . var_export($original_audio, true));
    }

    // Task 2.3: Validate and process new headword audio file (if uploaded)
    $headword_audio_temp_file = null;
    if (isset($_FILES['audio']) && $_FILES['audio']['error'] !== UPLOAD_ERR_NO_FILE) {
        $upload_info = $upload->save_file($_FILES['audio'], NV_ROOTDIR . '/' . NV_TEMP_DIR, false);
        
        error_log('[Dictionary Upload Debug] Headword audio upload_info: ' . print_r($upload_info, true));
        
        if (empty($upload_info['error'])) {
            // Check if upload_info['name'] is not null/empty
            if (empty($upload_info['name'])) {
                $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
                error_log('[Dictionary Upload Debug] upload_info[\'name\'] is empty or null');
            } else {
                $headword_audio_temp_file = $upload_info['name'];
                
                error_log('[Dictionary Upload Debug] Temp file path stored: ' . $headword_audio_temp_file);
                
                // Verify file exists immediately after setting path
                if (!file_exists($headword_audio_temp_file)) {
                    $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
                    error_log('[Dictionary Upload Debug] Temp file does NOT exist at: ' . $headword_audio_temp_file);
                    $headword_audio_temp_file = null; // Reset to prevent further processing
                } else {
                    error_log('[Dictionary Upload Debug] Temp file exists: YES');
                }
            }
        } else {
            $errors[] = $upload_info['error'];
            error_log('[Dictionary Upload Debug] Headword audio upload failed: ' . $upload_info['error']);
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
            
            error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' upload_info: ' . print_r($upload_info, true));
            
            if (empty($upload_info['error'])) {
                // Check if upload_info['name'] is not null/empty
                if (empty($upload_info['name'])) {
                    $errors[] = sprintf($nv_Lang->getModule('error_audio_upload_failed') . ' (Example #%d)', $idx + 1);
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' upload_info[\'name\'] is empty');
                } else {
                    $example_audio_temp_files[$idx] = $upload_info['name'];
                    
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' temp file: ' . $example_audio_temp_files[$idx]);
                    
                    // Verify file exists immediately after setting path
                    if (!file_exists($example_audio_temp_files[$idx])) {
                        $errors[] = sprintf($nv_Lang->getModule('error_audio_file_not_found') . ' (Example #%d)', $idx + 1);
                        error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' temp file does NOT exist');
                        $example_audio_temp_files[$idx] = null;
                    } else {
                        error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' temp file exists: YES');
                    }
                }
            } else {
                $errors[] = sprintf($nv_Lang->getModule('error_audio_upload_failed') . ' (Example #%d)', $idx + 1);
                error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' upload failed: ' . $upload_info['error']);
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

        // Task 2.4: Handle headword audio replacement - move temp file to final location if new audio uploaded
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
            
            error_log('[Dictionary Upload Debug] Before rename() - Source: ' . $headword_audio_temp_file);
            error_log('[Dictionary Upload Debug] Before rename() - Destination: ' . $final_path);
            
            // Check if source file exists before attempting rename
            if (!file_exists($headword_audio_temp_file)) {
                $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
                error_log('[Dictionary Upload Debug] Source file missing before rename');
            } else {
                error_log('[Dictionary Upload Debug] Source exists: YES');
                
                // Check directory writability
                if (!is_writable($targetDir)) {
                    $errors[] = $nv_Lang->getModule('error_audio_directory_not_writable');
                    error_log('[Dictionary Upload Debug] Destination directory NOT writable: ' . $targetDir);
                } else {
                    error_log('[Dictionary Upload Debug] Destination dir writable: YES');
                    
                    // Comprehensive error handling for rename()
                    $rename_result = rename($headword_audio_temp_file, $final_path);
                    error_log('[Dictionary Upload Debug] rename() result: ' . ($rename_result ? 'TRUE' : 'FALSE'));
                    
                    if (!$rename_result) {
                        $last_error = error_get_last();
                        $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
                        error_log('[Dictionary Upload Debug] rename() failed. Last error: ' . print_r($last_error, true));
                    } else {
                        // Verify file exists at destination after rename
                        if (file_exists($final_path)) {
                            error_log('[Dictionary Upload Debug] Destination file exists: YES');
                            
                            // File moved successfully, update new_audio_filename
                            $new_audio_filename = $final_filename;
                            
                            // Delete old audio file if it exists
                            if (!empty($original_audio)) {
                                $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $original_audio;
                                if (!nv_deletefile($old_path)) {
                                    trigger_error('[Dictionary Upload] Failed to delete old audio: ' . basename($old_path), E_USER_NOTICE);
                                }
                            }
                        } else {
                            $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
                            error_log('[Dictionary Upload Debug] Destination file does NOT exist after rename');
                        }
                    }
                    
                    // Keep temp file for debugging on error
                    if (!empty($errors)) {
                        error_log('[Dictionary Upload Debug] Keeping temp file for debugging: ' . $headword_audio_temp_file);
                    }
                }
            }
        }

        // Check if errors occurred during audio processing
        if (!empty($errors)) {
            // Store errors in session and redirect back to form (PRG pattern)
            $_SESSION['dictionary_form_errors'] = $errors;
            $_SESSION['dictionary_form_data'] = $data;
            
            // Clean up temp files on error
            if ($headword_audio_temp_file !== null && file_exists($headword_audio_temp_file)) {
                nv_deletefile($headword_audio_temp_file);
            }
            foreach ($example_audio_temp_files as $temp_file) {
                if ($temp_file !== null && file_exists($temp_file)) {
                    nv_deletefile($temp_file);
                }
            }
            
            nv_redirect_location(
                NV_BASE_ADMINURL . 'index.php?'
                . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
                . '&' . NV_NAME_VARIABLE . '=' . $module_name
                . '&' . NV_OP_VARIABLE . '=entry_edit&id=' . $id
            );
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

        // Task 2.5: Handle example updates with proper audio file management
        // Get submitted example IDs to track which examples are being kept
        $submitted_example_ids = isset($_POST['ex_id']) && is_array($_POST['ex_id']) ? $_POST['ex_id'] : [];

        // Delete examples that are not in the submitted list and their audio files
        $keep_audio_files = [];
        foreach ($existing_examples as $ex) {
            if (!in_array($ex['id'], $submitted_example_ids)) {
                // Example was removed - delete its audio file
                if (!empty($ex['audio_file'])) {
                    $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $ex['audio_file'];
                    if (!nv_deletefile($old_path)) {
                        trigger_error('[Dictionary Upload] Failed to delete removed example audio: ' . basename($old_path), E_USER_NOTICE);
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
        
        // DEBUG: Log what we received for example audio deletion
        error_log('[Dictionary Debug] ex_delete_audio array: ' . print_r($ex_delete_audio, true));

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
                    
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' before rename() - Source: ' . $example_audio_temp_files[$idx]);
                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' before rename() - Destination: ' . $final_path);
                    
                    // Check if source file exists before attempting rename
                    if (!file_exists($example_audio_temp_files[$idx])) {
                        trigger_error('[Dictionary Upload] Example #' . ($idx + 1) . ' source file missing before rename', E_USER_WARNING);
                        error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' source file missing');
                        
                        // Fall back to keeping old audio if exists
                        if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                            $example_audio_filename = $keep_audio_files[$old_example_id];
                        }
                    } else {
                        error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' source exists: YES');
                        
                        // Check directory writability
                        if (!is_writable($targetDir)) {
                            trigger_error('[Dictionary Upload] Example #' . ($idx + 1) . ' destination directory not writable', E_USER_WARNING);
                            error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' destination NOT writable');
                            
                            // Fall back to keeping old audio if exists
                            if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                                $example_audio_filename = $keep_audio_files[$old_example_id];
                            }
                        } else {
                            error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' destination writable: YES');
                            
                            // Comprehensive error handling for rename()
                            $rename_result = rename($example_audio_temp_files[$idx], $final_path);
                            error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' rename() result: ' . ($rename_result ? 'TRUE' : 'FALSE'));
                            
                            if (!$rename_result) {
                                $last_error = error_get_last();
                                trigger_error('[Dictionary Upload] Failed to move example #' . ($idx + 1) . ' audio. Error: ' . ($last_error['message'] ?? 'Unknown'), E_USER_WARNING);
                                error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' rename() failed. Last error: ' . print_r($last_error, true));
                                
                                // Fall back to keeping old audio if exists
                                if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                                    $example_audio_filename = $keep_audio_files[$old_example_id];
                                }
                            } else {
                                // Verify file exists at destination after rename
                                if (file_exists($final_path)) {
                                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' destination file exists: YES');
                                    
                                    // New audio file moved successfully
                                    $example_audio_filename = $final_filename;
                                    
                                    // Delete old audio file if it exists
                                    if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                                        $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $keep_audio_files[$old_example_id];
                                        if (!nv_deletefile($old_path)) {
                                            trigger_error('[Dictionary Upload] Failed to delete old example audio: ' . basename($old_path), E_USER_NOTICE);
                                        }
                                        unset($keep_audio_files[$old_example_id]);
                                    }
                                } else {
                                    trigger_error('[Dictionary Upload] Example #' . ($idx + 1) . ' file does not exist at destination after rename', E_USER_WARNING);
                                    error_log('[Dictionary Upload Debug] Example #' . ($idx + 1) . ' destination file does NOT exist after rename');
                                    
                                    // Fall back to keeping old audio if exists
                                    if ($old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                                        $example_audio_filename = $keep_audio_files[$old_example_id];
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // No new audio uploaded - check if user wants to delete existing audio
                    $delete_this_audio = isset($ex_delete_audio[$idx]) && (int)$ex_delete_audio[$idx] === 1;
                    
                    error_log('[Dictionary Debug] Example idx=' . $idx . ', delete_audio=' . (int)($ex_delete_audio[$idx] ?? 0) . ', should_delete=' . ($delete_this_audio ? 'YES' : 'NO'));
                    
                    if ($delete_this_audio && $old_example_id > 0 && isset($keep_audio_files[$old_example_id])) {
                        // User clicked "Remove" - delete the audio file
                        $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $keep_audio_files[$old_example_id];
                        error_log('[Dictionary Debug] Deleting example audio: ' . $old_path);
                        if (!nv_deletefile($old_path)) {
                            trigger_error('[Dictionary Upload] Failed to delete example audio: ' . basename($old_path), E_USER_NOTICE);
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
                if (!nv_deletefile($old_path)) {
                    trigger_error('[Dictionary Upload] Failed to delete orphaned audio file: ' . basename($old_path), E_USER_NOTICE);
                }
            }
        }

        // Store success message in session to show toast on next page
        // Use different message if audio was uploaded
        $has_audio = !empty($new_audio_filename);
        $success_key = $has_audio ? 'entry_updated_success_with_audio' : 'entry_updated_success';
        
        $_SESSION['dictionary_success_message'] = sprintf(
            $nv_Lang->getModule($success_key),
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
