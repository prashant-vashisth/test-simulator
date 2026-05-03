# Test Simulator – Vashisth Family Learning Platform

A fullscreen, gamified test-practice web app for Ayanna, Aarvi & Adhrit Vashisth.  
Supports NWEA MAP, Math Olympiad, and Science Olympiad preparation for grades K–12.

---

## Architecture

```
test-simulator/
├── frontend/      React 18 + TypeScript + Vite + Tailwind CSS
├── backend/       FastAPI + SQLAlchemy 2.0 (async) + PostgreSQL
├── pipeline/      Python CLI to load questions from Excel
├── database/      SQL schema, seed data, migration files
└── .github/       CI / CD workflow (GitHub Actions → Render)
```

---

## Quick Start (Local Development)

### Prerequisites
- Node.js 20+
- Python 3.12+
- A Supabase project (or any PostgreSQL 15+ instance)

### 1. Clone & configure

```bash
git clone https://github.com/<your-org>/test-simulator.git
cd test-simulator
cp .env.example .env
# Edit .env – fill in DATABASE_URL, SUPABASE_URL, etc.
```

### 2. Set up the database

Run in Supabase SQL editor **or** any `psql` client:

```bash
psql "$DATABASE_URL" -f database/schema.sql
psql "$DATABASE_URL" -f database/seed_data.sql
```

Or using the single migration file:

```bash
cd database && psql "$DATABASE_URL" -f migrations/001_initial.sql
```

### 3. Start the backend

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
# → http://localhost:8000/docs
```

### 4. Start the frontend

```bash
cd frontend
npm install
npm run dev
# → http://localhost:5173
```

---

## Loading Questions (Excel Pipeline)

### Create a blank template

```bash
cd pipeline
pip install -r requirements.txt
python main.py create-template --out templates/unprocessed/my_questions.xlsx
```

### Fill in the template

Open the generated `.xlsx`. Fill from **row 4** onward:

| Column | Values |
|---|---|
| `test_type` | `nwea_map` / `math_olympiad` / `science_olympiad` |
| `subject` | `math` / `reading` / `language` / `science` / `comp_math` / `algebra` / `geometry` / `life_sci` / `earth_sci` / `phys_sci` / `tech_eng` |
| `grade` | `K` / `1` / `2` … `12` |
| `topic` | Free text (auto-created if new) |
| `question` | Question text (can be very long) |
| `passage` | Optional reading passage / context |
| `type` | `single` or `multiple` |
| `difficulty` | `easy` / `medium` / `hard` |
| `points` | Integer (default 1) |
| `explanation` | Post-answer explanation (optional) |
| `option_a` … `option_e` | Option text (A and B required) |
| `correct` | `A` or `A,C` for multi-select |

### Load into the database

```bash
# Load a single file
python main.py load --file templates/unprocessed/my_questions.xlsx

# Load all files in a folder
python main.py load --dir templates/unprocessed/

# Validate without writing
python main.py validate --file templates/unprocessed/my_questions.xlsx

# Dry run (shows what would happen)
python main.py load --file templates/unprocessed/my_questions.xlsx --dry-run
```

Re-running load is safe – existing questions (matched by topic + question text) are updated, not duplicated.

---

## Hosting (100% Free Forever)

| Service | Role | Free Tier |
|---|---|---|
| **Supabase** | PostgreSQL database | 500 MB storage, 2 GB bandwidth/month |
| **Render.com** | Backend API + Frontend | Free web service + free static site |
| **UptimeRobot** | Keeps backend awake | Free, pings every 5 min (50 monitors) |
| **GitHub** | Source code + CI/CD | Free |

> **render.yaml** intentionally omits `plan:` for the backend — Render's Blueprint rejects the string `"free"` but will let you pick the Free plan in the dashboard during setup.

---

### Step-by-step Deployment

#### 1. Database — Supabase

1. Create a project at [supabase.com](https://supabase.com).
2. Go to **SQL Editor** and run (in order):
   - `database/schema.sql`
   - `database/seed_data.sql`
3. Note down from **Settings → Database**:
   - **Connection string (URI)** — change `postgresql://` to `postgresql+asyncpg://`
