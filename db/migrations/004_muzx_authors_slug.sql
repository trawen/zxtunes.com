ALTER TABLE `muzx_authors`
  ADD COLUMN `slug_ru` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' AFTER `meta_description_en`,
  ADD COLUMN `slug_en` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' AFTER `slug_ru`;
