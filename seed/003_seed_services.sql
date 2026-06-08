-- Seed services with 8 language translations

INSERT INTO services (name_en, name_bs, name_hr, name_me, name_de, name_fr, name_nl, name_pl, sort_order) VALUES
('Construction', 'Gradnja', 'Gradnja', 'Izgradnja', 'Konstruktion', 'Construction', 'Constructie', 'Budowa', 1),
('Repairs', 'Popravke', 'Popravke', 'Popravke', 'Reparaturen', 'Réparations', 'Reparaties', 'Naprawy', 2),
('Plumbing', 'Vodoinstalacije', 'Vodoinstalacije', 'Vodovodstvo', 'Sanitärinstallation', 'Plomberie', 'Loodgieterswerk', 'Hydraulika', 3),
('Electrical Work', 'Elektrikarski radovi', 'Elektrikarski radovi', 'Elektrotehnika', 'Elektroarbeiten', 'Travaux électriques', 'Elektriciteitswerk', 'Prace elektryczne', 4),
('Cleaning', 'Čišćenje', 'Čišćenje', 'Čišćenje', 'Reinigung', 'Nettoyage', 'Schoonmaak', 'Czyszczenie', 5),
('Painting', 'Slikanje', 'Slikanje', 'Šišanje', 'Malen', 'Peinture', 'Schilderwerk', 'Malowanie', 6),
('Carpentry', 'Tesarstvo', 'Tesarstvo', 'Tesarstvo', 'Schreinerei', 'Menuiserie', 'Timmerwerk', 'Stolarstwo', 7),
('Landscaping', 'Uređenje okoliša', 'Uređenje okoliša', 'Uređenje bašti', 'Landschaftsbau', 'Aménagement paysager', 'Tuinaanleg', 'Zagospodarowanie terenu', 8),
('HVAC Services', 'HVAC usluge', 'HVAC usluge', 'HVAC usluge', 'Heizungs- und Lüftungsarbeiten', 'Services CVC', 'HVAC-diensten', 'Uslugi grzewcze i wentylacyjne', 9),
('Moving Services', 'Službe premještanja', 'Službe premještanja', 'Usluge selidbe', 'Umzugsservices', 'Services de déménagement', 'Verhuisservices', 'Uslugi przeprowadzki', 10),
('Tutoring', 'Nauka', 'Podučavanje', 'Nastava', 'Nachhilfe', 'Tutorat', 'Bijles', 'Korepetycje', 11),
('Fitness Training', 'Trening u teretani', 'Treniranje fitnessa', 'Fitness trening', 'Fitnesstraining', 'Entraînement physique', 'Fitnesstraining', 'Trening fitnessu', 12),
('Photography', 'Fotografija', 'Fotografija', 'Fotografija', 'Fotografie', 'Photographie', 'Fotografie', 'Fotografia', 13),
('Videography', 'Videografija', 'Videografija', 'Videografija', 'Videografie', 'Vidéographie', 'Videografie', 'Wideografia', 14),
('Consulting', 'Konsultacije', 'Konzultacije', 'Konsultacije', 'Beratung', 'Conseil', 'Consultatie', 'Doradztwo', 15),
('Design Services', 'Usluge dizajna', 'Usluge dizajna', 'Usluge dizajna', 'Designservices', 'Services de conception', 'Ontwerpservices', 'Uslugi projektowania', 16),
('Translation', 'Prevod', 'Prijevod', 'Prijevod', 'Übersetzung', 'Traduction', 'Vertaling', 'Tlumaczenie', 17),
('Writing Services', 'Usluge pisanja', 'Usluge pisanja', 'Usluge pisanja', 'Schreibservices', 'Services de rédaction', 'Schrijfservices', 'Uslugi pisania', 18),
('Personal Assistant', 'Lični asistent', 'Osobni asistent', 'Lični asistent', 'Persönlicher Assistent', 'Assistant personnel', 'Persoonlijke assistent', 'Asystent personalny', 19);