4. Note down from **Settings → API**:
   - **Service Role Key** (backend only, keep secret)
   - **Anon public key** (frontend)

#### 2. Push to GitHub

```bash
git remote add origin https://github.com/<your-username>/test-simulator.git
git push -u origin main
```

#### 3. Deploy on Render (both services)

1. Go to [render.com](https://render.com) → **New → Blueprint**.
2. Connect your GitHub repo — Render reads `render.yaml` and shows both services.
3. For the **backend** service, when prompted to choose a plan, select **Free**.
4. Set environment variables for both services:

**Backend** (`test-simulator-api`):
```
DATABASE_URL              = postgresql+asyncpg://postgres:<pw>@db.<project-id>.supabase.co:5432/postgres
SUPABASE_URL              = https://<project-id>.supabase.co
SUPABASE_SERVICE_ROLE_KEY = <service-role-key>
ALLOWED_ORIGINS           = https://test-simulator-frontend.onrender.com
ENVIRONMENT               = production
```

**Frontend** (`test-simulator-frontend`):
```
VITE_API_BASE_URL      = https://test-simulator-api.onrender.com
VITE_SUPABASE_URL      = https://<project-id>.supabase.co
VITE_SUPABASE_ANON_KEY = <anon-key>
```

5. Click **Apply** — both services deploy automatically.

#### 4. Keep backend alive with UptimeRobot

Render's free web services sleep after 15 minutes of inactivity. UptimeRobot pings them awake:

1. Log in to [uptimerobot.com](https://uptimerobot.com).
2. Click **Add New Monitor**:
   - **Monitor Type**: HTTP(s)
   - **Friendly Name**: Test Simulator API
   - **URL**: `https://test-simulator-api.onrender.com/health`
   - **Monitoring Interval**: 5 minutes
3. Click **Create Monitor** — done.

The `/health` endpoint returns `{"status": "ok"}` instantly, costs no DB call, and keeps the service warm.

---

## Features

| Feature | Details |
|---|---|
| Parent lock | Password: `JaiShriRam@01` (stored client-side) |
| Child profiles | Ayanna, Aarvi, Adhrit – support for photo avatars |
| Test types | NWEA MAP (K–12), Math Olympiad (3–12), Science Olympiad (3–12) |
| Fullscreen mode | Locks test to fullscreen; warns on tab switch (3 strikes) |
| Text-to-speech | Auto-enabled for K–2 (Web Speech API, speaker button) |
| Question types | Single-choice and multi-select |
| Progressive difficulty | Questions sorted easy → medium → hard within session |
| Topic coverage | Questions drawn proportionally from all topics |
| Performance tracking | Score, per-topic accuracy, last 5 attempts, recommendations |
| Answer review | Post-test review with correct answers + explanations |
| Excel pipeline | Load unlimited questions via formatted `.xlsx` files |

---

## Adding Child Photos

1. Upload the photo to Supabase Storage (bucket: `avatars`) or any public URL.
2. Run the pipeline update or call the API:

```bash
curl -X PATCH https://your-app-xxxx.koyeb.app/api/v1/children/<child-uuid> \
  -H "Content-Type: application/json" \
  -d '{"avatar_url": "https://..."}'
```

Or use the Supabase table editor to update `children.avatar_url` directly.

---

## Database Portability

The schema uses standard PostgreSQL – no Supabase-specific features (functions/extensions used: `uuid-ossp`, `pg_trgm` – both available on any Postgres instance).

To migrate to a different host:

```bash
# Dump data
pg_dump --data-only --inserts "$OLD_DATABASE_URL" > backup.sql

# Restore on new host
psql "$NEW_DATABASE_URL" -f database/schema.sql
psql "$NEW_DATABASE_URL" -f backup.sql
```

---

## Tech Stack

- **Frontend**: React 18, TypeScript, Vite, Tailwind CSS 3, React Query 5, Zustand 5, React Router 6
- **Backend**: FastAPI, SQLAlchemy 2.0 (async), asyncpg, Pydantic v2, Uvicorn
- **Database**: PostgreSQL 15+ (Supabase)
- **Pipeline**: Python 3.12, pandas, openpyxl, Click, psycopg2
- **CI/CD**: GitHub Actions → Render.com
