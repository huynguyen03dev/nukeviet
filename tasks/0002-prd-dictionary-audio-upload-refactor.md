# PRD: Dictionary Module Audio Upload Refactoring

**Document ID:** 0002  
**Feature:** Dictionary Audio Upload Refactoring  
**Created:** October 22, 2025  
**Status:** Draft  
**Priority:** High  

---

## 1. Introduction/Overview

### Problem Statement
The Dictionary module currently handles audio file uploads using manual PHP validation and direct file manipulation (`$_FILES`, `move_uploaded_file()`, `@unlink()`). This approach:
- Bypasses NukeViet's standardized file upload infrastructure
- Lacks proper error handling and logging for debugging
- Uses inconsistent file naming that can lead to conflicts
- Doesn't follow the framework's established patterns seen in core modules (Users, News)
- Has limited security validation (only checks HTTP MIME headers)

### Goal
Refactor the audio upload functionality in `modules/dictionary/admin/entry_add.php` and `modules/dictionary/admin/entry_edit.php` to align with NukeViet CMS best practices by:
1. Adopting the `NukeViet\Files\Upload` class for validation and processing
2. Using a temporary upload directory first, then moving files to final locations
3. Implementing cryptographic hashing for unique, conflict-free filenames
4. Adding comprehensive error logging for debugging
5. Using `nv_deletefile()` for safe file deletion
6. Providing download handlers using `NukeViet\Files\Download` class

This will improve code maintainability, security, and consistency with the rest of the NukeViet ecosystem.

---

## 2. Goals

1. **Standardization**: Adopt `NukeViet\Files\Upload` class for all audio file uploads in the dictionary module
2. **Reliability**: Use temp-dir-first approach to enable atomic operations and rollback on errors
3. **Uniqueness**: Implement cryptographic hashing (via `nv_genpass()`) to eliminate filename conflicts
4. **Observability**: Add detailed logging using NukeViet's logging system for troubleshooting
5. **Safety**: Replace `@unlink()` with `nv_deletefile()` helper for safer file deletion
6. **Access Control**: Implement download handlers using `NukeViet\Files\Download` class (like News module)
7. **Maintainability**: Keep configuration hardcoded (5MB limit, mp3/wav/mpeg formats) for simplicity

---

## 3. User Stories

### US-1: Admin Adding Dictionary Entry with Audio
**As a** dictionary administrator  
**I want to** upload audio pronunciation files when adding new entries  
**So that** users can hear correct pronunciation, with confidence that the system validates and stores files securely  

**Acceptance Criteria:**
- Audio files (mp3, wav) up to 5MB can be uploaded for headwords
- Audio files can be uploaded for example sentences
- Invalid file types show clear error messages
- Files are stored with unique names to prevent conflicts
- Upload errors are logged for debugging

### US-2: Admin Editing Dictionary Entry with Audio
**As a** dictionary administrator  
**I want to** replace or delete existing audio files when editing entries  
**So that** I can update pronunciation or remove incorrect audio files  

**Acceptance Criteria:**
- Can upload new audio to replace existing file
- Old audio file is automatically deleted when replaced
- Can explicitly delete audio without uploading replacement
- Deletion failures are logged but don't block the operation
- Temporary files are cleaned up on errors

### US-3: Admin Debugging Upload Issues
**As a** system administrator  
**I want to** see detailed logs when audio uploads fail  
**So that** I can diagnose and fix upload problems quickly  

**Acceptance Criteria:**
- Failed uploads write to NukeViet's log system
- Logs include: filename, size, MIME type, error reason, timestamp
- Logs are accessible via admin interface or file system
- No sensitive information (paths, user data) exposed in user-facing errors

### US-4: User Downloading Audio Files
**As a** frontend dictionary user  
**I want to** download audio pronunciation files for offline use  
**So that** I can practice pronunciation without internet access  

**Acceptance Criteria:**
- Audio files can be played inline via HTML5 `<audio>` player
- Optional download button uses NukeViet download handler
- Download handler validates access and logs downloads
- Proper Content-Disposition headers for file downloads

---

## 4. Functional Requirements

