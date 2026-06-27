# Imperium Maledictum Character Creator

A full-stack web application for creating characters in the **Imperium Maledictum** tabletop RPG (Warhammer 40K). Built as a guided wizard that walks through all character creation steps and produces a complete, printable character sheet.

> My first Java project, written with Claude Code.

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java 25 · Spring Boot · Spring Data JPA · Spring Security |
| Database | PostgreSQL |
| Frontend | React · Axios · CSS custom properties |
| Auth | Session-based (email/password + Discord OAuth2) |

## Features

- Step-by-step character creation wizard (7 pages)
- Three supplement books supported: **Imperium Maledictum** (core), **Inquisition Supplement**, **Adeptus Mechanicus Supplement**
- AM faction grade system (Augmentation Level I / II / III with characteristic and skill bonuses)
- Save character to database with a 6-character code; reload anytime
- User accounts with a personal cabinet to manage saved characters
- Bug report button on every page
- Light / dark theme

## Prerequisites

- Java 25
- Node.js (18+)
- PostgreSQL running on `localhost:5432`
  - Database: `postgres`, user: `postgres`, password: `123`

## Running Locally

**Backend** (starts on port 8081):
```bash
cd backend
./mvnw spring-boot:run
```

**Frontend** (starts on port 3000):
```bash
cd frontend
npm install
npm start
```

Open `http://localhost:3000`.

## Project Structure

```
IM_CC_REST/
├── backend/
│   └── src/main/
│       ├── java/portfolio/example/im_cc/
│       │   ├── controllers/api/   — REST endpoints
│       │   ├── services/          — business logic
│       │   ├── models/            — JPA entities + enums
│       │   ├── repositories/      — Spring Data repositories
│       │   └── config/            — Security, CORS, OAuth2
│       └── resources/
│           ├── application.properties
│           └── sql/               — game data seed scripts
└── frontend/
    └── src/
        ├── api/api.js             — Axios client
        ├── context/
        │   ├── CharacterContext.js  — wizard state (reducer)
        │   └── AuthContext.js       — user session
        ├── pages/                 — one component per wizard step
        ├── components/            — Topbar, ProgressBar, etc.
        └── styles/theme.css       — design system (CSS variables)
```

## Wizard Steps

| Step | Page | What it does |
|---|---|---|
| 1 | IndexPage | Start new character or load by code |
| 2 | CharacteristicsPage | Choose base stat bonuses |
| 3 | OriginsPage | Choose origin → stat bonuses + starting inventory |
| 4 | FactionsPage | Choose faction → skills, talents, equipment |
| 5 | RolesPage | Choose role → specializations, role equipment |
| 6 | DetailsPage | Name, gender, appearance, backstory |
| 7 | SummaryPage | Full character sheet; save or print |

## Database Seeding

Game data is seeded via SQL scripts in `backend/src/main/resources/sql/`. Hibernate manages the schema (`ddl-auto=update`); the SQL files only insert game content. Scripts use `WHERE NOT EXISTS` guards and are safe to re-run.

### Supplement SQL files (run order matters)

```
# Core
characteristics_data.sql
skills_data.sql
specializations_data.sql
talents_data.sql
origins_data.sql
factions_data.sql
roles_data.sql
inventory.sql
melee_weapon.sql
ranged_weapon.sql

# Inquisition Supplement
inquisition_origins.sql
inquisition_roles_data.sql

# Adeptus Mechanicus Supplement
am_origins.sql
am_factions.sql
am_orphan_hotfix.sql      ← only if am_roles_data.sql was run before am_weapons.sql
am_roles_fix.sql          ← only if am_roles_data.sql was run before the Omnissian Axe split
am_weapons.sql
am_roles_data.sql
am_roles_lexmechanic.sql
am_roles_transmechanic.sql
```

## API Overview

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/api/origins` | — | Origins list |
| GET | `/api/factions` | — | Factions with skills, talents, grades |
| GET | `/api/roles` | — | Roles with choice groups |
| GET | `/api/characteristics` | — | Characteristic options |
| GET | `/api/equipment-packs` | — | Equipment packs |
| POST | `/api/summary` | — | Compute full character sheet |
| POST | `/api/character/save` | — | Save character (returns 6-char code) |
| GET | `/api/character/load/{code}` | — | Load character by code |
| GET | `/api/me/characters` | ✓ | List user's saved characters |
| POST | `/api/bug-report` | — | Submit bug report |