<!-- Copilot instructions for contributors and AI coding agents -->
# Quick orientation — Blink Domain (for AI coding agents)

This repository contains a Laravel API backend (`back/`) and a Vue 3 + Vite frontend (`front/`).
Below are concise, actionable facts and examples created from the codebase so an AI can work reliably here.

1) Big picture
- Backend: `back/` — Laravel 12 (PHP ^8.2). API routes live in `back/routes/api.php`. Controllers are under `back/app/Http/Controllers`. Models live in `back/app/Models` (examples: `Client.php`, `Domain.php`, `User.php`).
- Frontend: `front/` — Vue 3 + Vite, Pinia, file-based routing (unplugin-vue-router). Entry: `front/src/` and Vite config at `front/vite.config.ts`.

2) How frontend ↔ backend talk
- API base is configured with `VITE_API_BASE_URL` and falls back to `/api`. See `front/src/utils/api.ts` and `front/src/composables/useApi.ts`.
- Auth endpoints: `POST /api/login` returns `{ user, access_token }` (see `back/app/Http/Controllers/AuthController.php`). Protected endpoints use the `auth:sanctum` middleware (see `routes/api.php`).

3) HTTP client + auth conventions (concrete examples)
- $api (ofetch) — `front/src/utils/api.ts` creates an ofetch instance using `VITE_API_BASE_URL` and appends `Authorization: Bearer <token>` from cookie `accessToken`.
- useApi — `front/src/composables/useApi.ts` uses `createFetch` (vueuse). It adds the same Authorization header by reading a cookie `accessToken`.
- authStore — `front/src/stores/authStore.ts` is an existing Pinia store that uses `axios`, stores token in `localStorage` under `auth_token`, and calls `http://localhost:8000/api/login` (note: this is a hard-coded localhost URL). New code should prefer `$api`/`useApi` unless you're intentionally changing auth flows.

4) Dev & test workflows (commands you can run)
- Frontend (inside `front/`):
  - Install: `npm install`
  - Dev: `npm run dev` (Vite HMR)
  - Build: `npm run build`
  - Postinstall: `npm run postinstall` (icon build + `msw init public/`)
  - MSW worker directory: `public/` (see `package.json` `msw.workerDirectory`)
- Backend (inside `back/`):
  - Install PHP deps: `composer install`
  - Quick dev: `composer dev` runs a concurrently command that starts `php artisan serve`, `php artisan queue:listen`, and `npm run dev` (see `back/composer.json` scripts -> `dev`).
  - Typical one-off backend commands: `php artisan migrate`, `php artisan key:generate`, `php artisan test`.

5) Project-specific conventions and patterns
- File-based routes: the frontend uses `unplugin-vue-router` (see `vite.config.ts`). Route names are generated and converted to kebab-case by the plugin hook in `vite.config.ts`.
- Auto-imports / components: many utilities, composables and components are auto-imported — check `vite.config.ts` -> `AutoImport` and `Components` plugin sections and `dirs` arrays.
- API endpoints use kebab-case resource names (example: `client-contacts`, `client/categories` are defined in `routes/api.php`). Use the route list in `routes/api.php` to discover available endpoints.

6) Integration points to watch for
- Sanctum: backend config in `back/config/sanctum.php` and migration for `personal_access_tokens`. Token auth is used for API protection.
- MSW: frontend mocks live under `front/src/plugins/fake-api/handlers` & `front/public/` (MSW worker). After changing API contracts, update MSW handlers and run `npm run msw:init`.

7) When making code changes, follow these concrete rules
- Prefer `$api` / `useApi` for new API requests to use the shared baseURL and centralized token injection.
- If you must use `axios` (existing code does), match the current `authStore` pattern (store token in `localStorage` and set `axios.defaults.headers.common['Authorization']`).
- When adding new backend endpoints, update `routes/api.php` and the corresponding controller under `back/app/Http/Controllers`. Match naming and response shape (login returns `access_token`).

8) Useful reference files (examples)
- Frontend API utils: `front/src/utils/api.ts`, `front/src/composables/useApi.ts`
- Frontend auth store: `front/src/stores/authStore.ts`
- Vite config & aliases: `front/vite.config.ts` (see alias map and auto-import dirs)
- Backend routes & auth controller: `back/routes/api.php`, `back/app/Http/Controllers/AuthController.php`
- Composer scripts: `back/composer.json` (notice the `dev` script that composes backend+frontend)

If any of these areas need clarification or you want me to unify the auth flow (cookie vs localStorage) or convert axios users to `$api`/`useApi`, tell me which approach to take and I will open a PR with the changes and tests.
