# PRD: Fix Audio Upload Not Saving in Dictionary Module

**Document Version:** 1.0  
**Created:** October 31, 2025  
**Status:** Approved  
**Priority:** High (Critical Bug Fix)

---

## 1. Introduction/Overview

The dictionary module's audio upload feature is currently broken. When users upload an MP3 file for word pronunciation (headword audio) or example sentence audio and click save, the page redirects successfully and all text data is saved, but the audio files are never saved to disk or recorded in the database. The `audio_file` field remains `NULL` in the database, and no audio files appear in `/uploads/dictionary/audio/`.

This affects both:
- Headword audio pronunciation uploads
- Example sentence audio uploads

## 2. Goals

1. **Fix the audio upload bug** so that uploaded audio files are successfully:
   - Saved to the `/uploads/dictionary/audio/` directory
   - Recorded in the database (`audio_file` field for entries, examples)
   - Accessible for playback on the frontend

2. **Improve error handling and user feedback** so that:
   - Upload failures are clearly communicated to users
   - Detailed error logs are generated for debugging
   - Users know immediately if their audio upload succeeded or failed

3. **Ensure robustness** through:
   - Proper file path handling
   - Directory creation and permission checks
   - Transaction safety (cleanup on failure)

## 3. User Stories

**US-1: As an admin adding a dictionary entry**
- I want to upload an MP3 file for word pronunciation
- So that users can hear the correct pronunciation when viewing the word
- And I want immediate feedback if the upload fails

**US-2: As an admin adding example sentences**
- I want to upload audio files for each example sentence
- So that users can hear natural usage of the word in context
- And I want to see confirmation that my audio files were saved

**US-3: As a developer debugging upload issues**
- I want detailed error logs when file uploads fail
- So that I can quickly identify and fix permission issues, path problems, or other failures
- And I want to see the exact file paths being used

## 4. Root Cause Analysis

### Current Behavior

**entry_add.php (Lines 76-202):**

1. **Upload to temp directory** (Line 78):
   ```php
   $upload_info = $upload->save_file($_FILES['audio'], NV_ROOTDIR . '/' . NV_TEMP_DIR, false);
   ```
   - Uploads file to `/data/tmp/` successfully
   - Returns `$upload_info['name']` containing full path (e.g., `/opt/lampp/htdocs/nukeviet/data/tmp/nv_abc123.mp3`)

2. **Store temp file path** (Line 80):
   ```php
   $headword_audio_temp_file = $upload_info['name'];
   ```
   - Correctly captures the FULL PATH to temp file

3. **After database INSERT** (Lines 177-202):
   - Creates target directory `/uploads/dictionary/audio/`
   - Generates final filename: `{entry_id}_{random}.mp3`
   - **ATTEMPTS** to rename temp file to final location (Line 190):
     ```php
     if (rename($headword_audio_temp_file, $final_path)) {
         // Update database with audio filename
     } else {
         // Logs error but continues execution
         trigger_error('Failed to move audio', E_USER_WARNING);
         nv_deletefile($headword_audio_temp_file);
     }
     ```

### The Bug

**The `rename()` function at line 190 is FAILING SILENTLY** due to one or more of these reasons:

#### **Potential Issue #1: Incorrect Use of Upload Class Return Value**
- The Upload class returns `'basename'` (filename only) vs `'name'` (full path)
- If we're using the wrong key, `$headword_audio_temp_file` might only contain the filename
- `rename('filename.mp3', '/full/path/destination.mp3')` would fail because source has no path

#### **Potential Issue #2: File Already Moved/Deleted**
- The Upload class at line 1014 uses `@move_uploaded_file()` which MOVES (not copies) the file
- If something else deletes the temp file before our `rename()`, it will fail
- The `@` suppression operator hides errors

#### **Potential Issue #3: Path Construction Issues**
- `NV_TEMP_DIR` is a relative path (`'data/tmp'`), not absolute
- If `realpath()` or path construction is wrong, source file won't be found
- Trailing slashes, missing slashes, or incorrect concatenation

