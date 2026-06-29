# Supabase Setup

## Migrations

Apply the SQL migrations in `supabase/migrations/` to the linked Supabase project before testing device-to-device sync.

Current scope:
- `profiles`
- `accounts`
- `cards`
- `categories`
- `goals`
- `transactions`
- base indexes
- RLS policies for per-user isolation

## Current app expectation

The Flutter app currently:
- writes local-first to Drift
- enqueues sync mutations in `sync_queue`
- pushes queued `create/update/delete` mutations when authenticated
- pulls the remote snapshot for the six tables above after sync

## Important

`budgets`, `subscriptions`, `calendar_events` and richer reconciliation are still local-only for now. The remote schema and sync layer should be expanded together when those surfaces gain real UI.
