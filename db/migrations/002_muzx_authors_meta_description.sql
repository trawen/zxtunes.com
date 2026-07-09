ALTER TABLE `muzx_authors`
  ADD COLUMN `meta_description_ru` varchar(512) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' AFTER `locked`,
  ADD COLUMN `meta_description_en` varchar(512) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' AFTER `meta_description_ru`;
