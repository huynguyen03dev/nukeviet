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

// Fetch dictionary entry by slug
$word_slug = $nv_Request->get_title('word', 'get', '');

if (empty($word_slug)) {
    // Redirect to main dictionary page if no word parameter provided
    nv_redirect_location(
        NV_BASE_SITEURL . 'index.php?'
        . NV_LANG_VARIABLE . '=' . NV_LANG_DATA
        . '&' . NV_NAME_VARIABLE . '=' . $module_name
    );
}

// Fetch entry by slug
// Note: Dictionary module does not cache entry data, so no cache clearing is needed
$sql = 'SELECT * FROM ' . NV_DICTIONARY_GLOBALTABLE . '_entries WHERE slug = :slug';
$stmt = $db->prepare($sql);
$stmt->bindParam(':slug', $word_slug, PDO::PARAM_STR);
$stmt->execute();
$entry = $stmt->fetch();

if (empty($entry)) {
    // Entry not found - prepare error state
    $page_title = $nv_Lang->getModule('no_results');
    $error_state = true;
    $error_message = $nv_Lang->getModule('no_results');
    
    // Load template with error state
    $xtpl = new XTemplate('detail.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $xtpl->assign('DATA', [
        'error' => true,
        'error_message' => $error_message
    ]);
    $xtpl->assign('MODULE_URL', NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
    $xtpl->parse('main.error');
    $xtpl->parse('main');
    $contents = $xtpl->text('main');
    
    include NV_ROOTDIR . '/includes/header.php';
    echo nv_site_theme($contents);
    include NV_ROOTDIR . '/includes/footer.php';
    exit;
}

// Fetch examples for this entry
$sql = 'SELECT id, sentence_en, translation_vi, audio_file FROM ' . NV_DICTIONARY_GLOBALTABLE . '_examples 
        WHERE entry_id = :entry_id 
        ORDER BY sort ASC, id ASC';
$stmt = $db->prepare($sql);
$stmt->bindParam(':entry_id', $entry['id'], PDO::PARAM_INT);
$stmt->execute();
$examples = $stmt->fetchAll();

// Prepare data for template
$data = [
    'id' => (int) $entry['id'],
    'headword' => $entry['headword'],
    'slug' => $entry['slug'],
    'pos' => $entry['pos'],
    'phonetic' => $entry['phonetic'],
    'meaning_vi' => $entry['meaning_vi'],
    'notes' => $entry['notes'],
    'audio_file' => $entry['audio_file'],
    'examples' => []
];

// Process examples
foreach ($examples as $example) {
    $example_data = [
        'id' => (int) $example['id'],
        'sentence_en' => $example['sentence_en'],
        'translation_vi' => $example['translation_vi']
    ];
    
    if (!empty($example['audio_file'])) {
        $example_data['audio_url'] = NV_BASE_SITEURL . 'uploads/' . $module_data . '/audio/' . $example['audio_file'];
    }
    
    $data['examples'][] = $example_data;
}

// Set audio URL if available
if (!empty($entry['audio_file'])) {
    $data['audio_url'] = NV_BASE_SITEURL . 'uploads/' . $module_data . '/audio/' . $entry['audio_file'];
}

// Set page title to headword
$page_title = $entry['headword'];

// Load template
$xtpl = new XTemplate('detail.tpl', NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
$xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
$xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
$xtpl->assign('DATA', $data);
$xtpl->assign('MODULE_URL', NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);

// Parse conditional blocks for word details
$xtpl->parse('main.word_details');

// Parse audio blocks
if (!empty($data['audio_url'])) {
    $xtpl->parse('main.word_details.has_audio');
} else {
    $xtpl->parse('main.word_details.no_audio');
}

// Parse part of speech
if (!empty($data['pos'])) {
    $xtpl->parse('main.word_details.has_pos');
}

// Parse phonetic
if (!empty($data['phonetic'])) {
    $xtpl->parse('main.word_details.has_phonetic');
}

// Parse notes
if (!empty($data['notes'])) {
    $xtpl->parse('main.word_details.has_notes');
} else {
    $xtpl->parse('main.word_details.no_notes');
}

// Parse examples
if (!empty($data['examples'])) {
    $xtpl->parse('main.word_details.has_examples');
    foreach ($data['examples'] as $example) {
        $xtpl->assign('EXAMPLE', $example);
        
        if (!empty($example['audio_url'])) {
            $xtpl->parse('main.word_details.has_examples.example_loop.example_has_audio');
        } else {
            $xtpl->parse('main.word_details.has_examples.example_loop.example_no_audio');
        }
        
        if (!empty($example['translation_vi'])) {
            $xtpl->parse('main.word_details.has_examples.example_loop.example_has_translation');
        }
        
        $xtpl->parse('main.word_details.has_examples.example_loop');
    }
} else {
    $xtpl->parse('main.word_details.no_examples');
}

$xtpl->parse('main');
$contents = $xtpl->text('main');

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';

