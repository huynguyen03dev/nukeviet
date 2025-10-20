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

$page_title = $module_info['site_title'];
$key_words = $module_info['keywords'];

// Handle AJAX requests
$action = $nv_Request->get_title('action', 'get', '');

if ($action == 'autocomplete') {
    // Autocomplete search
    $q = $nv_Request->get_title('q', 'get', '');
    
    if (empty($q)) {
        nv_jsonOutput([
            'status' => 'error',
            'data' => []
        ]);
    }
    
    $q = $db->dblikeescape($q);
    
    $sql = 'SELECT id, headword, pos FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries 
            WHERE headword LIKE :keyword 
            ORDER BY headword ASC 
            LIMIT 10';
    
    $sth = $db->prepare($sql);
    $sth->bindValue(':keyword', $q . '%', PDO::PARAM_STR);
    $sth->execute();
    
    $results = [];
    while ($row = $sth->fetch()) {
        $results[] = [
            'id' => (int) $row['id'],
            'headword' => $row['headword'],
            'pos' => $row['pos']
        ];
    }
    
    nv_jsonOutput([
        'status' => 'success',
        'data' => $results
    ]);
}

if ($action == 'getword') {
    // Get word details
    $id = $nv_Request->get_int('id', 'get', 0);
    
    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'error',
            'message' => 'Invalid word ID'
        ]);
    }
    
    // Get entry details
    $sql = 'SELECT * FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE id = ' . $id;
    $entry = $db->query($sql)->fetch();
    
    if (empty($entry)) {
        nv_jsonOutput([
            'status' => 'error',
            'message' => 'Word not found'
        ]);
    }
    
    // Get examples
    $sql = 'SELECT id, sentence_en, translation_vi, audio_file FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples 
            WHERE entry_id = ' . $id . ' 
            ORDER BY sort ASC, id ASC';
    $result = $db->query($sql);
    
    $examples = [];
    while ($row = $result->fetch()) {
        $example_data = [
            'sentence_en' => $row['sentence_en'],
            'translation_vi' => $row['translation_vi']
        ];
        
        if (!empty($row['audio_file'])) {
            $example_data['audio_url'] = NV_BASE_SITEURL . 'uploads/' . $module_data . '/audio/' . $row['audio_file'];
        }
        
        $examples[] = $example_data;
    }
    
    $response_data = [
        'id' => (int) $entry['id'],
        'headword' => $entry['headword'],
        'slug' => $entry['slug'],
        'pos' => $entry['pos'],
        'phonetic' => $entry['phonetic'],
        'meaning_vi' => $entry['meaning_vi'],
        'notes' => $entry['notes'],
        'examples' => $examples
    ];
    
    if (!empty($entry['audio_file'])) {
        $response_data['audio_url'] = NV_BASE_SITEURL . 'uploads/' . $module_data . '/audio/' . $entry['audio_file'];
    }
    
    nv_jsonOutput([
        'status' => 'success',
        'data' => $response_data
    ]);
}

// Default view - display search interface
$intro_text = $nv_Lang->getModule('main_intro');
$contents = nv_dictionary_main($intro_text);

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
