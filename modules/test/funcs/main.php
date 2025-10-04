<?php

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$contents = "Welcome to test module";


include (NV_ROOTDIR . "/includes/header.php");

echo nv_site_theme($contents);

include (NV_ROOTDIR . "/includes/footer.php");