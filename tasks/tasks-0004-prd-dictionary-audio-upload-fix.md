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
- [ ] 2.0 Fix Headword Audio Upload in entry_add.php
- [ ] 3.0 Fix Example Audio Uploads in entry_add.php
- [ ] 4.0 Add Required Language Keys for Error Messages
- [ ] 5.0 Fix Audio Upload in entry_edit.php (Same Issues)
- [ ] 6.0 Manual Testing and Verification

---

## Status

**High-level tasks generated. Ready to generate sub-tasks.**

I have generated the high-level tasks based on the PRD. Ready to generate the sub-tasks? Respond with **'Go'** to proceed.

