# Backend Guidance

## Shared Configuration File for Domain Management

Create a single configuration file `config.ts` in the backend that defines the allowed domain for all Supabase backend requests. This file serves as the single source of truth for the domain across all edge functions and API endpoints.

### Configuration Structure

```typescript
// supabase/config.ts
export const config = {
  // Domain will be updated once chosen
  // Currently placeholder - will be replaced with actual domain
  ALLOWED_DOMAIN: process.env.ALLOWED_DOMAIN || 'https://placeholder-domain.com',
  
  // API endpoints
  API_VERSION: 'v1',
  
  // Security settings
  CORS_ALLOWED_ORIGINS: [
    process.env.ALLOWED_DOMAIN || 'https://placeholder-domain.com'
  ],
  
  // Services
  WORKER_APP_DOMAIN: process.env.WORKER_APP_DOMAIN || 'https://placeholder-domain.com/worker',
  CLIENT_APP_DOMAIN: process.env.CLIENT_APP_DOMAIN || 'https://placeholder-domain.com/client',
  ADMIN_DASHBOARD_DOMAIN: process.env.ADMIN_DASHBOARD_DOMAIN || 'https://placeholder-domain.com/admin'
};
```

### Usage in Edge Functions

All edge functions import this configuration and use it for:
- CORS validation — only allow requests from specified domains
- Request origin verification — check request origin against allowed domains
- Redirect URLs — use consistent domain across all functions
- API endpoints — construct URLs using central configuration

Example:
```typescript
import { config } from './config.ts';

export async function handler(req: Request) {
  const origin = req.headers.get('origin');
  
  // Validate origin against configured domains
  if (!config.CORS_ALLOWED_ORIGINS.includes(origin)) {
    return new Response('Forbidden', { status: 403 });
  }
  
  // Proceed with request
}
```

### Environment Variables

