# Local Development Setup - Supabase Backend

## Quick Start (TL;DR)

```bash
cd /Users/meldin/Documents/PROJECTS/THEHIREME/backend
supabase start
```

Then access:
- **Supabase Studio:** http://127.0.0.1:54323
- **API:** http://127.0.0.1:54321
- **Database:** 127.0.0.1:54322

---

## Prerequisites

✅ Docker Desktop installed and running  
✅ Supabase CLI installed: `npm install -g supabase` or `brew install supabase`  
✅ Docker system permissions granted in macOS (System Settings → Privacy & Security → Docker)

---

## Starting the Development Server

### Step 1: Navigate to Backend Directory
```bash
cd /Users/meldin/Documents/PROJECTS/THEHIREME/backend
```

### Step 2: Start Supabase
```bash
supabase start
```

**Do NOT exclude any services** - let Supabase start everything including Studio and Edge Functions.

### Step 3: Wait for Startup
Output should show:
```
Starting containers...
Waiting for health checks...
Started supabase local development setup.

╭──────────────────────────────────────╮
│ 🔧 Development Tools                 │
├─────────┬────────────────────────────┤
│ Studio  │ http://127.0.0.1:54323     │
│ Mailpit │ http://127.0.0.1:54324     │
╰─────────┴────────────────────────────╯
```

### Step 4: Access Supabase Studio
Open in browser: **http://127.0.0.1:54323**

---

## Connection Details

Copy these for your frontend apps:

```
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=<anon_key_from_supabase_status>
SUPABASE_SERVICE_ROLE_KEY=<service_key_from_supabase_status>

Database:
  Host: 127.0.0.1
  Port: 54322
  User: postgres
  Password: postgres
  Database: postgres
```

Run `supabase status` to get the actual keys from your local Supabase instance.

---

## Available Services

| Service | URL | Port |
|---------|-----|------|
| **Supabase Studio** | http://127.0.0.1:54323 | 54323 |
| **REST API** | http://127.0.0.1:54321/rest/v1 | 54321 |
| **GraphQL API** | http://127.0.0.1:54321/graphql/v1 | 54321 |
| **Edge Functions** | http://127.0.0.1:54321/functions/v1 | 54321 |
| **Database (PostgreSQL)** | postgresql://localhost:54322 | 54322 |
| **Authentication (GoTrue)** | Internal | 9999 |
| **Storage** | Internal | 5000 |
| **Realtime** | Internal | 4000 |
| **Mailpit (Email Testing)** | http://127.0.0.1:54324 | 54324 |

---

## Checking Status

```bash
supabase status
```

Expected output shows all services running with their URLs.

---

## Stopping the Server

```bash
supabase stop
```

---

## If Something Goes Wrong

### Stuck Containers
```bash
# Clean up stuck Docker containers
docker ps -a -q --filter "name=supabase" | xargs -r docker rm -f

# Then start fresh
supabase start
```

### Docker Desktop Not Running
- Open Docker Desktop application
- Wait 30 seconds for it to fully start
- Try `supabase start` again

### Port Already in Use
```bash
# Find what's using the port
lsof -i :54321

# Kill the process
kill -9 <PID>

# Then start again
supabase start
```

### Permission Denied Error
- Go to macOS System Settings → Privacy & Security
- Ensure Docker has full access
- Restart Docker Desktop
- Try `supabase start` again

---

## For Local Development with Multiple Apps

**Terminal 1 - Backend (Always Run First):**
```bash
cd backend
supabase start
```

**Terminal 2 - Admin Dashboard:**
```bash
cd admin-dashboard
npm run dev
# http://localhost:3000
```

**Terminal 3 - Worker App:**
```bash
cd worker
npm run web
# http://localhost:19006
```

**Terminal 4 - Client App:**
```bash
cd client
npm run web
# http://localhost:19007
```

---

## Important Notes

- **Always start Backend first** - Frontend apps depend on it
- **Do NOT exclude services** - Use `supabase start` without flags
- **Keep Docker Desktop running** - Services only run while Docker is active
- **Data persists** - Local data is backed up in Docker volumes
- **Reset database** (if needed): `supabase db reset`

---

## Troubleshooting Commands

```bash
# Check all running Supabase containers
docker ps -a | grep supabase

# View database logs
docker logs supabase_db_backend

# View API gateway logs
docker logs supabase_kong_backend

# View Studio logs
docker logs supabase_studio_backend

# Connect to database directly
psql postgresql://postgres:postgres@127.0.0.1:54322/postgres
```

---

## Useful Links

- Supabase Docs: https://supabase.com/docs
- Local Development Guide: https://supabase.com/docs/guides/local-development
- Supabase CLI Reference: https://supabase.com/docs/reference/cli/about

---

**Last Updated:** 2026-06-04  
**Status:** ✅ Tested and Working
