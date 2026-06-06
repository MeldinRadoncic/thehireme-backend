# Backend Guidance

## Shared Configuration File for Domain Management

Create a single configuration file `config.ts` in the backend that defines the allowed domain for all Supabase backend requests. This file serves as the single source of truth for the domain across all edge functions and API endpoints.

**CRITICAL: All environment variables are stored in Supabase dashboard. NO .env files.**

### Configuration Structure

```typescript
// supabase/config.ts
export const config = {
  // Access from Supabase dashboard environment variables using Deno.env.get()
  // Domain will be updated once chosen
  // Currently placeholder - will be replaced with actual domain
  ALLOWED_DOMAIN: Deno.env.get('ALLOWED_DOMAIN') || 'https://placeholder-domain.com',
  
  // API endpoints
  API_VERSION: 'v1',
  
  // Security settings
  CORS_ALLOWED_ORIGINS: [
    Deno.env.get('ALLOWED_DOMAIN') || 'https://placeholder-domain.com'
  ],
  
  // Services
  WORKER_APP_DOMAIN: Deno.env.get('WORKER_APP_DOMAIN') || 'https://placeholder-domain.com/worker',
  CLIENT_APP_DOMAIN: Deno.env.get('CLIENT_APP_DOMAIN') || 'https://placeholder-domain.com/client',
  ADMIN_DASHBOARD_DOMAIN: Deno.env.get('ADMIN_DASHBOARD_DOMAIN') || 'https://placeholder-domain.com/admin'
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

## Geo-Restriction: Country-Based Worker Visibility

**Critical Business Logic:** Users and workers are geo-restricted by country. Clients see ONLY workers from their own country. Workers are visible ONLY to clients from their own country.

### Database Schema Requirements

**Workers Table Must Include:**
- `country` column (string, required, not null)
- Index on `country` column for fast filtering
- Each worker belongs to exactly one country
- Country never changes after initial registration (or requires admin verification if changed)

**Users/Clients Table Must Include:**
- `country` column (string, required, not null)
- Represents client's location/residence country
- Determines which workers they can see

**Example Migration:**
```sql
-- Add country column if not exists
ALTER TABLE workers ADD COLUMN country VARCHAR(2) NOT NULL DEFAULT 'US';
ALTER TABLE users ADD COLUMN country VARCHAR(2) NOT NULL DEFAULT 'US';

-- Create indexes for fast filtering
CREATE INDEX idx_workers_country ON workers(country);
CREATE INDEX idx_users_country ON users(country);
```

### Edge Functions: Worker Listing and Filtering

**`get-workers-by-country` Function:**
- Endpoint: `GET /workers?country=<country_code>`
- Input: User's country (from user's profile, server-verified)
- Output: Workers from that country ONLY
- Never trust client to provide their own country — fetch from users table
- Validate user's country on every request

**Implementation:**
```typescript
// Fetch user's actual country from database (not from client request)
const userCountry = await getUserCountry(userId);

// Filter workers by user's country
const workers = await database
  .from('workers')
  .select('*')
  .eq('country', userCountry)
  .limit(50);

// Return only workers from user's country
```

**`get-worker-profile` Function:**
- Endpoint: `GET /worker/<worker_id>`
- Verify user's country matches worker's country
- Return 403 Forbidden if countries don't match
- Never return worker profile for cross-country access

**Implementation:**
```typescript
const userCountry = await getUserCountry(userId);
const worker = await getWorker(workerId);

// Verify country match
if (worker.country !== userCountry) {
  return new Response('Forbidden', { status: 403 });
}

// Safe to return worker profile
return worker;
```

### Row Level Security (RLS) Policies

**Workers Table RLS:**
- Policy: Authenticated users can only SELECT workers from their country
- Policy prevents cross-country worker visibility at database level
- Admin role can view all workers regardless of country

**Example RLS Policy:**
```sql
CREATE POLICY "Users can see workers from their country"
ON workers FOR SELECT
USING (
  country = (
    SELECT country FROM users WHERE id = auth.uid()
  )
);

