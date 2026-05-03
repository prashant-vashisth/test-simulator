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

## Hosting (Free Tier)

| Service | Role | Free Tier |
|---|---|---|
| **Supabase** | PostgreSQL database | 500 MB, 50 MB transfer/month |
| **Render.com** | Backend API (web service) | 750 hrs/month, sleeps after 15 min idle |
| **Render.com** | Frontend (static site) | Unlimited |
| **GitHub** | Source code + CI/CD | Free |

### Deploy to Render

1. Push this repo to GitHub.
2. On [render.com](https://render.com), click **New → Blueprint** and connect your GitHub repo.  
   Render will detect `render.yaml` and create both services automatically.
3. Set environment variables in Render dashboard (see `.env.example`).
4. For automatic deploys: add your Render deploy hook URLs as GitHub repository variables  
   `RENDER_BACKEND_HOOK` and `RENDER_FRONTEND_HOOK`.

### Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com).
2. Copy the **Database URL** (Settings → Database → Connection string – URI mode with **asyncpg**).
3. Copy the **Service Role Key** (Settings → API).
4. Run the SQL migration files in Supabase SQL Editor.

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
curl -X PATCH https://your-api.onrender.com/api/v1/children/<child-uuid> \
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
