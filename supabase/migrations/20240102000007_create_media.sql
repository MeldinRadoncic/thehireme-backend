-- Migration 007: Create worker media tables (images, videos)

CREATE TABLE worker_images (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id       UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  storage_path    TEXT NOT NULL,
  url             TEXT NOT NULL,
  sort_order      SMALLINT NOT NULL DEFAULT 0,
  credits_charged SMALLINT NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ
);

CREATE INDEX idx_worker_images_worker ON worker_images(worker_id) WHERE deleted_at IS NULL;

-- Worker videos
CREATE TABLE worker_videos (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id        UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  service_id       UUID NOT NULL REFERENCES services(id),
  title            VARCHAR(255) NOT NULL,
  description      TEXT,
  storage_path     TEXT NOT NULL,
  url              TEXT NOT NULL,
  thumbnail_url    TEXT,
  duration_seconds SMALLINT NOT NULL CHECK (duration_seconds > 0 AND duration_seconds <= 30),
  credits_charged  SMALLINT NOT NULL DEFAULT 0,
  like_count       INT NOT NULL DEFAULT 0,
  view_count       INT NOT NULL DEFAULT 0,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at       TIMESTAMPTZ
);

CREATE INDEX idx_worker_videos_worker ON worker_videos(worker_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_worker_videos_service ON worker_videos(service_id) WHERE deleted_at IS NULL;
