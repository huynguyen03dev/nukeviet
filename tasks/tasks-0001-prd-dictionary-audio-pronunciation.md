# Task List: Dictionary Audio Pronunciation Feature

Based on PRD: `0001-prd-dictionary-audio-pronunciation.md`

## Relevant Files

### Database Schema
- `/modules/dictionary/action_mysql.php` - Contains database table definitions that need audio_file column additions

### Admin Backend Files
- `/modules/dictionary/admin/entry_add.php` - Handles adding new entries; needs audio file upload logic
- `/modules/dictionary/admin/entry_edit.php` - Handles editing entries; needs audio file upload logic and display of existing audio

### Admin Templates
- `/themes/admin_default/modules/dictionary/entry_add.tpl` - Add entry form template; needs audio upload fields
- `/themes/admin_default/modules/dictionary/entry_edit.tpl` - Edit entry form template; needs audio upload fields with current file display

### Admin Assets
- `/themes/admin_default/css/dictionary.css` - Styling for admin interface; needs audio upload field styles
- `/themes/admin_default/js/dictionary.js` - Admin JavaScript; needs dynamic audio field handling for examples

### Public Frontend Files
- `/modules/dictionary/funcs/main.php` - Main dictionary page handler; needs to include audio data in AJAX responses
- `/modules/dictionary/theme.php` - Theme functions; may need helper function for audio player HTML

### Public Templates
- `/themes/default/modules/dictionary/main.tpl` - Main dictionary template; needs speaker icons and audio player elements

### Public Assets
- `/themes/default/css/dictionary.css` - Public-facing styles; needs speaker icon and audio player styles
- `/themes/default/js/dictionary.js` - Public JavaScript; needs audio playback functionality

### Language Files
- `/modules/dictionary/language/en.php` - English language strings; needs audio-related text
- `/modules/dictionary/language/vi.php` - Vietnamese language strings; needs audio-related text

### Upload Directory
- `/uploads/dictionary/audio/` - Directory to store audio files (needs to be created)
- `/uploads/dictionary/audio/index.html` - Security file to prevent directory listing
- `/uploads/dictionary/.htaccess` - May need update to allow audio MIME types

### Notes

- NukeViet uses standard PHP file upload handling with `$_FILES` superglobal
- Audio files should be validated for MIME type (audio/mpeg, audio/wav) and size (max 5MB)
- File naming convention: `{entry_id}_headword.{ext}` for headwords, `{entry_id}_example_{example_id}.{ext}` for examples
- When deleting entries, associated audio files must also be deleted using `unlink()`
- Use `nv_deletefile()` if available in NukeViet for consistent file deletion
- HTML5 `<audio>` element will be used for playback with native browser controls

---

## Tasks

- [x] 1.0 Update database schema to support audio files
  - [x] 1.1 Add `audio_file` column to `_entries` table (VARCHAR 255, nullable, default NULL) in `/modules/dictionary/action_mysql.php`
  - [x] 1.2 Add `audio_file` column to `_examples` table (VARCHAR 255, nullable, default NULL) in `/modules/dictionary/action_mysql.php`
  - [ ] 1.3 Test the schema changes by reinstalling or updating the dictionary module in admin panel
  - [ ] 1.4 Verify both columns exist in database using phpMyAdmin or similar tool

- [ ] 2.0 Create audio file upload directory and security configuration
  - [ ] 2.1 Create `/uploads/dictionary/audio/` directory with proper write permissions (755 or 777 depending on server)
  - [ ] 2.2 Create `/uploads/dictionary/audio/index.html` security file with empty or "Stop!!!" content to prevent directory listing
  - [ ] 2.3 Verify the parent `/uploads/dictionary/.htaccess` file allows audio file access (check for any deny rules that might block .mp3/.wav)
  - [ ] 2.4 Test directory is accessible but not listable by attempting to browse to it in a web browser

