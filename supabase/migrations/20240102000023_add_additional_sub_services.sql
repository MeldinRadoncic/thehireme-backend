-- Migration 023: Add additional sub-services for complete coverage

-- Repairs sub-services
INSERT INTO sub_services (service_id, name_en, name_bs, name_hr, name_me, name_de, name_fr, name_nl, name_pl) VALUES
((SELECT id FROM services WHERE name_en = 'Repairs'), 'Appliance Repair', 'Popravka uređaja', 'Popravka uređaja', 'Popravka aparata', 'Gerätereparatur', 'Réparation d''appareils', 'Apparaatuurherstelling', 'Naprawa urządzeń'),
((SELECT id FROM services WHERE name_en = 'Repairs'), 'Furniture Repair', 'Popravka namještaja', 'Popravka namještaja', 'Popravka nameštaja', 'Möbelreparatur', 'Réparation de meubles', 'Meubelreparatie', 'Naprawa mebli'),
((SELECT id FROM services WHERE name_en = 'Repairs'), 'Door Repair', 'Popravka vrata', 'Popravka vrata', 'Popravka vrata', 'Türreparatur', 'Réparation de portes', 'Deurherstelling', 'Naprawa drzwi'),

-- Landscaping sub-services
((SELECT id FROM services WHERE name_en = 'Landscaping'), 'Lawn Maintenance', 'Održavanje travnjaka', 'Održavanje travnjaka', 'Održavanje bašte', 'Rasenpflege', 'Entretien de pelouse', 'Onderhoud grasmat', 'Pielęgnacja trawnika'),
((SELECT id FROM services WHERE name_en = 'Landscaping'), 'Garden Design', 'Dizajn vrta', 'Dizajn vrta', 'Dizajn vrta', 'Gartengestaltung', 'Conception de jardin', 'Tuinontwerp', 'Projektowanie ogrodu'),
((SELECT id FROM services WHERE name_en = 'Landscaping'), 'Tree Trimming', 'Rezanje grana', 'Piljenje grana', 'Rezanje grana', 'Baumschnitt', 'Élagage', 'Boomonderhoud', 'Przycinanie drzew'),

-- HVAC Services sub-services
((SELECT id FROM services WHERE name_en = 'HVAC Services'), 'Air Conditioning Installation', 'Instalacija klime', 'Instalacija klime', 'Instalacija klime', 'Klimaanlage Installation', 'Installation d''climatisation', 'Airconditioninginstallatie', 'Instalacja klimatyzacji'),
((SELECT id FROM services WHERE name_en = 'HVAC Services'), 'Heating System Repair', 'Popravka grijanja', 'Popravka grijanja', 'Popravka grijanja', 'Heizungssystemreparatur', 'Réparation système chauffage', 'Verwarmingssysteemreparatie', 'Naprawa systemu ogrzewania'),
((SELECT id FROM services WHERE name_en = 'HVAC Services'), 'Maintenance', 'Održavanje', 'Održavanje', 'Održavanje', 'Wartung', 'Maintenance', 'Onderhoud', 'Konserwacja'),

-- Moving Services sub-services
((SELECT id FROM services WHERE name_en = 'Moving Services'), 'Local Moving', 'Lokalni prevoz', 'Lokalni prijevoz', 'Lokalni prevoz', 'Lokales Umzugsunternehmen', 'Déménagement local', 'Lokale verhuizing', 'Lokalna przeprowadzka'),
((SELECT id FROM services WHERE name_en = 'Moving Services'), 'Long Distance Moving', 'Međugradski prevoz', 'Međugradski prijevoz', 'Međugradski prevoz', 'Fernumzug', 'Déménagement longue distance', 'Langeafstandsverhuizing', 'Przeprowadzka na dużą odległość'),
((SELECT id FROM services WHERE name_en = 'Moving Services'), 'Packing Service', 'Usluga pakovanja', 'Usluga pakovanja', 'Usluga pakovanja', 'Verpackungsservice', 'Service d''emballage', 'Verpakkingsservice', 'Usługa pakowania'),

