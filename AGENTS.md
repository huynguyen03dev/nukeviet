<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# NukeViet CMS - Agent Development Guide

## Quick Start
1. **Read CLAUDE.md first** for comprehensive architecture, lifecycle, and conventions
2. **Check .cursor/rules/nukeviet-frontend-rule.mdc** for detailed frontend asset organization
3. **Understand the flow**: `index.php` → `includes/mainfile.php` → routing → module execution → templates
4. **Key principle**: Convention-based framework - follow naming patterns strictly for auto-loading to work

## Build/Test Commands
- **Start/Stop XAMPP**: `sudo /opt/lampp/lampp start|stop`
- **Restart Apache**: `sudo /opt/lampp/lampp restartapache`
- **Database Access**: `/opt/lampp/bin/mysql -u root -p`
- **Fix Permissions**: `bash nukeviet_fix_permissions.sh`
- **View PHP Errors**: `tail -f /opt/lampp/logs/php_error_log`
- **View Apache Errors**: `tail -f /opt/lampp/logs/error_log`
- **Clear Cache**: Delete contents of `data/cache/*` (keep index.html) or use admin panel
- **Admin Login**: http://localhost/nukeviet/admin/ (credentials in `docs/change.txt`)
- **No formal test suite**: Manual testing via browser (Frontend: `http://localhost/nukeviet/`, Admin: `http://localhost/nukeviet/admin/`)
- **No linting/typecheck**: Framework does not use modern PHP linters; follow code conventions strictly

## Code Style

### File Structure & Security
- **Security check required**: All PHP files must start with `if (!defined('NV_IS_MOD_<MODULE>')) { exit('Stop!!!'); }` (frontend) or `if (!defined('NV_IS_<MODULE>_ADMIN')) { exit('Stop!!!'); }` (admin)
- **Module structure**: `modules/<module>/admin/` (admin), `modules/<module>/funcs/` (frontend), `modules/<module>/language/` (i18n)
- **Templates**: `themes/admin_default/modules/<module>/*.tpl` (admin), `themes/default/modules/<module>/*.tpl` (site) - filename must match PHP file
- **Assets**: Auto-loaded from `themes/<theme>/css/<module>.css` and `themes/<theme>/js/<module>.js`

### Naming Conventions
- **Files/directories**: `lowercase_with_underscores` (e.g., `entry_add.php`)
- **Variables**: `$snake_case` (e.g., `$page_title`, `$module_data`)
- **Constants**: `SCREAMING_SNAKE_CASE` with `NV_` prefix (e.g., `NV_ROOTDIR`, `NV_CURRENTTIME`)
- **Language keys**: `lowercase_with_underscores` and descriptive (e.g., `$lang_module['error_empty_headword']`)
- **CSS classes**: Module-specific prefixes (e.g., `.dictionary-word`, `.dictionary-definition`)

### Language/Localization
- **Never hardcode text**: All user-facing text in `modules/<module>/language/{en,vi}.php`
- **PHP usage**: `$nv_Lang->getModule('key')` (module-specific), `$nv_Lang->getGlobal('key')` (global)
- **Template usage**: `{LANG.key}` (module), `{GLANG.key}` (global)
- **Template assignment**: `$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module); $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);`

### Database
- **Access via**: `$db` (write), `$db_slave` (read) - PDO-based `NukeViet\Core\Database`
- **Table naming**: `NV_PREFIXLANG . '_' . $module_data . '_<table>'` (e.g., `nv4_vi_dictionary_entries`)
- **Input handling**: Use `$nv_Request->get_int()`, `get_string()`, `get_title()` - never raw `$_GET/$_POST/$_COOKIE`
- **CSRF protection**: Validate with `$nv_Request->get_title('checkss', 'post', '')` === `md5(NV_CHECK_SESSION)`
- **Prepared statements required**: Always use parameterized queries with `$stmt->bindParam()` to prevent SQL injection

### Templating (XTemplate)
- **Pattern**: `$xtpl = new XTemplate('file.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);`
- **Blocks**: `<!-- BEGIN: name -->...<!-- END: name -->`
- **Variables**: `{VARIABLE}` in templates, `$xtpl->assign('VARIABLE', $value)` in PHP
- **Output**: `$xtpl->parse('main'); $contents = $xtpl->text('main');`

