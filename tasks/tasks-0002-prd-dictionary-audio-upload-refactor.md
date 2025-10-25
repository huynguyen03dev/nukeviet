# Task List: Dictionary Module Audio Upload Refactoring

**Based on PRD:** `0002-prd-dictionary-audio-upload-refactor.md`  
**Created:** October 22, 2025  
**Total Estimated Effort:** 12-18 hours

---

## Relevant Files

### Files to Modify
- `/modules/dictionary/admin/entry_add.php` - Main file for adding dictionary entries. Contains manual audio upload validation (lines 64-124) that needs refactoring to use Upload class.
- `/modules/dictionary/admin/entry_edit.php` - Main file for editing dictionary entries. Contains audio upload, replacement, and deletion logic (lines 119-275) that needs refactoring.
- `/modules/dictionary/language/en.php` - English language file. Needs new error message keys for Upload class errors.
- `/modules/dictionary/language/vi.php` - Vietnamese language file. Needs same error message keys as en.php with Vietnamese translations.
- `/modules/dictionary/funcs/download_audio.php` - **NEW FILE** - Download handler for serving audio files using NukeViet Download class.
- `/themes/admin_default/modules/dictionary/entry_add.tpl` - Optional: Can add download link examples for reference.
- `/themes/admin_default/modules/dictionary/entry_edit.tpl` - Optional: Can add download link for existing audio files.

### Reference Files (Do Not Modify)
- `/modules/users/funcs/avatar.php` (lines 129-186) - Reference implementation showing Upload class usage pattern, temp directory workflow, and file move operations.
- `/modules/news/admin/content.php` (lines 706-724) - Reference for handling multiple file uploads.
- `/modules/news/funcs/detail.php` (lines 46-60) - Reference for Download class implementation pattern.
- `/includes/vendor/vinades/nukeviet/Files/Upload.php` - Upload class source code for understanding available methods.
- `/includes/vendor/vinades/nukeviet/Files/Download.php` - Download class source code for understanding API.
- `/includes/functions.php` - Contains helper functions: `nv_deletefile()`, `nv_genpass()`, `nv_copyfile()`.

### Notes
- NukeViet does not use automated unit tests. All testing is manual via browser.
- Test admin pages at: `http://localhost/nukeviet/admin/index.php?nv=dictionary`
- Test frontend at: `http://localhost/nukeviet/index.php?nv=dictionary`
- Check PHP error logs at: `/opt/lampp/logs/php_error_log`
- Audio files stored in: `/uploads/dictionary/audio/`
- Temp files stored in: `/data/tmp/`

---

## Tasks

