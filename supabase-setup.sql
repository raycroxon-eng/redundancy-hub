-- Redundancy Hub: run once in Supabase → SQL Editor → New query → Run.
-- One row per signed-in user holds that user's jobs, package and documents.

create table if not exists public.hub_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

-- Only the signed-in owner can see or change their row.
alter table public.hub_state enable row level security;

create policy "Owner can read"   on public.hub_state for select using (auth.uid() = user_id);
create policy "Owner can insert" on public.hub_state for insert with check (auth.uid() = user_id);
create policy "Owner can update" on public.hub_state for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Owner can delete" on public.hub_state for delete using (auth.uid() = user_id);
