-- Seed sub-services for major service categories

-- Construction sub-services
INSERT INTO sub_services (service_id, name_en, name_bs, name_hr, name_me, name_de, name_fr, name_nl, name_pl) VALUES
((SELECT id FROM services WHERE name_en = 'Construction'), 'Home Building', 'Izgradnja kuće', 'Gradnja kuće', 'Izgradnja kuće', 'Hausbau', 'Construction de maison', 'Huisbouw', 'Budowa domu'),
((SELECT id FROM services WHERE name_en = 'Construction'), 'Room Addition', 'Dodatna soba', 'Dodavanje sobe', 'Dodavanje sobe', 'Zimmererweiterung', 'Extension de chambre', 'Kamer uitbreiding', 'Rozszerzenie pokoju'),
((SELECT id FROM services WHERE name_en = 'Construction'), 'Deck Building', 'Izgradnja terase', 'Gradnja terase', 'Izgradnja terase', 'Terrassenbau', 'Construction de terrasse', 'Terras bouwen', 'Budowa tarasu'),
((SELECT id FROM services WHERE name_en = 'Construction'), 'Bathroom Remodel', 'Preuređenje kupatila', 'Renoviranje kupaonice', 'Preuređenje kupatila', 'Badezimmerrenovierung', 'Rénovation de salle de bain', 'Badkamerrenovatie', 'Remont lazienki'),

-- Plumbing sub-services
((SELECT id FROM services WHERE name_en = 'Plumbing'), 'Pipe Installation', 'Instalacija cijevi', 'Instalacija cijevi', 'Instalacija cijevi', 'Rohrmontage', 'Installation de tuyauterie', 'Pijpinstallatie', 'Instalacja rur'),
((SELECT id FROM services WHERE name_en = 'Plumbing'), 'Leak Repair', 'Popravka procurjelih mjesta', 'Popravka curenja', 'Popravka procurivanja', 'Undichtheitsreparatur', 'Réparation de fuite', 'Lekreparatie', 'Naprawa wycieku'),
((SELECT id FROM services WHERE name_en = 'Plumbing'), 'Water Heater Installation', 'Instalacija bojlera', 'Instalacija bojlera', 'Instalacija bojlera', 'Wassererhitzerinstallation', 'Installation de chauffe-eau', 'Boiler installatie', 'Instalacja grzejnika wody'),

-- Electrical Work sub-services
((SELECT id FROM services WHERE name_en = 'Electrical Work'), 'Wiring Installation', 'Instalacija električne instalacije', 'Instalacija ožičenja', 'Instalacija razvodnih veza', 'Elektroleitungsinstallation', 'Installation de câblage', 'Bedrading installatie', 'Instalacja okablowania'),
((SELECT id FROM services WHERE name_en = 'Electrical Work'), 'Circuit Breaker Installation', 'Instalacija osigurača', 'Instalacija prekidača', 'Instalacija prekidača', 'Schaltschrankmontage', 'Installation de disjoncteur', 'Schakelkastinstallatie', 'Instalacja wyłącznika'),
((SELECT id FROM services WHERE name_en = 'Electrical Work'), 'Light Fixture Installation', 'Instalacija rasvjete', 'Instalacija armature', 'Instalacija svetiljki', 'Leuchteninstallation', 'Installation de luminaires', 'Lamp installatie', 'Instalacja oświetlenia'),

-- Cleaning sub-services
((SELECT id FROM services WHERE name_en = 'Cleaning'), 'House Cleaning', 'Čišćenje kuće', 'Čišćenje kuće', 'Čišćenje kuće', 'Hausreinigung', 'Nettoyage de maison', 'Huisschoonmaak', 'Czyszczenie domu'),
((SELECT id FROM services WHERE name_en = 'Cleaning'), 'Office Cleaning', 'Čišćenje ureda', 'Čišćenje ureda', 'Čišćenje kancelarije', 'Büroreinigung', 'Nettoyage de bureaux', 'Kantoor schoonmaak', 'Czyszczenie biura'),
((SELECT id FROM services WHERE name_en = 'Cleaning'), 'Window Cleaning', 'Čišćenje prozora', 'Čišćenje prozora', 'Čišćenje prozora', 'Fensterreinigung', 'Nettoyage de fenêtres', 'Raam schoonmaak', 'Czyszczenie okien'),
((SELECT id FROM services WHERE name_en = 'Cleaning'), 'Carpet Cleaning', 'Čišćenje tepiha', 'Čišćenje tepiha', 'Čišćenje tepiha', 'Teppichreinigung', 'Nettoyage de tapis', 'Tapijt schoonmaak', 'Czyszczenie dywanów'),

-- Painting sub-services
((SELECT id FROM services WHERE name_en = 'Painting'), 'Interior Painting', 'Unutarnje slikanje', 'Unutarnje slikanje', 'Unutarnje slikanje', 'Innenanstrich', 'Peinture intérieure', 'Binnenwerk schilderen', 'Malowanie wnętrz'),
((SELECT id FROM services WHERE name_en = 'Painting'), 'Exterior Painting', 'Vanjsko slikanje', 'Vanjsko slikanje', 'Vanjsko slikanje', 'Außenanstrich', 'Peinture extérieure', 'Buitenwerk schilderen', 'Malowanie elewacji'),
((SELECT id FROM services WHERE name_en = 'Painting'), 'Cabinet Painting', 'Slikanje ormara', 'Slikanje ormara', 'Slikanje ormara', 'Schrankbemalung', 'Peinture de meubles', 'Kast schilderen', 'Malowanie szafek'),

-- Carpentry sub-services
((SELECT id FROM services WHERE name_en = 'Carpentry'), 'Furniture Making', 'Izrada namještaja', 'Izrada namještaja', 'Izrada namještaja', 'Möbelherstellung', 'Fabrication de meubles', 'Meubelmakerij', 'Produkcja mebli'),
((SELECT id FROM services WHERE name_en = 'Carpentry'), 'Door Installation', 'Instalacija vrata', 'Instalacija vrata', 'Instalacija vrata', 'Türmontage', 'Installation de portes', 'Deurmontage', 'Instalacja drzwi'),
((SELECT id FROM services WHERE name_en = 'Carpentry'), 'Cabinet Installation', 'Instalacija ormara', 'Instalacija ormara', 'Instalacija ormara', 'Schrankinstallation', 'Installation d\'armoires', 'Kastinstallatie', 'Instalacja szafek');
