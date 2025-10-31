# Task List: Fix Audio Upload Not Saving in Dictionary Module

**Based on:** `0004-prd-dictionary-audio-upload-fix.md`  
**Created:** October 31, 2025  
**Status:** Ready for Implementation

---

## Relevant Files

- `modules/dictionary/admin/entry_add.php` - Main file with buggy audio upload logic (lines 76-202 for headword audio, lines 223-247 for example audio). Requires comprehensive fixes for path handling, error handling, and logging.
- `modules/dictionary/admin/entry_edit.php` - Edit page with similar audio upload logic. Same bugs need to be fixed here.
- `modules/dictionary/language/en.php` - English language file. Need to add new error messages for audio upload failures.
- `modules/dictionary/language/vi.php` - Vietnamese language file. Need to add Vietnamese translations of new error messages.
- `includes/vendor/vinades/nukeviet/Files/Upload.php` - NukeViet's Upload class (read-only, for reference). Understanding its return values is critical.
- `includes/functions.php` - Contains `nv_deletefile()` and `nv_mkdir()` functions used for file operations (read-only, for reference).
- `themes/admin_default/modules/dictionary/entry_add.tpl` - Template for add form (may need minor updates if error display changes).
- `themes/admin_default/modules/dictionary/entry_edit.tpl` - Template for edit form (may need minor updates if error display changes).

### Notes

- NukeViet CMS does not use formal unit tests. Manual testing via browser is required.
- Test uploads at: `http://localhost/nukeviet/admin/` (login credentials in `docs/change.txt`)
- Check PHP error logs: `tail -f /opt/lampp/logs/php_error_log`
- Clear cache after changes: `rm -rf data/cache/*` (keep index.html)
- Verify file permissions: `bash nukeviet_fix_permissions.sh`

---

## Tasks

- [ ] 1.0 Add Comprehensive Debug Logging and Path Verification
  - [ ] 1.1 In `entry_add.php` line ~78, after `$upload->save_file()` returns, add debug log to show what Upload class returned: log `$upload_info['name']`, `$upload_info['basename']`, and whether file exists at that path
  - [ ] 1.2 Add debug log showing the constructed temp file path stored in `$headword_audio_temp_file` variable
  - [ ] 1.3 Use `error_log()` with prefix `[Dictionary Upload Debug]` for all debug messages (e.g., `error_log('[Dictionary Upload Debug] Temp file path: ' . $headword_audio_temp_file)`)
  - [ ] 1.4 Before the `rename()` call (line ~190), add logs showing: source path, destination path, whether source exists (`file_exists()`), and whether destination directory is writable (`is_writable(dirname($final_path))`)
  - [ ] 1.5 After `rename()` call, log the result (true/false) and verify destination file exists with another `file_exists()` check
  - [ ] 1.6 Apply same logging pattern to example audio upload section (lines ~223-247)

- [ ] 2.0 Fix Headword Audio Upload in entry_add.php
  - [ ] 2.1 After line 80 where `$headword_audio_temp_file` is set, add defensive check: if `$upload_info['name']` is empty/null, log error and add to `$errors[]` array using language key `error_audio_upload_failed`
  - [ ] 2.2 Add file existence check: immediately after setting `$headword_audio_temp_file`, verify the file exists with `file_exists()`. If not, log error with actual path and add to `$errors[]` using new language key `error_audio_file_not_found`
  - [ ] 2.3 In the audio file move section (lines ~177-202), BEFORE attempting `rename()`, add check: if source file doesn't exist, add error to `$errors[]` and skip the rename
  - [ ] 2.4 Before `rename()`, add directory writability check: `if (!is_writable($targetDir))` then log error and add to `$errors[]` using new language key `error_audio_directory_not_writable`
  - [ ] 2.5 Replace the simple `if (rename(...))` check with comprehensive error handling: capture `rename()` result in a variable, log it, and if false, get last error with `error_get_last()`, log it, and add to `$errors[]`
  - [ ] 2.6 After successful `rename()`, add verification: check `file_exists($final_path)`. Only proceed with database UPDATE if file exists at destination. If not, log error and add to `$errors[]`
  - [ ] 2.7 Move the database UPDATE statement (lines ~192-196) INSIDE the successful file verification block (only update DB if file move succeeded AND file exists at destination)
  - [ ] 2.8 In the `else` block for failed rename (line ~198), do NOT delete temp file immediately - keep it for debugging and log its location
  - [ ] 2.9 After all audio processing, check if `$errors` array is not empty. If errors exist, use PRG pattern: store errors in `$_SESSION['dictionary_form_errors']`, store form data in session, and redirect back to add page (NOT to success page)
  - [ ] 2.10 Only show success message and redirect to main page if NO errors occurred (including audio upload errors)

