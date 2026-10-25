# Galactic Spacefarer Adventure

SAP CAP (Node.js) backend with a Fiori elements List Report and Object Page for managing galactic spacefarers.

## Features

- **Data model**: `Spacefarers` with stardust collection, wormhole navigation skill, origin planet and spacesuit color, plus associations to `Planets`, `Departments` and `Positions`.
- **CAP service** (`/spacefarer`) with full CRUD and draft handling (`@odata.draft.enabled`).
- **Event handlers** (`srv/service.js`):
  - `before CREATE`: validates the wormhole navigation skill (1-100), stardust (not negative) and the email format, sets defaults and adds a +50 stardust bonus for skill >= 80. The user can only create spacefarers for their own planet.
  - `before UPDATE`: only stardust collection and spacesuit color may be changed on existing spacefarers (server-side check against the stored values).
  - `after CREATE`: reads the saved record back and sends a welcome email to the new spacefarer (nodemailer with `jsonTransport`, so the email is printed to the console instead of being sent).
- **Fiori elements app** (`app/spacefarers`):
  - List Report with sorting, filtering and pagination (filters: origin planet, department, spacesuit color).
  - Object Page for viewing and editing.
  - Origin planet, department and position are selected from dropdowns (value helps backed by `Planets`, `Departments`, `Positions`).
  - Email is mandatory, as the welcome mail is sent to it.
  - On existing spacefarers only stardust collection and spacesuit color are editable (`@Core.Immutable` + server-side check). All fields can be filled in when creating.
  - The creation dialog shows mandatory fields and fields with default values, the remaining fields can be edited on the Object Page after creation.

## Getting started

```bash
npm install
cds deploy --to sqlite:db.sqlite
cds watch
```

Open the app:

http://localhost:4004/com.antal.galactic.spacefarers/index.html?sap-ui-language=en

Alternative Fiori preview: http://localhost:4004/$fiori-preview/SpacefarerService/Spacefarers

The welcome email appears in the `cds watch` console after saving a new spacefarer (look for `Welcome mail:`).

## Local users (mocked authentication)

| User    | Password  | Role      | Planet  |
|---------|-----------|-----------|---------|
| antonie | antonie15 | Commander | Mars    |
| bluey   | bluey     | Commander | Plutoin |
| diego   | diego     | Viewer    | Mars    |

- `Commander`: create, edit, delete.
- `Viewer`: read only. The Create/Edit buttons may be visible, but the actions are rejected with `403 Forbidden`.

## Security

- The service requires an authenticated user (`requires: 'authenticated-user'`).
- Role-based access with `@restrict` (`Viewer`, `Commander`).
- Planet isolation: a user only sees spacefarers whose `originPlanet_code` matches the `planet` attribute of the user (`$user.planet`). The filter is added to the database query by CAP, so data of other planets is not just hidden in the UI. UPDATE and DELETE are restricted the same way, and creation is limited to the user's own planet in `before CREATE`.
- In production (SAP BTP) the mocked users would be replaced by XSUAA or IAS: roles via role collections, the `planet` attribute via an attribute definition in `xs-security.json`.

## Database

File-based SQLite (`db.sqlite`) for local development. `cds deploy` creates the database and loads the CSV seed data from `db/data`. Changes made in the UI persist across restarts. Delete `db.sqlite` and redeploy to reset to the seed data (also needed after schema changes). In production SAP HANA Cloud would be used.

## Project structure

| Path | Content |
|------|---------|
| `db/schema.cds` | Data model |
| `db/data/*.csv` | Seed data |
| `srv/service.cds` | Service definition and authorization |
| `srv/service.js` | `before` / `after` event handlers |
| `app/spacefarers` | Fiori elements application and UI annotations |

## Design decisions / possible improvements

- Email uses `jsonTransport` for demo purposes. In production an SMTP server or the BTP Destination service would be used.
- With drafts, `before CREATE` runs on Save. Instant field validation could be added in a `PATCH` handler on the draft.
- The `after CREATE` handler reads the saved record back by ID, because with draft activation the handler parameter may not contain all fields.