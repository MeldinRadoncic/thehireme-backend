-- Migration 001: Create all enums for TheHireMe database

CREATE TYPE user_status AS ENUM ('active', 'suspended', 'banned', 'blocked');
CREATE TYPE admin_role AS ENUM ('super_admin', 'admin', 'member');
CREATE TYPE pricing_type AS ENUM ('hourly', 'fixed', 'by_agreement');
CREATE TYPE experience_level AS ENUM ('0_1', '2_5', '5_10', '10_20', '25_plus');
CREATE TYPE credit_txn_type AS ENUM (
  'signup_bonus',
  'review_earned',
  'five_star_earned',
  'image_upload',
  'video_upload',
  'video_promotion',
  'credit_purchase'
);
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE promotion_status AS ENUM ('active', 'expired', 'removed');
CREATE TYPE report_type AS ENUM ('user', 'review', 'video');
CREATE TYPE report_status AS ENUM ('pending', 'reviewed', 'resolved', 'dismissed');
CREATE TYPE app_type AS ENUM ('worker', 'client', 'admin');
CREATE TYPE device_type AS ENUM ('ios', 'android', 'web');
CREATE TYPE discount_scope AS ENUM ('all_packages', 'specific_packages');