-- Tutoring sub-services
((SELECT id FROM services WHERE name_en = 'Tutoring'), 'Math Tutoring', 'Nastava matematike', 'Poučavanje matematike', 'Nastava matematike', 'Mathematikunterricht', 'Cours de mathématiques', 'Wiskundeonderwijs', 'Korepetycje z matematyki'),
((SELECT id FROM services WHERE name_en = 'Tutoring'), 'Language Learning', 'Učenje jezika', 'Učenje jezika', 'Učenje jezika', 'Sprachenlernen', 'Apprentissage linguistique', 'Taalleren', 'Nauka języka'),
((SELECT id FROM services WHERE name_en = 'Tutoring'), 'Academic Support', 'Akademska podrška', 'Akademska podrška', 'Akademska podrška', 'Akademische Unterstützung', 'Support académique', 'Academische ondersteuning', 'Wsparcie akademickie'),

-- Fitness Training sub-services
((SELECT id FROM services WHERE name_en = 'Fitness Training'), 'Personal Training', 'Lični trening', 'Osobni trening', 'Lični trening', 'Personaltraining', 'Entraînement personnel', 'Persoonlijke training', 'Trening osobisty'),
((SELECT id FROM services WHERE name_en = 'Fitness Training'), 'Group Classes', 'Grupne klase', 'Grupne klase', 'Grupne klase', 'Gruppenunterricht', 'Cours en groupe', 'Groepsclasses', 'Zajęcia grupowe'),
((SELECT id FROM services WHERE name_en = 'Fitness Training'), 'Nutrition Coaching', 'Saveti o ishrani', 'Savjeti o prehrani', 'Saveti o ishrani', 'Ernährungsberatung', 'Coaching nutrition', 'Voedingscoaching', 'Coaching żywieniowy'),

-- Photography sub-services
((SELECT id FROM services WHERE name_en = 'Photography'), 'Portrait Photography', 'Portretna fotografija', 'Portretna fotografija', 'Portretna fotografija', 'Portraitfotografie', 'Photographie portrait', 'Portretfotografie', 'Fotografia portretowa'),
((SELECT id FROM services WHERE name_en = 'Photography'), 'Event Photography', 'Fotografisanje događaja', 'Fotografiranje događaja', 'Fotografisanje događaja', 'Eventfotografie', 'Photographie événementielle', 'Eventfotografie', 'Fotografia eventowa'),
((SELECT id FROM services WHERE name_en = 'Photography'), 'Product Photography', 'Fotografisanje proizvoda', 'Fotografiranje proizvoda', 'Fotografisanje proizvoda', 'Produktfotografie', 'Photographie de produits', 'Productfotografie', 'Fotografia produktów'),

-- Videography sub-services
((SELECT id FROM services WHERE name_en = 'Videography'), 'Event Videography', 'Snimanje događaja', 'Snimanje događaja', 'Snimanje događaja', 'Event-Videografie', 'Vidéographie d''événement', 'Eventvideografie', 'Wideografia eventowa'),
((SELECT id FROM services WHERE name_en = 'Videography'), 'Promotional Videos', 'Promocijski videi', 'Promocijski videi', 'Promocijski videi', 'Werbevideos', 'Vidéos promotionnels', 'Promotievideo''s', 'Filmy promocyjne'),
((SELECT id FROM services WHERE name_en = 'Videography'), 'Video Editing', 'Uređivanje videa', 'Uređivanje videa', 'Uređivanje videa', 'Videobearbeitung', 'Montage vidéo', 'Videobewerking', 'Edycja wideo'),

