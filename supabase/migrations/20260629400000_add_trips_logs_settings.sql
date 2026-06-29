-- Historial de viajes completados por choferes
create table if not exists public.viajes (
  id uuid default gen_random_uuid() primary key,
  bus_id uuid not null references public.buses(id) on delete cascade,
  chofer_id uuid not null references public.profiles(id) on delete cascade,
  ruta_id uuid not null references public.rutas(id) on delete cascade,
  inicio timestamptz not null,
  fin timestamptz,
  estado text not null default 'en_curso' check (estado in ('en_curso', 'completado', 'cancelado')),
  distancia_km double precision default 0,
  created_at timestamptz not null default now()
);

alter table public.viajes enable row level security;
create policy "Public read viajes" on public.viajes for select using (true);
create policy "Chofer manage own viajes" on public.viajes for all
  using (auth.uid() = chofer_id);
create policy "JIRB manage viajes" on public.viajes for all
  using (public.get_my_role() = 'admin_jirb');
create policy "Admin empresa read viajes" on public.viajes for select
  using (
    public.get_my_role() = 'admin_empresa'
    AND EXISTS (
      SELECT 1 FROM public.buses
      WHERE buses.id = viajes.bus_id
        AND buses.empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
    )
  );

-- Logs de actividad del sistema
create table if not exists public.activity_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete set null,
  accion text not null,
  detalle text,
  entidad text,
  entidad_id uuid,
  created_at timestamptz not null default now()
);

alter table public.activity_logs enable row level security;
create policy "JIRB read all logs" on public.activity_logs for all
  using (public.get_my_role() = 'admin_jirb');

-- Configuración global del sistema
create table if not exists public.system_config (
  key text primary key,
  value text not null,
  description text,
  updated_at timestamptz not null default now()
);

alter table public.system_config enable row level security;
create policy "Public read config" on public.system_config for select using (true);
create policy "JIRB manage config" on public.system_config for all
  using (public.get_my_role() = 'admin_jirb');

-- Insertar configuración por defecto
insert into public.system_config (key, value, description) values
  ('gps_refresh_seconds', '5', 'Intervalo de refresco GPS del chofer en segundos'),
  ('max_speed_kmh', '80', 'Velocidad máxima permitida para alertas'),
  ('operating_hours_start', '04:00', 'Hora de inicio de operaciones'),
  ('operating_hours_end', '23:00', 'Hora de fin de operaciones'),
  ('eta_enabled', 'true', 'Mostrar tiempo estimado de llegada'),
  ('maintenance_alert_km', '10000', 'Kilómetros para alerta de mantenimiento')
on conflict do nothing;

-- Índices
create index if not exists idx_viajes_chofer on public.viajes(chofer_id);
create index if not exists idx_viajes_bus on public.viajes(bus_id);
create index if not exists idx_viajes_ruta on public.viajes(ruta_id);
create index if not exists idx_activity_logs_created on public.activity_logs(created_at desc);
