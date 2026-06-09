-- Migration 009: Create clients table

CREATE TABLE clients (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  country_id UUID REFERENCES countries(id),
  city_id    UUID REFERENCES cities(id),
  lat        DECIMAL(9,6),
  lng        DECIMAL(9,6),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_clients_user ON clients(user_id);
CREATE INDEX idx_clients_country ON clients(country_id);
CREATE INDEX idx_clients_city ON clients(city_id);