CREATE POLICY "Admins can see all workers"
ON workers FOR SELECT
USING (
  auth.jwt() ->> 'role' = 'admin'
);
```

### Search and Filter Endpoints

**Worker Search:** `GET /workers/search?query=<name>&country=<country>`
- Only search within user's country
- Country validated server-side from user profile
- Results contain workers from user's country ONLY

**Worker Filter:** `GET /workers/filter?service=<service_id>&country=<country>`
- Filter by service AND country
- Country always validated server-side
- No cross-country filtering possible

### Client App Integration

**On User Login:**
1. Fetch user's profile including country
2. Cache country locally for quick access
3. All worker list requests include country parameter
4. If user changes country in settings, immediately invalidate cache and refetch workers

**On Worker Search:**
1. Get user's country from local cache or fresh fetch
2. Include `?country=<user_country>` in API request
3. Display results from that country ONLY
4. Never show workers from other countries in results

### Worker App Integration

**On Worker Registration:**
1. Worker selects country during onboarding
2. Country stored in worker profile (immutable)
3. Country determines visibility to clients
4. Worker profile includes country for admin/dashboard visibility

**Worker Profile Updates:**
- Worker can update name, bio, photos, services
- Country CANNOT be changed without admin intervention
- If country change needed, admin must verify and update manually

### Validation and Error Handling

**Always Validate:**
- User's country matches their profile in database
- Worker's country matches what's in database
- Request country parameter matches user's actual country
- Return 403 Forbidden for unauthorized country access

**Logging:**
- Log all attempts to access workers from different countries
- Alert if unusual cross-country access attempts detected
- Track for security monitoring

### Performance Optimization

**Indexes:**
- `idx_workers_country` — fast filtering by country
- `idx_users_country` — fast user country lookup
- Consider composite indexes: `(country, service_id)` for filtered searches

**Caching:**
- Cache workers list per country for 1 day TTL
- Invalidate cache when new workers registered in that country
- Cache country list (static data) for 3 days

### Summary

- Workers table MUST have `country` column (indexed)
- Users table MUST have `country` column
- RLS policies enforce country isolation at database level
- All edge functions validate country server-side (never trust client)
- Clients see workers ONLY from their country
- Workers visible ONLY to clients from their country
- Country cannot be changed after registration (immutable)
- All filtering, searching, and listing respects country boundaries

---

## Custom Error Handling (In-House Implementation)

**Note:** We implement custom error handling to avoid external service costs. Errors are logged to the database for admin review instead of using third-party services like Sentry.

### Error Logging Database Schema

Create an `error_logs` table in Supabase to store all application errors:

```sql
CREATE TABLE error_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  error_type VARCHAR(255) NOT NULL,
  error_message TEXT NOT NULL,
  stack_trace TEXT,
  endpoint VARCHAR(255),
  http_method VARCHAR(10),
  status_code INTEGER,
  request_data JSONB,
  user_agent VARCHAR(255),
  ip_address VARCHAR(45),
  device_type VARCHAR(50),
  app_version VARCHAR(50),
  environment VARCHAR(50) DEFAULT 'production',
  is_resolved BOOLEAN DEFAULT FALSE,
  resolution_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_error_logs_timestamp ON error_logs(timestamp DESC);
CREATE INDEX idx_error_logs_user_id ON error_logs(user_id);
CREATE INDEX idx_error_logs_error_type ON error_logs(error_type);
CREATE INDEX idx_error_logs_is_resolved ON error_logs(is_resolved);
```

### Error Logging Edge Function

Create `supabase/functions/log-error/index.ts`:

```typescript
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

