grant usage on schema public to authenticated;

grant select, insert, update, delete on table public.profiles to authenticated;
grant select, insert, update, delete on table public.accounts to authenticated;
grant select, insert, update, delete on table public.cards to authenticated;
grant select, insert, update, delete on table public.categories to authenticated;
grant select, insert, update, delete on table public.goals to authenticated;
grant select, insert, update, delete on table public.transactions to authenticated;

revoke all on table public.profiles from anon;
revoke all on table public.accounts from anon;
revoke all on table public.cards from anon;
revoke all on table public.categories from anon;
revoke all on table public.goals from anon;
revoke all on table public.transactions from anon;

drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_insert_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;

create policy "profiles_select_own" on public.profiles
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "profiles_insert_own" on public.profiles
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "profiles_update_own" on public.profiles
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "accounts_select_own" on public.accounts;
drop policy if exists "accounts_insert_own" on public.accounts;
drop policy if exists "accounts_update_own" on public.accounts;
drop policy if exists "accounts_delete_own" on public.accounts;

create policy "accounts_select_own" on public.accounts
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "accounts_insert_own" on public.accounts
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "accounts_update_own" on public.accounts
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "accounts_delete_own" on public.accounts
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "cards_select_own" on public.cards;
drop policy if exists "cards_insert_own" on public.cards;
drop policy if exists "cards_update_own" on public.cards;
drop policy if exists "cards_delete_own" on public.cards;

create policy "cards_select_own" on public.cards
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "cards_insert_own" on public.cards
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "cards_update_own" on public.cards
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "cards_delete_own" on public.cards
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "categories_select_owned_or_system" on public.categories;
drop policy if exists "categories_insert_own" on public.categories;
drop policy if exists "categories_update_own" on public.categories;
drop policy if exists "categories_delete_own" on public.categories;

create policy "categories_select_owned_or_system" on public.categories
  for select
  to authenticated
  using (((select auth.uid()) = user_id) or user_id is null);

create policy "categories_insert_own" on public.categories
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "categories_update_own" on public.categories
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "categories_delete_own" on public.categories
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "goals_select_own" on public.goals;
drop policy if exists "goals_insert_own" on public.goals;
drop policy if exists "goals_update_own" on public.goals;
drop policy if exists "goals_delete_own" on public.goals;

create policy "goals_select_own" on public.goals
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "goals_insert_own" on public.goals
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "goals_update_own" on public.goals
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "goals_delete_own" on public.goals
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "transactions_select_own" on public.transactions;
drop policy if exists "transactions_insert_own" on public.transactions;
drop policy if exists "transactions_update_own" on public.transactions;
drop policy if exists "transactions_delete_own" on public.transactions;

create policy "transactions_select_own" on public.transactions
  for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "transactions_insert_own" on public.transactions
  for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "transactions_update_own" on public.transactions
  for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "transactions_delete_own" on public.transactions
  for delete
  to authenticated
  using ((select auth.uid()) = user_id);
