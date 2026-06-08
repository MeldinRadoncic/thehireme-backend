-- Migration 014: Create error_logs table (partitioned by month)

CREATE TABLE error_logs (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            UUID REFERENCES users(id) ON DELETE SET NULL,
  clerk_id           VARCHAR(255),
  app_type           app_type NOT NULL,
  device_type        device_type NOT NULL,
  error_message      TEXT NOT NULL,
  stack_trace        TEXT,
  additional_context JSONB,
  is_resolved        BOOLEAN NOT NULL DEFAULT false,
  resolved_by        UUID REFERENCES admin_users(id),
  resolved_at        TIMESTAMPTZ,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (created_at);

CREATE TABLE error_logs_2026_06 PARTITION OF error_logs
  FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');

CREATE TABLE error_logs_2026_07 PARTITION OF error_logs
  FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');

CREATE INDEX idx_error_logs_recent ON error_logs(created_at DESC);
CREATE INDEX idx_error_logs_unresolved ON error_logs(created_at DESC) WHERE is_resolved = false;
CREATE INDEX idx_error_logs_user ON error_logs(user_id, created_at DESC) WHERE user_id IS NOT NULL;
