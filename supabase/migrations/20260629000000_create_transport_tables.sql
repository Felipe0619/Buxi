-- Empresas de transporte
create table if not exists public.empresas (
  id uuid default gen_random_uuid() primary key,
  nombre text not null,
  cedula_juridica text unique,
  telefono text,
  email text,
  direccion text,
  logo_url text,
  estado text not null default 'activo' check (estado in ('activo', 'inactivo')),
  created_at timestamptz not null default now()
);

-- Rutas de autobuses
create table if not exists public.rutas (
  id uuid default gen_random_uuid() primary key,
  empresa_id uuid not null references public.empresas(id) on delete cascade,
  nombre text not null,
  descripcion text,
  origen text not null,
  destino text not null,
  color text default '#00c853',
  estado text not null default 'activa' check (estado in ('activa', 'inactiva')),
  created_at timestamptz not null default now()
);

-- Paradas de cada ruta (puntos del recorrido)
create table if not exists public.paradas (
  id uuid default gen_random_uuid() primary key,
  ruta_id uuid not null references public.rutas(id) on delete cascade,
  nombre text not null,
  latitud double precision not null,
  longitud double precision not null,
  orden integer not null,
  created_at timestamptz not null default now()
);

-- Autobuses
create table if not exists public.buses (
  id uuid default gen_random_uuid() primary key,
  empresa_id uuid not null references public.empresas(id) on delete cascade,
  ruta_id uuid references public.rutas(id) on delete set null,
  placa text not null unique,
  numero_unidad text,
  capacidad integer default 40,
  chofer_id uuid references public.profiles(id) on delete set null,
  estado text not null default 'inactivo' check (estado in ('activo', 'inactivo', 'en_ruta', 'mantenimiento')),
  created_at timestamptz not null default now()
);

-- Ubicaciones en tiempo real de los buses
create table if not exists public.bus_locations (
  id uuid default gen_random_uuid() primary key,
  bus_id uuid not null references public.buses(id) on delete cascade,
  latitud double precision not null,
  longitud double precision not null,
  velocidad double precision default 0,
  heading double precision default 0,
  timestamp timestamptz not null default now()
);

-- Índice para consultas rápidas de ubicación por bus
create index if not exists idx_bus_locations_bus_id on public.bus_locations(bus_id);
create index if not exists idx_bus_locations_timestamp on public.bus_locations(timestamp desc);

-- Habilitar realtime en bus_locations
alter publication supabase_realtime add table public.bus_locations;

-- RLS policies
alter table public.empresas enable row level security;
alter table public.rutas enable row level security;
alter table public.paradas enable row level security;
alter table public.buses enable row level security;
alter table public.bus_locations enable row level security;

-- Lectura pública para pasajeros (datos de rutas y buses son públicos)
create policy "Public read empresas" on public.empresas for select using (true);
create policy "Public read rutas" on public.rutas for select using (true);
create policy "Public read paradas" on public.paradas for select using (true);
create policy "Public read buses" on public.buses for select using (true);
create policy "Public read bus_locations" on public.bus_locations for select using (true);

-- Choferes pueden insertar ubicaciones de su bus asignado
create policy "Chofer insert location" on public.bus_locations for insert
  with check (
    exists (
      select 1 from public.buses
      where buses.id = bus_id and buses.chofer_id = auth.uid()
    )
  );

-- Admin empresa puede gestionar sus propios recursos
create policy "Admin empresa manage buses" on public.buses for all
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
        and profiles.rol = 'admin_empresa'
        and profiles.empresa_id = buses.empresa_id
    )
  );

create policy "Admin empresa manage rutas" on public.rutas for all
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
        and profiles.rol = 'admin_empresa'
        and profiles.empresa_id = rutas.empresa_id
    )
  );

create policy "Admin empresa manage paradas" on public.paradas for all
  using (
    exists (
      select 1 from public.rutas
      join public.profiles on profiles.id = auth.uid()
      where rutas.id = paradas.ruta_id
        and profiles.rol = 'admin_empresa'
        and profiles.empresa_id = rutas.empresa_id
    )
  );
