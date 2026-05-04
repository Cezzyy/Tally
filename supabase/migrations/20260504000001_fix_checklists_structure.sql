-- Fix checklist structure: separate ticket checklists from standalone checklists

-- First, drop the incorrectly created checklists table from the previous migration
drop table if exists checklists cascade;

-- Rename existing checklist_items to ticket_checklist_items to clarify it belongs to tickets
alter table checklist_items rename to ticket_checklist_items;

-- Rename indexes and constraints for ticket_checklist_items
do $$
begin
  if exists (select 1 from pg_indexes where indexname = 'idx_checklist_items_ticket_id') then
    alter index idx_checklist_items_ticket_id rename to idx_ticket_checklist_items_ticket_id;
  end if;
  
  if exists (select 1 from pg_indexes where indexname = 'idx_checklist_items_user_id') then
    alter index idx_checklist_items_user_id rename to idx_ticket_checklist_items_user_id;
  end if;
  
  if exists (select 1 from pg_indexes where indexname = 'idx_checklist_items_display_order') then
    alter index idx_checklist_items_display_order rename to idx_ticket_checklist_items_display_order;
  end if;
  
  if exists (select 1 from pg_indexes where indexname = 'idx_checklist_items_completed') then
    alter index idx_checklist_items_completed rename to idx_ticket_checklist_items_completed;
  end if;
end $$;

-- Rename triggers for ticket_checklist_items
do $$
begin
  if exists (select 1 from pg_trigger where tgname = 'trigger_checklist_items_updated_at') then
    alter trigger trigger_checklist_items_updated_at on ticket_checklist_items 
      rename to trigger_ticket_checklist_items_updated_at;
  end if;
  
  if exists (select 1 from pg_trigger where tgname = 'trigger_checklist_items_completed_at') then
    alter trigger trigger_checklist_items_completed_at on ticket_checklist_items 
      rename to trigger_ticket_checklist_items_completed_at;
  end if;
end $$;

-- Update RLS policies for ticket_checklist_items
drop policy if exists "Users can view their own checklist items" on ticket_checklist_items;
drop policy if exists "Users can insert their own checklist items" on ticket_checklist_items;
drop policy if exists "Users can update their own checklist items" on ticket_checklist_items;
drop policy if exists "Users can delete their own checklist items" on ticket_checklist_items;

create policy "Users can view their own ticket checklist items"
  on ticket_checklist_items for select
  using (auth.uid() = user_id);

create policy "Users can insert their own ticket checklist items"
  on ticket_checklist_items for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own ticket checklist items"
  on ticket_checklist_items for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own ticket checklist items"
  on ticket_checklist_items for delete
  using (auth.uid() = user_id);

-- Update realtime publication
do $$
begin
  -- Try to drop checklist_items from publication (may not exist)
  begin
    alter publication supabase_realtime drop table checklist_items;
  exception when others then
    null; -- Ignore if it doesn't exist
  end;
  
  -- Try to add ticket_checklist_items (may already exist)
  begin
    alter publication supabase_realtime add table ticket_checklist_items;
  exception when others then
    null; -- Ignore if already exists
  end;
end $$;

-- Now create the standalone checklists feature

-- Create enums for standalone checklists (if they don't exist)
do $$
begin
  if not exists (select 1 from pg_type where typname = 'checklist_status') then
    create type checklist_status as enum ('pending', 'in_progress', 'completed');
  end if;
  
  if not exists (select 1 from pg_type where typname = 'checklist_priority') then
    create type checklist_priority as enum ('low', 'medium', 'high');
  end if;
end $$;

-- Create standalone checklists table
create table checklists (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  title text not null check (char_length(trim(title)) > 0),
  description text,
  status checklist_status default 'pending' not null,
  priority checklist_priority default 'medium' not null,
  due_date timestamptz,
  is_archived boolean default false not null,
  archived_at timestamptz,
  user_id uuid references auth.users(id) on delete cascade not null
);

-- Create checklist_items table that belongs to checklists (not tickets)
create table checklist_items (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  checklist_id uuid references checklists(id) on delete cascade not null,
  task text not null check (char_length(trim(task)) > 0),
  is_completed boolean default false not null,
  completed_at timestamptz,
  display_order int default 0 not null,
  user_id uuid references auth.users(id) on delete cascade not null
);

-- Create indexes for checklists
create index idx_checklists_user_id on checklists(user_id);
create index idx_checklists_status on checklists(status);
create index idx_checklists_priority on checklists(priority);
create index idx_checklists_created_at on checklists(created_at desc);
create index idx_checklists_user_status on checklists(user_id, status);
create index idx_checklists_user_archived on checklists(user_id, is_archived);
create index idx_checklists_due_date on checklists(due_date) where due_date is not null;

-- Create indexes for checklist_items
create index idx_checklist_items_checklist_id on checklist_items(checklist_id);
create index idx_checklist_items_user_id on checklist_items(user_id);
create index idx_checklist_items_display_order on checklist_items(checklist_id, display_order);
create index idx_checklist_items_completed on checklist_items(is_completed);

-- Create triggers for checklists
create trigger trigger_checklists_updated_at
  before update on checklists
  for each row
  execute function update_updated_at_column();

create trigger trigger_checklists_archived_at
  before update on checklists
  for each row
  execute function update_archived_at_column();

-- Create triggers for checklist_items
create trigger trigger_checklist_items_updated_at
  before update on checklist_items
  for each row
  execute function update_updated_at_column();

create trigger trigger_checklist_items_completed_at
  before update on checklist_items
  for each row
  execute function update_completed_at_column();

-- Enable RLS
alter table checklists enable row level security;
alter table checklist_items enable row level security;

-- Create RLS policies for checklists
create policy "Users can view their own checklists"
  on checklists for select
  using (auth.uid() = user_id);

create policy "Users can insert their own checklists"
  on checklists for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own checklists"
  on checklists for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete their own checklists"
  on checklists for delete
  using (auth.uid() = user_id);

-- Create RLS policies for checklist_items
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

-- Enable realtime
alter publication supabase_realtime add table checklists;
alter publication supabase_realtime add table checklist_items;

-- Add comment to explain the structure
comment on table ticket_checklist_items is 'Checklist items that belong to tickets (sub-tasks for tickets)';
comment on table checklists is 'Standalone checklists (independent from tickets)';
comment on table checklist_items is 'Items that belong to standalone checklists';
