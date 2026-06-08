-- Seed countries with 8 language translations

INSERT INTO countries (code, currency_code, name_en, name_bs, name_hr, name_me, name_de, name_fr, name_nl, name_pl, sort_order) VALUES
-- Balkans
('BA', 'BAM', 'Bosnia and Herzegovina', 'Bosna i Hercegovina', 'Bosna i Hercegovina', 'Bosna i Hercegovina', 'Bosnien und Herzegowina', 'Bosnie-Herzégovine', 'Bosnië en Herzegovina', 'Bośnia i Hercegowina', 1),
('SR', 'RSD', 'Serbia', 'Srbija', 'Srbija', 'Srbija', 'Serbien', 'Serbie', 'Servië', 'Serbia', 2),
('HR', 'EUR', 'Croatia', 'Hrvatska', 'Hrvatska', 'Hrvatska', 'Kroatien', 'Croatie', 'Kroatië', 'Chorwacja', 3),
('ME', 'EUR', 'Montenegro', 'Crna Gora', 'Crna Gora', 'Crna Gora', 'Montenegro', 'Monténégro', 'Montenegro', 'Czarnogóra', 4),
('XK', 'EUR', 'Kosovo', 'Kosovo', 'Kosovo', 'Kosovo', 'Kosovo', 'Kosovo', 'Kosovo', 'Kosowo', 5),
('MK', 'MKD', 'North Macedonia', 'Sjeverjna Makedonija', 'Sjevernamakedonija', 'Severna Makedonija', 'Nordmazedonien', 'Macédoine du Nord', 'Noord-Macedonië', 'Północna Macedonia', 6),

-- Central/Western Europe
('DE', 'EUR', 'Germany', 'Njemačka', 'Njemačka', 'Njemačka', 'Deutschland', 'Allemagne', 'Duitsland', 'Niemcy', 7),
('FR', 'EUR', 'France', 'Francuska', 'Francuska', 'Francuska', 'Frankreich', 'France', 'Frankrijk', 'Francja', 8),
('NL', 'EUR', 'Netherlands', 'Nizozemska', 'Nizozemska', 'Holandija', 'Niederlande', 'Pays-Bas', 'Nederland', 'Holandia', 9),
('PL', 'PLN', 'Poland', 'Poljska', 'Poljska', 'Poljska', 'Polen', 'Pologne', 'Polen', 'Polska', 10),
('AT', 'EUR', 'Austria', 'Austrija', 'Austrija', 'Austrija', 'Österreich', 'Autriche', 'Oostenrijk', 'Austria', 11),
('CZ', 'CZK', 'Czech Republic', 'Češka Republika', 'Češka Republika', 'Češka Republika', 'Tschechien', 'République Tchèque', 'Tsjechië', 'Czechy', 12),
('SI', 'EUR', 'Slovenia', 'Slovenija', 'Slovenija', 'Slovenija', 'Slowenien', 'Slovénie', 'Slovenië', 'Słowenia', 13),
('HU', 'HUF', 'Hungary', 'Mađarska', 'Mađarska', 'Mađarska', 'Ungarn', 'Hongrie', 'Hongarije', 'Węgry', 14);

-- Insert is complete