-- Consulting sub-services
((SELECT id FROM services WHERE name_en = 'Consulting'), 'Business Consulting', 'Poslovno savjetovanje', 'Poslovno savjetovanje', 'Poslovnog savetovanja', 'Unternehmensberatung', 'Conseil aux entreprises', 'Bedrijfsadvies', 'Konsultacje biznesowe'),
((SELECT id FROM services WHERE name_en = 'Consulting'), 'Marketing Consulting', 'Marketinško savjetovanje', 'Marketinško savjetovanje', 'Marketinskog savjetovanja', 'Marketingberatung', 'Conseil marketing', 'Marketingadvies', 'Doradztwo marketingowe'),
((SELECT id FROM services WHERE name_en = 'Consulting'), 'Financial Consulting', 'Finansijsko savjetovanje', 'Financijsko savjetovanje', 'Finansijskog savjetovanja', 'Finanzberatung', 'Conseil financier', 'Financieel advies', 'Doradztwo finansowe'),

-- Design Services sub-services
((SELECT id FROM services WHERE name_en = 'Design Services'), 'Graphic Design', 'Grafički dizajn', 'Grafički dizajn', 'Grafički dizajn', 'Grafikdesign', 'Design graphique', 'Grafisch ontwerp', 'Projektowanie graficzne'),
((SELECT id FROM services WHERE name_en = 'Design Services'), 'Interior Design', 'Dizajn interijera', 'Dizajn interijera', 'Dizajn interijera', 'Innenarchitektur', 'Design d''intérieur', 'Interieurontwerp', 'Projektowanie wnętrz'),
((SELECT id FROM services WHERE name_en = 'Design Services'), 'Web Design', 'Veb dizajn', 'Web dizajn', 'Veb dizajn', 'Webdesign', 'Design web', 'Webontwerp', 'Projektowanie stron internetowych'),

-- Translation sub-services
((SELECT id FROM services WHERE name_en = 'Translation'), 'Document Translation', 'Prevod dokumenata', 'Prevod dokumenata', 'Prevod dokumenata', 'Dokumentenübersetzung', 'Traduction de documents', 'Documentvertaling', 'Tłumaczenie dokumentów'),
((SELECT id FROM services WHERE name_en = 'Translation'), 'Interpretation', 'Interpretacija', 'Interpretacija', 'Interpretacija', 'Dolmetschen', 'Interprétation', 'Tolken', 'Interpretacja'),
((SELECT id FROM services WHERE name_en = 'Translation'), 'Localization', 'Lokalizacija', 'Lokalizacija', 'Lokalizacija', 'Lokalisierung', 'Localisation', 'Lokalisatie', 'Lokalizacja'),

-- Writing Services sub-services
((SELECT id FROM services WHERE name_en = 'Writing Services'), 'Content Writing', 'Pisanje sadržaja', 'Pisanje sadržaja', 'Pisanje sadržaja', 'Content Writing', 'Rédaction de contenu', 'Content writing', 'Pisanie zawartości'),
((SELECT id FROM services WHERE name_en = 'Writing Services'), 'Copywriting', 'Kopiranje', 'Kopiranje', 'Kopiranje', 'Copywriting', 'Rédaction publicitaire', 'Copywriting', 'Copywriting'),
((SELECT id FROM services WHERE name_en = 'Writing Services'), 'Proofreading', 'Lektura', 'Korektura', 'Lektura', 'Lektorat', 'Relecture', 'Proeflezen', 'Korekta'),

-- Personal Assistant sub-services
((SELECT id FROM services WHERE name_en = 'Personal Assistant'), 'Schedule Management', 'Upravljanje rasporedom', 'Upravljanje rasporedom', 'Upravljanje rasporedom', 'Terminplanung', 'Gestion d''agenda', 'Agendabeheer', 'Zarządzanie harmonogramem'),
((SELECT id FROM services WHERE name_en = 'Personal Assistant'), 'Email Management', 'Upravljanje e-mailom', 'Upravljanje e-mailom', 'Upravljanje e-mailom', 'E-Mail-Verwaltung', 'Gestion des e-mails', 'E-mailbeheer', 'Zarządzanie pocztą elektroniczną'),
((SELECT id FROM services WHERE name_en = 'Personal Assistant'), 'Travel Planning', 'Planiranje putovanja', 'Planiranje putovanja', 'Planiranje putovanja', 'Reiseplanung', 'Planification de voyage', 'Reisplanning', 'Planowanie podróży');
