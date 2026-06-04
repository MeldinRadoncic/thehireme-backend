# Backend Quick Start - 30 Seconds

## Start Backend (Terminal 1)
```bash
cd /Users/meldin/Documents/PROJECTS/THEHIREME/backend
supabase start
```

## Access Studio
```
http://127.0.0.1:54323
```

## API & Database
- API: http://127.0.0.1:54321
- Database: 127.0.0.1:54322 (postgres/postgres)

## Stop Backend
```bash
supabase stop
```

---

## Frontend Apps (Start After Backend)

**Terminal 2 - Admin:** `cd admin-dashboard && npm run dev` → localhost:3000  
**Terminal 3 - Worker:** `cd worker && npm run web` → localhost:19006  
**Terminal 4 - Client:** `cd client && npm run web` → localhost:19007

---

## Stuck? Clean & Restart
```bash
docker ps -a -q --filter "name=supabase" | xargs -r docker rm -f
supabase start
```

---

That's it! 🚀