interface ErrorLogPayload {
  userId?: string;
  errorType: string;
  errorMessage: string;
  stackTrace?: string;
  endpoint?: string;
  httpMethod?: string;
  statusCode?: number;
  requestData?: any;
  deviceType?: string;
  appVersion?: string;
  userAgent?: string;
  ipAddress?: string;
}

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    const payload: ErrorLogPayload = await req.json();
    
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL'),
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    );

    // Insert error log into database
    const { error: insertError } = await supabase
      .from('error_logs')
      .insert({
        user_id: payload.userId,
        error_type: payload.errorType,
        error_message: payload.errorMessage,
        stack_trace: payload.stackTrace,
        endpoint: payload.endpoint,
        http_method: payload.httpMethod,
        status_code: payload.statusCode,
        request_data: payload.requestData,
        device_type: payload.deviceType,
        app_version: payload.appVersion,
        user_agent: payload.userAgent,
        ip_address: payload.ipAddress,
      });

    if (insertError) {
      console.error('Failed to log error:', insertError);
      return new Response(
        JSON.stringify({ success: false, error: insertError.message }),
        { status: 500 }
      );
    }

    return new Response(
      JSON.stringify({ success: true, message: 'Error logged' }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error logging endpoint error:', error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500 }
    );
  }
});
```

### Error Handling in Edge Functions

All edge functions should follow this error handling pattern:

```typescript
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const getClientIp = (req: Request): string => {
  return req.headers.get('x-forwarded-for')?.split(',')[0].trim() 
    || req.headers.get('x-real-ip') 
    || 'unknown';
};

Deno.serve(async (req: Request) => {
  const clientIp = getClientIp(req);
  
  try {
    // Your business logic here
    const data = await req.json();
    
    if (!data.userId) {
      throw new Error('User ID is required');
    }

    // Process request...
    return new Response(
      JSON.stringify({ success: true, data: {} }),
      { status: 200 }
    );

  } catch (error) {
    // Log error to database
    const errorPayload = {
      userId: req.headers.get('user-id'),
      errorType: error.name || 'UnknownError',
      errorMessage: error.message,
      stackTrace: error.stack,
      endpoint: new URL(req.url).pathname,
      httpMethod: req.method,
      statusCode: 500,
      userAgent: req.headers.get('user-agent'),
      ipAddress: clientIp,
      deviceType: req.headers.get('user-agent')?.includes('Mobile') ? 'mobile' : 'web',
    };

    try {
      await fetch(`${Deno.env.get('SUPABASE_URL')}/functions/v1/log-error`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${Deno.env.get('SUPABASE_ANON_KEY')}`,
        },
        body: JSON.stringify(errorPayload),
      });
    } catch (logError) {
      console.error('Failed to log error:', logError);
    }

    // Return user-friendly error message (never expose technical details)
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: 'An error occurred. Please try again later.',
        errorId: Date.now() // For support reference
      }),
      { status: 500 }
    );
  }
});
```

### Client-Side Error Logging (React Native / Next.js)

**For Worker App & Client App:**

```typescript
// utils/errorLogger.ts
import AsyncStorage from '@react-native-async-storage/async-storage';

interface ClientError {
  type: string;
  message: string;
  stack?: string;
  screen?: string;
  userId?: string;
  appVersion: string;
  timestamp: string;
}

export const logClientError = async (
  errorType: string,
  errorMessage: string,
  errorStack?: string,
  currentScreen?: string
) => {
  try {
    const userId = await AsyncStorage.getItem('userId');
    const appVersion = '1.0.0'; // from package.json

    const errorLog: ClientError = {
      type: errorType,
      message: errorMessage,
      stack: errorStack,
      screen: currentScreen,
      userId: userId || undefined,
      appVersion,
      timestamp: new Date().toISOString(),
    };

    // Send to backend error logging endpoint
    await fetch(`${API_URL}/functions/v1/log-error`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${authToken}`,
      },
      body: JSON.stringify(errorLog),
    }).catch(() => {
      // If network fails, store locally for later retry
      storeErrorLocally(errorLog);
    });
  } catch (error) {
    console.error('Failed to log client error:', error);
  }
};

const storeErrorLocally = async (error: ClientError) => {
  try {
    const stored = await AsyncStorage.getItem('pendingErrors');
    const errors = stored ? JSON.parse(stored) : [];
    errors.push(error);
    await AsyncStorage.setItem('pendingErrors', JSON.stringify(errors));
  } catch (error) {
    console.error('Failed to store error locally:', error);
  }
};