Store actual domain values in Supabase environment variables:
- `ALLOWED_DOMAIN` — main domain (e.g., https://thehireme.com)
- `WORKER_APP_DOMAIN` — worker app domain
- `CLIENT_APP_DOMAIN` — client app domain
- `ADMIN_DASHBOARD_DOMAIN` — admin dashboard domain

### Update Process

When domain is finalized:
1. Update Supabase environment variables with actual domain
2. No code changes needed in edge functions
3. All functions automatically use new domain from config.ts
4. No app crashes or redeployment required

### Benefits

- **Single source of truth** — all functions reference same config file
- **Easy updates** — change domain in one place, applies everywhere
- **No hardcoding** — domains never hardcoded in function files
- **Environment-based** — different domains for development, staging, production
- **Prevents crashes** — centralized configuration prevents inconsistent state
- **Security** — consistent CORS and origin validation across all endpoints
- **Maintenance** — future domain changes require only environment variable updates

### Development vs. Production

**During Development (No Domain Yet):**
- Allow requests from all origins (`*`)
- Set `CORS_ALLOWED_ORIGINS: ['*']` in config
- Allows all three apps to communicate with backend freely
- No domain restrictions needed until domain is finalized

**Production (Domain Finalized):**
- Restrict to specific domain only
- Set `CORS_ALLOWED_ORIGINS: [ALLOWED_DOMAIN]`
- Validate request origins strictly
- Only approved domains can access backend

### Security Considerations

- During development: allow all origins (`*`) for flexibility
- Once domain is chosen: switch to whitelist-specific domains only
- Never hardcode domains in edge function code
- Always validate request origin against config (production)
- Use HTTPS only — enforce in config
- Environment variables secured in Supabase dashboard
- Regular audits of allowed domains and CORS policies
- Update config.ts CORS_ALLOWED_ORIGINS when moving from development to production

## Project Folder Structure

The backend project must follow a strict folder structure to ensure clarity, consistency, and seamless deployment. This structure is essential for managing edge functions, migrations, and seed data in alignment with the production database schema.

### Directory Layout

```
backend/
├── supabase/
│   ├── functions/
│   │   ├── admin-remove-user/
│   │   ├── admin-suspend-user/
│   │   ├── admin-ban-user/
│   │   ├── admin-add-admin/
│   │   ├── admin-change-role/
│   │   ├── auth-login/
│   │   ├── auth-register/
│   │   ├── payment-process/
│   │   └── [other edge functions]/
│   └── config.ts
├── migrations/
│   ├── 001_init_database.sql
│   ├── 002_create_users_table.sql
│   ├── 003_create_services_table.sql
│   ├── 004_create_reviews_table.sql
│   ├── 005_add_rls_policies.sql
│   └── [additional migrations]/
├── seed/
│   ├── 001_seed_countries.sql
│   ├── 002_seed_services.sql
│   ├── 003_seed_initial_data.sql
│   └── [additional seed files]/
├── docs/
│   ├── Backend_Guidance.md
│   └── schema.md
├── package.json
├── tsconfig.json
└── CLAUDE.md
```

### Supabase Folder (`supabase/`)

The `supabase/` directory contains all configuration and serverless functions for the backend.

**`functions/` subdirectory:**
- Stores all edge functions that run on Supabase's serverless compute
- Each function has its own folder with an `index.ts` or similar entry point
- **Admin functions MUST follow the strict naming convention:** `admin-` prefix (e.g., `admin-remove-user`, `admin-suspend-user`)
- **Authentication functions:** `auth-login`, `auth-register`, `auth-logout`, etc.
- **Payment functions:** `payment-process`, `payment-verify`, etc.
- **Business logic functions:** any other operation like `worker-profile-update`, `service-list`, etc.
- All functions must validate request origin against `config.ts`
- All functions must validate user roles and permissions server-side
- No sensitive data hardcoded — use `Deno.env.get()` for all environment variables

**`config.ts` file:**
- Central configuration file for all edge functions
- Defines allowed domains, CORS policies, and app-specific URLs
- Acts as single source of truth for domain management
- Must be imported by all edge functions for consistent behavior

### Migrations Folder (`migrations/`)

The `migrations/` directory is **outside** the `supabase/` folder and contains all database schema migrations.

**Critical Rules:**
- All migration files MUST use zero-padded sequential numbering: `001_`, `002_`, `003_`, etc.
- Each migration file must be a valid SQL script that can be executed independently
- Migrations must be idempotent where possible (use `IF NOT EXISTS`, `IF EXISTS`)
- Migrations are applied in sequential order by filename
- Never manually modify production schema — always use migrations
- All migrations must align exactly with the `schema.md` documentation

**Example migration files:**
```
001_init_database.sql       — Create base schema
002_create_users_table.sql  — Create users and authentication tables
003_create_services_table.sql — Create services and service offerings
004_create_reviews_table.sql — Create reviews and ratings
005_add_rls_policies.sql    — Enable Row Level Security policies
006_create_payments_table.sql — Add payment processing tables
007_add_indexes.sql         — Create database indexes for performance
```

**Deployment:**
- All migrations MUST be deployed using Supabase CLI
- Do NOT apply migrations manually to the database
- CLI ensures consistent ordering and rollback capability
- Test all migrations locally with Docker before pushing to production

### Seed Folder (`seed/`)

The `seed/` directory contains data seeding scripts for pre-populating the database with essential static data.

**Critical Rules:**
- All seed files MUST use zero-padded sequential numbering: `001_`, `002_`, `003_`, etc.
- Seed files are SQL scripts that insert initial data into tables
- Seeds should only be applied to development and staging environments
- Never run seeds on production without explicit confirmation
- Seed data should include: countries, languages, service categories, default system data

**Example seed files:**
```
001_seed_countries.sql      — Insert all supported countries and locales
002_seed_services.sql       — Insert service categories and types
003_seed_initial_data.sql   — Insert system defaults and configuration data
```

**Deployment:**
- All seed scripts MUST be deployed using Supabase CLI
- Seeds are idempotent — can be re-run safely (include `ON CONFLICT` clauses)
- Apply seeds after migrations in development
- Verify seed data integrity in `schema.md` documentation

### Production Schema Documentation (`schema.md`)

The `schema.md` file is the source of truth for the entire database structure and must be kept in perfect alignment with the actual production schema.

**Every table, column, and constraint must be documented:**
- Table names and purposes
- Column names, types, and constraints
- Primary keys and foreign keys
- Indexes and performance optimizations
- Row Level Security (RLS) policies
- Relationships between tables

**Maintenance:**
- Update `schema.md` BEFORE creating migrations
- Keep `schema.md` synchronized with actual production schema
- Any schema change requires updating both the migration file AND `schema.md`
- Document relationships clearly to prevent data integrity issues

### Supabase CLI Deployment (MANDATORY)

All migrations and edge function deployments MUST use the Supabase CLI. This ensures consistency and prevents manual errors.

**Deployment steps:**
```bash
# Install Supabase CLI
npm install -g supabase

# Link to your Supabase project
supabase link --project-ref YOUR_PROJECT_REF

# Test migrations locally (requires Docker)
npm run dev

# Push migrations to production
supabase db push

# Deploy edge functions
supabase functions deploy
```

**Critical rules:**
- Never modify production schema directly in Supabase dashboard
- Never run SQL queries directly on production
- All changes go through migrations and CLI
- Local Docker development environment mirrors production exactly
- Changes are version-controlled in git before deployment

### Cost Efficiency and Minimal Supabase Usage

Minimize Supabase costs by following these principles throughout the project:

**Edge Functions:**
- Keep function cold start time minimal — optimize code size
- Use efficient algorithms to reduce execution time
- Avoid long-running operations; use asynchronous processing where possible
- Cache static data (countries, services) to reduce repeated queries
- Implement rate limiting in all public edge functions

**Database Queries:**
- Write efficient SQL — use indexes, avoid N+1 queries
- Batch operations where possible
- Use pagination for large result sets
- Cache rarely-changing data (1–3 day TTL)
- Implement query timeouts to prevent runaway costs

**RLS Policies:**
- Use RLS to prevent unauthorized data access
- RLS policies reduce backend validation overhead
- Properly scoped policies improve security AND efficiency

**Monitoring:**
- Track edge function execution time in logs
- Monitor database query performance
- Alert on unusual API usage patterns
- Regular cost audits to identify optimization opportunities

### Summary

- `supabase/functions/` — all edge functions with proper naming conventions
- `migrations/` — sequential SQL migrations (001, 002, etc.)
- `seed/` — sequential data seed scripts (001, 002, etc.)
- `schema.md` — complete production schema documentation
- **Always use Supabase CLI** for all deployments
- **Keep costs minimal** through efficient queries, caching, and rate limiting
- **Test locally** with Docker before pushing to production
