<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_DICTIONARY')) {
    exit('Stop!!!');
}

/**
 * nv_dictionary_main()
 *
 * @param string $intro_text
 * @return string
 */
function nv_dictionary_main($intro_text)
{
    global $module_info, $module_name, $global_config;

    [$template, $dir] = get_module_tpl_dir('main.tpl', true);
    $xtpl = new XTemplate('main.tpl', $dir);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $xtpl->assign('INTRO_TEXT', $intro_text);
    $xtpl->assign('MODULE_NAME', $module_name);
    $xtpl->assign('NV_BASE_SITEURL', NV_BASE_SITEURL);
    $xtpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $xtpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);

    $xtpl->parse('main');

    return $xtpl->text('main');
}