### FR-1: Upload Class Integration
**Priority:** Must Have  
- **FR-1.1**: Replace all `$_FILES` direct access with `NukeViet\Files\Upload` class instantiation
- **FR-1.2**: Configure Upload class with allowed extensions: `['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav']`
- **FR-1.3**: Set maximum file size to `5 * 1024 * 1024` bytes (5MB)
- **FR-1.4**: Use Upload class's `save_file()` method to save to `NV_TEMP_DIR` first
- **FR-1.5**: Use Upload class's language integration: `$upload->setLanguage(\NukeViet\Core\Language::$lang_global)`

### FR-2: Temporary Upload Flow
**Priority:** Must Have  
- **FR-2.1**: All uploaded files must first be saved to `NV_ROOTDIR . '/' . NV_TEMP_DIR`
- **FR-2.2**: After successful validation, move files from temp to `NV_ROOTDIR . '/uploads/' . $module_name . '/audio/'`
- **FR-2.3**: Use `nv_copyfile()` or `rename()` for atomic file moves
- **FR-2.4**: If database insert/update fails, delete temporary files using `nv_deletefile()`
- **FR-2.5**: Clean up temp files immediately after successful move to final location

### FR-3: Cryptographic File Naming
**Priority:** Must Have  
- **FR-3.1**: Generate unique filenames using pattern: `{entry_id}_{random_hash}.{ext}`
- **FR-3.2**: Use `nv_genpass(8)` to generate 8-character random hash
- **FR-3.3**: For headword audio: `{entry_id}_{hash}.mp3` (e.g., `42_a7b3c9d1.mp3`)
- **FR-3.4**: For example audio: `{entry_id}_ex_{sort}_{hash}.mp3` (e.g., `42_ex_1_f4e8d2a6.mp3`)
- **FR-3.5**: Preserve original file extension from uploaded file
- **FR-3.6**: Ensure filenames are URL-safe (no spaces, special characters)

