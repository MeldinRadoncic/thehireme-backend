# TheHireMe Database Migrations

## Overview

This directory contains all database migrations for TheHireMe platform. Migrations must be applied in sequential order (001, 002, 003, etc.). Each migration is a standalone SQL file that can be executed independently.

## Migration Order & Purpose

### 001_create_enums.sql
**Purpose:** Create all PostgreSQL enums used throughout the schema
**Contents:**
- `user_status` - user account status (active, suspended, banned, blocked)
- `admin_role` - admin role levels (super_admin, admin, member)
- `pricing_type` - pricing models (hourly, fixed, by_agreement)
- `experience_level` - worker experience tiers
- `credit_txn_type` - credit transaction types
- `payment_status` - payment processing status
- `promotion_status` - video promotion status
- `report_type` - abuse report types
- `report_status` - report resolution status
- `app_type` - application type (worker, client, admin)
- `device_type` - device type (ios, android, web)
- `discount_scope` - discount promotion scope

### 002_create_reference_tables.sql
**Purpose:** Create foundational reference tables (countries, cities, services)
**Contents:**
- `countries` - 14 supported European countries with 8-language translations
- `cities` - cities per country with 8-language translations and optional GPS
- `services` - service categories (Construction, Plumbing, etc.) with translations
- `sub_services` - detailed sub-categories under each service

### 003_create_admin_users.sql
**Purpose:** Create admin user management table
**Contents:**
- `admin_users` - admin dashboard users with role-based access (super_admin, admin, member)

### 004_create_users.sql
**Purpose:** Create base user identity table
**Contents:**
- `users` - core user record for all app users (workers and clients share this table)
- Supports status tracking (active, suspended, banned, blocked)
- Soft deletes for account deletion

### 005_create_workers.sql
**Purpose:** Create worker profile table
**Contents:**
- `workers` - worker-specific profile data (services, availability, location, etc.)
- Geo-restriction by country and city
- Denormalized counters (credits, ratings, views, likes)
- Credit economy fields

### 006_create_worker_services.sql
**Purpose:** Create worker service offerings and availability
**Contents:**
- `worker_services` - worker's selected services (up to 5) with pricing
- `worker_sub_services` - per-sub-service pricing overrides
- `worker_availability` - time windows when worker is available

### 007_create_media.sql
**Purpose:** Create worker media storage
**Contents:**
- `worker_images` - portfolio images (first 5 free, max 15 total)
- `worker_videos` - promotional videos (first 3 free, unlimited total, max 30 sec)

### 008_create_video_promotions.sql
**Purpose:** Create video promotion management
**Contents:**
- `video_promotions` - promotional video placements in client feed
- City-level scoping (clients see promotions only in their city)
- Automatic expiry tracking

### 009_create_clients.sql
**Purpose:** Create client profile table
**Contents:**
- `clients` - client-specific data (country, city, location)

### 010_create_reviews.sql
**Purpose:** Create review system
**Contents:**
- `reviews` - client reviews of workers (one per client per worker)
- Rating and text feedback
- Soft deletes for deleted reviews

### 011_create_engagement.sql
**Purpose:** Create engagement tracking (views and likes)
**Contents:**
- `video_watches` - tracks every video view/watch by registered clients (partitioned by month)
- `worker_views` - tracks every profile view by registered clients (partitioned by month)
- Automatic counter updates via triggers

### 012_create_credits_payments.sql
**Purpose:** Create credit and payment systems
**Contents:**
- `credit_packages` - purchasable credit packages (100, 300, 600, 1000)
- `credit_package_prices` - prices per package per country (in local currency)
- `credit_transactions` - immutable append-only ledger of all credit movements
- `payments` - Stripe payment records with webhook idempotency

### 013_create_promotions_reports.sql
**Purpose:** Create admin discount promotions and abuse reporting
**Contents:**
- `discount_promotions` - admin-created promotional campaigns
- `discount_promotion_packages` - which packages each promotion applies to
- `reports` - user-submitted abuse reports (user, review, or video)

