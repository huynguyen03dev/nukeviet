# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **NukeViet CMS v5.x** installation - a modular, PHP-based content management system with a focus on Vietnamese language support. The codebase follows a strict modular architecture with convention-based routing, multi-language support, and a comprehensive theme system.

Current development focus: Building an English-Vietnamese Dictionary module (`dictionary`) with admin management and frontend display capabilities.

## Architecture Overview

### Core Lifecycle

1. **Entry Points**
   - Frontend: `index.php` (defines `NV_SYSTEM`)
   - Admin: `admin/index.php` (defines `NV_ADMIN`)
   - Both require `includes/mainfile.php` for bootstrap

2. **Bootstrap Sequence** (`includes/mainfile.php`)
   - Server/Request initialization
   - Security guards (IP bans, proxy, flood control, CSRF, HTTPS)
   - Plugin/hook system loading
   - Cache backend selection (Files/Memcached/Redis)
   - Database connection (PDO wrapper)
   - Configuration loading (cached from DB)
   - Language bootstrapping
   - Theme/CDN setup

3. **Routing** (`includes/request_uri.php`)
   - SEO-friendly URL parsing
   - Variables: `NV_NAME_VARIABLE=nv` (module), `NV_OP_VARIABLE=op` (operation), `NV_LANG_VARIABLE=language`
   - URL pattern: `/[language]/[module]/[operation]`

4. **Module Execution**
   - Resolve module/op from URL
   - Load module's `funcs/<op>.php` file
   - Render via `header.php → nv_site_theme($contents) → footer.php`

### Module Structure

Standard module layout (`modules/<module_name>/`):

```
<module_name>/
├── admin/                    # Admin interface files
│   ├── main.php
│   ├── entry_add.php
│   └── entry_edit.php
├── funcs/                    # Frontend operations
│   ├── main.php
│   └── detail.php
├── language/                 # Multi-language support
│   ├── en.php
│   └── vi.php
├── admin.functions.php       # Admin-side utilities
├── admin.menu.php           # Admin menu definition
├── functions.php            # Module-level helpers
├── theme.php               # View rendering helpers
├── version.php             # Module metadata
└── action_mysql.php        # Database setup/migration
```

### Theme/Asset Organization

**Critical Convention**: Assets are organized by theme and module, with automatic loading:

**Admin Pages:**
- Templates: `/themes/admin_default/modules/<module_name>/*.tpl`
- CSS: `/themes/admin_default/css/<module_name>.css`
- JS: `/themes/admin_default/js/<module_name>.js`

**Site Pages:**
- Templates: `/themes/default/modules/<module_name>/*.tpl`
- CSS: `/themes/default/css/<module_name>.css`
- JS: `/themes/default/js/<module_name>.js`

**Template Naming**: `.tpl` filename MUST match the corresponding PHP filename (e.g., `entry_add.php` → `entry_add.tpl`)

### Templating System

- **Frontend**: XTemplate (see `includes/xtemplate.class.php`)
- **Admin**: Smarty via `NukeViet\Template\NVSmarty`

**XTemplate Pattern**:
```php
$xtpl = new XTemplate('template.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
$xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
$xtpl->assign('DATA', $data);
$xtpl->parse('main');
$contents = $xtpl->text('main');
```

### Language/Localization

**Language Files**: `modules/<module_name>/language/<lang>.php`

**Structure**:
```php
<?php
if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$lang_translator['author'] = 'Name <email>';
$lang_translator['createdate'] = 'DD/MM/YYYY, HH:MM';
$lang_translator['copyright'] = '@Copyright (C) YEAR Name';
$lang_translator['langtype'] = 'lang_module';

$lang_module['key'] = 'Translation';
```

**Usage in PHP**:
```php
$text = $nv_Lang->getModule('key');      // Module-specific
$text = $nv_Lang->getGlobal('key');      // Global/shared
```

**Usage in Templates**:
```html
{LANG.key}    <!-- Module language -->
{GLANG.key}   <!-- Global language -->
```

### Database Access

- **Abstraction**: `NukeViet\Core\Database` (extends PDO)
- **Table Naming**: `NV_PREFIXLANG_<module>_<table>` (e.g., `nv4_vi_dictionary_entries`)
- **Query Builder** (fluent interface):
```php
$db_slave->sqlreset()
    ->select('*')
    ->from(NV_PREFIXLANG . '_' . $module_data . '_entries')
    ->where('status=1')
    ->order('id DESC')
    ->limit(10);
$result = $db_slave->query($db_slave->sql());
```

### Security Patterns

1. **All entry files must check**:
   ```php
   if (!defined('NV_IS_MOD_<MODULE>')) {
       exit('Stop!!!');
   }
   // Admin files:
   if (!defined('NV_IS_<MODULE>_ADMIN')) {
       exit('Stop!!!');
   }
   ```

