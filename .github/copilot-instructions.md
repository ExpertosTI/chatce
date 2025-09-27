# Chatwoot — AI contributor quick guide

This short guide helps AI coding agents be productive quickly in this repo (Rails backend + Vue 3 frontend + Enterprise overlay).

- Tech stack: Ruby on Rails (app/), Vue 3 + Vite + pnpm (app/javascript/), Tailwind CSS, Redis, Sidekiq.
- Enterprise overlay: `enterprise/` may extend or override `app/`. Always search both trees before editing core logic.

Core commands (quick):
- Setup: `bundle install && pnpm install`
- Run frontend dev server: `pnpm dev` (or `overmind start -f Procfile.dev`)
- JS tests: `pnpm test` (Vitest)
- Ruby tests: `bundle exec rspec` (RSpec)
- Lint: `pnpm eslint:fix` and `bundle exec rubocop -a`

High-value repo patterns to know:
- Centralized frontend: `app/javascript/` holds all UI code. Look for `entrypoints/*` to find widget & SDK bootstrapping.
- Widget / SDK compatibility: the live chat widget relies on global names (window.$chatwoot, chatwootSettings), iframe id `chatwoot_live_chat_widget`, and a postMessage prefix `chatwoot-widget:`. Do not rename these without a migration shim.
- i18n split: Backend locales -> `config/locales/*.yml`, Frontend locales -> `app/javascript/**/i18n/*.json` (edit `en.json`/`en.yml` primarily).
- Enterprise-aware edits: when changing controllers/services/models under `app/`, run `rg -n "ClassName|module_name|def method" app enterprise` to find mirrors.

Search tips and shortcuts:
- Find all occurrences across OSS + Enterprise: `rg -n "chatwoot|chatwoot.com|chatwoot_" app enterprise`.
- Trace usages: use `rg -n "ClassName\b"` to find definitions/usages. Grep for `prepend_mod_with` to find extension hooks.

Tests & CI notes:
- JS tests are fast and reliable: run `pnpm test` locally; CI runs Vitest with setup in `vitest.setup.js`.
- Ruby tests require a Ruby environment and Bundler. If `bundle` is missing, install via rbenv/ruby-build or use the project's Docker setup.

Coding conventions (project-specific):
- Frontend: use Vue 3 Composition API (`<script setup>`), PascalCase components, and Tailwind utility classes only (no scoped/custom CSS).
- Backend: follow RuboCop; use `lib/custom_exceptions/` for errors; prefer compact module/class defs.
- i18n: do not hardcode UI strings in templates—use i18n keys from `en.json`/`en.yml`.

When modifying data keys / persisted identifiers:
- Do NOT change Redis keys, database column names or public widget globals without a migration/compat shim. Add alias constants (see `lib/redis/redis_keys.rb`) and a frontend shim (imports in `entrypoints/*`) to preserve backwards compatibility.

Quick file examples to open first when investigating a change:
- Backend controller flow: `app/controllers/dashboard_controller.rb`
- Widget bootstrap & constants: `app/javascript/entrypoints/widget.js`, `app/javascript/widget/constants/sdkEvents.js`
- Theme & styling tokens: `theme/colors.js`, `tailwind.config.js`
- Redis keys & aliases: `lib/redis/redis_keys.rb`

If you modify core behavior, always:
1. Search both `app/` and `enterprise/` for related files.
2. Update i18n (`config/locales/en.yml` and `app/javascript/**/i18n/en.json`) if strings change.
3. Run `pnpm test` and (if possible) `bundle exec rspec` and fix failures.

If anything above is unclear or you want more examples (e.g., how the widget postMessage format looks, or a list of commonly used Redis keys), tell me which area to expand and I'll iterate.

