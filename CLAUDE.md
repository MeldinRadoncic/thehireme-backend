# The Hire Me Backend

**GitHub Repository:** https://github.com/MeldinRadoncic/thehireme-backend

## Project Overview

The backend project is its own dedicated GitHub repository. All commits and pushes to GitHub must be explicitly requested by the developer; no automatic pushes.

This backend is the core of The Hire Me platform. It handles all business logic, data validation, error logging, payments via Stripe, and more.

## Documentation - MUST READ ALL FILES

**CRITICAL:** Before writing any backend code, you MUST read ALL documentation files:

### Backend Project Docs (This Folder)

Inside this backend project, there is a docs folder. You MUST read:
- Backend_Guidance.md — comprehensive backend architecture and deployment guidelines
- schema.md — database schema (every table, column, constraint, relationship)

Any changes to configuration, environment variables, or deployment procedures must be reflected in the documentation.

### Main Project Docs (Root /THEHIREME/docs Folder)

You MUST also read all documentation in the main root docs folder:
- APP_COMPLETE_FLOW.md — complete overview of all three apps and how they connect to the backend
- Countries_and_Languages.md — translation and localization system
- Any other docs in the main /docs folder

### Why All Documentation is MANDATORY

Reading ALL documentation ensures you understand:
- Exactly how the three frontend apps communicate with this backend
- Exactly how the database schema supports all features
- Exactly how edge functions should be structured
- Exactly how payments, authentication, and other critical flows work
- Exactly what cost optimization and rate limiting strategies must be implemented
- How security, performance, and maintainability requirements affect backend decisions

**You cannot build correct backend features without understanding the complete system.**

Do NOT start coding until you have read and fully understood ALL documentation files from both the backend project and the main root project.

### Database Schema (MUST UNDERSTAND)

There is a schema.md file. This file must be fully understood and kept up to date at all times.

- Any change to tables, rows, columns, or constraints must be reflected in schema.md
- The file must always mirror the production schema exactly—every table, column, constraint, and relationship
- This ensures that whenever we build a new feature, we know exactly what the database structure is, avoiding any confusion
- The schema is the source of truth for all database operations

## Local Development Environment

The backend runs locally using **Docker** with a local Supabase instance.

To start development:

```bash
npm install
npm run dev
```

Docker automatically spins up a local Supabase instance. All three apps (client, worker, admin) connect to this same local instance during development.

## Environment Variables

All sensitive credentials and configuration are stored in the **Supabase dashboard** as environment variables.

**Access environment variables at runtime using:**
```typescript
const value = Deno.env.get('VARIABLE_NAME');
```

**Never:**
- Hardcode API keys, secrets, or configuration in code
- Expose environment variables in URLs or logs
- Store secrets in code files

**Always:**
- Use Deno.env.get() to fetch variables at runtime
- Store all sensitive data in Supabase dashboard
- Validate that required environment variables exist on startup

**Environment variables include:**
- Clerk API key
- Stripe publishable/secret keys
- Supabase URL and anon key
- Database connection strings
- Third-party API keys

## Supabase Cost Optimization

We must always be mindful of Supabase costs. Avoid unnecessary API calls—use caching for rarely changing data like services and countries. Don't repeatedly poll the database; instead, use a sensible TTL (e.g., 24 or 48 hours) so we avoid unnecessary costs.

**Rate Limiting (Critical for Cost Control)**

Rate limiting is **mandatory** to prevent excessive API calls and uncontrolled Supabase charges.

**Implementation:**
- Limit requests per user per minute (e.g., 60 requests/min)
- Return 429 (Too Many Requests) when limit exceeded
- Different limits for different endpoints:
  - Search/filter endpoints: more restrictive
  - Authentication endpoints: strictest limits
  - Payment endpoints: very strict limits
- Log all rate limit violations for monitoring abuse patterns
- Use exponential backoff on clients (1s, 2s, 4s, etc.)

**Why Rate Limiting is Critical:**
- Prevents accidental duplicate requests
- Protects against abuse and spam
- Controls database query load
- Prevents runaway costs from misbehaving clients
- Ensures stable performance for all users

## Deployment and Supabase CLI

Whenever we need to deploy edge functions or run migrations, we must use the **Supabase CLI**. The CLI ensures that all changes are consistent across environments.

**Before deploying:**
1. Test all edge functions locally
2. Test migrations locally
3. Use load testing tools (k6 or Artillery) to simulate 500+ concurrent users
4. Once verified, use Supabase CLI to push them live

**Load Testing:**
Use k6 or Artillery (mentioned in main project docs) to simulate hundreds or thousands of concurrent users before production deployment. This identifies bottlenecks and ensures the backend can handle production load.

## Security and Cost Principles

- Never hardcode API keys or secrets; all must be in environment variables stored securely in Supabase
- Always validate all input server-side. Never rely solely on frontend validation
- Keep URLs simple and avoid exposing sensitive information
- Use parameterized queries to prevent SQL injection
- Keep logic simple—if something is overcomplicated, simplify it
- Implement rate limiting strictly to prevent cost overruns
- Log all security-relevant events for audit trails

## Database Modifications and Schema Changes

**When modifying or creating database schema, migrations, or edge functions:**

You **MUST** use the superpowers skill `superpowers:subagent-driven-development` or appropriate database planning tools. Never make assumptions about database structure or relationships.

**Before any database change:**
1. Fully understand the current schema
2. Document the change in schema.md
3. Create a migration file
4. Test locally with Docker
5. Update all affected edge functions
6. Run load tests to ensure performance

## Critical Rule: Ask Clarifying Questions

**You MUST ask clarifying questions if anything is unclear.**

Never:
- Assume how something should work
- Make decisions on your own about database structure
- Implement features without full understanding
- Skip documentation or testing

Always:
- Ask clarifying questions when confused
- Request explicit confirmation before making changes
- Document all decisions and changes
- Test thoroughly before deployment

If something is unclear—ask. Do not proceed without understanding.

## Final Guidelines

Every decision must focus on:

- **Security**: Validate, sanitize, encrypt, protect
- **Performance**: Optimize queries, use indexes, cache wisely
- **Cost optimization**: Rate limiting, caching, efficient queries, minimal API calls
- **Maintainability**: Clear code, good documentation, simple architecture
- **Simplicity**: No overengineering, straightforward solutions

**Permission to Research:**

If something is unclear, you have full permission to consult official Supabase, Postgres, Deno, or other relevant documentation. Always find the best solution. Never stall due to uncertainty—consult official docs and ask clarifying questions.

**Always ensure your changes:**
- Match the production schema exactly
- Are documented in schema.md
- Are tested locally with Docker
- Follow security and cost optimization principles
- Are reviewed for performance implications

This backend must be professional, secure, performant, and cost-efficient.
