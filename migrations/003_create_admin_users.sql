-- Migration 003: Create admin_users table

CREATE TABLE admin_users (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clerk_id   VARCHAR(255) UNIQUE NOT NULL,
  email      VARCHAR(255) UNIQUE NOT NULL,
  role       admin_role NOT NULL DEFAULT 'member',
  added_by   UUID REFERENCES admin_users(id),
  is_active  BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_admin_users_clerk_id ON admin_users(clerk_id);
CREATE INDEX idx_admin_users_email ON admin_users(email);
CREATE INDEX idx_admin_users_role ON admin_users(role);
