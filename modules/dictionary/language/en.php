<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$lang_translator['author'] = 'VINADES.,JSC <contact@vinades.vn>';
$lang_translator['createdate'] = '20/07/2023, 07:15';
$lang_translator['copyright'] = '@Copyright (C) 2010 VINADES.,JSC. All rights reserved';
$lang_translator['info'] = '';
$lang_translator['langtype'] = 'lang_module';

// Page titles
$lang_module['add'] = 'Add New Entry';
$lang_module['edit'] = 'Edit Entry';
$lang_module['list'] = 'Dictionary Entries';

// Form fields
$lang_module['headword'] = 'Headword';
$lang_module['slug'] = 'URL Alias';
$lang_module['pos'] = 'Part of Speech';
$lang_module['phonetic'] = 'Phonetic';
$lang_module['meaning_vi'] = 'Vietnamese Meaning';
$lang_module['notes'] = 'Notes';
$lang_module['examples'] = 'Examples';
$lang_module['example_sentence'] = 'Sentence (EN)';
$lang_module['example_translation'] = 'Translation (VI)';

// Placeholders
$lang_module['slug_auto_generate'] = 'Auto-generated if left empty';
$lang_module['pos_placeholder'] = 'e.g., n., v., adj.';
$lang_module['phonetic_placeholder'] = '/fəˈnɛtɪk/';
$lang_module['example_sentence_placeholder'] = 'Example sentence in English';
$lang_module['example_translation_placeholder'] = 'Vietnamese translation (optional)';

// Buttons
$lang_module['add_example'] = 'Add example';
$lang_module['remove_example'] = 'Remove example';
$lang_module['save'] = 'Save';
$lang_module['cancel'] = 'Cancel';
$lang_module['delete'] = 'Delete';

// Validation messages
$lang_module['error_empty_headword'] = 'Please enter a headword';
$lang_module['error_empty_meaning'] = 'Please enter the Vietnamese meaning';

// Success messages
$lang_module['success_add'] = 'Entry added successfully';
$lang_module['success_edit'] = 'Entry updated successfully';
$lang_module['success_delete'] = 'Entry deleted successfully';
$lang_module['entry_added_success'] = 'Entry "%s" has been added successfully';
$lang_module['entry_added_success_with_audio'] = 'Entry "%s" has been added successfully with audio pronunciation.';
$lang_module['entry_updated_success'] = 'Entry "%s" has been updated successfully';
$lang_module['entry_updated_success_with_audio'] = 'Entry "%s" has been updated successfully with audio pronunciation.';
$lang_module['entry_deleted_success'] = 'Entry "%s" has been deleted successfully';
$lang_module['errorsave'] = 'An error occurred while saving';

// Notifications
$lang_module['notif_entry_added'] = 'New dictionary entry added: {title}';
$lang_module['notif_entry_updated'] = 'Dictionary entry updated: {title}';
$lang_module['notif_entry_deleted'] = 'Dictionary entry deleted: {title}';

// Common
$lang_module['example'] = 'Example';
$lang_module['search'] = 'Search';
$lang_module['actions'] = 'Actions';
$lang_module['status'] = 'Status';
$lang_module['created_at'] = 'Created';
$lang_module['updated_at'] = 'Updated';
$lang_module['no_data'] = 'No data available';

// Search
$lang_module['search_placeholder'] = 'Search by headword, meaning, or part of speech...';
$lang_module['searching'] = 'Searching...';

// Main page
$lang_module['main_intro'] = 'Search for English words to see Vietnamese meanings and examples.';
$lang_module['type_to_search'] = 'Type a word to search...';
$lang_module['no_results'] = 'No words found matching your search';
$lang_module['loading'] = 'Loading...';
$lang_module['select_word'] = 'Select a word from the suggestions';
$lang_module['back_to_search'] = 'Back to Search';

// Audio
$lang_module['audio_pronunciation'] = 'Audio Pronunciation';
$lang_module['play_pronunciation'] = 'Play pronunciation';
$lang_module['upload_audio'] = 'Upload Audio';
$lang_module['audio_optional'] = 'Optional - MP3 or WAV, max 5MB';
$lang_module['current_audio'] = 'Current audio file';
$lang_module['replace_audio'] = 'Replace audio';
$lang_module['delete_audio'] = 'Delete audio';
$lang_module['example_audio'] = 'Example Audio';

// Audio UI - buttons and messages
$lang_module['upload_audio_btn'] = 'Upload Audio';
$lang_module['replace_audio_btn'] = 'Replace Audio';
$lang_module['remove_audio_btn'] = 'Remove';
$lang_module['undo_remove_audio_btn'] = 'Undo';
$lang_module['will_be_deleted'] = 'Will be deleted on save';
$lang_module['new_file_selected'] = 'New file selected: {filename}';
$lang_module['file_selected'] = 'File selected: {filename}';

// Audio - errors
$lang_module['error_audio_size'] = 'Audio file size exceeds 5MB';
$lang_module['error_audio_type'] = 'Only MP3 and WAV files are allowed';
$lang_module['error_audio_upload'] = 'Failed to upload audio file';
$lang_module['error_audio_upload_failed'] = 'Failed to upload audio file. Please try again.';
$lang_module['error_audio_move_failed'] = 'Audio file uploaded but could not be saved to final location.';
$lang_module['error_audio_delete_failed'] = 'Could not delete old audio file (file may be missing).';
$lang_module['error_audio_not_found'] = 'The requested audio file could not be found.';
$lang_module['error_audio_file_not_found'] = 'Audio file could not be found after upload. Please try again.';
$lang_module['error_audio_directory_not_writable'] = 'Audio upload directory is not writable. Please contact administrator.';
$lang_module['error_example_audio_failed'] = 'Failed to save audio for example #%d.';
$lang_module['download_audio'] = 'Download Audio';
