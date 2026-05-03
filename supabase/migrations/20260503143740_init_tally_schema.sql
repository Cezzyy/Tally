-- Initial Schema

create type ticket_status as enum ('backlog', 'in_progress', 'done');
create type ticket_priority as enum ('low', 'medium', 'high', 'urgent');

create table tickets (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  ticket_number bigint not null,
  title text not null check (char_length(trim(title)) > 0),
  description text default '' not null,
  status ticket_status default 'backlog' not null,
  priority ticket_priority default 'medium' not null,
  due_date timestamptz,
  is_archived boolean default false not null,
  archived_at timestamptz,
  user_id uuid references auth.users(id) on delete cascade not null,
  unique(user_id, ticket_number)
);

create table checklist_items (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  ticket_id uuid references tickets(id) on delete cascade not null,
  task text not null check (char_length(trim(task)) > 0),
  is_completed boolean default false not null,
  completed_at timestamptz,
  display_order int default 0 not null,
  user_id uuid references auth.users(id) on delete cascade not null
);

create index idx_tickets_user_id on tickets(user_id);
create index idx_tickets_status on tickets(status);
create index idx_tickets_priority on tickets(priority);
create index idx_tickets_created_at on tickets(created_at desc);
create index idx_tickets_user_status on tickets(user_id, status);
create index idx_tickets_user_archived on tickets(user_id, is_archived);
create index idx_tickets_due_date on tickets(due_date) where due_date is not null;

create index idx_checklist_items_ticket_id on checklist_items(ticket_id);
create index idx_checklist_items_user_id on checklist_items(user_id);
create index idx_checklist_items_display_order on checklist_items(ticket_id, display_order);
create index idx_checklist_items_completed on checklist_items(is_completed);

create or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create or replace function update_completed_at_column()
returns trigger as $$
begin
  if new.is_completed = true and old.is_completed = false then
    new.completed_at = now();
  elsif new.is_completed = false and old.is_completed = true then
    new.completed_at = null;
  end if;
  return new;
end;
$$ language plpgsql;

create or replace function update_archived_at_column()
returns trigger as $$
begin
  if new.is_archived = true and old.is_archived = false then
    new.archived_at = now();
  elsif new.is_archived = false and old.is_archived = true then
    new.archived_at = null;
  end if;
  return new;
end;
$$ language plpgsql;

create or replace function get_next_ticket_number(p_user_id uuid)
returns bigint as $$
declare
  next_number bigint;
begin
  select coalesce(max(ticket_number), 0) + 1
  into next_number
  from tickets
  where user_id = p_user_id;
  return next_number;
end;
$$ language plpgsql;

create or replace function assign_ticket_number()
returns trigger as $$
begin
  if new.ticket_number is null then
    new.ticket_number := get_next_ticket_number(new.user_id);
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trigger_tickets_updated_at
  before update on tickets
  for each row
  execute function update_updated_at_column();

create trigger trigger_tickets_archived_at
  before update on tickets
  for each row
  execute function update_archived_at_column();

create trigger trigger_tickets_assign_number
  before insert on tickets
  for each row
  execute function assign_ticket_number();

create trigger trigger_checklist_items_updated_at
  before update on checklist_items
  for each row
  execute function update_updated_at_column();

create trigger trigger_checklist_items_completed_at
  before update on checklist_items
  for each row
  execute function update_completed_at_column();

alter table tickets enable row level security;
alter table checklist_items enable row level security;

create policy "Users can view their own tickets"
  on tickets for select
  using (auth.uid() = user_id);

create policy "Users can insert their own tickets"
  on tickets for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own tickets"
  on tickets for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own tickets"
  on tickets for delete
  using (auth.uid() = user_id);

create policy "Users can view their own checklist items"
  on checklist_items for select
  using (auth.uid() = user_id);

create policy "Users can insert their own checklist items"
  on checklist_items for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own checklist items"
  on checklist_items for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own checklist items"
  on checklist_items for delete
  using (auth.uid() = user_id);

alter publication supabase_realtime add table tickets;
alter publication supabase_realtime add table checklist_items;
