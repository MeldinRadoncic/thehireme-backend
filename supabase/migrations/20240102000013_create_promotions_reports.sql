-- Migration 013: Create discount promotions and reports tables

CREATE TABLE discount_promotions (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                VARCHAR(255) NOT NULL,
  discount_percentage NUMERIC(5,2) NOT NULL CHECK (discount_percentage > 0 AND discount_percentage <= 100),
  starts_at           TIMESTAMPTZ NOT NULL,
  ends_at             TIMESTAMPTZ NOT NULL CHECK (ends_at > starts_at),
  scope               discount_scope NOT NULL DEFAULT 'all_packages',
  is_active           BOOLEAN NOT NULL DEFAULT true,
  created_by          UUID NOT NULL REFERENCES admin_users(id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_discount_active ON discount_promotions(starts_at, ends_at) WHERE is_active = true;

-- Which packages apply to discount
CREATE TABLE discount_promotion_packages (
  promotion_id UUID NOT NULL REFERENCES discount_promotions(id) ON DELETE CASCADE,
  package_id   UUID NOT NULL REFERENCES credit_packages(id),
  PRIMARY KEY(promotion_id, package_id)
);

-- Reports
CREATE TABLE reports (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id        UUID NOT NULL REFERENCES users(id),
  reported_user_id   UUID REFERENCES users(id),
  reported_review_id UUID REFERENCES reviews(id),
  reported_video_id  UUID REFERENCES worker_videos(id),
  report_type        report_type NOT NULL,
  reason             TEXT NOT NULL,
  status             report_status NOT NULL DEFAULT 'pending',
  admin_note         TEXT,
  resolved_by        UUID REFERENCES admin_users(id),
  resolved_at        TIMESTAMPTZ,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (reported_user_id IS NOT NULL OR reported_review_id IS NOT NULL OR reported_video_id IS NOT NULL)
);

CREATE INDEX idx_reports_pending ON reports(created_at DESC) WHERE status = 'pending';
CREATE INDEX idx_reports_reported_user ON reports(reported_user_id);
CREATE INDEX idx_reports_status ON reports(status, created_at DESC);
