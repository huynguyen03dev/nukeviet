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

// Task 3.2: Get and validate request parameters
$entry_id = $nv_Request->get_int('id', 'get', 0);
$audio_type = $nv_Request->get_title('type', 'get', '');
$example_id = $nv_Request->get_int('ex', 'get', 0);

// Validate entry_id
if ($entry_id <= 0) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

// Task 3.3: Fetch audio filename from database based on type
$audio_file = null;

if ($audio_type === 'headword') {
    // Get headword audio
    $sql = 'SELECT audio_file FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE id = :id';
    $stmt = $db->prepare($sql);
    $stmt->bindParam(':id', $entry_id, PDO::PARAM_INT);
    $stmt->execute();
    $result = $stmt->fetch();
    
    if ($result && !empty($result['audio_file'])) {
        $audio_file = $result['audio_file'];
    }
} elseif ($audio_type === 'example' && $example_id > 0) {
    // Get example audio with security validation
    $sql = 'SELECT audio_file FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples WHERE id = :ex_id AND entry_id = :entry_id';
    $stmt = $db->prepare($sql);
    $stmt->bindParam(':ex_id', $example_id, PDO::PARAM_INT);
    $stmt->bindParam(':entry_id', $entry_id, PDO::PARAM_INT);
    $stmt->execute();
    $result = $stmt->fetch();
    
    if ($result && !empty($result['audio_file'])) {
        $audio_file = $result['audio_file'];
    }
} else {
    // Invalid type or missing example_id
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

// If no audio file found, redirect to module main page
if (empty($audio_file)) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

// Task 3.4: Validate file exists on filesystem
$file_path = NV_ROOTDIR . '/uploads/' . $module_name . '/audio/' . $audio_file;

if (!file_exists($file_path)) {
    trigger_error('[Dictionary Download] Audio file not found: ' . basename($file_path), E_USER_WARNING);
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

// Task 3.5: Instantiate Download class and serve file
$file_info = pathinfo($file_path);
$download = new NukeViet\Files\Download($file_path, $file_info['dirname'], $file_info['basename'], true);
$download->download_file();
exit();
