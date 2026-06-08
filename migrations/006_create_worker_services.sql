-- Migration 006: Create worker services and availability tables

CREATE TABLE worker_services (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id      UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  service_id     UUID NOT NULL REFERENCES services(id),
  pricing_type   pricing_type NOT NULL,
  base_price     NUMERIC(10,2),
  currency_code  VARCHAR(3),
  experience_lvl experience_level NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(worker_id, service_id)
);

CREATE INDEX idx_worker_services_worker ON worker_services(worker_id);
CREATE INDEX idx_worker_services_service ON worker_services(service_id);

-- Per sub-service pricing
CREATE TABLE worker_sub_services (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_service_id UUID NOT NULL REFERENCES worker_services(id) ON DELETE CASCADE,
  sub_service_id    UUID NOT NULL REFERENCES sub_services(id),
  pricing_type      pricing_type NOT NULL,
  price             NUMERIC(10,2),
  currency_code     VARCHAR(3),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(worker_service_id, sub_service_id)
);

CREATE INDEX idx_worker_sub_services_service ON worker_sub_services(worker_service_id);

-- Worker availability
CREATE TABLE worker_availability (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id   UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  start_time  TIME NOT NULL,
  end_time    TIME NOT NULL CHECK (end_time > start_time),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_worker_availability_worker ON worker_availability(worker_id);
