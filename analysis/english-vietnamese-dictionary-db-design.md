# English–Vietnamese Dictionary (MVP) – Database Design

## Goals
- Minimal schema for a beginner-friendly NukeViet module
- Store English headwords with Vietnamese meanings
- Optional example sentences
- Simple to query, index, and evolve later

## Overview
This MVP uses just two tables:
- entries: one row per English headword with its Vietnamese meaning
- examples: optional example sentences per entry (1-to-many)

Keep it to a single language for now (English ➝ Vietnamese). If your site is multilingual later, you can duplicate per-language using NukeViet’s NV_PREFIXLANG convention.

## Tables and Fields

### 1) entries (core dictionary entries)
- id: INT UNSIGNED, primary key, auto-increment
- headword: VARCHAR(128), NOT NULL — the English word or phrase
- slug: VARCHAR(160), NOT NULL, UNIQUE — URL/search-friendly version of headword
- pos: VARCHAR(16), NULL — part of speech (e.g., n, v, adj); keep free-text for simplicity
- phonetic: VARCHAR(64), NULL — optional phonetic transcription
- meaning_vi: TEXT, NOT NULL — concise Vietnamese meaning/definition
- notes: TEXT, NULL — optional notes (synonyms, usage hints)
- created_at: INT UNSIGNED, NOT NULL — Unix timestamp when created
- updated_at: INT UNSIGNED, NULL — Unix timestamp when last updated

Indexes:
- PRIMARY KEY (id)
- UNIQUE KEY on slug
- KEY on headword for fast lookups

Relationship:
- One-to-many with examples (entries.id ➝ examples.entry_id)

### 2) examples (optional example sentences)
- id: INT UNSIGNED, primary key, auto-increment
- entry_id: INT UNSIGNED, NOT NULL — references entries.id
- sentence_en: TEXT, NOT NULL — English example sentence
- translation_vi: TEXT, NULL — Vietnamese translation (optional)
- sort: SMALLINT UNSIGNED, NOT NULL DEFAULT 0 — display ordering
- created_at: INT UNSIGNED, NOT NULL — Unix timestamp when created

Indexes:
- PRIMARY KEY (id)
- KEY on entry_id
- Optional FOREIGN KEY to entries(id) with ON DELETE CASCADE (if using InnoDB)

## Why this design?
- Beginner-friendly: one main table, one auxiliary table
- Flexible: you can add more fields later (frequency, synonyms table, tagging)
- Practical: headword and slug indexed for quick search/autocomplete
- Portable: uses common MySQL types; timestamps as INT for NukeViet familiarity

## SQL – Generic MySQL (simple to run locally)

```sql
CREATE TABLE IF NOT EXISTS `evdict_entries` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `headword` VARCHAR(128) NOT NULL,
  `slug` VARCHAR(160) NOT NULL,
  `pos` VARCHAR(16) NULL,
  `phonetic` VARCHAR(64) NULL,
  `meaning_vi` TEXT NOT NULL,
  `notes` TEXT NULL,
  `created_at` INT UNSIGNED NOT NULL,
  `updated_at` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_slug` (`slug`),
  KEY `idx_headword` (`headword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `evdict_examples` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `entry_id` INT UNSIGNED NOT NULL,
  `sentence_en` TEXT NOT NULL,
  `translation_vi` TEXT NULL,
  `sort` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entry_id` (`entry_id`),
  CONSTRAINT `fk_examples_entry`
    FOREIGN KEY (`entry_id`) REFERENCES `evdict_entries`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Notes:
- Uses InnoDB + utf8mb4 for modern MySQL
- If your MySQL version or hosting defaults differ, adjust ENGINE/CHARSET accordingly.

## SQL – NukeViet naming conventions
NukeViet typically prefixes tables per language with NV_PREFIXLANG, which resolves to something like `nv4_vi` for Vietnamese. For a module named `evdict`, table names would be:
- `NV_PREFIXLANG`_evdict_entries
- `NV_PREFIXLANG`_evdict_examples

You can use the following SQL (replace literally at runtime via NukeViet’s install routine or your module code that expands NV_PREFIXLANG):

```sql
CREATE TABLE IF NOT EXISTS `NV_PREFIXLANG`_evdict_entries (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `headword` VARCHAR(128) NOT NULL,
  `slug` VARCHAR(160) NOT NULL,
  `pos` VARCHAR(16) NULL,
  `phonetic` VARCHAR(64) NULL,
  `meaning_vi` TEXT NOT NULL,
  `notes` TEXT NULL,
  `created_at` INT UNSIGNED NOT NULL,
  `updated_at` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_slug` (`slug`),
  KEY `idx_headword` (`headword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `NV_PREFIXLANG`_evdict_examples (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `entry_id` INT UNSIGNED NOT NULL,
  `sentence_en` TEXT NOT NULL,
  `translation_vi` TEXT NULL,
  `sort` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_entry_id` (`entry_id`),
  CONSTRAINT `fk_examples_entry`
    FOREIGN KEY (`entry_id`) REFERENCES `NV_PREFIXLANG`_evdict_entries(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Notes:
- If you prefer to avoid foreign keys initially (for absolute simplicity or MyISAM), remove the CONSTRAINT and keep the `entry_id` index.
- The module name `evdict` is an example; you can change it if you choose a different module directory name.

## Minimal usage examples (queries)
- Insert a new word:

```sql
INSERT INTO `evdict_entries` (headword, slug, pos, meaning_vi, created_at)
VALUES ('run', 'run', 'v', 'chạy; vận hành', UNIX_TIMESTAMP());
```

- Add an example sentence for that word:

```sql
INSERT INTO `evdict_examples` (entry_id, sentence_en, translation_vi, sort, created_at)
VALUES (1, 'I run every morning.', 'Tôi chạy mỗi sáng.', 1, UNIX_TIMESTAMP());
```

- Find by headword prefix (basic autocomplete):

```sql
SELECT id, headword, pos, meaning_vi
FROM evdict_entries
WHERE headword LIKE 'ru%'
ORDER BY headword ASC
LIMIT 20;
```

## Next steps (optional)
- Add full-text index on headword and meaning_vi for richer search
- Add unique constraint on (headword, pos) if you want one entry per POS
- Build simple admin forms for CRUD in the NukeViet module
- Add pagination and simple search in the frontend