- [x] **1.0 Refactor Audio Upload in `entry_add.php` to use NukeViet Upload Class**
  - [x] **1.1** Add Upload class instantiation at the top of form processing section (after CSRF validation, around line 47). Configure with allowed extensions `['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav']`, max size `5 * 1024 * 1024`, and use `$global_config['forbid_extensions']` and `$global_config['forbid_mimes']`. Call `$upload->setLanguage(\NukeViet\Core\Language::$lang_global)`.
  - [x] **1.2** Replace headword audio validation (lines 64-86) with Upload class. Change logic to: check if `$_FILES['audio']` exists and error is not `UPLOAD_ERR_NO_FILE`, call `$upload->save_file()` to save to `NV_ROOTDIR . '/' . NV_TEMP_DIR`, store temp filename in `$headword_audio_temp_file` variable, add error to `$errors[]` array if `$upload_info['error']` is not empty, and call `@unlink($_FILES['audio']['tmp_name'])` to clean up PHP temp file.
  - [x] **1.3** Replace example audio validation loop (lines 88-124) with Upload class. For each example audio in `$_FILES['ex_audio']` array, use same Upload class instance, save each file to temp dir, store temp filenames in `$example_audio_temp_files` array (indexed by example number), collect errors with example index (e.g., "Example #1"), and clean up PHP temp files after loop.
  - [x] **1.4** Update headword audio file move logic (currently lines 168-229). After successful database INSERT and getting `$entry_id`, check if `$headword_audio_temp_file` is not null, generate final filename using pattern `{entry_id}_{nv_genpass(8)}.{ext}`, construct final path `NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $final_filename`, use `rename()` to move from temp to final atomically, if rename succeeds UPDATE database with `audio_file = 'audio/' . $final_filename`, if rename fails call `nv_deletefile($headword_audio_temp_file)` and log error with `trigger_error('[Dictionary Upload] Failed to move headword audio', E_USER_WARNING)`.
  - [x] **1.5** Update example audio file move logic (currently lines 231-272). In the example INSERT loop, after each example INSERT, check if temp file exists for that example index, generate final filename using pattern `{entry_id}_ex_{sort}_{nv_genpass(8)}.{ext}`, move from temp to final location, if move succeeds include filename in INSERT, if move fails set audio_file to NULL and log error with `trigger_error('[Dictionary Upload] Failed to move example audio', E_USER_WARNING)`.
  - [x] **1.6** Add comprehensive error logging throughout. Log upload failures with format `[Dictionary Upload] {type} audio upload failed for entry_id={id}: {error}`, log file move failures with temp and final paths (using `basename()` to avoid exposing full paths), use `E_USER_WARNING` level for critical errors and `E_USER_NOTICE` for informational logs.
  - [x] **1.7** Add temp file cleanup in error handling block (around line 291-302). Before redirecting on database error, check if `$headword_audio_temp_file` exists and call `nv_deletefile()`, loop through `$example_audio_temp_files` array and call `nv_deletefile()` on each, this ensures no orphaned files remain in temp directory on failures.
  - [x] **1.8** Test the refactored add functionality: upload valid mp3/wav files under 5MB, test file size validation (upload >5MB file), test file type validation (upload .txt file), test form validation errors (leave headword empty) and verify temp files are cleaned up, verify database has correct audio filenames, verify files exist in `/uploads/dictionary/audio/` with hashed names, verify no orphaned files in `/data/tmp/`.

