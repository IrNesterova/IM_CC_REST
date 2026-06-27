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
- **`context/CharacterContext.js`** — Global state. Actions: `SET_CHARACTERISTICS`, `SET_ORIGIN`, `SET_FACTION`, `SET_ROLE`, `SET_DETAILS`, `RESTORE`, `RESET`.
- **`pages/`** — One component per wizard step: `CharacteristicsPage → OriginsPage → FactionsPage → RolesPage → DetailsPage → SummaryPage`.
- **`styles/theme.css`** — Design system using CSS custom properties; supports light/dark via `data-theme` attribute. Theme: dark sci-fi, fonts Cinzel (headings) / EB Garamond (body), primary accent `#085d65`.

### Wizard Flow
1. **IndexPage** — Create new character (dispatches `RESET`) or load existing by 6-char code
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
| GET | `/api/factions` | Faction list with all choice groups and AM grades |
| GET | `/api/roles` | Role list with all choice groups |
| GET | `/api/equipment-packs` | Equipment packs |
| POST | `/api/summary` | Build character sheet from `CharacterCreationModel` |
| POST | `/api/character/save[?code=XXX]` | Save or update character |
| GET | `/api/character/load/{code}` | Load character by code |
| GET | `/api/me/characters` | Authenticated: list user's saved characters |
| POST | `/api/bug-report` | Submit bug report |

## Key Domain Concepts

- **Origin/Faction/Role** each provide "choice groups" — players pick from options at each step.
- **Skills** link to characteristics and have **Specializations** as sub-types.
- **CharacterSheetDTO** aggregates stats, skills (with advances), talents, mutations, weapons, armor, equipment, and combat stats (wounds, corruption, fate points).
- Character save/load uses a 6-character alphanumeric code stored in the database.
- `/api/me/**` requires authentication (Spring Security session cookie).

---

## Supplement System

Game content spans four source books, tracked via the `SourceBook` enum: `IM` (core), `IN` (Inquisition), `AM` (Adeptus Mechanicus / Assembly of Means), `MR` (Malediction Rising).

Each supplement has its own SQL seed files and frontend UI sections. The nav sidebar on FactionsPage and RolesPage groups entries by source book with distinct accent colours:
- **IM** — neutral (`var(--muted)`)
- **IN** — amber `#a07840`
- **AM** — crimson `#8b3a3a`

### AM Supplement — Faction Grade System

AM factions have an extra layer: **Augmentation Grades** (I / II / III). Each grade gives characteristic bonuses, a skill advance pool, fixed talents, fixed inventory, and its own choice groups (INVENTORY and TALENT picks).

Backend: `FactionGrade`, `FactionGradeChoiceGroup`, `FactionGradeInventoryChoice`, `FactionGradeTalentChoice` entities; loaded in `FactionServiceImpl.loadGrades()`.

Frontend: `FactionsPage.js` has dedicated state hooks for the grade UI:
- `gradeId` / `selectGrade(grade)` — selected grade
- `gradeSecondaryCharId` — dropdown pick for the grade's +5 bonus
- `gradeSkillAdvances` — `{ skillId: count }` object
- `gradeChoices` — `{ groupId: [optionIds] }` for grade choice groups

`handleSubmit` branches on `selected.sourceBook === 'AM'` to undo previous grade bonuses and apply new ones before dispatching `SET_FACTION`.

`CharacterContext` state fields for grades: `factionGradeId`, `factionGradeCharId`, `factionGradeFixedCharName`, `factionGradeFixedCharAmount`, `factionGradeCharName`, `factionGradeSkillAdvances`, `factionGradeChoices`, `_factionGradeName`.

---

## SQL Seeding

### Inventory Inheritance — Critical Rule

`Inventory` uses `@Inheritance(strategy = InheritanceType.JOINED)`. Every row in the `inventory` table **must** have a corresponding row in exactly one subtype table:

| Subtype table | Java class | Used for |
|---|---|---|
| `melee_weapon` | `MeleeWeapon` | Melee weapons |
| `ranged_weapon` | `RangedWeapon` | Ranged weapons |
| `armour` | `Armour` | Armour |
| `generic_item` | `GenericItem` | Everything else |
| `force_field` | `ForceField` | Force fields |
| `grenades_and_explosives` | `GrenadesAndExplosives` | Grenades |
| `book` | `Book` | Books |

