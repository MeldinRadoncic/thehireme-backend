-- Seed cities for each country (sample major cities)

INSERT INTO cities (country_id, slug, name_en, name_bs, name_hr, name_me, name_de, name_fr, name_nl, name_pl) VALUES
-- Bosnia and Herzegovina
((SELECT id FROM countries WHERE code = 'BA'), 'sarajevo', 'Sarajevo', 'Sarajevo', 'Sarajevo', 'Sarajevo', 'Sarajevo', 'Sarajevo', 'Sarajevo', 'Sarajewo'),
((SELECT id FROM countries WHERE code = 'BA'), 'banja-luka', 'Banja Luka', 'Banja Luka', 'Banja Luka', 'Banja Luka', 'Banja Luka', 'Banja Luka', 'Banja Luka', 'Banja Luka'),
((SELECT id FROM countries WHERE code = 'BA'), 'mostar', 'Mostar', 'Mostar', 'Mostar', 'Mostar', 'Mostar', 'Mostar', 'Mostar', 'Mostar'),

-- Serbia
((SELECT id FROM countries WHERE code = 'SR'), 'belgrade', 'Belgrade', 'Beograd', 'Beograd', 'Beograd', 'Belgrad', 'Belgrade', 'Belgrado', 'Belgrad'),
((SELECT id FROM countries WHERE code = 'SR'), 'novi-sad', 'Novi Sad', 'Novi Sad', 'Novi Sad', 'Novi Sad', 'Neusatz', 'Novi Sad', 'Novi Sad', 'Nowy Sad'),
((SELECT id FROM countries WHERE code = 'SR'), 'nis', 'Niš', 'Niš', 'Niš', 'Niš', 'Nisch', 'Niš', 'Niš', 'Niš'),

-- Croatia
((SELECT id FROM countries WHERE code = 'HR'), 'zagreb', 'Zagreb', 'Zagreb', 'Zagreb', 'Zagreb', 'Zagreb', 'Zagreb', 'Zagreb', 'Zagreb'),
((SELECT id FROM countries WHERE code = 'HR'), 'split', 'Split', 'Split', 'Split', 'Split', 'Split', 'Split', 'Split', 'Split'),
((SELECT id FROM countries WHERE code = 'HR'), 'rijeka', 'Rijeka', 'Rijeka', 'Rijeka', 'Rijeka', 'Fiume', 'Rijeka', 'Rijeka', 'Rijeka'),

-- Montenegro
((SELECT id FROM countries WHERE code = 'ME'), 'podgorica', 'Podgorica', 'Podgorica', 'Podgorica', 'Podgorica', 'Podgorica', 'Podgorica', 'Podgorica', 'Podgorica'),
((SELECT id FROM countries WHERE code = 'ME'), 'kotor', 'Kotor', 'Kotor', 'Kotor', 'Kotor', 'Kotor', 'Kotor', 'Kotor', 'Kotor'),

-- Kosovo
((SELECT id FROM countries WHERE code = 'XK'), 'pristina', 'Pristina', 'Priština', 'Priština', 'Priština', 'Pristina', 'Pristina', 'Pristina', 'Pristina'),

-- North Macedonia
((SELECT id FROM countries WHERE code = 'MK'), 'skopje', 'Skopje', 'Skopje', 'Skopje', 'Skopje', 'Skopje', 'Skopje', 'Skopje', 'Skopje'),

-- Germany
((SELECT id FROM countries WHERE code = 'DE'), 'berlin', 'Berlin', 'Berlin', 'Berlin', 'Berlin', 'Berlin', 'Berlin', 'Berlijn', 'Berlin'),
((SELECT id FROM countries WHERE code = 'DE'), 'munich', 'Munich', 'Müchen', 'München', 'München', 'München', 'Munich', 'München', 'Monachium'),
((SELECT id FROM countries WHERE code = 'DE'), 'hamburg', 'Hamburg', 'Hamburg', 'Hamburg', 'Hamburg', 'Hamburg', 'Hamburg', 'Hamburg', 'Hamburg'),
((SELECT id FROM countries WHERE code = 'DE'), 'cologne', 'Cologne', 'Köln', 'Köln', 'Köln', 'Köln', 'Cologne', 'Keulen', 'Kolonia'),

