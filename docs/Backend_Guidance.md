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