#### **Potential Issue #4: Permissions**
- `/uploads/dictionary/audio/` might not be writable by the web server user
- `/data/tmp/` might have restrictive permissions preventing file moves

#### **Potential Issue #5: Silent Failure Pattern**
- `rename()` returns `false` on failure but doesn't throw exceptions
- `trigger_error()` only logs (doesn't stop execution or show user)
- User sees "success" message because database INSERT succeeded, unaware audio failed

### Why Users Don't See Errors

1. **No validation** after `rename()` - execution continues regardless
2. **Errors only logged** with `trigger_error()`, not shown in UI
3. **PRG pattern** (Post-Redirect-Get) clears any potential error messages
4. **User sees success toast** based on database insert, not file upload

## 5. Functional Requirements

### FR-1: Fix Headword Audio Upload (entry_add.php)

**FR-1.1:** Verify the Upload class return value usage
- Confirm `$upload_info['name']` contains the FULL PATH (not just filename)
- Add defensive check: if `'name'` is missing, fall back to constructing full path from `'basename'`
- Log the actual path value for debugging

**FR-1.2:** Use absolute paths throughout
- Ensure `$headword_audio_temp_file` is an ABSOLUTE path
- Convert relative paths to absolute using `NV_ROOTDIR . '/' . NV_TEMP_DIR . '/' . basename()`
- Verify file exists before attempting `rename()`

**FR-1.3:** Add comprehensive error handling
- Check if source file exists before `rename()`:
  ```php
  if (!file_exists($headword_audio_temp_file)) {
      $errors[] = 'Audio file not found in temp directory';
      // Handle error
  }
  ```
- Check if destination directory is writable:
  ```php
  if (!is_writable($targetDir)) {
      $errors[] = 'Upload directory is not writable';
      // Handle error
  }
  ```
- Capture and show `rename()` failures to user:
  ```php
  if (!rename($source, $dest)) {
      $errors[] = 'Failed to save audio file: ' . error_get_last()['message'];
      // Handle error, don't just log
  }
  ```

**FR-1.4:** Add detailed debug logging
- Log source path, destination path, and file existence checks
- Log rename operation results
- Use format: `[Dictionary Upload Debug] Source: {path}, Exists: {yes/no}, Dest: {path}, Writable: {yes/no}`

**FR-1.5:** Verify file after move
- After successful `rename()`, verify destination file exists:
  ```php
  if (rename($source, $dest) && file_exists($dest)) {
      // Success - update database
  } else {
      // Failed - show error to user
  }
  ```

**FR-1.6:** Handle errors properly with PRG pattern
- If `rename()` fails, add error to `$errors[]` array
- Store errors in `$_SESSION['dictionary_form_errors']`
- Redirect back to form (not to success page)
- Show clear error message: "Failed to save audio file. Please try again."

**FR-1.7:** Clean up temp files reliably
- Use `nv_deletefile()` to remove temp file ONLY after successful move
- If move fails, keep temp file for debugging (but log its location)
- Clean up temp files in the error handler (`catch` block)

### FR-2: Fix Example Audio Upload (entry_add.php)

**FR-2.1:** Apply all fixes from FR-1 to example audio handling (lines 223-247)
- Same path verification, error handling, logging, and cleanup logic

**FR-2.2:** Handle multiple file uploads correctly
- Each example can have its own audio file
- Track which example audio uploads succeed vs fail
- Show specific error messages (e.g., "Example #2 audio upload failed")

### FR-3: Fix Same Issues in entry_edit.php

**FR-3.1:** Review and fix entry_edit.php using same patterns
- The edit page likely has the same bug
- Apply all FR-1 and FR-2 fixes to editing flow

### FR-4: Add User Feedback

**FR-4.1:** Show upload success/failure clearly
- On success: "Entry saved with audio pronunciation"
- On partial success: "Entry saved, but audio upload failed: {reason}"
- On complete failure: "Failed to save entry: {reasons}"

**FR-4.2:** Preserve uploaded file selection on error
- If audio upload fails, user shouldn't have to re-enter all form data
- PRG pattern should preserve form state including file names (not contents - browser limitation)
- Show which audio upload failed if multiple are involved

### FR-5: Add Diagnostic Tools

**FR-5.1:** Create a diagnostic script to check:
- `/uploads/dictionary/audio/` directory exists
- Directory is writable by web server user
- `/data/tmp/` is writable
- Display current file permissions
- Test writing a file to both directories

**FR-5.2:** Add admin panel status indicator
- Show audio upload capability status in dictionary admin
- Warning message if directories aren't writable

## 6. Non-Goals (Out of Scope)

1. **Audio file validation** (format, quality, duration checks) - Future enhancement
2. **Audio file conversion** (converting between formats) - Out of scope
3. **Audio waveform visualization** - UI enhancement for future
4. **Bulk audio upload** - Not part of this bug fix
5. **Cloud storage integration** (S3, etc.) - Local storage only for now
6. **Audio editing/trimming in browser** - Out of scope

## 7. Technical Implementation Plan

### Phase 1: Diagnosis & Logging (Priority: Critical)

**Task 1.1:** Add comprehensive debug logging
- Location: `entry_add.php` lines 76-202
- Add logs before/after each file operation
- Log: source path, destination path, file_exists() results, is_writable() results, rename() result
- Format: Use `error_log()` with prefix `[Dictionary Upload Debug]`

**Task 1.2:** Verify Upload class behavior
- Test what `$upload->save_file()` actually returns
- Confirm 'name' contains full path vs just basename
- Document findings

**Task 1.3:** Add file existence checks
- Before rename(): check source file exists
- After rename(): check destination file exists
- Log all checks

### Phase 2: Path Handling Fix (Priority: Critical)

**Task 2.1:** Ensure absolute paths
```php
// Instead of:
$headword_audio_temp_file = $upload_info['name'];

// Use:
$headword_audio_temp_file = $upload_info['name'] ?? null;
if ($headword_audio_temp_file === null) {
    error_log('[Dictionary Upload] ERROR: Upload class did not return file path');
    $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
}

// Verify it's an absolute path
if (!file_exists($headword_audio_temp_file)) {
    error_log('[Dictionary Upload] ERROR: Temp file does not exist: ' . $headword_audio_temp_file);
    $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
}
```

**Task 2.2:** Fix rename() operation
```php
// Before rename, verify source and destination
error_log('[Dictionary Upload Debug] Attempting rename: ' . $headword_audio_temp_file . ' -> ' . $final_path);

if (!file_exists($headword_audio_temp_file)) {
    error_log('[Dictionary Upload] ERROR: Source file does not exist: ' . $headword_audio_temp_file);
    $errors[] = $nv_Lang->getModule('error_audio_file_not_found');
} elseif (!is_writable(dirname($final_path))) {
    error_log('[Dictionary Upload] ERROR: Destination directory not writable: ' . dirname($final_path));
    $errors[] = $nv_Lang->getModule('error_audio_directory_not_writable');
} elseif (!rename($headword_audio_temp_file, $final_path)) {
    $last_error = error_get_last();
    error_log('[Dictionary Upload] ERROR: rename() failed: ' . ($last_error['message'] ?? 'Unknown error'));
    $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
    // Don't delete temp file yet - keep for debugging
} else {
    // Verify destination file exists after rename
    if (file_exists($final_path)) {
        error_log('[Dictionary Upload Debug] File successfully moved to: ' . $final_path);
        
        // Update database with final filename
        $sql_update = 'UPDATE ' . NV_DICTIONARY_GLOBALTABLE . '_entries SET audio_file = :audio_file WHERE id = :id';
        $stmt_update = $db->prepare($sql_update);
        $stmt_update->bindParam(':audio_file', $final_filename, PDO::PARAM_STR);
        $stmt_update->bindParam(':id', $entry_id, PDO::PARAM_INT);
        $stmt_update->execute();
        
        // Now it's safe to consider the operation complete
    } else {
        error_log('[Dictionary Upload] ERROR: rename() reported success but file does not exist at destination');
        $errors[] = $nv_Lang->getModule('error_audio_upload_failed');
    }
}
```

### Phase 3: Error Handling (Priority: High)

**Task 3.1:** Show errors to users
- Don't hide rename() failures
- Add errors to `$errors[]` array
- Use PRG pattern to show errors on form
- Don't show generic "success" if audio upload failed

**Task 3.2:** Improve error messages in language files
```php
// modules/dictionary/language/en.php
$lang_module['error_audio_file_not_found'] = 'Audio file could not be found after upload. Please try again.';
$lang_module['error_audio_directory_not_writable'] = 'Audio upload directory is not writable. Please contact administrator.';
$lang_module['error_audio_upload_failed'] = 'Failed to save audio file. Please try again.';

// modules/dictionary/language/vi.php
$lang_module['error_audio_file_not_found'] = 'Không tìm thấy tệp âm thanh sau khi tải lên. Vui lòng thử lại.';
$lang_module['error_audio_directory_not_writable'] = 'Thư mục tải lên không có quyền ghi. Vui lòng liên hệ quản trị viên.';
$lang_module['error_audio_upload_failed'] = 'Không thể lưu tệp âm thanh. Vui lòng thử lại.';
```

**Task 3.3:** Update success message
```php
// Success message should differentiate:
// - Entry saved with audio
// - Entry saved without audio (if optional)
// - Entry and audio both saved successfully

$_SESSION['dictionary_success_message'] = sprintf(
    $nv_Lang->getModule('entry_added_success_with_audio'),
    $data['headword']
);
```

### Phase 4: Apply to Example Audio (Priority: High)

**Task 4.1:** Fix example audio uploads (lines 223-247)
- Apply all fixes from Phase 1-3
- Handle array of files
- Track individual successes/failures

**Task 4.2:** Update language for example errors
```php
$lang_module['error_example_audio_failed'] = 'Failed to save audio for example #%d';
```

### Phase 5: Fix entry_edit.php (Priority: High)

**Task 5.1:** Review entry_edit.php for same bug
**Task 5.2:** Apply all fixes from Phases 1-4

### Phase 6: Testing & Verification (Priority: Critical)

**Test Case 1: Normal upload (< 1MB MP3)**
- Upload valid MP3 file for headword
- Verify file appears in `/uploads/dictionary/audio/`
- Verify filename matches database `audio_file` column
- Verify no errors in PHP error log

**Test Case 2: Multiple example audios**
- Upload 2 example sentences with audio
- Verify both files saved
- Verify database records both filenames

**Test Case 3: Upload without audio (optional)**
- Submit form without audio file
- Verify entry saves normally
- Verify no errors

**Test Case 4: Large file (> 5MB)**
- Upload 6MB file
- Verify proper error message shown to user
- Verify file not saved

**Test Case 5: Invalid file type**
- Upload .txt file renamed to .mp3
- Verify Upload class rejects it
- Verify user sees error

**Test Case 6: Permission issues**
- Temporarily make `/uploads/dictionary/audio/` read-only
- Attempt upload
- Verify user sees clear error message
- Verify temp file cleaned up

**Test Case 7: Edit existing entry**
- Edit entry that already has audio
- Upload new audio
- Verify old audio replaced, new audio saved

## 8. Success Metrics

1. **Upload Success Rate:** 100% of valid audio uploads should succeed
2. **Error Visibility:** 100% of upload failures should show clear error messages to users
3. **File Integrity:** 100% of successful uploads should result in:
   - File present on disk
   - Correct filename in database
   - File is playable (future: add validation)
4. **No Silent Failures:** 0 cases where user sees "success" but audio didn't save
5. **Log Completeness:** Every upload attempt should have corresponding debug logs

## 9. Open Questions

1. **Q:** Should we validate audio file content (not just extension)?
   **A:** Future enhancement. For now, rely on Upload class MIME type checking.

2. **Q:** Should we keep temp files for debugging when upload fails?
   **A:** Yes, for first iteration. Log the temp file path. Later, add cleanup cron job.

3. **Q:** What if database UPDATE fails after successful file move?
   **A:** Wrap in transaction if possible, or add cleanup logic to delete orphaned files.

4. **Q:** Should we show partial success (entry saved, audio failed)?
   **A:** Yes - show warning message, allow user to edit and re-upload audio.

5. **Q:** How to handle concurrent uploads (multiple admins)?
   **A:** Current filename scheme (entry_id + random string) should prevent collisions. No changes needed.

## 10. Dependencies

- **NukeViet Upload Class:** `includes/vendor/vinades/nukeviet/Files/Upload.php`
- **File functions:** `nv_deletefile()`, `nv_mkdir()` from `includes/functions.php`
- **Language files:** `modules/dictionary/language/{en,vi}.php`
- **Templates:** `themes/admin_default/modules/dictionary/entry_add.tpl`

## 11. Rollback Plan

If this fix causes issues:

1. **Revert files:**
   - `modules/dictionary/admin/entry_add.php`
   - `modules/dictionary/admin/entry_edit.php`
   - `modules/dictionary/language/en.php`
   - `modules/dictionary/language/vi.php`

2. **Clear cache:** Delete `data/cache/*`

3. **Restore database:** No schema changes, so no database rollback needed

## 12. Acceptance Criteria

✅ **AC-1:** Admin can upload MP3 file for headword pronunciation and see it saved successfully  
✅ **AC-2:** Admin can upload multiple example audio files and see all saved successfully  
✅ **AC-3:** If audio upload fails, admin sees specific error message (not generic "success")  
✅ **AC-4:** Uploaded audio files appear in `/uploads/dictionary/audio/` with correct filenames  
✅ **AC-5:** Database `audio_file` column contains correct filename for uploaded audio  
✅ **AC-6:** PHP error log contains detailed debug information for troubleshooting  
✅ **AC-7:** All 7 test cases from Phase 6 pass successfully  
✅ **AC-8:** Edit page works correctly with same audio upload functionality  

---

## Appendix A: File Structure

```
nukeviet/
├── modules/dictionary/
│   ├── admin/
│   │   ├── entry_add.php      ← FIX REQUIRED
│   │   └── entry_edit.php     ← FIX REQUIRED
│   └── language/
│       ├── en.php             ← ADD ERROR MESSAGES
│       └── vi.php             ← ADD ERROR MESSAGES
├── uploads/dictionary/
│   └── audio/                 ← TARGET DIRECTORY (must be writable)
└── data/tmp/                  ← TEMP UPLOAD DIRECTORY (must be writable)
```

## Appendix B: Related Code References

- **Upload Class:** `includes/vendor/vinades/nukeviet/Files/Upload.php:879` (save_file method)
- **File Functions:** `includes/functions.php` (nv_deletefile, nv_mkdir)
- **Constants:** `includes/constants.php:47` (NV_TEMP_DIR definition)
- **Entry Add:** `modules/dictionary/admin/entry_add.php:76-202` (audio upload logic)
- **Entry Edit:** `modules/dictionary/admin/entry_edit.php` (similar logic)

## Appendix C: Debugging Checklist

When troubleshooting audio upload issues, check:

1. ✅ `/uploads/dictionary/audio/` exists and is writable (755 or 777)
2. ✅ `/data/tmp/` exists and is writable
3. ✅ PHP error log shows [Dictionary Upload] debug messages
4. ✅ `$upload_info['name']` contains full path (not just filename)
5. ✅ Source file exists before rename()
6. ✅ Destination directory is writable
7. ✅ rename() returns true
8. ✅ Destination file exists after rename()
9. ✅ Database UPDATE executes successfully
10. ✅ User sees appropriate success/error message

---

**END OF PRD**

