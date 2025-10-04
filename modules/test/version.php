<?php
 
/**
 * @Project Module Nukeviet 4.x
 * @Author Webvang.vn (hoang.nguyen@webvang.vn)
 * @copyright 2014 J&A.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @createdate 08/10/2014 09:47
 */
 
if (!defined('NV_ADMIN') or !defined('NV_MAINFILE'))
    die('Stop!!!');
 
$module_version = array(
    'name' => 'test', // Tieu de module
    'modfuncs' => 'main', // Cac function co block
    'change_alias' => '',
    'submenu' => '',
    'is_sysmod' => 0, // 1:0 => Co phai la module he thong hay khong
    'virtual' => 1, // 1:0 => Co cho phep ao hao module hay khong
    'version' => '4.0.00', // Phien ban cua modle
    'date' => 'Wed, 8 Oct 2014 00:00:00 GMT', // Ngay phat hanh phien ban
    'author' => 'huynguyen', // Tac gia
    'note' => '', // Ghi chu
    // 'uploads_dir' => array(
    //     $module_upload,
    //     $module_upload . '/source',
    //     $module_upload . '/temp_pic',
    //     $module_upload . '/topics'
    // ),
    // 'files_dir' => array($module_upload . '/topics')
);