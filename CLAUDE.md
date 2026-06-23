# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**IM_CC_REST** is a full-stack character creation wizard for the Imperium Maledictum tabletop RPG (Warhammer 40K). It is a monorepo with a Java Spring Boot backend and a React frontend.

## Commands

### Backend (from `backend/`)
```bash
cd ./backend
/mvnw spring-boot:run     # Start API server on port 8081
/mvnw clean install       # Build (also runs tests)
/mvnw test                # Run tests only
/mvnw test -Dtest=ImCcApplicationTests  # Run a single test class
```

### Frontend (from `frontend/`)
```bash
cd ./frontend
npm start        # Dev server on port 3000
npm test         # Run Jest tests (interactive)
npm run build    # Production build
```

### Prerequisites
- PostgreSQL running on `localhost:5432` (database: `postgres`, user: `postgres`, password: `123`)
- Java 25, Node.js

## Architecture

### Data Flow
```
React (port 3000) → Spring Boot REST API (port 8081) → PostgreSQL
```

The frontend uses a **wizard pattern** across 7 pages. State is accumulated in `CharacterContext` (reducer-based, see `frontend/src/context/CharacterContext.js`) and posted as a `CharacterCreationModel` DTO to `POST /api/summary`, which returns a fully computed `SummaryResponseDTO` (character sheet).

### Backend Structure (`backend/src/main/java/portfolio/example/im_cc/`)
- **`controllers/api/`** — One controller per resource. `SummaryApiController` is the core: it takes the wizard payload and returns the rendered character sheet.
- **`services/`** — Business logic. `SummaryServiceImpl` assembles the full character sheet from chosen origin/faction/role/characteristics.
- **`models/`** — JPA entities (70+ domain types). Key DTOs: `CharacterCreationModel` (wizard input), `CharacterSheetDTO` (sheet output), `SummaryResponseDTO` (full API response).
- **`repositories/`** — Spring Data JPA repositories (one per entity).
- **`config/WebConfig.java`** — CORS: allows all methods from `localhost:3000` and `localhost:5173`.

Database schema is managed by Hibernate (`ddl-auto=update`). Game data is seeded via SQL scripts in `backend/src/main/resources/sql/`.

### Frontend Structure (`frontend/src/`)
- **`api/api.js`** — Axios client; all calls go to `http://localhost:8081/api`.
- **`context/CharacterContext.js`** — Global state (characteristics, origin, faction, role, skills, details). Actions: `SET_CHARACTERISTICS`, `SET_ORIGIN`, `SET_FACTION`, `SET_ROLE`, `SET_DETAILS`, `RESTORE`.
- **`pages/`** — One component per wizard step: `CharacteristicsPage → OriginsPage → FactionsPage → RolesPage → DetailsPage → SummaryPage`.
- **`styles/theme.css`** — Design system using CSS custom properties; supports light/dark via `data-theme` attribute. Theme: dark sci-fi, fonts Cinzel (headings) / EB Garamond (body), primary accent `#085d65`.

### Wizard Flow
1. **IndexPage** — Create new character or load existing by 6-char code
2. **CharacteristicsPage** — Pick base stat bonuses
3. **OriginsPage** — Choose origin (provides stat bonuses + inventory)
4. **FactionsPage** — Choose faction (provides skills, talents, equipment)
5. **RolesPage** — Choose role (specializations, abilities)
6. **DetailsPage** — Name, appearance, backstory
7. **SummaryPage** — Full rendered character sheet; save/print

### Key API Endpoints
| Method | Path | Purpose |
|--------|------|---------|
| GET | `/api/characteristics` | Characteristic options |
| GET | `/api/origins` | Origin list |
| GET | `/api/factions` | Faction list |
| GET | `/api/roles` | Role list |
| GET | `/api/equipment-packs` | Equipment packs |
| POST | `/api/summary` | Build character sheet from `CharacterCreationModel` |
| POST | `/api/character/save[?code=XXX]` | Save or update character |
| GET | `/api/character/load/{code}` | Load character by code |
| POST | `/api/bug-report` | Submit bug report |

## Key Domain Concepts

- **Origin/Faction/Role** each provide "choice groups" (`ChoiceOption` entities) — players pick from options at each step.
- **Skills** link to characteristics and have **Specializations** as sub-types.
- **CharacterSheetDTO** aggregates stats, skills (with advances), talents, mutations, weapons, armor, equipment, and combat stats (wounds, corruption, fate points).
- Character save/load uses a 6-character alphanumeric code stored in the database.