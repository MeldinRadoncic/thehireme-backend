-- Migration 008: Create video_promotions table

CREATE TABLE video_promotions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id        UUID NOT NULL REFERENCES worker_videos(id) ON DELETE CASCADE,
  worker_id       UUID NOT NULL REFERENCES workers(id),
  city_id         UUID NOT NULL REFERENCES cities(id),
  country_id      UUID NOT NULL REFERENCES countries(id),
  credits_charged SMALLINT NOT NULL CHECK (credits_charged IN (20, 40)),
  duration_days   SMALLINT NOT NULL CHECK (duration_days IN (7, 14)),
  starts_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at      TIMESTAMPTZ NOT NULL,
  status          promotion_status NOT NULL DEFAULT 'active',
  removed_at      TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_promotions_city_active ON video_promotions(city_id, expires_at DESC)
  WHERE status = 'active';
CREATE INDEX idx_promotions_worker ON video_promotions(worker_id, status);
CREATE INDEX idx_promotions_video ON video_promotions(video_id, status);
CREATE INDEX idx_promotions_expires ON video_promotions(expires_at) WHERE status = 'active';
