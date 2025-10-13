<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_DICTIONARY_ADMIN')) {
    exit('Stop!!!');
}

$page_title = $nv_Lang->getModule('list');

// Check for success message from session (flash message)
$success_message = '';
if (isset($_SESSION['dictionary_success_message'])) {
    $success_message = $_SESSION['dictionary_success_message'];
    unset($_SESSION['dictionary_success_message']);
}

// Handle delete request
if ($nv_Request->isset_request('delete', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    if ($id > 0) {
        // Get entry title before deleting for toast notification
        $headword = $db->query('SELECT headword FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE id = ' . $id)->fetchColumn();
        
        // Delete examples first
        $db->query('DELETE FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples WHERE entry_id = ' . $id);
        
        // Delete entry
        $result = $db->query('DELETE FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE id = ' . $id);
        
        if ($result && $headword) {
            // Store success message in session to show toast on next page
            $_SESSION['dictionary_success_message'] = sprintf(
                $nv_Lang->getModule('entry_deleted_success'),
                $headword
            );
            
            die('OK');
        }
    }
    die('ERROR');
}

// Pagination
$page = $nv_Request->get_int('page', 'get', 1);
$per_page = 30;

// Get total entries
$sql = 'SELECT COUNT(*) FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries';
$total = $db->query($sql)->fetchColumn();

// Get entries
$sql = 'SELECT * FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries 
        ORDER BY created_at DESC 
        LIMIT ' . (($page - 1) * $per_page) . ', ' . $per_page;
$result = $db->query($sql);

$xtpl = new XTemplate('entry_list.tpl', NV_ROOTDIR . '/themes/' . $global_config['admin_theme'] . '/modules/' . $module_file);
$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
$xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
$xtpl->assign('MODULE_NAME', $module_name);
$xtpl->assign('OP', $op);
$xtpl->assign('ADD_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=entry_add');

// Pass success message to template
if (!empty($success_message)) {
    $xtpl->assign('SUCCESS_MESSAGE', htmlspecialchars($success_message, ENT_QUOTES, 'UTF-8'));
    $xtpl->parse('main.success_toast');
}

$i = ($page - 1) * $per_page;
if ($total > 0) {
    while ($row = $result->fetch()) {
        $i++;
        $row['num'] = $i;
        $row['created_at'] = nv_date('d/m/Y H:i', $row['created_at']);
        $row['url_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=entry_edit&amp;id=' . $row['id'];
        
        // Truncate meaning if too long for display
        if (mb_strlen($row['meaning_vi']) > 100) {
            $row['meaning_vi'] = mb_substr($row['meaning_vi'], 0, 100) . '...';
        }
        
        $xtpl->assign('ROW', $row);
        
        if (!empty($row['phonetic'])) {
            $xtpl->parse('main.loop.phonetic');
        }
        
        $xtpl->parse('main.loop');
    }
} else {
    // Add no_data language key if not exists
    if (!isset(\NukeViet\Core\Language::$lang_module['no_data'])) {
        \NukeViet\Core\Language::$lang_module['no_data'] = 'No data available';
    }
    $xtpl->parse('main.empty');
}

// Generate page
if ($total > $per_page) {
    $base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
    $generate_page = nv_generate_page($base_url, $total, $per_page, $page);
    if (!empty($generate_page)) {
        $xtpl->assign('NV_GENERATE_PAGE', $generate_page);
        $xtpl->parse('main.page');
    }
}

$xtpl->parse('main');
$contents = $xtpl->text('main');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
