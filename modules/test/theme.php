<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_TEST')) {
    exit('Stop!!!');
}

/**
 * nv_page_main()
 *
 * @param array  $row
 * @param array  $ab_links
 * @param string $content_comment
 * @return string
 */
function nv_main_test($array)
{
    global $module_name, $module_info, $meta_property, $client_info, $page_config, $global_config;

    [$template, $dir] = get_module_tpl_dir('main.tpl', true);
    $xtpl = new XTemplate('main.tpl', $dir);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);

    if (!empty($array)) {
        foreach ($array as $value) {
            $xtpl->assign('ITEM', $value);
            $xtpl->parse('main.loop');
        }
    } else {
        $xtpl->parse('main.empty');
    }

    $xtpl->parse('main');
    return $xtpl->text('main');
}

