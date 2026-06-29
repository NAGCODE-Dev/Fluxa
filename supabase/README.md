# Supabase Setup

## Migrations

Apply all SQL migrations in `supabase/migrations/` to the linked Supabase project before testing device-to-device sync.

Current scope:
- `profiles`
- `accounts`
- `cards`
- `categories`
- `goals`
- `transactions`
- base indexes
- RLS policies for per-user isolation
- explicit grants for the Data API on authenticated sessions

## Current app expectation

The Flutter app currently:
- writes local-first to Drift
- enqueues sync mutations in `sync_queue`
- pushes queued `create/update/delete` mutations when authenticated
- pulls the remote snapshot for the six tables above after sync

## Important

`budgets`, `subscriptions`, `calendar_events` and richer reconciliation are still local-only for now. They should not be synced to Supabase until the remote schema is expanded together with the app sync layer.

If the app shows `PGRST205` or `Could not find the table 'public.profiles' in the schema cache`, the remote project is missing these migrations or the Data API grants were not applied yet.
