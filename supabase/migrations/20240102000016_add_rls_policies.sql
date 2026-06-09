-- Migration 016: Enable RLS and create security policies

-- Enable RLS on all tables
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_sub_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_watches ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE credit_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Public reference tables (no RLS needed)
-- countries, cities, services, sub_services, credit_packages, etc. are public

-- Admin users - admin only
CREATE POLICY admin_users_admin_only ON admin_users
  FOR ALL USING (auth.uid()::text IN (SELECT clerk_id FROM admin_users));

-- Users - own record or admin
CREATE POLICY users_own_or_admin ON users
  FOR SELECT USING (auth.uid()::text = clerk_id OR auth.uid()::text IN (SELECT clerk_id FROM admin_users));

CREATE POLICY users_update_own ON users
  FOR UPDATE USING (auth.uid()::text = clerk_id);

-- Workers - geo-restriction (country filtering)
CREATE POLICY workers_select_same_country ON workers
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM clients
      WHERE clients.user_id = auth.uid()::uuid
        AND clients.country_id = workers.country_id
    )
    OR auth.uid()::text IN (SELECT clerk_id FROM admin_users)
  );

CREATE POLICY workers_update_own ON workers
  FOR UPDATE USING (user_id = auth.uid()::uuid);

-- Worker services - geo-restricted
CREATE POLICY worker_services_select_same_country ON worker_services
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM workers
      WHERE workers.id = worker_services.worker_id
        AND (
          EXISTS (
            SELECT 1 FROM clients
            WHERE clients.user_id = auth.uid()::uuid
              AND clients.country_id = workers.country_id
          )
          OR auth.uid()::text IN (SELECT clerk_id FROM admin_users)
        )
    )
  );

CREATE POLICY worker_services_update_own ON worker_services
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM workers
      WHERE workers.id = worker_services.worker_id
        AND workers.user_id = auth.uid()::uuid
    )
  );

-- Worker images
CREATE POLICY worker_images_select_visible ON worker_images
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM workers w
      WHERE w.id = worker_images.worker_id
        AND (
          EXISTS (
            SELECT 1 FROM clients c
            WHERE c.user_id = auth.uid()::uuid
              AND c.country_id = w.country_id
          )
          OR auth.uid()::text IN (SELECT clerk_id FROM admin_users)
        )
    )
  );

CREATE POLICY worker_images_update_own ON worker_images
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM workers
      WHERE workers.id = worker_images.worker_id
        AND workers.user_id = auth.uid()::uuid
    )
  );

-- Worker videos
CREATE POLICY worker_videos_select_all ON worker_videos
  FOR SELECT USING (deleted_at IS NULL OR auth.uid()::text IN (SELECT clerk_id FROM admin_users));

CREATE POLICY worker_videos_update_own ON worker_videos
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM workers
      WHERE workers.id = worker_videos.worker_id
        AND workers.user_id = auth.uid()::uuid
    )
  );

-- Video promotions (city-level)
CREATE POLICY video_promotions_select_active ON video_promotions
  FOR SELECT USING (
    status = 'active'::promotion_status
    AND (
      EXISTS (
        SELECT 1 FROM clients
        WHERE clients.user_id = auth.uid()::uuid
          AND clients.city_id = video_promotions.city_id
      )
      OR auth.uid()::text IN (SELECT clerk_id FROM admin_users)
    )
  );

-- Clients - own or admin
CREATE POLICY clients_select_own ON clients
  FOR SELECT USING (user_id = auth.uid()::uuid OR auth.uid()::text IN (SELECT clerk_id FROM admin_users));

CREATE POLICY clients_update_own ON clients
  FOR UPDATE USING (user_id = auth.uid()::uuid);

-- Reviews - public select, own update/delete
CREATE POLICY reviews_select_all ON reviews
  FOR SELECT USING (deleted_at IS NULL);

CREATE POLICY reviews_insert_own ON reviews
  FOR INSERT WITH CHECK (client_id = (SELECT id FROM clients WHERE user_id = auth.uid()::uuid));

CREATE POLICY reviews_update_own ON reviews
  FOR UPDATE USING (client_id = (SELECT id FROM clients WHERE user_id = auth.uid()::uuid));

CREATE POLICY reviews_delete_own ON reviews
  FOR DELETE USING (client_id = (SELECT id FROM clients WHERE user_id = auth.uid()::uuid));

-- Credit transactions - worker select, service role insert
CREATE POLICY credit_txn_worker_select ON credit_transactions
  FOR SELECT USING (worker_id = (SELECT id FROM workers WHERE user_id = auth.uid()::uuid));

-- Payments - worker select/insert, service role update
CREATE POLICY payments_worker_select ON payments
  FOR SELECT USING (worker_id = (SELECT id FROM workers WHERE user_id = auth.uid()::uuid));

CREATE POLICY payments_worker_insert ON payments
  FOR INSERT WITH CHECK (worker_id = (SELECT id FROM workers WHERE user_id = auth.uid()::uuid));

-- Error logs - all authenticated insert, admin select
CREATE POLICY error_logs_insert_all ON error_logs
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY error_logs_select_admin ON error_logs
  FOR SELECT USING (auth.uid()::text IN (SELECT clerk_id FROM admin_users));

-- Reports - authenticated insert, admin select/update
CREATE POLICY reports_insert_all ON reports
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY reports_select_admin ON reports
  FOR SELECT USING (auth.uid()::text IN (SELECT clerk_id FROM admin_users));

CREATE POLICY reports_update_admin ON reports
  FOR UPDATE USING (auth.uid()::text IN (SELECT clerk_id FROM admin_users));