-- France
((SELECT id FROM countries WHERE code = 'FR'), 'paris', 'Paris', 'Pariz', 'Pariz', 'Pariz', 'Paris', 'Paris', 'Parijs', 'Paryż'),
((SELECT id FROM countries WHERE code = 'FR'), 'lyon', 'Lyon', 'Lyon', 'Lyon', 'Lyon', 'Lyon', 'Lyon', 'Lyon', 'Lyon'),
((SELECT id FROM countries WHERE code = 'FR'), 'marseille', 'Marseille', 'Marselj', 'Marselj', 'Marselj', 'Marseille', 'Marseille', 'Marseille', 'Marsylia'),

-- Netherlands
((SELECT id FROM countries WHERE code = 'NL'), 'amsterdam', 'Amsterdam', 'Amsterdam', 'Amsterdam', 'Amsterdam', 'Amsterdam', 'Amsterdam', 'Amsterdam', 'Amsterdam'),
((SELECT id FROM countries WHERE code = 'NL'), 'rotterdam', 'Rotterdam', 'Rotterdam', 'Rotterdam', 'Rotterdam', 'Rotterdam', 'Rotterdam', 'Rotterdam', 'Rotterdam'),
((SELECT id FROM countries WHERE code = 'NL'), 'the-hague', 'The Hague', 'Den Haag', 'Den Haag', 'Den Haag', 'Den Haag', 'The Hague', 'Den Haag', 'Haag'),

-- Poland
((SELECT id FROM countries WHERE code = 'PL'), 'warsaw', 'Warsaw', 'Varšava', 'Varšava', 'Varšava', 'Warschau', 'Varsovie', 'Warschau', 'Warszawa'),
((SELECT id FROM countries WHERE code = 'PL'), 'krakow', 'Kraków', 'Kraków', 'Kraków', 'Kraków', 'Krakau', 'Cracovie', 'Krakau', 'Kraków'),
((SELECT id FROM countries WHERE code = 'PL'), 'wroclaw', 'Wrocław', 'Wrocław', 'Wrocław', 'Wrocław', 'Breslau', 'Wrocław', 'Wrocław', 'Wrocław'),

-- Austria
((SELECT id FROM countries WHERE code = 'AT'), 'vienna', 'Vienna', 'Bečnjača', 'Beč', 'Beč', 'Wien', 'Vienne', 'Wenen', 'Wiedeń'),
((SELECT id FROM countries WHERE code = 'AT'), 'salzburg', 'Salzburg', 'Salzburg', 'Salzburg', 'Salzburg', 'Salzburg', 'Salzburg', 'Salzburg', 'Salzburg'),

-- Czech Republic
((SELECT id FROM countries WHERE code = 'CZ'), 'prague', 'Prague', 'Prag', 'Prag', 'Prag', 'Prag', 'Prague', 'Praag', 'Praga'),
((SELECT id FROM countries WHERE code = 'CZ'), 'brno', 'Brno', 'Brno', 'Brno', 'Brno', 'Brünn', 'Brno', 'Brno', 'Brno'),

-- Slovenia
((SELECT id FROM countries WHERE code = 'SI'), 'ljubljana', 'Ljubljana', 'Ljubljana', 'Ljubljana', 'Ljubljana', 'Ljubljana', 'Ljubljana', 'Ljubljana', 'Lublana'),

-- Hungary
((SELECT id FROM countries WHERE code = 'HU'), 'budapest', 'Budapest', 'Budimpešta', 'Budimpešta', 'Budimpešta', 'Budapest', 'Budapest', 'Boedapest', 'Budapeszt');
