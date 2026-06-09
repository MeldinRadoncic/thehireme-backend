-- Migration 002: Create reference tables (countries, cities, services, sub-services)

-- Countries table with 8 language columns (en, bs, hr, me, de, fr, nl, pl)
CREATE TABLE countries (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code          VARCHAR(2) UNIQUE NOT NULL,
  currency_code VARCHAR(3) NOT NULL,
  name_en       VARCHAR(100) NOT NULL,
  name_bs       VARCHAR(100),
  name_hr       VARCHAR(100),
  name_me       VARCHAR(100),
  name_de       VARCHAR(100),
  name_fr       VARCHAR(100),
  name_nl       VARCHAR(100),
  name_pl       VARCHAR(100),
  is_active     BOOLEAN NOT NULL DEFAULT true,
  sort_order    SMALLINT NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_countries_code ON countries(code);
CREATE INDEX idx_countries_active ON countries(is_active) WHERE is_active = true;

-- Cities table
CREATE TABLE cities (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id UUID NOT NULL REFERENCES countries(id) ON DELETE CASCADE,
  slug       VARCHAR(100) NOT NULL,
  name_en    VARCHAR(100) NOT NULL,
  name_bs    VARCHAR(100),
  name_hr    VARCHAR(100),
  name_me    VARCHAR(100),
  name_de    VARCHAR(100),
  name_fr    VARCHAR(100),
  name_nl    VARCHAR(100),
  name_pl    VARCHAR(100),
  lat        DECIMAL(9,6),
  lng        DECIMAL(9,6),
  is_active  BOOLEAN NOT NULL DEFAULT true,
  UNIQUE(country_id, slug)
);

CREATE INDEX idx_cities_country ON cities(country_id) WHERE is_active = true;

-- Services table
CREATE TABLE services (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  icon_name  VARCHAR(100),
  name_en    VARCHAR(100) NOT NULL,
  name_bs    VARCHAR(100),
  name_hr    VARCHAR(100),
  name_me    VARCHAR(100),
  name_de    VARCHAR(100),
  name_fr    VARCHAR(100),
  name_nl    VARCHAR(100),
  name_pl    VARCHAR(100),
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_active  BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_services_active ON services(is_active) WHERE is_active = true;

-- Sub-services table
CREATE TABLE sub_services (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  name_en    VARCHAR(100) NOT NULL,
  name_bs    VARCHAR(100),
  name_hr    VARCHAR(100),
  name_me    VARCHAR(100),
  name_de    VARCHAR(100),
  name_fr    VARCHAR(100),
  name_nl    VARCHAR(100),
  name_pl    VARCHAR(100),
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_active  BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sub_services_service ON sub_services(service_id) WHERE is_active = true;