// Global error handler for React Native
export const setupGlobalErrorHandler = () => {
  const originalConsoleError = console.error;
  console.error = (...args: any[]) => {
    originalConsoleError(...args);
    
    if (args[0] instanceof Error) {
      logClientError(
        args[0].name,
        args[0].message,
        args[0].stack
      );
    }
  };
};
```

**Usage in Components:**

```typescript
import { logClientError } from '@/utils/errorLogger';

const MyComponent = () => {
  const handleUploadVideo = async () => {
    try {
      // upload logic
    } catch (error) {
      logClientError(
        'VideoUploadError',
        error.message,
        error.stack,
        'VideoUploadScreen'
      );
      
      // Show user-friendly message
      showErrorMessage('Unable to upload video. Please try again.');
    }
  };

  return (
    // component JSX
  );
};
```

### Admin Dashboard Error Review

Create an admin page to review logged errors:

```typescript
// app/admin/errors/page.tsx
'use client';

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';

interface ErrorLog {
  id: string;
  timestamp: string;
  user_id: string;
  error_type: string;
  error_message: string;
  endpoint: string;
  device_type: string;
  is_resolved: boolean;
}

export default function ErrorLogsPage() {
  const [errors, setErrors] = useState<ErrorLog[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchErrors();
  }, []);

  const fetchErrors = async () => {
    const { data, error } = await supabase
      .from('error_logs')
      .select('*')
      .eq('is_resolved', false)
      .order('timestamp', { ascending: false })
      .limit(100);

    if (error) {
      console.error('Failed to fetch errors:', error);
    } else {
      setErrors(data || []);
    }
    setLoading(false);
  };

  const markResolved = async (errorId: string) => {
    await supabase
      .from('error_logs')
      .update({ is_resolved: true })
      .eq('id', errorId);

    fetchErrors();
  };

  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold mb-6">Error Logs</h1>
      
      {loading ? (
        <p>Loading errors...</p>
      ) : (
        <table className="w-full border">
          <thead>
            <tr className="bg-gray-200">
              <th className="border p-2 text-left">Time</th>
              <th className="border p-2 text-left">Type</th>
              <th className="border p-2 text-left">Message</th>
              <th className="border p-2 text-left">Endpoint</th>
              <th className="border p-2 text-left">Device</th>
              <th className="border p-2 text-left">Action</th>
            </tr>
          </thead>
          <tbody>
            {errors.map((error) => (
              <tr key={error.id} className="border">
                <td className="border p-2 text-sm">{new Date(error.timestamp).toLocaleString()}</td>
                <td className="border p-2 font-mono text-sm">{error.error_type}</td>
                <td className="border p-2 text-sm max-w-xs truncate">{error.error_message}</td>
                <td className="border p-2 text-sm">{error.endpoint}</td>
                <td className="border p-2 text-sm">{error.device_type}</td>
                <td className="border p-2">
                  <button
                    onClick={() => markResolved(error.id)}
                    className="px-3 py-1 bg-blue-500 text-white rounded text-sm"
                  >
                    Resolve
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
```

---

## Custom Rate Limiting (In-House Implementation)

**Note:** We implement rate limiting using the database to avoid external service costs. Rate limit state is stored in Supabase for persistence across requests.

### Rate Limiting Database Schema

Create a `rate_limits` table to track request counts:

```sql
CREATE TABLE rate_limits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  endpoint VARCHAR(255) NOT NULL,
  request_count INTEGER DEFAULT 0,
  window_start TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  window_end TIMESTAMP WITH TIME ZONE,
  is_blocked BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Compound index for fast lookups
CREATE UNIQUE INDEX idx_rate_limits_user_endpoint 
ON rate_limits(user_id, endpoint, window_start);

CREATE INDEX idx_rate_limits_user_id ON rate_limits(user_id);
CREATE INDEX idx_rate_limits_endpoint ON rate_limits(endpoint);
CREATE INDEX idx_rate_limits_blocked ON rate_limits(is_blocked);
```

### Rate Limiting Edge Function

Create `supabase/functions/check-rate-limit/index.ts`:

```typescript
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// Rate limit configuration (requests per time window)
const RATE_LIMITS: Record<string, { limit: number; windowSeconds: number }> = {
  'auth-login': { limit: 5, windowSeconds: 900 }, // 5 attempts per 15 min
  'auth-register': { limit: 3, windowSeconds: 3600 }, // 3 per hour
  'worker-profile-update': { limit: 10, windowSeconds: 3600 }, // 10 per hour
  'worker-video-upload': { limit: 3, windowSeconds: 3600 }, // 3 per hour
  'worker-promotion': { limit: 5, windowSeconds: 3600 }, // 5 per hour
  'payment-process': { limit: 3, windowSeconds: 3600 }, // 3 per hour
  'worker-search': { limit: 100, windowSeconds: 60 }, // 100 per minute
  'worker-filter': { limit: 100, windowSeconds: 60 }, // 100 per minute
  'review-submit': { limit: 5, windowSeconds: 3600 }, // 5 per hour
  'admin-user-delete': { limit: 10, windowSeconds: 3600 }, // 10 per hour
};

interface RateLimitRequest {
  userId: string;
  endpoint: string;
}

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    const { userId, endpoint }: RateLimitRequest = await req.json();

    const config = RATE_LIMITS[endpoint];
    if (!config) {
      // If endpoint not configured, allow unlimited
      return new Response(
        JSON.stringify({ allowed: true, remaining: -1, resetTime: null }),
        { status: 200 }
      );
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL'),
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    );

    const now = new Date();
    const windowStart = new Date(now.getTime() - config.windowSeconds * 1000);

    // Get or create rate limit record
    let { data: rateLimitRecord, error: fetchError } = await supabase
      .from('rate_limits')
      .select('*')
      .eq('user_id', userId)
      .eq('endpoint', endpoint)
      .gte('window_start', windowStart.toISOString())
      .single();

    if (fetchError && fetchError.code !== 'PGRST116') {
      throw fetchError;
    }

    if (!rateLimitRecord) {
      // Create new rate limit record
      const { data: newRecord, error: createError } = await supabase
        .from('rate_limits')
        .insert({
          user_id: userId,
          endpoint,
          request_count: 1,
          window_start: now.toISOString(),
          window_end: new Date(now.getTime() + config.windowSeconds * 1000).toISOString(),
        })
        .select()
        .single();

      if (createError) throw createError;

      return new Response(
        JSON.stringify({
          allowed: true,
          remaining: config.limit - 1,
          resetTime: new Date(now.getTime() + config.windowSeconds * 1000).toISOString(),
        }),
        { status: 200 }
      );
    }

    // Check if request count exceeded
    const remaining = config.limit - rateLimitRecord.request_count;

    if (remaining <= 0) {
      return new Response(
        JSON.stringify({
          allowed: false,
          remaining: 0,
          resetTime: rateLimitRecord.window_end,
          retryAfter: Math.ceil(
            (new Date(rateLimitRecord.window_end).getTime() - now.getTime()) / 1000
          ),
        }),
        { status: 429 }
      );
    }

    // Increment request count
    const { error: updateError } = await supabase
      .from('rate_limits')
      .update({ request_count: rateLimitRecord.request_count + 1 })
      .eq('id', rateLimitRecord.id);

    if (updateError) throw updateError;

    return new Response(
      JSON.stringify({
        allowed: true,
        remaining: remaining - 1,
        resetTime: rateLimitRecord.window_end,
      }),
      { status: 200 }
    );

  } catch (error) {
    console.error('Rate limit check error:', error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500 }
    );
  }
});
```

### Using Rate Limiting in Edge Functions

Add rate limit checks at the beginning of all edge functions:

```typescript
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async (req: Request) => {
  try {
    // Get user ID from auth token
    const authHeader = req.headers.get('Authorization');
    const token = authHeader?.replace('Bearer ', '');
    
    if (!token) {
      return new Response('Unauthorized', { status: 401 });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL'),
      Deno.env.get('SUPABASE_ANON_KEY')
    );

    // Verify token and get user
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    
    if (authError || !user) {
      return new Response('Unauthorized', { status: 401 });
    }

    // CHECK RATE LIMIT
    const rateLimitResponse = await fetch(
      `${Deno.env.get('SUPABASE_URL')}/functions/v1/check-rate-limit`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')}`,
        },
        body: JSON.stringify({
          userId: user.id,
          endpoint: 'payment-process', // Replace with actual endpoint
        }),
      }
    );

    const rateLimitResult = await rateLimitResponse.json();

    if (!rateLimitResult.allowed) {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'Too many requests. Please try again later.',
          retryAfter: rateLimitResult.retryAfter,
        }),
        { 
          status: 429,
          headers: {
            'Retry-After': rateLimitResult.retryAfter?.toString() || '60',
          }
        }
      );
    }

    // Process request...
    return new Response(JSON.stringify({ success: true }), { status: 200 });

  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500 }
    );
  }
});
```

### Client-Side Rate Limit Handling

When the client receives a 429 response with `Retry-After` header:

```typescript
// utils/apiClient.ts
import AsyncStorage from '@react-native-async-storage/async-storage';