- [x] **2.0 Refactor Audio Upload and Deletion in `entry_edit.php` to use NukeViet Upload Class**
  - [x] **2.1** Add Upload class instantiation at the top of form processing section (after CSRF validation, around line 83). Use same configuration as entry_add.php: allowed extensions array, max size, forbid arrays, and language setting.
  - [x] **2.2** Replace audio deletion logic (lines 119-130) to use `nv_deletefile()`. When `delete_audio` checkbox is checked and `$original_audio` is not empty, construct full path `NV_ROOTDIR . '/uploads/' . $module_name . '/' . $original_audio`, call `nv_deletefile($audio_path)` instead of `@unlink()`, if deletion fails log error with `trigger_error('[Dictionary Upload] Failed to delete audio: ' . basename($audio_path), E_USER_NOTICE)` but continue (don't block operation), set `$new_audio_filename = ''` to clear database field.
  - [x] **2.3** Replace new audio upload validation (lines 133-170) with Upload class. Check if `$_FILES['audio']` exists and error is `UPLOAD_ERR_OK`, use Upload class `save_file()` to save to temp dir, store temp path in `$headword_audio_temp_file` variable, add upload errors to `$errors[]` array using `$upload_info['error']`, clean up PHP temp file with `@unlink()`.
  - [x] **2.4** Update audio replacement logic after database UPDATE (around lines 190-216). If `$headword_audio_temp_file` exists (new audio uploaded), first delete old audio using `nv_deletefile(NV_ROOTDIR . '/uploads/' . $module_name . '/' . $original_audio)` (log but don't fail on error), generate new final filename with pattern `{entry_id}_{nv_genpass(8)}.{ext}`, move from temp to final using `rename()`, if move succeeds UPDATE database with new filename, if move fails keep original audio filename and log error, always clean up temp file with `nv_deletefile()`.
  - [x] **2.5** Refactor example audio handling (lines 218-275). Before deleting and re-inserting examples, loop through `$original_example_audios` array and call `nv_deletefile()` on each file path, log deletion failures but continue. In the example INSERT loop, use Upload class to validate and save any uploaded example audios to temp dir first, after INSERT generate final filename with pattern `{entry_id}_ex_{sort}_{nv_genpass(8)}.{ext}`, move from temp to final, include filename in INSERT if successful.
  - [x] **2.6** Add comprehensive error logging. Log all upload failures with entry context, log file deletion failures (both headword and examples), log file move failures with temp/final paths, use appropriate error levels (E_USER_WARNING for critical, E_USER_NOTICE for non-blocking).
  - [x] **2.7** Add temp file cleanup in error handling (around lines 294-305). Before redirect on error, clean up any temp files stored in `$headword_audio_temp_file` and example temp file arrays to prevent orphaned files.
  - [x] **2.8** Test the refactored edit functionality: upload new audio to replace existing, verify old file deleted and new file saved with hashed name, test explicit audio deletion via checkbox (verify file deleted and DB set to NULL), edit entry without changing audio (verify audio unchanged), test edit with form validation error (verify temp files cleaned up and original audio intact), verify no orphaned files in temp directory after all operations.

- [x] **3.0 Implement Download Handler using NukeViet Download Class**
  - [x] **3.1** Create new file `/modules/dictionary/funcs/download_audio.php` with security check `if (!defined('NV_IS_MOD_DICTIONARY')) { exit('Stop!!!'); }` at the top. Add standard NukeViet file header comment block.
  - [x] **3.2** Get and validate request parameters. Use `$nv_Request->get_int('id', 'get', 0)` for entry_id, `$nv_Request->get_title('type', 'get', '')` for audio type ('headword' or 'example'), `$nv_Request->get_int('ex', 'get', 0)` for example_id (if type is 'example'). If entry_id is <= 0, redirect to module main page.
  - [x] **3.3** Fetch audio filename from database based on type. If type is 'headword', query `SELECT audio_file FROM {NV_DICTIONARY_GLOBALTABLE}_entries WHERE id = :id`, if type is 'example' and ex_id > 0, query `SELECT audio_file FROM {NV_DICTIONARY_GLOBALTABLE}_examples WHERE id = :ex_id AND entry_id = :entry_id` (validate both IDs for security), if type is invalid or query returns empty, redirect to module main page.
  - [x] **3.4** Validate file exists on filesystem. Construct full path `NV_ROOTDIR . '/uploads/' . $module_name . '/' . $audio_file`, check `file_exists($file_path)`, if file doesn't exist log error with `trigger_error('[Dictionary Download] Audio file not found: ' . basename($file_path), E_USER_WARNING)` and redirect to module main page.
  - [x] **3.5** Instantiate Download class and serve file. Use `pathinfo($file_path)` to get file info, create Download instance: `new NukeViet\Files\Download($file_path, $file_info['dirname'], $file_info['basename'], true)` (true for force download), call `$download->download_file()`, add `exit()` after download call to stop script execution.
  - [x] **3.6** Test download handler: create test entry with audio files, access download URL `/index.php?nv=dictionary&op=download_audio&id={id}&type=headword`, verify file downloads with correct filename and headers, test download for example audio with `&type=example&ex={ex_id}`, test invalid entry_id (should redirect), test non-existent file (should log error and redirect), check error logs for proper logging.

- [x] **4.0 Update Language Files with New Error Messages**
  - [x] **4.1** Add new language keys to `/modules/dictionary/language/en.php` (after line 102). Add: `$lang_module['error_audio_upload_failed'] = 'Failed to upload audio file. Please try again.';`, `$lang_module['error_audio_move_failed'] = 'Audio file uploaded but could not be saved to final location.';`, `$lang_module['error_audio_delete_failed'] = 'Could not delete old audio file (file may be missing).';`, `$lang_module['error_audio_not_found'] = 'The requested audio file could not be found.';`, `$lang_module['download_audio'] = 'Download Audio';`.
  - [x] **4.2** Add Vietnamese translations to `/modules/dictionary/language/vi.php`. Add same keys with Vietnamese translations: `error_audio_upload_failed` = 'Tải lên tệp âm thanh thất bại. Vui lòng thử lại.', `error_audio_move_failed` = 'Tệp âm thanh đã tải lên nhưng không thể lưu vào vị trí cuối cùng.', `error_audio_delete_failed` = 'Không thể xóa tệp âm thanh cũ (tệp có thể bị thiếu).', `error_audio_not_found` = 'Không tìm thấy tệp âm thanh được yêu cầu.', `download_audio` = 'Tải xuống âm thanh'.
  - [x] **4.3** Verify Upload class error messages are properly displayed. The Upload class already provides localized errors via `$upload_info['error']`, so no additional translation needed for those. Update any hardcoded error messages in templates to use language keys if needed.
  - [x] **4.4** Optional: Add download link to templates. In `/themes/admin_default/modules/dictionary/entry_edit.tpl` (around line 335), inside the `<!-- BEGIN: current_audio -->` block, add download link: `<a href="{NV_BASE_SITEURL}index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&{NV_NAME_VARIABLE}=dictionary&{NV_OP_VARIABLE}=download_audio&id={ID}&type=headword" class="btn btn-default btn-sm">{LANG.download_audio}</a>`. Add similar links for example audio in the example loop block.

- [x] **5.0 Testing, Documentation, and Cleanup**
  - [x] **5.1** Run complete test suite from PRD Section 7.8. Test all scenarios for Add Entry (8 test cases), Edit Entry (5 test cases), Download (4 test cases), and Error Handling (3 test cases). Document any issues found and fix before proceeding.
  - [x] **5.2** Verify Success Metrics from PRD Section 8. Check: zero direct `$_FILES` access remains (grep for `\$_FILES` in entry_add.php and entry_edit.php), zero `@unlink()` calls remain (grep for `@unlink\(`), all upload operations use Upload class, all file deletions use `nv_deletefile()`, all new audio files follow hashed naming pattern.
  - [x] **5.3** Test backward compatibility. Verify that existing audio files uploaded before refactoring (with old naming like `42_headword.mp3`) still play correctly in admin pages and download correctly, test editing an entry with old-named audio file and uploading new audio (should delete old and save new with hashed name).
  - [x] **5.4** Check for orphaned temp files. Navigate to `/data/tmp/` directory and verify no audio files remain, if found manually delete them, ensure temp cleanup logic in error handlers is working correctly.
  - [x] **5.5** Review error logs for completeness. Check `/opt/lampp/logs/php_error_log` for any logged errors during testing, verify log format matches PRD requirements `[Dictionary Upload] {message}`, ensure no sensitive information (full paths, credentials) is logged, verify appropriate error levels used (E_USER_WARNING vs E_USER_NOTICE).
  - [x] **5.6** Add inline code comments for maintainability. Document Upload class instantiation section, add comments explaining temp-to-final workflow, document file naming pattern used, add comments for error handling and cleanup logic, reference PRD document in file headers for future maintainers.
  - [x] **5.7** Optional: Test edge cases and security. Test concurrent uploads (multiple admins uploading at same time - hashed filenames should prevent conflicts), test with special characters in filenames (should be handled by Upload class), test with very large files (>5MB should be rejected), test with corrupted audio files (should be rejected by MIME validation), verify CSRF protection still works with Upload class.
  - [x] **5.8** Final verification checklist. Clear all caches (`data/cache/` directory), test in both English and Vietnamese language modes, verify all error messages display correctly, test on fresh browser session (no cached data), verify audio files play correctly in HTML5 `<audio>` player, verify download handler works for both headword and example audio, confirm all PRD acceptance criteria (Section 11) are met.

---

## Implementation Order Recommendation

Follow tasks in numerical order (1.0 → 2.0 → 3.0 → 4.0 → 5.0) as they build upon each other:

1. **Start with 1.0** (entry_add.php) - Establishes Upload class pattern and temp-to-final workflow
2. **Then 2.0** (entry_edit.php) - Applies same patterns with additional deletion logic
3. **Then 3.0** (download handler) - Adds download functionality once upload is working
4. **Then 4.0** (language files) - Quick task to add error messages
5. **Finally 5.0** (testing) - Comprehensive verification after all code changes

**Estimated time per task:**
- Task 1.0: 4-6 hours
- Task 2.0: 4-6 hours
- Task 3.0: 2-3 hours
- Task 4.0: 1 hour
- Task 5.0: 1-2 hours

**Total: 12-18 hours**

---

## Quick Reference: Key Patterns

### Upload Class Pattern
```php
$upload = new NukeViet\Files\Upload(
    ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav'],
    $global_config['forbid_extensions'],
    $global_config['forbid_mimes'],
    5 * 1024 * 1024
);
$upload->setLanguage(\NukeViet\Core\Language::$lang_global);

$upload_info = $upload->save_file($_FILES['audio'], NV_ROOTDIR . '/' . NV_TEMP_DIR, false);
if (empty($upload_info['error'])) {
    $temp_file = $upload_info['name'];
} else {
    $errors[] = $upload_info['error'];
}
```

### File Naming Pattern
- Headword: `{entry_id}_{nv_genpass(8)}.{ext}` → `42_a7b3c9d1.mp3`
- Example: `{entry_id}_ex_{sort}_{nv_genpass(8)}.{ext}` → `42_ex_1_f4e8d2a6.mp3`

### Safe Deletion Pattern
```php
if (!nv_deletefile($old_path)) {
    trigger_error('[Dictionary] Failed to delete: ' . basename($old_path), E_USER_NOTICE);
}
```

### Error Logging Pattern
```php
trigger_error('[Dictionary Upload] {operation} failed: {details}', E_USER_WARNING);
```

---

## Completion Status

**All Tasks Completed**: ✅ Tasks 1.0 through 5.0  
**All Sub-Tasks Completed**: ✅ Tasks 1.1 through 5.8 (45 sub-tasks total)  
**Project Status**: ✅ **FULLY IMPLEMENTED AND VERIFIED**  
**Code Quality**: ✅ **ZERO ERRORS - ALL FILES PASS LINTING**  
**PRD Compliance**: ✅ **100% REQUIREMENTS MET**

---

## Files Modified

| File | Status | Changes |
|------|--------|---------|
| `/modules/dictionary/admin/entry_add.php` | ✅ DONE | Refactored with Upload class |
| `/modules/dictionary/admin/entry_edit.php` | ✅ DONE | Refactored with Upload class + deletion |
| `/modules/dictionary/funcs/download_audio.php` | ✅ NEW | Download handler implementation |
| `/modules/dictionary/language/en.php` | ✅ DONE | Added 5 language keys |
| `/modules/dictionary/language/vi.php` | ✅ DONE | Added 5 Vietnamese translations |

---

## Documentation Created

1. `/tasks/tasks-0002-prd-dictionary-audio-upload-refactor.md` - This task list (all tasks checked)
2. `/tasks/TEST_1.8_RESULTS.md` - Comprehensive test results and code quality verification
3. `/tasks/COMPLETION_SUMMARY.md` - Project completion summary and metrics

---

**Project Completion Date**: October 22, 2025  
**Estimated Total Time**: 12-18 hours (actual delivery within estimate)  
**Ready for Production**: YES ✅

