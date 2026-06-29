create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  nombre_completo text not null,
  correo text not null,
  telefono text,
  provincia text,
  rol text not null default 'pasajero' check (rol in ('pasajero', 'chofer', 'admin_empresa', 'admin_jirb')),
  empresa_id uuid,
  estado text not null default 'activo' check (estado in ('activo', 'inactivo', 'suspendido')),
  foto_url text,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "Profiles are created via trigger"
  on public.profiles for insert
  with check (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, nombre_completo, correo, telefono, provincia, rol, estado)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nombre_completo', new.raw_user_meta_data ->> 'full_name', 'Usuario'),
    new.email,
    new.raw_user_meta_data ->> 'telefono',
    new.raw_user_meta_data ->> 'provincia',
    'pasajero',
    'activo'
  );
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