export const apiCall = async (endpoint: string, options: RequestInit) => {
  const maxRetries = 3;
  let attempt = 0;

  while (attempt < maxRetries) {
    try {
      const response = await fetch(endpoint, options);

      if (response.status === 429) {
        const retryAfter = response.headers.get('Retry-After');
        const delayMs = (parseInt(retryAfter) || 60) * 1000;

        console.log(`Rate limited. Retrying after ${delayMs}ms`);
        
        // Wait before retrying
        await new Promise(resolve => setTimeout(resolve, delayMs));
        attempt++;
        continue;
      }

      return response;
    } catch (error) {
      throw error;
    }
  }

  throw new Error('Max retries exceeded');
};
```

### Admin Dashboard Rate Limit Monitoring

Track rate limit violations in admin dashboard:

```typescript
// Get rate limit statistics
const getRateLimitStats = async (userId?: string) => {
  const query = supabase
    .from('rate_limits')
    .select('endpoint, COUNT(*) as violations', { count: 'exact' })
    .eq('is_blocked', true);

  if (userId) {
    query.eq('user_id', userId);
  }

  return await query.group_by('endpoint');
};
```

### Cleanup Old Rate Limit Records

Create a scheduled job (run daily) to clean up old records:

```sql
-- Delete rate limit records older than 7 days
DELETE FROM rate_limits
WHERE created_at < NOW() - INTERVAL '7 days';
```

---

## Implementation Timeline for Custom Solutions

### Phase 1: Error Logging (Week 1)
- [ ] Create `error_logs` table
- [ ] Create `log-error` edge function
- [ ] Add error handling to 3-4 critical edge functions
- [ ] Test error logging from backend

### Phase 2: Client Error Logging (Week 2)
- [ ] Create error logger utility for React Native
- [ ] Add global error handler
- [ ] Integrate into worker and client apps
- [ ] Add offline error storage

### Phase 3: Admin Dashboard (Week 3)
- [ ] Create error logs admin page
- [ ] Add filtering by error type, endpoint, user
- [ ] Add error resolution tracking
- [ ] Create error statistics dashboard

### Phase 4: Rate Limiting (Week 4)
- [ ] Create `rate_limits` table
- [ ] Create `check-rate-limit` edge function
- [ ] Integrate into payment, auth, and upload endpoints
- [ ] Add client-side retry logic

### Phase 5: Monitoring (Week 5)
- [ ] Create rate limit violation dashboard
- [ ] Add analytics for error patterns
- [ ] Set up cleanup jobs
- [ ] Test under load

---

## Migration to Paid Services (Future)

When you have budget, you can easily migrate to Sentry + Upstash:

1. **Error Logs:** Continue logging to database AND send to Sentry
2. **Rate Limiting:** Switch from database-based to Upstash
3. **Gradual Migration:** No breaking changes, can coexist
4. **Cost Savings:** Reduce database queries for rate limiting

See `ERROR_HANDLING_AND_RATELIMIT_RESEARCH.md` for details on Sentry and Upstash when ready to upgrade.