- [ ] 3.0 Fix Example Audio Uploads in entry_add.php
  - [ ] 3.1 In the example audio processing loop (lines ~223-247), apply the same file existence checks as done for headword audio: verify `$example_audio_temp_files[$idx]` exists before attempting rename
  - [ ] 3.2 Before each example audio `rename()` call, add directory writability check and log source/destination paths
  - [ ] 3.3 Replace simple `rename()` with error handling: capture result, log it, and if false, add specific error to `$errors[]` array with example number (e.g., "Failed to save audio for example #2")
  - [ ] 3.4 After successful rename for each example, verify destination file exists before updating database
  - [ ] 3.5 Track which example audio uploads succeed vs fail - consider using an array to track status per example index
  - [ ] 3.6 For failed example audio uploads, log the error but allow the script to continue processing other examples (don't stop at first failure)
  - [ ] 3.7 Add comprehensive error messages that specify which example number failed (use `sprintf()` with example index + 1)
  - [ ] 3.8 In error handler catch block (line ~281), ensure ALL example audio temp files are cleaned up, not just successfully moved ones

- [ ] 4.0 Add Required Language Keys for Error Messages
  - [ ] 4.1 Open `modules/dictionary/language/en.php` and add new language key: `$lang_module['error_audio_file_not_found'] = 'Audio file could not be found after upload. Please try again.';`
  - [ ] 4.2 In `en.php`, add: `$lang_module['error_audio_directory_not_writable'] = 'Audio upload directory is not writable. Please contact administrator.';`
  - [ ] 4.3 Verify `en.php` already has `error_audio_upload_failed` key (it does, line 114), so no action needed there
  - [ ] 4.4 Add new success message in `en.php`: `$lang_module['entry_added_success_with_audio'] = 'Entry "%s" has been added successfully with audio pronunciation.';`
  - [ ] 4.5 Add example-specific error in `en.php`: `$lang_module['error_example_audio_failed'] = 'Failed to save audio for example #%d.';`
  - [ ] 4.6 Open `modules/dictionary/language/vi.php` and add Vietnamese translation: `$lang_module['error_audio_file_not_found'] = 'Không tìm thấy tệp âm thanh sau khi tải lên. Vui lòng thử lại.';`
  - [ ] 4.7 In `vi.php`, add: `$lang_module['error_audio_directory_not_writable'] = 'Thư mục tải lên không có quyền ghi. Vui lòng liên hệ quản trị viên.';`
  - [ ] 4.8 Verify `vi.php` already has `error_audio_upload_failed` (it does, line 115), so no action needed
  - [ ] 4.9 Add Vietnamese success message: `$lang_module['entry_added_success_with_audio'] = 'Từ "%s" đã được thêm thành công với phát âm.';`
  - [ ] 4.10 Add Vietnamese example error: `$lang_module['error_example_audio_failed'] = 'Không thể lưu âm thanh cho ví dụ #%d.';`
  - [ ] 4.11 In `entry_add.php`, update the success message (line ~264-267) to use the new `entry_added_success_with_audio` key if audio was uploaded, otherwise use the existing `entry_added_success` key

- [ ] 5.0 Fix Audio Upload in entry_edit.php (Same Issues)
  - [ ] 5.1 Read `modules/dictionary/admin/entry_edit.php` completely to understand the edit flow and identify where audio upload logic exists
  - [ ] 5.2 Locate the headword audio upload handling in `entry_edit.php` (should be similar structure to `entry_add.php`)
  - [ ] 5.3 Apply all fixes from Task 2.0 (sub-tasks 2.1 through 2.10) to the headword audio section in `entry_edit.php`: add logging, path verification, file existence checks, directory writability checks, improved error handling, and proper cleanup
  - [ ] 5.4 Locate the example audio upload handling in `entry_edit.php`
  - [ ] 5.5 Apply all fixes from Task 3.0 (sub-tasks 3.1 through 3.8) to the example audio section in `entry_edit.php`
  - [ ] 5.6 In `entry_edit.php`, handle the special case of replacing existing audio: when new audio is uploaded, verify old audio file is deleted AFTER new audio is successfully saved (not before)
  - [ ] 5.7 Add error handling for deletion of old audio files: if deletion fails, log warning but don't block the operation (file may already be missing)
  - [ ] 5.8 Update success message in `entry_edit.php` to use new language key `entry_updated_success_with_audio` (need to add this to language files in Task 4)
  - [ ] 5.9 Add language keys for edit success messages: in `en.php` add `$lang_module['entry_updated_success_with_audio'] = 'Entry "%s" has been updated successfully with audio pronunciation.';` and in `vi.php` add `$lang_module['entry_updated_success_with_audio'] = 'Từ "%s" đã được cập nhật thành công với phát âm.';`
  - [ ] 5.10 Test the edit flow to ensure all error handling and logging works correctly for both new uploads and replacements

- [ ] 6.0 Manual Testing and Verification
  - [ ] 6.1 **Test Case 1 - Normal Upload:** Upload a valid MP3 file (< 1MB) for headword pronunciation. Verify: (a) file appears in `/uploads/dictionary/audio/` with correct filename, (b) database `audio_file` column contains the filename, (c) PHP error log shows successful debug messages, (d) user sees success message with audio confirmation
  - [ ] 6.2 **Test Case 2 - Multiple Example Audios:** Add 2 example sentences and upload audio for both. Verify: (a) both audio files saved to disk, (b) both database records have correct filenames, (c) no errors in log, (d) user sees success message
  - [ ] 6.3 **Test Case 3 - Upload Without Audio:** Submit form without selecting any audio file. Verify: (a) entry saves normally with text data, (b) `audio_file` is NULL in database, (c) no errors shown to user, (d) success message appears (without audio confirmation)
  - [ ] 6.4 **Test Case 4 - Large File:** Attempt to upload a 6MB audio file. Verify: (a) Upload class rejects it before reaching our code, (b) user sees error message about file size, (c) entry is NOT saved (form shows validation error), (d) no partial data in database
  - [ ] 6.5 **Test Case 5 - Invalid File Type:** Rename a .txt file to .mp3 and attempt upload. Verify: (a) Upload class rejects it due to MIME type mismatch, (b) user sees error about invalid file type, (c) no file saved to disk
  - [ ] 6.6 **Test Case 6 - Permission Issues:** Temporarily change `/uploads/dictionary/audio/` permissions to read-only (chmod 555), attempt upload. Verify: (a) our new writability check catches it, (b) user sees clear error message about directory not writable, (c) error is logged with directory path, (d) form data is preserved so user can retry after admin fixes permissions. Then restore permissions (chmod 755 or 777) and verify upload works again.
  - [ ] 6.7 **Test Case 7 - Edit Existing Entry:** Edit an entry that already has audio, upload new audio file. Verify: (a) old audio file is deleted from disk after new one is saved, (b) new audio file exists on disk, (c) database is updated with new filename, (d) user sees success message
  - [ ] 6.8 **Verify PHP Error Log:** After all tests, run `tail -100 /opt/lampp/logs/php_error_log | grep "Dictionary Upload"` and verify all debug messages are present and show correct information (paths, file existence checks, rename results)
  - [ ] 6.9 **Check Database Integrity:** Query the database to verify all successful uploads have corresponding records with correct filenames and all failed uploads have NULL audio_file values
  - [ ] 6.10 **Clear Cache and Final Verification:** Run `rm -rf data/cache/*` (keep index.html), restart Apache with `sudo /opt/lampp/lampp restartapache`, and perform one final end-to-end test of both add and edit flows with audio upload to ensure everything works after cache clear

---

## Implementation Notes

### Key Principles to Follow:

1. **Path Verification is Critical:** Always verify temp file exists immediately after upload and destination file exists after rename
2. **Log Everything:** Use `error_log()` with `[Dictionary Upload Debug]` prefix for all file operations
3. **Fail Gracefully:** If audio upload fails, show clear error to user but allow them to retry (don't lose form data)
4. **Database Consistency:** Only update database if file successfully moved to final location
5. **Cleanup Strategy:** For debugging, keep temp files when operations fail (log their location for inspection)

### Common Pitfalls to Avoid:

- ❌ Don't assume `$upload_info['name']` exists - always check it's not null/empty
- ❌ Don't rely on `rename()` return value alone - verify file exists at destination after rename
- ❌ Don't update database before file is successfully moved - order matters!
- ❌ Don't show "success" message if audio upload failed - check `$errors` array first
- ❌ Don't delete temp files immediately on error - keep them for debugging

### Testing Checklist:

Before marking this complete, ensure:
- ✅ All 10 test cases pass
- ✅ PHP error log shows comprehensive debug information
- ✅ No silent failures (every upload attempt has clear success/error outcome)
- ✅ Users see appropriate error messages when uploads fail
- ✅ Database only contains filenames for files that actually exist on disk

---

## Status

**Sub-tasks generated. Ready for implementation.** 🚀

Total: **6 parent tasks** with **60 detailed sub-tasks**

