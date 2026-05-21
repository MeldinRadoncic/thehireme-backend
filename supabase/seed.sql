-- Seed data for TheHireMe

-- Insert sample users
INSERT INTO public.users (email, user_type) VALUES
  ('client1@example.com', 'client'),
  ('client2@example.com', 'client'),
  ('worker1@example.com', 'worker'),
  ('worker2@example.com', 'worker')
ON CONFLICT (email) DO NOTHING;