### Error Handling
- **Try-catch**: Use for database operations and file uploads
- **PRG pattern**: Store errors in `$_SESSION`, redirect to prevent resubmission
- **Validation**: Collect all errors in `$errors[]` array before displaying

### Best Practices
- **Never hardcode paths**: Use `$global_config['module_theme']` / `$global_config['admin_theme']`, never literal theme names
- **Use framework functions**: `change_alias()` (slugs), `nv_redirect_location()` (redirects), `nv_jsonOutput()` (AJAX)
- **Autoloading**: PSR-4 via Composer - `NukeViet\` namespace maps to `includes/vendor/vinades/nukeviet/`
- **Constants**: `NV_ROOTDIR`, `NV_LANG_DATA`, `NV_CURRENTTIME`, `NV_CHECK_SESSION`, `NV_PREFIXLANG`
- **Global objects**: `$db`, `$db_slave`, `$nv_Request`, `$nv_Lang`, `$global_config`, `$module_info` are auto-loaded
- **IP handling**: Use constants `NV_CLIENT_IP`, `NV_REMOTE_ADDR`, `NV_FORWARD_IP` from `NukeViet\Core\Ips`

## When to Use Sequential Thinking
Use the sequential-thinking tool for complex tasks requiring careful analysis:
- **Database schema design**: Analyze relationships, indexes, performance implications, migration strategy
- **Module architecture**: Plan file structure, routing, security boundaries, data flow across components
- **Security implementations**: Validate CSRF protection, input sanitization, permission checks, SQL injection prevention
- **Multi-step features**: Break down dependencies, identify edge cases, plan error handling, ensure transaction safety
- **Performance optimization**: Analyze query patterns, caching strategy, N+1 problems, bottleneck identification
- **Debugging complex issues**: Trace execution flow across multiple files/layers, identify root cause vs symptoms

**Why use it**: NukeViet has strict conventions and security requirements. Sequential thinking helps avoid introducing bugs, security holes, or architectural inconsistencies that would require refactoring.

## Common Workflows

### Adding a New Admin Page
1. Create PHP file: `modules/<module>/admin/<page>.php` with security check `if (!defined('NV_IS_<MODULE>_ADMIN')) { exit('Stop!!!'); }`
2. Create template: `themes/admin_default/modules/<module>/<page>.tpl` (filename MUST match PHP file)
3. Add language keys: `modules/<module>/language/{en,vi}.php` (all user-facing text)
4. Update admin menu: `modules/<module>/admin.menu.php` if adding to navigation
5. Load template: `$xtpl = new XTemplate('<page>.tpl', NV_ROOTDIR . '/themes/' . $global_config['admin_theme'] . '/modules/' . $module_file);`
6. Assign language: `$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);`
7. Test: Clear cache (`data/cache/`), visit `http://localhost/nukeviet/admin/`

### Adding a New Frontend Page
1. Create PHP file: `modules/<module>/funcs/<page>.php` with security check `if (!defined('NV_IS_MOD_<MODULE>')) { exit('Stop!!!'); }`
2. Create template: `themes/default/modules/<module>/<page>.tpl`
3. Add language keys: Same language files as admin
4. Use `$global_config['module_theme']` for template path (NOT `admin_theme`)
5. Output: `$contents = nv_<module>_<page>($data); include NV_ROOTDIR . '/includes/header.php'; echo nv_site_theme($contents);`

### Form Handling with PRG Pattern
1. Validate input: Collect errors in `$errors[]` array
2. If errors: Store in session → `$_SESSION['<module>_form_errors'] = $errors; $_SESSION['<module>_form_data'] = $data;`
3. Redirect: `nv_redirect_location(NV_BASE_ADMINURL . 'index.php?...')`
4. On page load: Check session for errors/data, display, then `unset()`
5. On success: Store success message in session, redirect to list/detail page

### Database Operations
1. Use prepared statements: `$stmt = $db->prepare('SELECT * FROM ' . NV_PREFIXLANG . '_' . $module_data . '_table WHERE id = :id');`
2. Bind parameters: `$stmt->bindParam(':id', $id, PDO::PARAM_INT);`
3. Execute: `$stmt->execute();`
4. Fetch: `$row = $stmt->fetch();` or `$rows = $stmt->fetchAll();`
5. Wrap in try-catch for INSERT/UPDATE/DELETE operations

