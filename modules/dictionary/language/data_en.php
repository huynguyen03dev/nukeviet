<?php

/**
 * NukeViet Content Management System
 * Sample seed data for Dictionary module (global tables)
 *
 * Note:
 *  - Module vars: $lang, $module_file, $module_data, $module_upload, $module_theme, $module_name
 *  - Globals: $db, $db_config, $global_config
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

$entriesTbl = $db_config['prefix'] . '_' . $module_data . '_entries';
$examplesTbl = $db_config['prefix'] . '_' . $module_data . '_examples';

// Seed 10 sample entries (INSERT IGNORE relies on UNIQUE KEY uq_slug)
$entries = [
    // slug, headword, pos, phonetic, meaning_vi
    ['hello', 'hello', 'interj.', '/ˈhɛləʊ/', 'Xin chào'],
    ['world', 'world', 'n.', '/wɜːld/', 'Thế giới'],
    ['book', 'book', 'n.', '/bʊk/', 'Sách'],
    ['computer', 'computer', 'n.', '/kəmˈpjuːtə(r)/', 'Máy tính'],
    ['language', 'language', 'n.', '/ˈlæŋɡwɪdʒ/', 'Ngôn ngữ'],
    ['translate', 'translate', 'v.', '/trænzˈleɪt/', 'Dịch'],
    ['example', 'example', 'n.', '/ɪɡˈzɑːmpl/', 'Ví dụ'],
    ['search', 'search', 'v.', '/sɜːtʃ/', 'Tìm kiếm'],
    ['dictionary', 'dictionary', 'n.', '/ˈdɪkʃənri/', 'Từ điển'],
    ['word', 'word', 'n.', '/wɜːd/', 'Từ']
];

$insEntry = $db->prepare("INSERT IGNORE INTO $entriesTbl (slug, headword, pos, phonetic, meaning_vi, notes, created_at, updated_at)
VALUES (:slug, :headword, :pos, :phonetic, :meaning_vi, '', " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . ")");

foreach ($entries as [$slug, $head, $pos, $pho, $vi]) {
    $insEntry->execute([
        ':slug' => $slug,
        ':headword' => $head,
        ':pos' => $pos,
        ':phonetic' => $pho,
        ':meaning_vi' => $vi
    ]);
}

// Sample example sentences for select entries
$examplesBySlug = [
    'hello' => [
        ['Hello, how are you?', 'Xin chào, bạn khỏe không?'],
        ['She waved hello to her neighbors.', 'Cô ấy vẫy tay chào hàng xóm.']
    ],
    'book' => [
        ['I read a book every week.', 'Tôi đọc một cuốn sách mỗi tuần.'],
        ['This book is very interesting.', 'Cuốn sách này rất thú vị.']
    ],
    'computer' => [
        ['This computer is very fast.', 'Chiếc máy tính này rất nhanh.'],
        ['He bought a new computer yesterday.', 'Anh ấy đã mua một chiếc máy tính mới hôm qua.']
    ],
    'example' => [
        ['Here is an example sentence.', 'Đây là một câu ví dụ.']
    ],
    'search' => [
        ['You can search the dictionary online.', 'Bạn có thể tìm kiếm từ điển trực tuyến.']
    ]
];

$getEntryId = $db->prepare("SELECT id FROM $entriesTbl WHERE slug = :slug");
$existsExample = $db->prepare("SELECT COUNT(*) FROM $examplesTbl WHERE entry_id = :eid AND sentence_en = :sen");
$insExample = $db->prepare("INSERT INTO $examplesTbl (entry_id, sentence_en, translation_vi, sort, created_at)
VALUES (:eid, :sen, :vi, 0, " . NV_CURRENTTIME . ")");

foreach ($examplesBySlug as $slug => $pairs) {
    $getEntryId->execute([':slug' => $slug]);
    $eid = (int) $getEntryId->fetchColumn();
    if (!$eid) {
        continue;
    }
    foreach ($pairs as [$sen, $vi]) {
        $existsExample->execute([':eid' => $eid, ':sen' => $sen]);
        if ((int) $existsExample->fetchColumn() === 0) {
            $insExample->execute([':eid' => $eid, ':sen' => $sen, ':vi' => $vi]);
        }
    }
}

