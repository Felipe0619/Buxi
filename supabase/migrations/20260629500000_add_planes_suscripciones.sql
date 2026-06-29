-- Planes disponibles
create table if not exists public.planes (
  id uuid default gen_random_uuid() primary key,
  nombre text not null unique,
  max_buses integer not null,
  max_rutas integer not null,
  gps_intervalo_seg integer not null default 10,
  precio_mensual numeric(10,2) not null default 0,
  descripcion text,
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

-- Suscripciones de cada empresa
create table if not exists public.suscripciones (
  id uuid default gen_random_uuid() primary key,
  empresa_id uuid not null references public.empresas(id) on delete cascade,
  plan_id uuid not null references public.planes(id),
  fecha_inicio date not null default current_date,
  fecha_fin date,
  estado text not null default 'activa' check (estado in ('activa', 'vencida', 'cancelada', 'prueba')),
  auto_renovar boolean not null default true,
  created_at timestamptz not null default now(),
  unique(empresa_id)
);

alter table public.planes enable row level security;
alter table public.suscripciones enable row level security;

create policy "Public read planes" on public.planes for select using (true);
create policy "JIRB manage planes" on public.planes for all
  using (public.get_my_role() = 'admin_jirb');

create policy "JIRB manage suscripciones" on public.suscripciones for all
  using (public.get_my_role() = 'admin_jirb');
create policy "Admin empresa read own sub" on public.suscripciones for select
  using (
    empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
  );

-- Insertar los 3 planes
insert into public.planes (id, nombre, max_buses, max_rutas, gps_intervalo_seg, precio_mensual, descripcion) values
  ('d0000000-0000-0000-0000-000000000001', 'Básico', 10, 5, 15, 0, 'Hasta 10 buses, 5 rutas, GPS cada 15 segundos'),
  ('d0000000-0000-0000-0000-000000000002', 'Pro', 50, 999, 5, 0, 'Hasta 50 buses, rutas ilimitadas, GPS cada 5 segundos'),
  ('d0000000-0000-0000-0000-000000000003', 'Enterprise', 9999, 9999, 3, 0, 'Sin límites, soporte dedicado, API personalizada')
on conflict do nothing;

-- Asignar plan Básico a las empresas existentes
insert into public.suscripciones (empresa_id, plan_id, estado)
select e.id, 'd0000000-0000-0000-0000-000000000001', 'activa'
from public.empresas e
where not exists (select 1 from public.suscripciones s where s.empresa_id = e.id)
on conflict do nothing;
