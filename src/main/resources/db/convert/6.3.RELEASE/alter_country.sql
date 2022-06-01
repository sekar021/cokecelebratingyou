--liquibase formatted sql

--changeset siemback:1
--comment Added a column to identify editable system variables
ALTER TABLE COUNTRY ADD IS_SMS_CAPABLE NUMBER(1,0) DEFAULT 0 NOT NULL;
--rollback ALTER TABLE COUNTRY DROP (IS_SMS_CAPABLE);

--changeset siemback:2
--comment change value of SMS Capable from false to true
UPDATE country SET IS_SMS_CAPABLE=1 WHERE COUNTRY_CODE IN ('us', 'bj', 'kh', 'sd', 'kz', 'py', 'bn', 'pt', 'ky', 'gr', 'lv', 'ma', 'ml', 'pa', 'iq', 'cl', 'ar', 'ua', 'bz', 'zm', 'bh', 'in', 'tr', 'be', 'na', 'fo', 'fi', 'za', 'bm', 'cf', 'ge', 'jm', 'pe', 'de', 'hk', 'mg', 'th', 'ly', 'se', 'mw', 'li', 'pl', 'bg', 'jo', 'kw', 'ng', 'tn', 'hr', 'lk', 'ke', 'ch', 'es', 'lb', 'az', 'cz', 'bf', 'il', 'au', 'tj', 'ee', 'mm', 'gi', 'cy', 'my', 'is', 'am', 'ga', 'at', 'mz', 'sv', 'lu', 'br', 'tc', 'dz', 'si', 'ls', 'co', 'hu', 'jp', 'by', 'al', 'nz', 'hn', 'it', 'sg', 'gf', 'eg', 'as', 'mt', 'sa', 'nl', 'pk', 'gm', 'cn', 'ie', 'qa', 'sk', 'fr', 'lt', 'rs', 'kg', 'ro', 'tg', 'ne', 'ph', 'rw', 'uz', 'bd', 'bb', 'no', 'bw', 'dk', 'do', 'mx', 'ug', 'zw', 'sr', 'me', 'id', 'ba', 'sy', 'tw', 'ae', 've', 'mq', 'gb', 'md', 'mk', 'tt', 'ru', 'cd', 'vg', 'tz');
--rollback UPDATE country SET IS_SMS_CAPABLE=0 WHERE COUNTRY_CODE IN ('us','bj', 'kh', 'sd', 'kz', 'py', 'bn', 'pt', 'ky', 'gr', 'lv', 'ma', 'ml', 'pa', 'iq', 'cl', 'ar', 'ua', 'bz', 'zm', 'bh', 'in', 'tr', 'be', 'na', 'fo', 'fi', 'za', 'bm', 'cf', 'ge', 'jm', 'pe', 'de', 'hk', 'mg', 'th', 'ly', 'se', 'mw', 'li', 'pl', 'bg', 'jo', 'kw', 'ng', 'tn', 'hr', 'lk', 'ke', 'ch', 'es', 'lb', 'az', 'cz', 'bf', 'il', 'au', 'tj', 'ee', 'mm', 'gi', 'cy', 'my', 'is', 'am', 'ga', 'at', 'mz', 'sv', 'lu', 'br', 'tc', 'dz', 'si', 'ls', 'co', 'hu', 'jp', 'by', 'al', 'nz', 'hn', 'it', 'sg', 'gf', 'eg', 'as', 'mt', 'sa', 'nl', 'pk', 'gm', 'cn', 'ie', 'qa', 'sk', 'fr', 'lt', 'rs', 'kg', 'ro', 'tg', 'ne', 'ph', 'rw', 'uz', 'bd', 'bb', 'no', 'bw', 'dk', 'do', 'mx', 'ug', 'zw', 'sr', 'me', 'id', 'ba', 'sy', 'tw', 'ae', 've', 'mq', 'gb', 'md', 'mk', 'tt', 'ru', 'cd', 'vg', 'tz');