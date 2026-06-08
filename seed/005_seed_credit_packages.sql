-- Seed credit packages and prices

-- Credit packages (100, 300, 600, 1000)
INSERT INTO credit_packages (credits, sort_order) VALUES
(100, 1),
(300, 2),
(600, 3),
(1000, 4);

-- Prices per country
-- Balkans (using BAM for Bosnia, RSD for Serbia, EUR for Croatia/Montenegro/Kosovo, MKD for N.Macedonia)
INSERT INTO credit_package_prices (package_id, country_id, price, currency_code) VALUES
-- Bosnia and Herzegovina (BAM - approx 0.51 EUR = 1 BAM)
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'BA'), 5.10, 'BAM'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'BA'), 15.30, 'BAM'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'BA'), 30.60, 'BAM'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'BA'), 51.00, 'BAM'),

-- Serbia (RSD - approx 0.0085 EUR = 1 RSD)
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'SR'), 425, 'RSD'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'SR'), 1275, 'RSD'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'SR'), 2550, 'RSD'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'SR'), 4250, 'RSD'),

-- Croatia, Montenegro, Kosovo, North Macedonia (EUR)
-- 100 credits = €5, 300 credits = €15, 600 credits = €30, 1000 credits = €50
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'HR'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'HR'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'HR'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'HR'), 50.00, 'EUR'),

((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'ME'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'ME'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'ME'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'ME'), 50.00, 'EUR'),

((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'XK'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'XK'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'XK'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'XK'), 50.00, 'EUR'),

-- North Macedonia (MKD - approx 0.0163 EUR = 1 MKD)
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'MK'), 307, 'MKD'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'MK'), 921, 'MKD'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'MK'), 1842, 'MKD'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'MK'), 3070, 'MKD'),

-- Western/Central Europe (EUR and national currencies)
-- Germany, France, Netherlands, Austria, Czech Republic, Slovenia, Hungary
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'DE'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'DE'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'DE'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'DE'), 50.00, 'EUR'),

((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'FR'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'FR'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'FR'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'FR'), 50.00, 'EUR'),

((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'NL'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'NL'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'NL'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'NL'), 50.00, 'EUR'),

-- Poland (PLN - approx 0.25 EUR = 1 PLN)
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'PL'), 20, 'PLN'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'PL'), 60, 'PLN'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'PL'), 120, 'PLN'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'PL'), 200, 'PLN'),

((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'AT'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'AT'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'AT'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'AT'), 50.00, 'EUR'),

-- Czech Republic (CZK - approx 0.042 EUR = 1 CZK)
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'CZ'), 119, 'CZK'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'CZ'), 357, 'CZK'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'CZ'), 714, 'CZK'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'CZ'), 1190, 'CZK'),

((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'SI'), 5.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'SI'), 15.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'SI'), 30.00, 'EUR'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'SI'), 50.00, 'EUR'),

-- Hungary (HUF - approx 0.0027 EUR = 1 HUF)
((SELECT id FROM credit_packages WHERE credits = 100), (SELECT id FROM countries WHERE code = 'HU'), 1850, 'HUF'),
((SELECT id FROM credit_packages WHERE credits = 300), (SELECT id FROM countries WHERE code = 'HU'), 5550, 'HUF'),
((SELECT id FROM credit_packages WHERE credits = 600), (SELECT id FROM countries WHERE code = 'HU'), 11100, 'HUF'),
((SELECT id FROM credit_packages WHERE credits = 1000), (SELECT id FROM countries WHERE code = 'HU'), 18500, 'HUF');
