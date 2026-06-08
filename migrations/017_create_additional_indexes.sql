-- Migration 017: Create additional performance indexes

-- Composite indexes for common queries
CREATE INDEX idx_workers_country_city_sort ON workers(country_id, city_id, is_active)
  WHERE is_active = true;

CREATE INDEX idx_video_promotions_active_city ON video_promotions(city_id, status, expires_at)
  WHERE status = 'active'::promotion_status;

-- Service filtering
CREATE INDEX idx_worker_services_service_worker ON worker_services(service_id, worker_id);

-- Engagement analytics
CREATE INDEX idx_worker_views_created ON worker_views(created_at DESC);
CREATE INDEX idx_video_watches_created ON video_watches(created_at DESC);

-- Admin queries
CREATE INDEX idx_reviews_created ON reviews(created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_worker_videos_created ON worker_videos(created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_payments_created ON payments(created_at DESC);
CREATE INDEX idx_credit_txn_created ON credit_transactions(created_at DESC);

-- Search/filter optimization
CREATE INDEX idx_workers_country_rating ON workers(country_id, avg_rating DESC)
  WHERE is_active = true;

CREATE INDEX idx_workers_city_balance ON workers(city_id, credit_balance DESC)
  WHERE is_active = true;

-- Activity tracking
CREATE INDEX idx_error_logs_app_device ON error_logs(app_type, device_type, created_at DESC);

-- Foreign key performance
CREATE INDEX idx_worker_videos_worker_created ON worker_videos(worker_id, created_at DESC);
CREATE INDEX idx_worker_images_worker_created ON worker_images(worker_id, created_at DESC);
