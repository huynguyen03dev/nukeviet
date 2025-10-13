<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_ADMIN')) {
    exit('Stop!!!');
}

$submenu['entry_list'] = $nv_Lang->getModule('list');
$submenu['entry_add'] = $nv_Lang->getModule('add');

$allow_func[] = 'main';
$allow_func[] = 'entry_list';
$allow_func[] = 'entry_add';