## Common Pitfalls (CRITICAL - AVOID THESE)

### 1. Mismatched Template Filenames
❌ **Wrong**: PHP file `entry_add.php` → Template `add_entry.tpl`  
✅ **Correct**: PHP file `entry_add.php` → Template `entry_add.tpl`  
**Why**: Convention-based template loading will fail silently or throw errors

### 2. Hardcoded Text
❌ **Wrong**: `echo "Add New Entry";` or `<h1>Add New Entry</h1>`  
✅ **Correct**: `$nv_Lang->getModule('add')` (PHP) or `{LANG.add}` (template)  
**Why**: Breaks multi-language support, violates framework conventions

### 3. Hardcoded Theme Paths
❌ **Wrong**: `NV_ROOTDIR . '/themes/admin_default/modules/' . $module_file`  
✅ **Correct**: `NV_ROOTDIR . '/themes/' . $global_config['admin_theme'] . '/modules/' . $module_file`  
**Why**: Breaks when users change themes

### 4. Missing Security Checks
❌ **Wrong**: PHP file starts directly with logic  
✅ **Correct**: First line after `<?php` and comments: `if (!defined('NV_IS_MOD_<MODULE>')) { exit('Stop!!!'); }`  
**Why**: Direct file access bypasses authentication and security checks

### 5. Raw Input Access
❌ **Wrong**: `$id = $_GET['id'];` or `$name = $_POST['name'];`  
✅ **Correct**: `$id = $nv_Request->get_int('id', 'get', 0);` or `$name = $nv_Request->get_title('name', 'post', '');`  
**Why**: SQL injection, XSS vulnerabilities

### 6. Missing CSRF Validation
❌ **Wrong**: Process form without checking session token  
✅ **Correct**: `if ($nv_Request->get_title('checkss', 'post', '') !== md5(NV_CHECK_SESSION)) { /* error */ }`  
**Why**: CSRF attacks can manipulate user actions

### 7. Inconsistent Language Keys
❌ **Wrong**: `en.php` has `'add_entry'` but `vi.php` has `'them_moi'` (different key)  
✅ **Correct**: Both files use `'add_entry'` with different values  
**Why**: Language switching will show missing translation errors

### 8. Forgetting to Assign LANG to Templates
❌ **Wrong**: Template uses `{LANG.add}` but PHP never assigns it  
✅ **Correct**: `$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);`  
**Why**: Template variables will be empty/undefined

## Debugging Guide

### When Something Doesn't Work
1. **Check PHP error log**: `tail -f /opt/lampp/logs/php_error_log`
2. **Clear cache**: Delete `data/cache/*` contents (keep index.html)
3. **Verify file permissions**: Run `bash nukeviet_fix_permissions.sh`
4. **Check security constant**: Ensure correct `NV_IS_MOD_<MODULE>` or `NV_IS_<MODULE>_ADMIN` in if statement
5. **Verify template path**: Check theme name variable, module name, filename match
6. **Check database table name**: Must use `NV_PREFIXLANG . '_' . $module_data . '_table'` pattern
7. **Inspect browser console**: For JavaScript errors or failed AJAX requests
8. **Check admin menu**: Verify `admin.menu.php` has correct operation name

### Common Error Messages
- **"Stop!!!"**: Security check failed - wrong constant or file accessed directly
- **Template not found**: Filename mismatch or wrong theme path
- **Undefined variable LANG**: Forgot to assign language to template
- **SQL error**: Wrong table name format or missing prepared statement binding
- **404 on module page**: Check `modules/<module>/version.php` and module installation

## File Reference Quick Guide
- **Core bootstrap**: `includes/mainfile.php`
- **Database class**: `includes/vendor/vinades/nukeviet/Core/Database.php`
- **Request handler**: `includes/vendor/vinades/nukeviet/Core/Request.php`
- **XTemplate engine**: `includes/xtemplate.class.php`
- **Common functions**: `includes/functions.php`
- **Admin controller**: `admin/index.php`
- **Frontend controller**: `index.php`

See `.cursor/rules/nukeviet-frontend-rule.mdc` for detailed frontend conventions and architecture.