If you insert into `inventory` without the subtype row, Hibernate throws `NullPointerException: Cannot invoke EntityPersister.getRootEntityName() because this.persister is null` when loading any list that includes that item.

**Diagnostic query**: `backend/src/main/resources/sql/find_orphan_inventory.sql` — finds all orphan rows.

### Adding New Weapon Subcategories

`InventorySubcategory` is a Java enum (`models/InventorySubcategory.java`). Adding a new subcategory value in SQL without adding it to the enum causes `IllegalArgumentException: No enum constant`. Current AM values added: `ARC`, `FLECHETTE`, `GALVANIC`, `PHOSPHOR`, `RADIUM`.

After editing the enum, restart the Spring Boot server.

### SQL File Order (AM Supplement)

```
am_orphan_hotfix.sql        ← run if am_roles_data.sql was applied before am_weapons.sql
am_roles_fix.sql            ← run if am_roles_data.sql was applied before the Omnissian Axe split
am_weapons.sql              ← all AM melee and ranged weapons
am_roles_data.sql           ← ENGINESEER role
am_roles_lexmechanic.sql    ← LEXMECHANIC role
am_roles_transmechanic.sql  ← TRANSMECHANIC role
```

### Role Seeding Pattern

Sections in order for any new role SQL file:

1. **New talents** — `INSERT INTO talent WHERE NOT EXISTS`
2. **New inventory** — insert into `inventory` + subtype table (never insert into `inventory` alone)
3. **New specializations** — link to correct skill via `skill_specializations`
4. **Role row** — `INSERT INTO role (name, source_book) WHERE NOT EXISTS`
5. **Fixed inventory** — `INSERT INTO role_inventory WHERE NOT EXISTS`
6. **Choice groups (non-INVENTORY)** — TALENT, SKILL, SPECIALIZATION groups, one INSERT each with `WHERE NOT EXISTS`
7. **Inventory choice groups** — `DO $$ ... RETURNING id INTO v_grp` block (requires PL/pgSQL; guard with `IF EXISTS ... RETURN`)
8. **Talent pool** — `DO $$ ... INSERT INTO role_talent_choice_group WHERE NOT EXISTS`
9. **Skill pool** — `DO $$ ... INSERT INTO role_skill_choice_group WHERE NOT EXISTS`
10. **Specialization pool** — `DO $$ ... INSERT INTO role_specialization_choice_group WHERE NOT EXISTS`

Key idempotency guard for inventory choice groups:
```sql
IF EXISTS (SELECT 1 FROM role_choice_group WHERE role_id = v_role_id AND choice_type = 'INVENTORY') THEN
    RETURN;
END IF;
```

Tables involved: `role_inventory`, `role_choice_group`, `role_inventory_choice_group`, `role_talent_choice_group`, `role_skill_choice_group`, `role_specialization_choice_group`.

ChoiceType enum values: `TALENT`, `INVENTORY`, `SKILL`, `SPECIALIZATION`.

---

## Known Issues & Fixes Applied

### JPA Duplicate Entities in `findByXIn` Queries

`findByFactionIn`, `findByRoleIn`, and similar bulk-load queries can return the same entity object multiple times when the entity has EAGER `@OneToMany` collections (the underlying SQL JOIN multiplies rows). This causes duplicate `key` warnings in React and corrupted list state.

**Fix applied**: `.stream().distinct().collect(Collectors.toList())` after every `findByXIn` call in:
- `FactionServiceImpl` — `allGroups` (line ~95) and `allChoiceGroups` in `loadGrades()` (line ~183)
- `RoleServiceImpl` — `allGroups` (line ~51) and `roleInventoryRepository` result (line ~47)

If a new service has the same pattern and starts showing duplicate key warnings, apply the same `.distinct()` fix.

### CSS Accent Variable

`var(--accent)` is a **background tint** (semi-transparent), not a text or border colour. Use `#085d65` directly for text/borders where the teal accent colour is needed.

### `RESET` vs `RESTORE` in CharacterContext

- `RESET` — clears everything back to `initialState` (used by "Create a character" on IndexPage)
- `RESTORE` — merges a saved payload over `initialState` (used by "Load character")