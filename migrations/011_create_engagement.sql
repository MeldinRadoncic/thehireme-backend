-- Migration 011: Create engagement tables (video_watches, worker_views)

CREATE TABLE video_watches (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id   UUID NOT NULL REFERENCES worker_videos(id) ON DELETE CASCADE,
  worker_id  UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  client_id  UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  watched_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (watched_at);

CREATE TABLE video_watches_2026_06 PARTITION OF video_watches
  FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');

CREATE INDEX idx_video_watches_video ON video_watches(video_id, watched_at DESC);
CREATE INDEX idx_video_watches_worker ON video_watches(worker_id, watched_at DESC);

-- Worker profile views
CREATE TABLE worker_views (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  viewed_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (viewed_at);

CREATE TABLE worker_views_2026_06 PARTITION OF worker_views
  FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');

CREATE INDEX idx_worker_views_worker ON worker_views(worker_id, viewed_at DESC);
CREATE INDEX idx_worker_views_client ON worker_views(client_id, viewed_at DESC);