- [ ] 3.0 Implement admin interface for audio file upload (add/edit entry forms)
  - [ ] 3.1 Update `/modules/dictionary/admin/entry_add.php` to handle headword audio upload:
    - [ ] 3.1.1 Add file validation logic (check MIME type for audio/mpeg or audio/wav, check size <= 5MB)
    - [ ] 3.1.2 Generate unique filename using pattern `{entry_id}_headword.{ext}`
    - [ ] 3.1.3 Move uploaded file to `/uploads/dictionary/audio/` directory
    - [ ] 3.1.4 Save filename to `audio_file` column in entries table during INSERT
    - [ ] 3.1.5 Add error handling for upload failures and display error messages
  - [ ] 3.2 Update `/modules/dictionary/admin/entry_add.php` to handle example audio uploads:
    - [ ] 3.2.1 Process array of example audio files from `$_FILES['ex_audio'][]`
    - [ ] 3.2.2 Generate unique filenames using pattern `{entry_id}_example_{example_id}.{ext}` for each example
    - [ ] 3.2.3 Save filenames to `audio_file` column in examples table during INSERT
    - [ ] 3.2.4 Handle cases where example audio is not provided (optional field)
  - [ ] 3.3 Update `/modules/dictionary/admin/entry_edit.php` to handle audio replacement/deletion:
    - [ ] 3.3.1 Load existing audio filenames from database and pass to template
    - [ ] 3.3.2 Add logic to handle new audio upload (delete old file if exists, upload new one)
    - [ ] 3.3.3 Add logic to handle audio deletion via checkbox or delete button (remove file and set column to NULL)
    - [ ] 3.3.4 Update audio_file columns during UPDATE query
    - [ ] 3.3.5 Ensure old example audio files are deleted when examples are removed
  - [ ] 3.4 Add file deletion logic when entry is deleted:
    - [ ] 3.4.1 Find the entry deletion code (likely in `/modules/dictionary/admin/main.php` or similar)
    - [ ] 3.4.2 Before deleting database record, fetch audio filenames and delete files using `unlink()`
    - [ ] 3.4.3 Delete both headword audio and all associated example audio files
  - [ ] 3.5 Update `/themes/admin_default/modules/dictionary/entry_add.tpl`:
    - [ ] 3.5.1 Add `enctype="multipart/form-data"` to the form tag
    - [ ] 3.5.2 Add file upload field for headword audio after phonetic field
    - [ ] 3.5.3 Add help text indicating "Optional - MP3 or WAV, max 5MB"
    - [ ] 3.5.4 Modify example item template in JavaScript to include audio upload field for each example
  - [ ] 3.6 Update `/themes/admin_default/modules/dictionary/entry_edit.tpl`:
    - [ ] 3.6.1 Add `enctype="multipart/form-data"` to the form tag
    - [ ] 3.6.2 Add file upload field for headword audio with current file display if exists
    - [ ] 3.6.3 Add "Replace" or "Delete" option for existing headword audio
    - [ ] 3.6.4 Add audio upload fields to each existing example with current file display
    - [ ] 3.6.5 Ensure dynamically added examples also have audio upload fields
  - [ ] 3.7 Update `/themes/admin_default/js/dictionary.js`:
    - [ ] 3.7.1 Modify the dynamic example adding logic to include audio file input fields
    - [ ] 3.7.2 Add proper name attributes like `ex_audio[]` for array handling
  - [ ] 3.8 Update `/themes/admin_default/css/dictionary.css`:
    - [ ] 3.8.1 Add styles for audio upload sections (spacing, layout)
    - [ ] 3.8.2 Add styles for "current audio file" display and delete/replace controls

