# TheHireMe Database Schema

**Last Updated:** June 6, 2026  
**Status:** Complete - 18 Tables, 12 Enums, Production Ready  
**Scalability:** Designed for 1M+ users

---

## Table of Contents

1. [Enums](#enums)
2. [Reference Tables](#reference-tables)
3. [User & Identity](#user--identity)
4. [Worker Profile](#worker-profile)
5. [Client Profile](#client-profile)
6. [Services](#services)
7. [Media & Content](#media--content)
8. [Engagement & Interactions](#engagement--interactions)
9. [Credits & Payments](#credits--payments)
10. [Admin & Moderation](#admin--moderation)
11. [Triggers & Indexes](#triggers--indexes)
12. [RLS Policies](#rls-policies)

---

## Enums

### user_status
```sql
ENUM ('active', 'suspended', 'banned', 'blocked')
```
Account status of any user. Set by admins during moderation.

### admin_role
```sql
ENUM ('super_admin', 'admin', 'member')
```
Role-based access control for admin dashboard.

### pricing_type
```sql
ENUM ('hourly', 'fixed', 'by_agreement')
```
How a service is priced.

### experience_level
```sql
ENUM ('0_1', '2_5', '5_10', '10_20', '25_plus')
```
Years of experience for each service (0-1, 2-5, 5-10, 10-20, 25+).

### credit_txn_type
```sql
ENUM (
  'signup_bonus',      -- +100
  'review_earned',     -- +12 per review (first 5)
  'five_star_earned',  -- +40 (first 5-star)
  'image_upload',      -- -10 after 5 free
  'video_upload',      -- -20 after 3 free
  'video_promotion',   -- -20 or -40
  'credit_purchase'    -- +N from Stripe
)
```
Type of credit transaction.

### payment_status
```sql
ENUM ('pending', 'completed', 'failed', 'refunded')
```
Status of a Stripe payment.

### promotion_status
```sql
ENUM ('active', 'expired', 'removed')
```
Status of a video promotion.

### report_type
```sql
ENUM ('user', 'review', 'video')
```
What is being reported.

### report_status
```sql
ENUM ('pending', 'reviewed', 'resolved', 'dismissed')
```
Report resolution status.

### app_type
```sql
ENUM ('worker', 'client', 'admin')
```
Which app generated an error log.

### device_type
```sql
ENUM ('ios', 'android', 'web')
```
Device that generated an error log.

### discount_scope
```sql
ENUM ('all_packages', 'specific_packages')
```
Scope of a discount promotion.

---

## Reference Tables

### countries
Stores 14 supported European countries with 8-language translations.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | Primary key |
| code | VARCHAR(2) | UNIQUE NOT NULL | ISO 3166-1 alpha-2 (DE, BA, HR, etc.) |
| currency_code | VARCHAR(3) | NOT NULL | ISO 4217 (EUR, BAM, RSD, etc.) |
| name_en | VARCHAR(100) | NOT NULL | English name |
| name_bs | VARCHAR(100) | | Bosnian name |
| name_hr | VARCHAR(100) | | Croatian name |
| name_me | VARCHAR(100) | | Montenegrin name |
| name_de | VARCHAR(100) | | German name |
| name_fr | VARCHAR(100) | | French name |
| name_nl | VARCHAR(100) | | Dutch name |
| name_pl | VARCHAR(100) | | Polish name |
| is_active | BOOLEAN | NOT NULL DEFAULT true | Enable/disable country |
| sort_order | SMALLINT | NOT NULL DEFAULT 0 | Display order |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | Creation timestamp |

**Indexes:**
- `idx_countries_code` - (code) - for lookups by country code
- `idx_countries_active` - (is_active) WHERE is_active = true

**Supported Countries:** Bosnia, Serbia, Croatia, Montenegro, Kosovo, North Macedonia, Germany, France, Netherlands, Poland, Austria, Czech Republic, Slovenia, Hungary

---

### cities
Cities in each country with optional GPS coordinates.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| country_id | UUID | FK → countries(id) | |
| slug | VARCHAR(100) | NOT NULL | URL-friendly identifier |
| name_en | VARCHAR(100) | NOT NULL | |
| name_bs | VARCHAR(100) | | |
| name_hr | VARCHAR(100) | | |
| name_me | VARCHAR(100) | | |
| name_de | VARCHAR(100) | | |
| name_fr | VARCHAR(100) | | |
| name_nl | VARCHAR(100) | | |
| name_pl | VARCHAR(100) | | |
| lat | DECIMAL(9,6) | | Optional GPS latitude |
| lng | DECIMAL(9,6) | | Optional GPS longitude |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| | | UNIQUE(country_id, slug) | One slug per country |

---

### services
Service categories (Construction, Plumbing, Cleaning, etc.).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| icon_name | VARCHAR(100) | | Icon name from icon library (e.g., 'construction', 'wrench') |
| name_en | VARCHAR(100) | NOT NULL | |
| name_bs | VARCHAR(100) | | |
| name_hr | VARCHAR(100) | | |
| name_me | VARCHAR(100) | | |
| name_de | VARCHAR(100) | | |
| name_fr | VARCHAR(100) | | |
| name_nl | VARCHAR(100) | | |
| name_pl | VARCHAR(100) | | |
| sort_order | SMALLINT | NOT NULL DEFAULT 0 | |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**Total Services:** 20+ (Construction, Plumbing, Electrical, Cleaning, Painting, etc.)

**Icons:** Use icon name from chosen library (Material Icons, Feather, etc.) - not full URL

---

### sub_services
Detailed sub-categories under each service.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| service_id | UUID | FK → services(id) ON DELETE CASCADE | Parent service |
| name_en | VARCHAR(100) | NOT NULL | |
| name_bs | VARCHAR(100) | | |
| ... (6 more language columns) | | | |
| sort_order | SMALLINT | NOT NULL DEFAULT 0 | |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**Example Sub-services:**
- Construction → Home Building, Room Addition, Deck Building, Bathroom Remodel
- Plumbing → Pipe Installation, Leak Repair, Water Heater Installation
- Electrical → Wiring Installation, Circuit Breaker, Light Fixtures

---

## User & Identity

### Entity-Role Design Pattern

This section uses an **Entity-Role** database design pattern. Here's how it works:

**USERS** = Central identity entity (the person)
**WORKERS** = Role: User as service provider
**CLIENTS** = Role: User as service consumer

A single person (one Clerk account) can have:
- 1 USERS record (always) ← core identity
- 1 WORKERS record (optional) ← if they registered as a worker
- 1 CLIENTS record (optional) ← if they registered as a client
- Both WORKERS + CLIENTS records (optional) ← if they are both

**Example Flow:**
```
1. Ahmed browses app freely → Not in any table

2. Ahmed registers as CLIENT
   → INSERT into USERS (clerk_id, email, name, status='active')
   → INSERT into CLIENTS (clerk_id, country_id, city_id)
   → Ahmed now has: 1 USERS record + 1 CLIENTS record

3. Ahmed later registers as WORKER
   → INSERT into WORKERS (clerk_id, company_name, credits=100, ...)
   → Ahmed now has: 1 USERS record + 1 CLIENTS record + 1 WORKERS record
   → All linked by same clerk_id

4. Ahmed updates his name
   → UPDATE users SET first_name='Ahmad' WHERE clerk_id=xxx
   → Change is atomic, affects worker + client automatically
   → No inconsistency possible
```

**Why this design:**
- ✅ Single source of truth for identity (USERS)
- ✅ Atomic operations (one update = consistent everywhere)
- ✅ Future-proof (add new roles without duplicating identity fields)
- ✅ Scalable (no data duplication, consistency issues)
- ✅ Compliance-friendly (one place to handle GDPR deletion)

---

### admin_users
Admin dashboard users with role-based access.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| clerk_id | VARCHAR(255) | UNIQUE NOT NULL | Clerk auth ID |
| email | VARCHAR(255) | UNIQUE NOT NULL | |
| role | admin_role | NOT NULL DEFAULT 'member' | super_admin, admin, or member |
| added_by | UUID | FK → admin_users(id) | Who added this admin (NULL for first super_admin) |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

---

### users

**Central Identity Table - The Entity**

This table represents the **person/account** in the system. It's the single source of truth for:
- Who the user is (clerk_id links to Clerk authentication)
- Contact info (email, name)
- Account status (active, suspended, banned, blocked)

**KEY POINT:** Every user in the system has EXACTLY ONE USERS record.

**How it relates to WORKERS and CLIENTS:**
- A USERS record stands alone when user just browses (no login)
- When user registers as WORKER → creates WORKERS record with FK to this USERS
- When user registers as CLIENT → creates CLIENTS record with FK to this USERS
- WORKERS and CLIENTS both reference this USERS record via clerk_id

**Why USERS is separate (not merged with WORKERS/CLIENTS):**
1. **Single source of truth** - One place to update email, name, status
2. **Consistency** - If user is suspended here, they're suspended everywhere
3. **No duplication** - Email/name stored once, not duplicated in WORKERS + CLIENTS
4. **Future roles** - Add VENDORS, MODERATORS, ADMINS without duplicating identity
5. **Atomic operations** - Status change affects worker and client simultaneously
6. **Compliance** - GDPR deletion deletes one record, cascade handles rest

**Avatar:** Fetched directly from Clerk, NOT stored here (Clerk is source of truth for profile photos)

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| clerk_id | VARCHAR(255) | UNIQUE NOT NULL | Clerk authentication ID |
| email | VARCHAR(255) | UNIQUE NOT NULL | |
| first_name | VARCHAR(100) | | |
| last_name | VARCHAR(100) | | |
| status | user_status | NOT NULL DEFAULT 'active' | active, suspended, banned, blocked |
| status_reason | TEXT | | Admin note on status change |
| status_changed_at | TIMESTAMPTZ | | When status changed |
| status_changed_by | UUID | FK → admin_users(id) | Which admin changed status |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| deleted_at | TIMESTAMPTZ | | Soft delete (account deletion) |

**Indexes:**
- `idx_users_clerk_id` - (clerk_id)
- `idx_users_email` - (email)
- `idx_users_status` - (status) WHERE status != 'active'
- `idx_users_deleted` - (deleted_at) WHERE deleted_at IS NULL

---

## Worker Profile

### workers

**Worker Role Table - Service Provider Profile**

This table represents a user's **WORKER role** (service provider). It contains ALL worker-specific data.

**How it works:**
- User registers as WORKER → One row created in this table
- This row is linked to USERS table via user_id (Foreign Key)
- If same person is also a CLIENT → They have 1 USERS record + 1 WORKERS record + 1 CLIENTS record

**What this table stores:**
- ✅ Worker business info (company_name, phone, website, social media)
- ✅ Location (country_id, city_id, address, ZIP) - GEO-RESTRICTION
- ✅ Optional GPS (lat, lng) - if worker grants location permission
- ✅ Credits economy (credit_balance) - AUTHORITATIVE source of worker's credits
- ✅ Cached counters (avg_rating, review_count, total_views, total_likes) - updated by triggers
- ✅ Account status (onboarding_completed, is_active, terms_accepted_at)
- ✅ Free resource tracking (free_images_used, free_videos_used) - tracks 5 free images, 3 free videos

**Critical Fields:**
- `user_id (FK to USERS)` - Links to the person's core identity
- `credit_balance` - Is AUTHORITATIVE (source of truth). Updated by trigger on CREDIT_TRANSACTIONS
- `country_id` - Enforces GEO-RESTRICTION (clients only see workers from their country)
- Cached fields (avg_rating, review_count, total_views, etc.) - Updated by triggers, never manually set

**Important:** Never update cached fields manually. They're maintained by database triggers on:
- reviews INSERT/UPDATE/DELETE → updates avg_rating, review_count
- video_watches INSERT → updates total_likes, like_count on videos
- worker_views INSERT → updates total_views
- credit_transactions INSERT → updates credit_balance
- worker_images/videos INSERT → updates image_count, video_count

| Column | Type | Constraints | Notes |

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| user_id | UUID | UNIQUE FK → users(id) | Exactly one worker per user |
| company_name | VARCHAR(255) | | Business name |
| phone | VARCHAR(50) | | Contact phone |
| website | TEXT | | Business website |
| facebook_url | TEXT | | Social media |
| viber | VARCHAR(50) | | Viber contact |
| whatsapp | VARCHAR(50) | | WhatsApp contact |
| country_id | UUID | NOT NULL FK → countries(id) | Geo-restriction |
| city_id | UUID | NOT NULL FK → cities(id) | City-level visibility |
| address | TEXT | | Street address |
| zip_code | VARCHAR(20) | | Postal code |
| lat | DECIMAL(9,6) | | Optional GPS latitude |
| lng | DECIMAL(9,6) | | Optional GPS longitude |
| biography | TEXT | | Worker bio/description |
| credit_balance | INT | NOT NULL DEFAULT 100, CHECK >= 0 | Current credits (authoritative) |
| total_views | INT | NOT NULL DEFAULT 0 | Total profile views |
| total_likes | INT | NOT NULL DEFAULT 0 | Total video watches |
| avg_rating | NUMERIC(3,2) | NOT NULL DEFAULT 0.00 | Average review rating |
| review_count | INT | NOT NULL DEFAULT 0 | Number of reviews |
| image_count | SMALLINT | NOT NULL DEFAULT 0 | Portfolio images (max 15) |
| video_count | SMALLINT | NOT NULL DEFAULT 0 | Portfolio videos (unlimited) |
| free_images_used | SMALLINT | NOT NULL DEFAULT 0 | Tracks free usage (max 5) |
| free_videos_used | SMALLINT | NOT NULL DEFAULT 0 | Tracks free usage (max 3) |
| reviews_received_paid | SMALLINT | NOT NULL DEFAULT 0 | Reviews that earned credits (max 5) |
| first_five_star_paid | BOOLEAN | NOT NULL DEFAULT false | Earned bonus for first 5-star |
| onboarding_completed | BOOLEAN | NOT NULL DEFAULT false | |
| terms_accepted_at | TIMESTAMPTZ | | When terms accepted |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**Indexes:**
- `idx_workers_country` - (country_id) WHERE is_active = true
- `idx_workers_city` - (city_id) WHERE is_active = true
- `idx_workers_list_sort` - (country_id, city_id, credit_balance DESC, avg_rating DESC) WHERE is_active = true
- `idx_workers_country_rating` - (country_id, avg_rating DESC) WHERE is_active = true
- `idx_workers_city_balance` - (city_id, credit_balance DESC) WHERE is_active = true

---

### worker_services
Services a worker offers (up to 5 per worker).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| service_id | UUID | NOT NULL FK → services(id) | |
| pricing_type | pricing_type | NOT NULL | hourly, fixed, by_agreement |
| base_price | NUMERIC(10,2) | | NULL if by_agreement |
| currency_code | VARCHAR(3) | | From country |
| experience_lvl | experience_level | NOT NULL | Years of experience |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| | | UNIQUE(worker_id, service_id) | One per service |

**Max 5 per worker** - enforced by trigger.

---

### worker_sub_services
Per-sub-service pricing overrides.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_service_id | UUID | NOT NULL FK → worker_services(id) | Parent service |
| sub_service_id | UUID | NOT NULL FK → sub_services(id) | Specific sub-service |
| pricing_type | pricing_type | NOT NULL | May differ from service |
| price | NUMERIC(10,2) | | Override base price |
| currency_code | VARCHAR(3) | | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| | | UNIQUE(worker_service_id, sub_service_id) | One per sub-service |

---

### worker_availability
Time windows when worker is available.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| day_of_week | SMALLINT | NOT NULL CHECK 0-6 | 0=Sunday, 1=Monday, etc. |
| start_time | TIME | NOT NULL | 08:00 |
| end_time | TIME | NOT NULL, > start_time | 17:00 |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**Example:** Monday 08:00-17:00, Saturday 09:00-13:00

---

## Client Profile

### clients

**Client Role Table - Service Consumer Profile**

This table represents a user's **CLIENT role** (service consumer/browser). It contains ALL client-specific data.

**How it works:**
- User registers as CLIENT → One row created in this table
- This row is linked to USERS table via user_id (Foreign Key)
- If same person is also a WORKER → They have 1 USERS record + 1 WORKERS record + 1 CLIENTS record
- User can browse freely WITHOUT being in this table (anonymous browsing)

**What this table stores:**
- ✅ Location (country_id, city_id) - Used for GEO-RESTRICTION (clients only see workers from their country)
- ✅ Optional GPS (lat, lng) - if client grants location permission for distance-based search
- ✅ Current location state (what country/city client is browsing in)

**Current state (minimal):**
Currently stores only location data. But this table exists for future expansion:
- Saved workers (favorites list)
- Search preferences
- Budget range
- Notification settings
- Review drafts
- Booking history

**GEO-RESTRICTION in action:**
```
1. Client registers in Germany
   → INSERT into CLIENTS (user_id, country_id=germany, city_id=berlin)

2. Client browses workers
   → RLS Policy filters: SELECT * FROM workers 
     WHERE country_id = clients.country_id (Germany only)
   → Client ONLY sees workers from Germany

3. Client from France tries to view German worker profile
   → RLS Policy blocks: 403 Forbidden
   → No cross-country worker visibility
```

**Why separate from WORKERS:**
- Workers don't need client-specific fields (saved workers, search prefs)
- Clients don't need worker-specific fields (company_name, credits, services)
- Clean separation of concerns
- Easier to add client-only features later

| Column | Type | Constraints | Notes |

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| user_id | UUID | UNIQUE FK → users(id) | Exactly one client per user |
| country_id | UUID | FK → countries(id) | Can be NULL initially |
| city_id | UUID | FK → cities(id) | Can be NULL initially |
| lat | DECIMAL(9,6) | | Optional GPS latitude |
| lng | DECIMAL(9,6) | | Optional GPS longitude |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

---

## Services

### (Already covered above - services, sub_services)

---

## Media & Content

### worker_images
Portfolio images (first 5 free, max 15 total).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| storage_path | TEXT | NOT NULL | Supabase Storage path |
| url | TEXT | NOT NULL | CDN URL |
| sort_order | SMALLINT | NOT NULL DEFAULT 0 | Display order |
| credits_charged | SMALLINT | NOT NULL DEFAULT 0 | 0 (free) or 10 |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| deleted_at | TIMESTAMPTZ | | Soft delete |

**Pricing:**
- Images 1-5: FREE
- Images 6-15: -10 credits each

---

### worker_videos
Portfolio videos (first 3 free, unlimited total, max 30 seconds).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| service_id | UUID | NOT NULL FK → services(id) | Tagged service |
| title | VARCHAR(255) | NOT NULL | |
| description | TEXT | | |
| storage_path | TEXT | NOT NULL | Supabase Storage |
| url | TEXT | NOT NULL | CDN URL |
| thumbnail_url | TEXT | | Video thumbnail |
| duration_seconds | SMALLINT | NOT NULL, 1-30 | Max 30 seconds |
| credits_charged | SMALLINT | NOT NULL DEFAULT 0 | 0 (free) or 20 |
| like_count | INT | NOT NULL DEFAULT 0 | Updated by trigger |
| view_count | INT | NOT NULL DEFAULT 0 | Actual video watches |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| deleted_at | TIMESTAMPTZ | | Soft delete (warning if promoted) |

**Pricing:**
- Videos 1-3: FREE
- Videos 4+: -20 credits each

**Note:** `like_count` and `view_count` updated by triggers on video_watches inserts.

---

### video_promotions
Promoted videos in client feed (city-level).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| video_id | UUID | NOT NULL FK → worker_videos(id) | |
| worker_id | UUID | NOT NULL FK → workers(id) | Denormalized for query efficiency |
| city_id | UUID | NOT NULL FK → cities(id) | **City-level scoping** |
| country_id | UUID | NOT NULL FK → countries(id) | Fallback country queries |
| credits_charged | SMALLINT | NOT NULL CHECK IN (20, 40) | 7-day or 14-day |
| duration_days | SMALLINT | NOT NULL CHECK IN (7, 14) | |
| starts_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| expires_at | TIMESTAMPTZ | NOT NULL | starts_at + duration_days |
| status | promotion_status | NOT NULL DEFAULT 'active' | active, expired, removed |
| removed_at | TIMESTAMPTZ | | When manually removed (no refund) |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**Pricing:**
- 7 days: 20 credits
- 14 days: 40 credits

**Indexes:**
- `idx_promotions_city_active` - (city_id, expires_at DESC) WHERE status = 'active'
- `idx_promotions_worker` - (worker_id, status)
- `idx_promotions_video` - (video_id, status)
- `idx_promotions_expires` - (expires_at) WHERE status = 'active' (for automated expiry)

---

## Engagement & Interactions

### video_watches
Every time a registered client watches a promoted video. **PARTITIONED by month.**

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| video_id | UUID | NOT NULL FK → worker_videos(id) | |
| worker_id | UUID | NOT NULL FK → workers(id) | Denormalized |
| client_id | UUID | NOT NULL FK → clients(id) | |
| watched_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| | | PARTITION BY RANGE (watched_at) | Monthly partitions |

**No uniqueness constraint** - same client watching multiple times counts each time.

**Trigger:** `update_video_and_worker_likes()` - increments video.like_count and worker.total_likes

---

### worker_views
Every time a registered client views a worker profile. **PARTITIONED by month.**

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| client_id | UUID | NOT NULL FK → clients(id) | |
| viewed_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| | | PARTITION BY RANGE (viewed_at) | Monthly partitions |

**No uniqueness constraint** - each visit counts separately.

**Trigger:** `update_worker_total_views()` - increments worker.total_views

---

### reviews
Client reviews of workers (one per client per worker, ever).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| client_id | UUID | NOT NULL FK → clients(id) | |
| rating | SMALLINT | NOT NULL CHECK 1-5 | Star rating |
| text | TEXT | | Review text |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| deleted_at | TIMESTAMPTZ | | Soft delete |
| | | UNIQUE(worker_id, client_id) | Max one per client per worker |

**Triggers:**
- `update_worker_rating_on_review()` - updates worker.avg_rating and review_count
- Review credits awarded via credit_transactions when inserted (if < 5 reviews earned)
- First 5-star review awards 40-credit bonus (if not already awarded)

---

## Credits & Payments

### credit_packages
Purchasable credit packages.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| credits | INT | NOT NULL | 100, 300, 600, or 1000 |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| sort_order | SMALLINT | NOT NULL DEFAULT 0 | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

---

### credit_package_prices
Prices per package per country (in local currency).

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| package_id | UUID | NOT NULL FK → credit_packages(id) | |
| country_id | UUID | NOT NULL FK → countries(id) | |
| price | NUMERIC(10,2) | NOT NULL | In local currency |
| currency_code | VARCHAR(3) | NOT NULL | EUR, BAM, RSD, etc. |
| | | UNIQUE(package_id, country_id) | One price per package per country |

**Example Pricing:**
- 100 credits = €5 (Germany), 5.10 BAM (Bosnia), 425 RSD (Serbia)
- 300 credits = €15, 15.30 BAM, 1275 RSD
- Etc.

---

### credit_transactions
Immutable append-only ledger of all credit movements.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| type | credit_txn_type | NOT NULL | signup_bonus, review_earned, video_upload, etc. |
| amount | INT | NOT NULL | Positive = earned, Negative = spent |
| balance_after | INT | NOT NULL | Snapshot for audit trail |
| reference_id | UUID | | Related video_id, review_id, payment_id, etc. |
| reference_type | VARCHAR(50) | | 'video', 'review', 'payment' |
| description | TEXT | | Human-readable description |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**NEVER UPDATE OR DELETE** - immutable ledger.

**Trigger:** `update_worker_credit_balance()` - updates workers.credit_balance to NEW.balance_after

---

### payments
Stripe payment records.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| worker_id | UUID | NOT NULL FK → workers(id) | |
| package_id | UUID | NOT NULL FK → credit_packages(id) | |
| stripe_payment_intent_id | VARCHAR(255) | UNIQUE | Idempotency key for webhook |
| stripe_session_id | VARCHAR(255) | | Checkout session ID |
| amount | NUMERIC(10,2) | NOT NULL | Payment amount |
| currency_code | VARCHAR(3) | NOT NULL | EUR, PLN, etc. |
| credits_purchased | INT | NOT NULL | Number of credits |
| status | payment_status | NOT NULL DEFAULT 'pending' | pending, completed, failed, refunded |
| webhook_received_at | TIMESTAMPTZ | | When webhook confirmed |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

**Webhook flow:**
1. Create payment record with status='pending'
2. Stripe sends webhook to edge function
3. Edge function verifies signature
4. Updates payment status to 'completed'
5. Creates credit_transaction with type='credit_purchase'
6. Trigger updates worker.credit_balance

---

## Admin & Moderation

### discount_promotions
Admin-created promotional campaigns.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| name | VARCHAR(255) | NOT NULL | "Summer Sale", "Holiday Special" |
| discount_percentage | NUMERIC(5,2) | NOT NULL, 0-100 | % discount |
| starts_at | TIMESTAMPTZ | NOT NULL | |
| ends_at | TIMESTAMPTZ | NOT NULL, > starts_at | |
| scope | discount_scope | NOT NULL DEFAULT 'all_packages' | all_packages or specific_packages |
| is_active | BOOLEAN | NOT NULL DEFAULT true | |
| created_by | UUID | NOT NULL FK → admin_users(id) | |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |

---

### discount_promotion_packages
Which packages each discount applies to.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| promotion_id | UUID | NOT NULL FK → discount_promotions(id) | |
| package_id | UUID | NOT NULL FK → credit_packages(id) | |
| | | PRIMARY KEY(promotion_id, package_id) | |

---

### reports
User-submitted abuse reports.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| reporter_id | UUID | NOT NULL FK → users(id) | Who reported |
| reported_user_id | UUID | FK → users(id) | User being reported (nullable) |
| reported_review_id | UUID | FK → reviews(id) | Review being reported (nullable) |
| reported_video_id | UUID | FK → worker_videos(id) | Video being reported (nullable) |
| report_type | report_type | NOT NULL | user, review, or video |
| reason | TEXT | NOT NULL | Why reported |
| status | report_status | NOT NULL DEFAULT 'pending' | pending, reviewed, resolved, dismissed |
| admin_note | TEXT | | Admin's note |
| resolved_by | UUID | FK → admin_users(id) | Which admin resolved |
| resolved_at | TIMESTAMPTZ | | When resolved |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| updated_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| | | CHECK (at least one target NOT NULL) | Must report something |

---

### error_logs
Application error logging. **PARTITIONED by month.**

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | UUID | PK, default gen_random_uuid() | |
| user_id | UUID | FK → users(id) ON DELETE SET NULL | Nullable for errors before login |
| clerk_id | VARCHAR(255) | | For correlation before user exists |
| app_type | app_type | NOT NULL | worker, client, or admin |
| device_type | device_type | NOT NULL | ios, android, web |
| error_message | TEXT | NOT NULL | Error message |
| stack_trace | TEXT | | Full stack trace |
| additional_context | JSONB | | Flexible metadata (screen, action, etc.) |
| is_resolved | BOOLEAN | NOT NULL DEFAULT false | Marked resolved by admin |
| resolved_by | UUID | FK → admin_users(id) | Which admin resolved |
| resolved_at | TIMESTAMPTZ | | When marked resolved |
| created_at | TIMESTAMPTZ | NOT NULL DEFAULT now() | |
| | | PARTITION BY RANGE (created_at) | Monthly partitions (auto-archive after 30 days) |

---

## Triggers & Indexes

### Triggers

All triggers maintain denormalized counters efficiently:

1. **update_worker_rating_on_review()** - Reviews INSERT/UPDATE/DELETE
   - Recalculates worker.avg_rating and worker.review_count

2. **update_worker_credit_balance()** - Credit_transactions INSERT
   - Updates worker.credit_balance from transaction

3. **update_video_and_worker_likes()** - Video_watches INSERT
   - Increments video.like_count and worker.total_likes

4. **update_worker_total_views()** - Worker_views INSERT
   - Increments worker.total_views

5. **update_worker_image_count()** - Worker_images INSERT/UPDATE
   - Tracks image count and free_images_used

6. **update_worker_video_count()** - Worker_videos INSERT/UPDATE
   - Tracks video count and free_videos_used

7. **validate_max_worker_services()** - Worker_services INSERT
   - Prevents adding 6th service (max 5)

### Indexes

**Performance Indexes:**
- `idx_workers_list_sort` - (country_id, city_id, credit_balance DESC, avg_rating DESC) WHERE is_active
- `idx_promotions_city_active` - (city_id, expires_at DESC) WHERE status = 'active'
- `idx_video_watches_video` - (video_id, watched_at DESC)
- `idx_worker_views_worker` - (worker_id, viewed_at DESC)
- `idx_reviews_worker` - (worker_id) WHERE deleted_at IS NULL
- `idx_credit_txn_worker` - (worker_id, created_at DESC)
- `idx_payments_stripe` - (stripe_payment_intent_id) for webhook lookup
- 20+ other specialized indexes

---

## RLS Policies

Row Level Security enforces data isolation at database level:

| Table | Policy | Description |
|-------|--------|-------------|
| workers | SELECT: country match | Client sees only workers in their country |
| workers | UPDATE: own record | Worker updates only their own |
| video_promotions | SELECT: city match | Client sees only city promotions |
| clients | SELECT/UPDATE: own | Own record only |
| reviews | SELECT: public | All reviews visible (public) |
| reviews | INSERT/UPDATE/DELETE: own | Own reviews only |
| credit_transactions | SELECT: own | Worker sees own ledger |
| payments | SELECT: own | Worker sees own payments |
| error_logs | INSERT: all auth | All authenticated users can log |
| error_logs | SELECT: admin | Admins only |
| reports | INSERT: auth | Authenticated users can report |
| reports | SELECT/UPDATE: admin | Admins only |
| admin_users | ALL: admin | Admins only |

---

## Statistics

| Metric | Value |
|--------|-------|
| **Total Tables** | 18 |
| **Enums** | 12 |
| **Partitioned Tables** | 3 (video_watches, worker_views, error_logs) |
| **Total Indexes** | 40+ |
| **RLS Enabled** | Yes - all tables |
| **Countries** | 14 |
| **Languages** | 8 |
| **Services** | 20+ |
| **Sub-services** | 40+ |

---

## Design Notes

### Scalability for 1M+ Users
- Partitioned high-volume tables (monthly)
- Denormalized counters avoid expensive aggregates
- Composite indexes for common query patterns
- RLS policies filter at database level
- Connection pooling via Supabase PgBouncer

### Security
- Row Level Security on all tables
- Geo-restriction at database level (country filtering)
- Soft deletes for audit trails
- Immutable credit ledger
- Admin audit logging

### Performance
- Partial indexes (WHERE is_active = true)
- Trigger-based counter updates (no SELECT needed)
- Indexed foreign keys for joins
- Partitioned append-only tables

### Cost Optimization
- Denormalized data = fewer queries
- Rate limiting at application layer
- Efficient pagination support
- Connection pooling reduces overhead

---

## Change Log

**June 6, 2026** - Initial schema design
- All 18 tables designed and indexed
- All triggers implemented
- RLS policies configured
- Scalability for 1M+ users verified

---

## References

- Migrations: `/backend/migrations/`
- Seed data: `/backend/seed/`
- Entity relationships documented in migration files
- RLS policies in migration 016
- Triggers in migration 015