2. **Input Handling**: Always use `$nv_Request` methods:
   - `get_int()`, `get_string()`, `get_title()`
   - Never trust raw `$_GET`, `$_POST`, `$_COOKIE`

3. **CSRF**: Validate with `$nv_Request->get_title('checkss', 'post', '')`

### Caching

- Backends: Files (default), Memcached, Redis
- Common pattern: `$nv_Cache->db($sql, $keyfield, 'module')`
- Invalidation: `$nv_Cache->delMod('module')`

### Authentication

- **User**: `NV_IS_USER`, `NV_IS_1STEP_USER` (2FA required)
- **Admin Levels**: `NV_IS_ADMIN`, `NV_IS_SPADMIN` (super admin), `NV_IS_GODADMIN` (god admin)

## Development Workflow

### Working with the Dictionary Module

The current `dictionary` module implements an English-Vietnamese dictionary with:
- Database tables: `<prefix>_dictionary_entries`, `<prefix>_dictionary_examples`
- Admin pages: entry list, add/edit entry
- Language support: English (en.php) and Vietnamese (vi.php)

**Database Schema** (see `analysis/english-vietnamese-dictionary-db-design.md`):
- `entries`: headword, slug, pos, phonetic, meaning_vi, notes, timestamps
- `examples`: sentence_en, translation_vi, linked to entries

### Adding a New Module Page

1. **Create PHP file**: `modules/<module>/admin/<page>.php` or `modules/<module>/funcs/<page>.php`
2. **Create template**: `themes/<theme>/modules/<module>/<page>.tpl`
3. **Add language keys**: `modules/<module>/language/{en,vi}.php`
4. **Create assets** (if needed):
   - `themes/<theme>/css/<module>.css`
   - `themes/<theme>/js/<module>.js`

### Testing During Development

Since this is a local XAMPP installation:

1. **Access the site**:
   - Frontend: `http://localhost/nukeviet/`
   - Admin: `http://localhost/nukeviet/admin/`

2. **View logs**: Check `data/logs/` directory

3. **Clear cache**: Delete contents of `data/cache/` or use admin cache management

### Common Commands

**Start/Stop Services** (XAMPP on Linux):
```bash
sudo /opt/lampp/lampp start
sudo /opt/lampp/lampp stop
```

**Database Access**:
```bash
/opt/lampp/bin/mysql -u root -p
```

**File Permissions** (if needed):
```bash
# From the nukeviet root directory
bash nukeviet_fix_permissions.sh
```

**View PHP Errors**:
```bash
tail -f /opt/lampp/logs/php_error_log
```

## Code Conventions from AGENTS.md

The `.cursor/rules/nukeviet-frontend-rule.mdc` file (also in AGENTS.md) contains critical frontend development rules:

1. **Default themes**: `admin_default` for admin, `default` for site pages
2. **Automatic asset loading**: Framework loads CSS/JS automatically when properly named
3. **Template naming**: Must match PHP filename exactly
4. **Language keys**: Use lowercase_with_underscores, descriptive names
5. **XTemplate blocks**: Use `<!-- BEGIN: name -->` and `<!-- END: name -->`
6. **Security checks**: Always include `if (!defined('NV_MAINFILE'))` in language files

## Important Files

- `includes/mainfile.php` - Core bootstrap
- `includes/functions.php` - Core utilities, module discovery, hooks
- `includes/request_uri.php` - SEO URL parsing
- `includes/xtemplate.class.php` - XTemplate engine
- `includes/vendor/vinades/nukeviet/Core/Database.php` - Database abstraction
- `includes/vendor/vinades/nukeviet/Core/Request.php` - Input handling
- `index.php` - Frontend controller
- `admin/index.php` - Admin controller

## Analysis Documents

The `analysis/` directory contains detailed documentation:
- `framework-analysis.md` - Comprehensive framework architecture
- `english-vietnamese-dictionary-db-design.md` - Database schema for dictionary module
- `AGENTS.md` - Frontend development rules (duplicate of cursor rules)

## Constants and Conventions

- `NV_ROOTDIR` - Root directory path
- `NV_LANG_DATA` - Current language code
- `NV_PREFIXLANG` - Table prefix with language (e.g., `nv4_vi`)
- `$global_config` - Global configuration array
- `$module_config` - Module-specific configuration
- `$module_file` - Current module directory name
- `$module_data` - Module's database table base name

## Best Practices

1. **Never hardcode text** - Always use language files
2. **Use theme variables** - Never hardcode theme paths (`$global_config['module_theme']`)
3. **Cache aggressively** - Use `$nv_Cache->db()` for repeated queries
4. **Follow naming conventions** - Ensures automatic asset loading
5. **Security first** - Always validate with `NV_IS_*` constants and check `NV_MAINFILE`
6. **Modular CSS/JS** - Use module-specific prefixes to avoid conflicts
7. **Template naming** - Must match PHP filename exactly
