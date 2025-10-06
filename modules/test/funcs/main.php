<?php

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$array = [
    'id' => 'Chuỗi ABC',
    'name' => 'Chuỗi XYZ',
    '123' => 'Chuỗi 123'
];

$contents = nv_main_test($array);

include (NV_ROOTDIR . "/includes/header.php");

echo nv_site_theme($contents);

include (NV_ROOTDIR . "/includes/footer.php");