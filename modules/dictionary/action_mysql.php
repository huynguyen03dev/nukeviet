<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author huynguyen03dev
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_MODULES')) {
    exit('Stop!!!');
}

$sql_drop_module = [];

// Drop child table first (if present), then main table
$sql_drop_module[] = 'DROP TABLE IF EXISTS ' . $db_config['prefix'] . '_' . $module_data . '_examples;';
$sql_drop_module[] = 'DROP TABLE IF EXISTS ' . $db_config['prefix'] . '_' . $module_data . '_entries;';

$sql_create_module = $sql_drop_module;

// Core dictionary entries
$sql_create_module[] = 'CREATE TABLE ' . $db_config['prefix'] . '_' . $module_data . "_entries (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  headword varchar(128) NOT NULL,
  slug varchar(160) NOT NULL,
  pos varchar(16) DEFAULT '',
  phonetic varchar(64) DEFAULT '',
  meaning_vi text NOT NULL,
  notes text,
  created_at int(11) unsigned NOT NULL DEFAULT '0',
  updated_at int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY uq_slug (slug),
  KEY idx_headword (headword)
) ENGINE=MyISAM";

// Example sentences (1-to-many with entries)
$sql_create_module[] = 'CREATE TABLE ' . $db_config['prefix'] . '_' . $module_data . "_examples (
  id int(11) unsigned NOT NULL AUTO_INCREMENT,
  entry_id int(11) unsigned NOT NULL DEFAULT '0',
  sentence_en text NOT NULL,
  translation_vi text,
  sort smallint(5) unsigned NOT NULL DEFAULT '0',
  created_at int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  KEY idx_entry_id (entry_id)
) ENGINE=MyISAM";



// Default configuration for Dictionary module
$sql_create_module[] = 'INSERT INTO ' . NV_CONFIG_GLOBALTABLE . " (lang, module, config_name, config_value) VALUES
('" . $lang . "', '" . $module_name . "', 'per_page', '20'),
('" . $lang . "', '" . $module_name . "', 'search_mode', 'prefix'),
('" . $lang . "', '" . $module_name . "', 'search_min_length', '2'),
('" . $lang . "', '" . $module_name . "', 'show_phonetic', '1'),
('" . $lang . "', '" . $module_name . "', 'show_examples', '1'),
('" . $lang . "', '" . $module_name . "', 'example_limit', '3'),
('" . $lang . "', '" . $module_name . "', 'suggest_limit', '10'),
('" . $lang . "', '" . $module_name . "', 'cache_ttl', '300'),
('" . $lang . "', '" . $module_name . "', 'allow_submit', '0'),
('" . $lang . "', '" . $module_name . "', 'admin_review_required', '1'),
('" . $lang . "', '" . $module_name . "', 'alias_lower', '1')";
