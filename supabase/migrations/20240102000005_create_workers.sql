-- Migration 005: Create workers table

CREATE TABLE workers (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  company_name          VARCHAR(255),
  phone                 VARCHAR(50),
  website               TEXT,
  facebook_url          TEXT,
  viber                 VARCHAR(50),
  whatsapp              VARCHAR(50),
  country_id            UUID NOT NULL REFERENCES countries(id),
  city_id               UUID NOT NULL REFERENCES cities(id),
  address               TEXT,
  zip_code              VARCHAR(20),
  lat                   DECIMAL(9,6),
  lng                   DECIMAL(9,6),
  biography             TEXT,
  credit_balance        INT NOT NULL DEFAULT 100 CHECK (credit_balance >= 0),
  total_views           INT NOT NULL DEFAULT 0,
  total_likes           INT NOT NULL DEFAULT 0,
  avg_rating            NUMERIC(3,2) NOT NULL DEFAULT 0.00,
  review_count          INT NOT NULL DEFAULT 0,
  image_count           SMALLINT NOT NULL DEFAULT 0,
  video_count           SMALLINT NOT NULL DEFAULT 0,
  free_images_used      SMALLINT NOT NULL DEFAULT 0,
  free_videos_used      SMALLINT NOT NULL DEFAULT 0,
  reviews_received_paid SMALLINT NOT NULL DEFAULT 0,
  first_five_star_paid  BOOLEAN NOT NULL DEFAULT false,
  onboarding_completed  BOOLEAN NOT NULL DEFAULT false,
  terms_accepted_at     TIMESTAMPTZ,
  is_active             BOOLEAN NOT NULL DEFAULT true,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_workers_country ON workers(country_id) WHERE is_active = true;
CREATE INDEX idx_workers_city ON workers(city_id) WHERE is_active = true;
CREATE INDEX idx_workers_list_sort ON workers(country_id, city_id, credit_balance DESC, avg_rating DESC)
  WHERE is_active = true;
CREATE INDEX idx_workers_active ON workers(is_active) WHERE is_active = true;
