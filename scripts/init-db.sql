-- Active l'extension pgvector
create extension if not exists vector;

-- Création de la table users
create table if not exists public.users (
  id uuid references auth.users on delete cascade not null primary key,
  email text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  subscription_status text check (subscription_status in ('active', 'inactive', 'cancelled')) default 'inactive',
  subscription_id text
);

-- Création de la table documents avec support vectoriel modifié pour 3072 dimensions
create table if not exists public.documents (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  content text not null,
  embedding vector(3072),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  type text check (type in ('pdf', 'word', 'excel', 'json', 'xml')) not null
);

-- Création de la table conversations
create table if not exists public.conversations (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.users on delete cascade not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Création de la table messages
create table if not exists public.messages (
  id uuid default uuid_generate_v4() primary key,
  conversation_id uuid references public.conversations on delete cascade not null,
  content text not null,
  role text check (role in ('user', 'assistant')) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Activation de la sécurité niveau ligne (RLS)
alter table public.users enable row level security;
alter table public.documents enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;

-- Création des politiques de sécurité
create policy "Users can read their own data"
  on public.users for select
  using (auth.uid() = id);

create policy "Allow read access to all documents"
  on public.documents for select
  to authenticated
  using (true);

create policy "Users can read their own conversations"
  on public.conversations for select
  using (auth.uid() = user_id);

create policy "Users can read messages from their conversations"
  on public.messages for select
  using (
    conversation_id in (
      select id from public.conversations 
      where user_id = auth.uid()
    )
  );