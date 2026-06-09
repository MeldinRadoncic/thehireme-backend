-- Migration 004: Create users table
-- Avatar URL is fetched directly from Clerk, not stored here

DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clerk_id          VARCHAR(255) UNIQUE NOT NULL,
  email             VARCHAR(255) UNIQUE NOT NULL,
  first_name        VARCHAR(100),
  last_name         VARCHAR(100),
  status            user_status NOT NULL DEFAULT 'active',
  status_reason     TEXT,
  status_changed_at TIMESTAMPTZ,
  status_changed_by UUID REFERENCES admin_users(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at        TIMESTAMPTZ
);

CREATE INDEX idx_users_clerk_id ON users(clerk_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status) WHERE status != 'active';
CREATE INDEX idx_users_deleted ON users(deleted_at) WHERE deleted_at IS NULL;
