# TheHireMe Backend

Supabase backend for the TheHireMe platform.

## Features
- PostgreSQL database with migrations
- Edge Functions for serverless API logic
- Database seeding for development
- Shared data layer for all frontend projects

## Quick Start

1. Install dependencies:
```bash
npm install
```

2. Start Supabase locally:
```bash
npm run dev
```

3. Run migrations:
```bash
npm run db:push
```

4. Seed the database:
```bash
npm run seed
```

## Project Structure
- `supabase/migrations/` - Database schema migrations
- `supabase/functions/` - Edge Functions
- `supabase/seed.sql` - Seed data for development

## Used By
- thehireme-client (React Native client app)
- thehireme-worker (React Native worker app)
- thehireme-admin (Next.js admin dashboard)