- [ ] 4.0 Implement public-facing audio playback interface with speaker icons
  - [ ] 4.1 Update `/modules/dictionary/funcs/main.php` to include audio data:
    - [ ] 4.1.1 Modify the 'getword' action to include `audio_file` from entries table
    - [ ] 4.1.2 Modify the examples query to include `audio_file` column
    - [ ] 4.1.3 Add audio file URLs to JSON response (construct full URL path like `/uploads/dictionary/audio/{filename}`)
    - [ ] 4.1.4 Handle cases where audio_file is NULL (don't include URL or set to empty string)
  - [ ] 4.2 Update `/themes/default/modules/dictionary/main.tpl`:
    - [ ] 4.2.1 Add speaker icon element next to word headword display area (use FontAwesome `fa-volume-up` or similar)
    - [ ] 4.2.2 Add hidden HTML5 `<audio>` element for headword pronunciation
    - [ ] 4.2.3 Add speaker icon template for example sentences (to be rendered by JavaScript)
    - [ ] 4.2.4 Ensure icons are positioned inline with text
  - [ ] 4.3 Update `/themes/default/js/dictionary.js`:
    - [ ] 4.3.1 When rendering word details, check if `audio_file` exists in response data
    - [ ] 4.3.2 If audio exists, enable speaker icon and set audio source; if not, disable/grey out icon
    - [ ] 4.3.3 Add click event listener to speaker icons to play audio using HTML5 Audio API
    - [ ] 4.3.4 Add visual feedback when audio is playing (change icon color or add animation)
    - [ ] 4.3.5 Handle audio loading errors gracefully (show disabled icon if file missing)
    - [ ] 4.3.6 Render speaker icons for each example sentence with similar enable/disable logic
  - [ ] 4.4 Update `/themes/default/css/dictionary.css`:
    - [ ] 4.4.1 Style speaker icons (size, color, positioning)
    - [ ] 4.4.2 Add disabled state styles (grey color, reduced opacity, no pointer cursor)
    - [ ] 4.4.3 Add active/playing state styles (different color or animation)
    - [ ] 4.4.4 Add hover effects for enabled speaker icons
    - [ ] 4.4.5 Ensure responsive design (appropriate sizes for mobile devices)

- [ ] 5.0 Add language keys for audio-related UI text
  - [ ] 5.1 Update `/modules/dictionary/language/en.php`:
    - [ ] 5.1.1 Add `$lang_module['audio_pronunciation']` = "Audio Pronunciation"
    - [ ] 5.1.2 Add `$lang_module['upload_audio']` = "Upload Audio"
    - [ ] 5.1.3 Add `$lang_module['audio_optional']` = "Optional - MP3 or WAV, max 5MB"
    - [ ] 5.1.4 Add `$lang_module['current_audio']` = "Current audio file"
    - [ ] 5.1.5 Add `$lang_module['replace_audio']` = "Replace audio"
    - [ ] 5.1.6 Add `$lang_module['delete_audio']` = "Delete audio"
    - [ ] 5.1.7 Add `$lang_module['example_audio']` = "Example Audio"
    - [ ] 5.1.8 Add error messages: `$lang_module['error_audio_size']` = "Audio file size exceeds 5MB"
    - [ ] 5.1.9 Add error messages: `$lang_module['error_audio_type']` = "Only MP3 and WAV files are allowed"
    - [ ] 5.1.10 Add error messages: `$lang_module['error_audio_upload']` = "Failed to upload audio file"
  - [ ] 5.2 Update `/modules/dictionary/language/vi.php` with Vietnamese translations:
    - [ ] 5.2.1 Add corresponding Vietnamese translations for all keys added in 5.1
    - [ ] 5.2.2 Ensure translation quality and natural phrasing in Vietnamese

---

## Testing Checklist

After completing all tasks, verify the following:

- [ ] Admin can add new entry with headword audio (MP3 and WAV)
- [ ] Admin can add new entry with example audio files
- [ ] Admin can edit entry and replace existing audio files
- [ ] Admin can edit entry and delete existing audio files
- [ ] Admin sees validation errors for files > 5MB
- [ ] Admin sees validation errors for non-audio files
- [ ] Public users see enabled speaker icon when audio exists
- [ ] Public users see disabled speaker icon when no audio exists
- [ ] Public users can click speaker icon to play audio
- [ ] Audio playback works on desktop browsers (Chrome, Firefox, Safari)
- [ ] Audio playback works on mobile devices (iOS Safari, Android Chrome)
- [ ] When entry is deleted, all associated audio files are removed from server
- [ ] Directory `/uploads/dictionary/audio/` is not listable via browser
- [ ] Audio files are accessible directly via URL when needed for playback

---

**Document Version**: 1.0  
**Created**: October 18, 2025  
**Status**: Ready for Implementation