### FR-4: Error Logging
**Priority:** Must Have  
- **FR-4.1**: Log all upload failures using NukeViet's logging system (write to `data/logs/error_log/`)
- **FR-4.2**: Log format: `[Dictionary Upload] {operation} failed for entry_id={id}: {error_message}`
- **FR-4.3**: Include metadata: original filename, file size, MIME type, user ID, timestamp
- **FR-4.4**: Log file deletion failures (but don't expose to end users)
- **FR-4.5**: Use `trigger_error()` or write directly to `data/logs/` directory
- **FR-4.6**: Do not log sensitive information (full server paths, database credentials)

### FR-5: Safe File Deletion
**Priority:** Must Have  
- **FR-5.1**: Replace all `@unlink()` calls with `nv_deletefile()` helper function
- **FR-5.2**: When replacing audio file during edit, delete old file using `nv_deletefile(NV_ROOTDIR . '/' . $old_path)`
- **FR-5.3**: When user explicitly deletes audio (via checkbox), use `nv_deletefile()` and set database field to NULL
- **FR-5.4**: When deleting entry (if implemented), delete all associated audio files
- **FR-5.5**: Deletion failures should log errors but not block database updates

### FR-6: Download Handler Implementation
**Priority:** Must Have  
- **FR-6.1**: Create new operation file: `modules/dictionary/funcs/download_audio.php`
- **FR-6.2**: Use `NukeViet\Files\Download` class to serve files (similar to News module pattern)
- **FR-6.3**: Validate entry_id and audio type (headword vs example) before serving
- **FR-6.4**: Download URL pattern: `/dictionary/download_audio?id={entry_id}&type=headword` or `type=example&ex={example_id}`
- **FR-6.5**: Set proper headers: `Content-Type: audio/mpeg`, `Content-Disposition: attachment; filename="{headword}.mp3"`
- **FR-6.6**: Log successful downloads for analytics (optional, low priority)

### FR-7: Configuration Management
**Priority:** Must Have  
- **FR-7.1**: Keep validation rules hardcoded in PHP files (no database config needed)
- **FR-7.2**: Define constants at top of upload handling section:
  ```php
  define('DICT_AUDIO_MAX_SIZE', 5 * 1024 * 1024); // 5MB
  $allowed_audio_types = ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav'];
  ```
- **FR-7.3**: Use `$module_upload` variable (already defined by NukeViet) for upload base path
- **FR-7.4**: Audio files stored in `NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/audio/'`

### FR-8: Headword Audio Upload (entry_add.php)
**Priority:** Must Have  
- **FR-8.1**: Replace manual validation (lines 64-86) with Upload class validation
- **FR-8.2**: Save uploaded file to temp dir first, get temporary filename
- **FR-8.3**: After INSERT, generate final filename: `{entry_id}_{hash}.{ext}`
- **FR-8.4**: Move file from temp to final location atomically
- **FR-8.5**: If move fails, delete temp file and log error, but don't fail entire operation
- **FR-8.6**: Update database with final filename (relative path: `audio/{filename}`)

### FR-9: Example Audio Upload (entry_add.php)
**Priority:** Must Have  
- **FR-9.1**: Replace manual validation (lines 88-124) with Upload class for array of files
- **FR-9.2**: Process each example audio file in loop using Upload class
- **FR-9.3**: Save each file to temp dir, track temp filenames
- **FR-9.4**: After example INSERT, move from temp to final location with pattern: `{entry_id}_ex_{sort}_{hash}.{ext}`
- **FR-9.5**: Clean up all temp files after loop completes (success or failure)

### FR-10: Audio Replacement (entry_edit.php)
**Priority:** Must Have  
- **FR-10.1**: Replace manual validation (lines 119-170) with Upload class
- **FR-10.2**: If new audio uploaded, save to temp first
- **FR-10.3**: After successful temp save, delete old audio using `nv_deletefile()`
- **FR-10.4**: Move new audio from temp to final location with new hashed filename
- **FR-10.5**: Update database with new filename
- **FR-10.6**: If any step fails, rollback: keep old file, delete temp file, log error

### FR-11: Audio Deletion (entry_edit.php)
**Priority:** Must Have  
- **FR-11.1**: When `delete_audio` checkbox is checked, use `nv_deletefile()` to remove file
- **FR-11.2**: Set database field to NULL after successful deletion
- **FR-11.3**: If deletion fails, log error but proceed with database update
- **FR-11.4**: Apply same logic to example audio files when examples are removed

### FR-12: Error Message Localization
**Priority:** Should Have  
- **FR-12.1**: Update language files (`modules/dictionary/language/en.php`, `vi.php`) with Upload class error messages
- **FR-12.2**: Add language keys:
  - `error_audio_upload_failed`: Generic upload failure message
  - `error_audio_move_failed`: File move from temp failed
  - `error_audio_delete_failed`: File deletion failed (informational only)
  - `error_audio_not_found`: Requested audio file doesn't exist
- **FR-12.3**: Use `$upload_info['error']` from Upload class (already localized)

---

## 5. Non-Goals (Out of Scope)

The following are explicitly **not** included in this refactoring:

1. **Date-based or hierarchical upload directory structures** (using flat `/uploads/dictionary/audio/` structure)
2. **Frontend user audio uploads** (only admin pages being refactored)
3. **Bulk audio upload tool** (upload multiple files at once)
4. **Migration script for existing audio files** (existing files keep current naming, new uploads use new naming)
5. **Configurable upload settings** (no admin settings page for changing limits)
6. **Audio transcoding or format conversion** (accept mp3/wav as-is, no processing)
7. **Advanced security features** (per-user quotas, rate limiting, virus scanning)
8. **Audio metadata extraction** (duration, bitrate, etc.)
9. **CDN integration** (files served from local server only)
10. **Streaming or progressive download** (standard HTTP download only)
11. **Access control beyond admin-only** (no per-entry permission checks)
12. **Audio file preview in admin list view** (playback only on add/edit pages)

---

## 6. Design Considerations

### 6.1 File Upload Flow (Sequence)

**Add Entry Flow:**
```
1. User submits form with audio file
2. Validate CSRF token
3. Upload class validates file (type, size, extension)
4. Save file to NV_TEMP_DIR with temporary name
5. Validate form data (headword, meaning, etc.)
6. If validation fails: delete temp file, show errors, exit
7. INSERT entry into database (without audio filename yet)
8. Get entry_id from last insert
9. Generate final filename: {entry_id}_{hash}.{ext}
10. Move file from temp to /uploads/dictionary/audio/
11. UPDATE entry with audio filename
12. Delete temp file (if still exists)
13. Redirect to success page
```

**Edit Entry Flow:**
```
1. Load existing entry and audio filename
2. User submits form (may include new audio or delete checkbox)
3. Validate CSRF token
4. If new audio uploaded:
   a. Upload class validates file
   b. Save to NV_TEMP_DIR
5. If delete_audio checked:
   a. Delete old file using nv_deletefile()
   b. Set audio_filename = NULL
6. Validate form data
7. If validation fails: delete temp file, show errors, exit
8. UPDATE entry in database
9. If new audio exists in temp:
   a. Delete old audio file (if exists) using nv_deletefile()
   b. Generate final filename with new hash
   c. Move from temp to final location
   d. UPDATE entry with new filename
10. Delete temp file (if still exists)
11. Redirect to success page
```

### 6.2 Error Handling Strategy

**Principle:** Fail gracefully - missing audio should not prevent entry creation/update.

- **Validation errors**: Show to user, don't save entry
- **Upload errors**: Show to user via Upload class error messages
- **Move errors**: Log error, save entry without audio, show warning to user
- **Delete errors**: Log error, proceed with update (file remains orphaned, can be cleaned up later)

### 6.3 Template Changes

Minimal template changes required:

1. **entry_add.tpl / entry_edit.tpl**: No changes to form structure
2. **Audio playback**: Keep existing `<audio>` tags with direct file URLs for now
3. **Download links**: Add optional download button that links to download handler:
   ```html
   <a href="{NV_BASE_SITEURL}index.php?{NV_LANG_VARIABLE}={NV_LANG_DATA}&{NV_NAME_VARIABLE}=dictionary&{NV_OP_VARIABLE}=download_audio&id={ENTRY_ID}&type=headword">
       {LANG.download_audio}
   </a>
   ```

### 6.4 Database Schema

**No changes required.** Existing columns are sufficient:

- `nv4_XX_dictionary_entries.audio_file` (varchar 255) - stores relative path like `audio/42_a7b3c9d1.mp3`
- `nv4_XX_dictionary_examples.audio_file` (varchar 255) - stores relative path like `audio/42_ex_1_f4e8d2a6.mp3`

### 6.5 Backward Compatibility

**Existing audio files:** Files uploaded before refactoring will continue to work. The system will:
- Serve old files with their original names (e.g., `42_headword.mp3`)
- Only apply new naming convention to newly uploaded files
- Not require data migration

---

## 7. Technical Considerations

### 7.1 Dependencies

- **Upload Class**: `NukeViet\Files\Upload` (located at `includes/vendor/vinades/nukeviet/Files/Upload.php`)
- **Download Class**: `NukeViet\Files\Download` (located at `includes/vendor/vinades/nukeviet/Files/Download.php`)
- **Helper Functions**: `nv_deletefile()`, `nv_copyfile()`, `nv_genpass()` (defined in `includes/functions.php`)
- **Constants**: `NV_TEMP_DIR`, `NV_UPLOADS_REAL_DIR`, `NV_ROOTDIR`, `NV_BASE_SITEURL`

### 7.2 Reference Implementation

Study these files for patterns to follow:

1. **Users Module Avatar Upload**: `modules/users/funcs/avatar.php` (lines 129-186)
   - Shows Upload class instantiation
   - Temp directory pattern
   - Image processing (we'll skip this for audio)
   - File move and database update

2. **News Module File Attachments**: `modules/news/admin/content.php` (lines 706-724)
   - Shows handling multiple files
   - File validation and storage
   - Database serialization of file paths

3. **News Module Download Handler**: `modules/news/funcs/detail.php` (lines 46-60)
   - Shows Download class usage
   - File existence check
   - Proper headers and exit

### 7.3 Upload Class API Reference

```php
// Instantiate Upload class
$upload = new NukeViet\Files\Upload(
    $allowed_extensions,    // Array: ['audio/mpeg', 'audio/mp3', 'audio/wav']
    $forbid_extensions,     // Array: $global_config['forbid_extensions']
    $forbid_mimes,          // Array: $global_config['forbid_mimes']
    $max_filesize           // Int: 5 * 1024 * 1024
);

// Set language for error messages
$upload->setLanguage(\NukeViet\Core\Language::$lang_global);

// Save uploaded file
$upload_info = $upload->save_file(
    $_FILES['audio'],           // File array from $_FILES
    NV_ROOTDIR . '/' . NV_TEMP_DIR,  // Target directory
    false                       // Don't auto-rename (we'll handle naming)
);

// Check result
if (empty($upload_info['error'])) {
    // Success: $upload_info['name'] contains full path to temp file
    $temp_file = $upload_info['name'];
} else {
    // Error: $upload_info['error'] contains localized error message
    $errors[] = $upload_info['error'];
}

// Clean up temp file
@unlink($_FILES['audio']['tmp_name']);
```

### 7.4 Download Class API Reference

```php
// Instantiate Download class
$download = new NukeViet\Files\Download(
    $file_path,          // Full path to file
    $file_directory,     // Directory containing file
    $file_name,          // Filename to send to browser
    true                 // Force download (vs inline display)
);

// Trigger download (sends headers and file content, then exits)
$download->download_file();
exit();
```

### 7.5 Security Considerations

Since the user selected "don't know" for security enhancements, we'll implement these reasonable defaults:

1. **MIME Type Validation**: Use Upload class's built-in validation (validates against allowed types)
2. **File Extension Check**: Upload class automatically checks extension matches MIME type
3. **File Size Limit**: Enforced by Upload class (5MB max)
4. **Path Traversal Prevention**: Use `basename()` and validate filenames don't contain `../`
5. **Admin-Only Access**: All upload functionality behind `NV_IS_DICTIONARY_ADMIN` check
6. **CSRF Protection**: Existing `checkss` validation remains in place

**Not implementing** (out of scope for this refactoring):
- Per-user upload quotas
- Rate limiting
- Virus/malware scanning
- Deep MIME type inspection (file content analysis)

### 7.6 Logging Implementation

Use NukeViet's error logging pattern:

```php
// Log upload failure
if (!empty($upload_info['error'])) {
    $log_message = '[Dictionary Upload] Headword audio upload failed for entry_id=' . $entry_id 
                   . ' - Original: ' . $_FILES['audio']['name'] 
                   . ' - Error: ' . $upload_info['error'];
    trigger_error($log_message, E_USER_WARNING);
}

// Log file move failure
if (!rename($temp_file, $final_path)) {
    $log_message = '[Dictionary Upload] Failed to move audio from temp to final location. '
                   . 'Temp: ' . basename($temp_file) . ' -> Final: ' . basename($final_path);
    trigger_error($log_message, E_USER_WARNING);
}

// Log file deletion failure
if (!nv_deletefile($old_audio_path)) {
    $log_message = '[Dictionary Upload] Failed to delete old audio file: ' . basename($old_audio_path);
    trigger_error($log_message, E_USER_NOTICE);
}
```

Logs will appear in:
- **Development**: PHP error log (`/opt/lampp/logs/php_error_log`)
- **Production**: NukeViet error log (`data/logs/error_log/`)

### 7.7 Performance Considerations

- **File Operations**: Moving files between temp and final directory is fast (atomic on same filesystem)
- **Database Updates**: Minimal overhead (single UPDATE per audio file)
- **No Blocking**: Audio upload failures don't prevent form processing
- **Cleanup**: Temp files deleted immediately (no accumulation)

### 7.8 Testing Checklist

Manual testing required (no automated test suite in NukeViet):

**Add Entry:**
- [ ] Upload valid mp3 file (< 5MB) - success
- [ ] Upload valid wav file (< 5MB) - success
- [ ] Upload file > 5MB - validation error shown
- [ ] Upload .txt file - validation error shown
- [ ] Upload with form validation error - temp file cleaned up
- [ ] Upload headword + example audios together - both saved
- [ ] Check database for correct filenames
- [ ] Check `/uploads/dictionary/audio/` for files with hashed names
- [ ] Check `/data/tmp/` for no leftover temp files

**Edit Entry:**
- [ ] Replace existing audio - old deleted, new saved
- [ ] Delete audio (checkbox) - file deleted, DB set to NULL
- [ ] Upload new audio without deleting - old replaced
- [ ] Edit without changing audio - audio unchanged
- [ ] Edit with form error - temp file cleaned up, old audio intact

**Download:**
- [ ] Click download link - file downloads with correct headers
- [ ] Request non-existent file - 404 error
- [ ] Request without entry_id - redirect or error
- [ ] Check download log entries (if implemented)

**Error Handling:**
- [ ] Simulate temp dir write failure - error logged, form shows error
- [ ] Simulate final dir write failure - error logged, entry saved without audio
- [ ] Check error logs for all failure scenarios

---

## 8. Success Metrics

### Quantitative Metrics

1. **Code Quality**
   - **Target**: Zero direct `$_FILES` access in upload handling code
   - **Target**: Zero `@unlink()` calls (replaced with `nv_deletefile()`)
   - **Target**: 100% of upload operations use Upload class

2. **Error Handling**
   - **Target**: All upload failures logged to error log
   - **Target**: Zero silent failures (all errors either logged or shown to user)
   - **Target**: Temp directory empty after successful operations (no orphaned files)

3. **Consistency**
   - **Target**: All new audio filenames follow pattern `{entry_id}_{hash}.{ext}`
   - **Target**: All file operations use NukeViet helper functions

### Qualitative Metrics

1. **Code Maintainability**
   - Code follows NukeViet patterns (easier for other developers to understand)
   - Upload logic centralized in Upload class (single responsibility)
   - Error handling predictable and debuggable

2. **Developer Experience**
   - Clear error messages help diagnose upload issues quickly
   - Logs provide sufficient detail for troubleshooting
   - Code structure matches Users and News modules (familiar patterns)

3. **System Reliability**
   - Temp-dir-first approach prevents partial uploads on errors
   - Hashed filenames eliminate race conditions and conflicts
   - Safe file deletion prevents accidental data loss

---

## 9. Open Questions

### Q1: Temp File Cleanup Schedule
**Question:** Should we add a cron job to clean up orphaned temp files older than 24 hours?  
**Context:** If PHP crashes during upload, temp files may remain in `NV_TEMP_DIR`. NukeViet may have built-in cleanup.  
**Action Required:** Research if NukeViet has temp file cleanup mechanism, document findings.

### Q2: Download Logging Detail
**Question:** Should download handler log every audio file download, or only log errors?  
**Context:** Logging every download could fill logs quickly but provides usage analytics.  
**Recommendation:** Log errors only for MVP, add analytics later if needed.

### Q3: File Extension Handling
**Question:** Should we normalize extensions (e.g., `.mp3` vs `.MP3` vs `.mpeg`)?  
**Context:** Different browsers/devices may send different extensions for same MIME type.  
**Recommendation:** Force lowercase extension: `strtolower(pathinfo($file, PATHINFO_EXTENSION))`

### Q4: Existing File Migration
**Question:** Should we create a migration script to rename old audio files to new hashed format?  
**Context:** Mixed naming conventions may cause confusion.  
**Decision:** Out of scope for this PRD (marked as Non-Goal), but document as future enhancement.

### Q5: Audio File Limits Per Entry
**Question:** Should we limit number of example audio files per entry (e.g., max 10)?  
**Context:** No current limit could allow abuse or performance issues.  
**Recommendation:** Add soft limit in code: `if (count($ex_sentences) > 20) { /* limit error */ }`

### Q6: Download Authentication
**Question:** Should audio downloads require user login, or allow public access?  
**Context:** Dictionary may be public resource vs member-only.  
**Recommendation:** Allow public download (no auth required), add auth later if needed.

---

## 10. Implementation Notes

### Phase 1: entry_add.php Refactoring (Priority: High)
**Estimated Effort:** 4-6 hours

1. Add Upload class instantiation at top of file
2. Replace headword audio validation with Upload class
3. Implement temp-to-final file flow for headword audio
4. Replace example audio validation with Upload class
5. Add error logging for all failure points
6. Test add flow thoroughly

### Phase 2: entry_edit.php Refactoring (Priority: High)
**Estimated Effort:** 4-6 hours

1. Add Upload class instantiation
2. Refactor audio replacement logic
3. Replace `@unlink()` with `nv_deletefile()`
4. Implement temp-to-final flow for replacement
5. Add error logging
6. Test edit flow thoroughly

### Phase 3: Download Handler (Priority: Medium)
**Estimated Effort:** 2-3 hours

1. Create `modules/dictionary/funcs/download_audio.php`
2. Implement Download class integration
3. Add entry_id validation and file existence checks
4. Test download for headword and example audio
5. Add error handling for missing files

### Phase 4: Language Keys (Priority: Low)
**Estimated Effort:** 1 hour

1. Add new error message keys to `language/en.php` and `language/vi.php`
2. Update templates to show Upload class errors
3. Test localization switching

### Phase 5: Documentation (Priority: Low)
**Estimated Effort:** 1-2 hours

1. Update inline comments in refactored files
2. Document new file naming convention
3. Add troubleshooting guide for common upload errors

**Total Estimated Effort:** 12-18 hours

---

## 11. Acceptance Criteria Summary

### Definition of Done

This feature is considered complete when:

1. ✅ All audio uploads in `entry_add.php` use `NukeViet\Files\Upload` class
2. ✅ All audio uploads in `entry_edit.php` use `NukeViet\Files\Upload` class
3. ✅ All uploaded files follow temp-to-final workflow (via `NV_TEMP_DIR`)
4. ✅ All new audio filenames use cryptographic hash pattern: `{entry_id}_{hash}.{ext}`
5. ✅ All file deletions use `nv_deletefile()` instead of `@unlink()`
6. ✅ All upload failures are logged using `trigger_error()` or error log
7. ✅ Download handler implemented using `NukeViet\Files\Download` class
8. ✅ Download handler accessible via `/dictionary/download_audio?id={id}&type={type}`
9. ✅ All manual testing scenarios pass (see Section 7.8)
10. ✅ No `$_FILES` direct access remains in upload code
11. ✅ No `@unlink()` calls remain in file deletion code
12. ✅ Code follows existing NukeViet conventions (matches Users/News modules)
13. ✅ Error messages are localized and user-friendly
14. ✅ Existing audio files continue to work (backward compatibility maintained)
15. ✅ No orphaned temp files remain after operations

---

## Appendix A: Code Examples

### Example 1: Upload Class Usage for Single File

```php
// At top of file after validation
$upload = new NukeViet\Files\Upload(
    ['audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav'],
    $global_config['forbid_extensions'],
    $global_config['forbid_mimes'],
    5 * 1024 * 1024 // 5MB
);
$upload->setLanguage(\NukeViet\Core\Language::$lang_global);

// Handle upload
$headword_audio_temp_file = null;
if (isset($_FILES['audio']) && $_FILES['audio']['error'] !== UPLOAD_ERR_NO_FILE) {
    $upload_info = $upload->save_file($_FILES['audio'], NV_ROOTDIR . '/' . NV_TEMP_DIR, false);
    @unlink($_FILES['audio']['tmp_name']);
    
    if (empty($upload_info['error'])) {
        $headword_audio_temp_file = $upload_info['name'];
    } else {
        $errors[] = $upload_info['error'];
        trigger_error('[Dictionary Upload] Headword audio upload failed: ' . $upload_info['error'], E_USER_WARNING);
    }
}

// After INSERT, move to final location
if ($headword_audio_temp_file !== null) {
    $file_ext = strtolower(pathinfo($headword_audio_temp_file, PATHINFO_EXTENSION));
    $final_filename = $entry_id . '_' . nv_genpass(8) . '.' . $file_ext;
    $final_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $final_filename;
    
    if (rename($headword_audio_temp_file, $final_path)) {
        // Update database with final filename
        $stmt = $db->prepare('UPDATE ' . NV_DICTIONARY_GLOBALTABLE . '_entries SET audio_file = :audio WHERE id = :id');
        $stmt->bindValue(':audio', 'audio/' . $final_filename, PDO::PARAM_STR);
        $stmt->bindValue(':id', $entry_id, PDO::PARAM_INT);
        $stmt->execute();
    } else {
        trigger_error('[Dictionary Upload] Failed to move audio to final location', E_USER_WARNING);
        nv_deletefile($headword_audio_temp_file);
    }
}
```

### Example 2: Safe File Deletion

```php
// Replace existing audio file
if (!empty($old_audio_filename)) {
    $old_path = NV_ROOTDIR . '/uploads/' . $module_name . '/' . $old_audio_filename;
    if (!nv_deletefile($old_path)) {
        // Log error but don't fail operation
        trigger_error('[Dictionary] Failed to delete old audio: ' . basename($old_path), E_USER_NOTICE);
    }
}
```

### Example 3: Download Handler

```php
// modules/dictionary/funcs/download_audio.php
if (!defined('NV_IS_MOD_DICTIONARY')) {
    exit('Stop!!!');
}

$entry_id = $nv_Request->get_int('id', 'get', 0);
$type = $nv_Request->get_title('type', 'get', ''); // 'headword' or 'example'
$ex_id = $nv_Request->get_int('ex', 'get', 0);

if ($entry_id <= 0) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

// Fetch entry and audio filename
if ($type === 'headword') {
    $sql = 'SELECT audio_file FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE id = :id';
    $stmt = $db->prepare($sql);
    $stmt->bindValue(':id', $entry_id, PDO::PARAM_INT);
    $stmt->execute();
    $audio_file = $stmt->fetchColumn();
} elseif ($type === 'example' && $ex_id > 0) {
    $sql = 'SELECT audio_file FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples WHERE id = :id AND entry_id = :entry_id';
    $stmt = $db->prepare($sql);
    $stmt->bindValue(':id', $ex_id, PDO::PARAM_INT);
    $stmt->bindValue(':entry_id', $entry_id, PDO::PARAM_INT);
    $stmt->execute();
    $audio_file = $stmt->fetchColumn();
} else {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

if (empty($audio_file)) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

$file_path = NV_ROOTDIR . '/uploads/' . $module_name . '/' . $audio_file;
if (!file_exists($file_path)) {
    trigger_error('[Dictionary Download] Audio file not found: ' . basename($file_path), E_USER_WARNING);
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

$file_info = pathinfo($file_path);
$download = new NukeViet\Files\Download($file_path, $file_info['dirname'], $file_info['basename'], true);
$download->download_file();
exit();
```

---

## Appendix B: File Checklist

Files to modify:
- ✏️ `/modules/dictionary/admin/entry_add.php` (refactor upload logic)
- ✏️ `/modules/dictionary/admin/entry_edit.php` (refactor upload and deletion logic)
- ✏️ `/modules/dictionary/language/en.php` (add error message keys)
- ✏️ `/modules/dictionary/language/vi.php` (add error message keys)
- ➕ `/modules/dictionary/funcs/download_audio.php` (create new file)
- ✏️ `/themes/admin_default/modules/dictionary/entry_add.tpl` (optional: add download link example)
- ✏️ `/themes/admin_default/modules/dictionary/entry_edit.tpl` (optional: add download link)

Files to reference (do not modify):
- 📖 `/modules/users/funcs/avatar.php` (Upload class pattern)
- 📖 `/modules/news/admin/content.php` (multiple files handling)
- 📖 `/modules/news/funcs/detail.php` (Download class pattern)
- 📖 `/includes/vendor/vinades/nukeviet/Files/Upload.php` (Upload class source)
- 📖 `/includes/vendor/vinades/nukeviet/Files/Download.php` (Download class source)
- 📖 `/includes/functions.php` (helper functions: nv_deletefile, nv_genpass, nv_copyfile)

---

**End of PRD**