### 014_create_error_logs.sql
**Purpose:** Create application error logging
**Contents:**
- `error_logs` - all application errors from worker/client/admin apps (partitioned by month)
- Includes app type, device type, error message, stack trace, and context

### 015_create_triggers.sql
**Purpose:** Create database triggers for maintaining denormalized counters
**Contents:**
- `update_worker_rating_on_review` - updates worker avg_rating and review_count
- `update_worker_credit_balance` - updates worker credit_balance from transactions
- `update_video_and_worker_likes` - increments video and worker like counts
- `update_worker_total_views` - increments worker view count
- `update_worker_image_count` - tracks image count and free image usage
- `update_worker_video_count` - tracks video count and free video usage
- `validate_max_worker_services` - enforces max 5 services per worker

### 016_add_rls_policies.sql
**Purpose:** Enable Row Level Security and create security policies
**Contents:**
- Enables RLS on all tables
- Implements geo-restriction (workers visible only in client's country)
- Implements city-level scoping for video promotions
- Enforces role-based access for admin functions
- Prevents users from accessing others' data

### 017_create_additional_indexes.sql
**Purpose:** Create performance-optimized indexes
**Contents:**
- Composite indexes for common queries
- Engagement analytics indexes
- Search/filter optimization
- Activity tracking indexes

## Seed Data (Apply After All Migrations)

After migrations, run these seed files in order:

1. **001_seed_countries.sql** - Populates 14 European countries with 8-language translations
2. **002_seed_cities.sql** - Populates major cities for each country with translations
3. **003_seed_services.sql** - Populates 20 service categories with translations
4. **004_seed_sub_services.sql** - Populates sub-services for major categories
5. **005_seed_credit_packages.sql** - Populates credit packages and country-specific prices

## Deployment Steps

### Local Development (Docker)

```bash
# 1. Navigate to backend directory
cd backend

# 2. Start Supabase (if not already running)
supabase start

# 3. Apply migrations via Supabase CLI
supabase db push

# 4. Seed data via Supabase Studio SQL Editor or CLI
# - Open http://127.0.0.1:54323 (Supabase Studio)
# - Go to SQL Editor
# - Run seed files in order: 001, 002, 003, 004, 005
```

### Production Deployment

```bash
# 1. Test all migrations locally first
# 2. Ensure all RLS policies are working correctly
# 3. Load test with k6 or Artillery (simulate 500+ concurrent users)
# 4. Deploy via Supabase CLI
supabase db push --linked

# 5. Verify schema with
supabase schema list
```

## Database Statistics

**Total Tables:** 18
**Enums:** 12
**Partitioned Tables:** 3 (video_watches, worker_views, error_logs)
**Total Indexes:** 40+
**RLS Enabled:** Yes on all tables

## Scalability Design

- **1M+ users** supported via indexing and partitioning strategy
- **Partitioned tables** (monthly) prevent monolithic growth
- **Denormalized counters** avoid expensive aggregates
- **RLS policies** filter at database level for geo-restriction
- **Connection pooling** via Supabase PgBouncer

## Important Notes

1. **Never modify migrations after they're deployed** - create new migrations instead
2. **Test RLS policies thoroughly** - they enforce security at database level
3. **Monitor trigger performance** - they maintain denormalized counters
4. **Partition management** - old partitions should be archived after 30 days
5. **Keep schema.md updated** - document all changes to the schema

## Troubleshooting

### Reset local database
```bash
supabase db reset
```

### View migration history
```bash
supabase db list
```

### Check RLS policies
```bash
SELECT * FROM pg_policies WHERE tablename = 'workers';
```

### View trigger definitions
```bash
SELECT routine_name FROM information_schema.routines WHERE routine_type='FUNCTION';
```
