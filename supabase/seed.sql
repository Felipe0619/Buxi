-- Empresas de transporte de Costa Rica
insert into public.empresas (id, nombre, cedula_juridica, telefono, email, estado) values
  ('a1000000-0000-0000-0000-000000000001', 'TUASA', '3-101-000001', '2222-0000', 'info@tuasa.cr', 'activo'),
  ('a1000000-0000-0000-0000-000000000002', 'Lumaca', '3-101-000002', '2233-0000', 'info@lumaca.cr', 'activo'),
  ('a1000000-0000-0000-0000-000000000003', 'Transportes San José - San Pedro', '3-101-000003', '2244-0000', 'info@tssp.cr', 'activo'),
  ('a1000000-0000-0000-0000-000000000004', 'MUSOC', '3-101-000004', '2222-2422', 'info@musoc.cr', 'activo'),
  ('a1000000-0000-0000-0000-000000000005', 'Transportes Heredianos', '3-101-000005', '2261-0000', 'info@theredianos.cr', 'activo')
on conflict do nothing;

-- Rutas principales del GAM
insert into public.rutas (id, empresa_id, nombre, descripcion, origen, destino, color, estado) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'San José - Alajuela', 'Ruta principal entre San José y Alajuela por autopista General Cañas', 'San José Centro', 'Alajuela Centro', '#00c853', 'activa'),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'San José - Alajuela (Turrúcares)', 'Ruta alterna por Turrúcares y La Garita', 'San José Centro', 'Alajuela Centro', '#2196f3', 'activa'),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000005', 'San José - Heredia', 'Ruta directa entre San José y Heredia', 'San José Centro', 'Heredia Centro', '#ff9800', 'activa'),
  ('b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000003', 'San José - San Pedro', 'Ruta UCR y alrededores de San Pedro', 'San José Centro', 'San Pedro', '#9c27b0', 'activa'),
  ('b1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000002', 'San José - Cartago', 'Ruta expresa San José a Cartago por autopista Florencio del Castillo', 'San José Centro', 'Cartago Centro', '#f44336', 'activa'),
  ('b1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000004', 'San José - San Isidro del General', 'Ruta interurbana al sur por Cerro de la Muerte', 'San José Centro', 'San Isidro de El General', '#607d8b', 'activa'),
  ('b1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000001', 'Alajuela - Aeropuerto Juan Santamaría', 'Ruta corta entre Alajuela centro y el aeropuerto', 'Alajuela Centro', 'Aeropuerto SJO', '#00bcd4', 'activa'),
  ('b1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000005', 'Heredia - Barva', 'Ruta local Heredia a Barva y San Pedro de Barva', 'Heredia Centro', 'Barva', '#795548', 'activa')
on conflict do nothing;

-- Paradas de la ruta San José - Alajuela
insert into public.paradas (ruta_id, nombre, latitud, longitud, orden) values
  ('b1000000-0000-0000-0000-000000000001', 'Terminal Alajuela (San José)', 9.9347, -84.0797, 1),
  ('b1000000-0000-0000-0000-000000000001', 'Hospital México', 9.9445, -84.1003, 2),
  ('b1000000-0000-0000-0000-000000000001', 'La Uruca', 9.9521, -84.1120, 3),
  ('b1000000-0000-0000-0000-000000000001', 'Firestone', 9.9618, -84.1357, 4),
  ('b1000000-0000-0000-0000-000000000001', 'Río Segundo', 9.9782, -84.1542, 5),
  ('b1000000-0000-0000-0000-000000000001', 'Alajuela Centro', 10.0162, -84.2116, 6);

-- Paradas de la ruta San José - Heredia
insert into public.paradas (ruta_id, nombre, latitud, longitud, orden) values
  ('b1000000-0000-0000-0000-000000000003', 'Calle 1, Ave 7-9 (San José)', 9.9357, -84.0783, 1),
  ('b1000000-0000-0000-0000-000000000003', 'Tibás', 9.9558, -84.0830, 2),
  ('b1000000-0000-0000-0000-000000000003', 'Santo Domingo', 9.9770, -84.0893, 3),
  ('b1000000-0000-0000-0000-000000000003', 'Heredia Centro', 9.9985, -84.1196, 4);

-- Paradas de la ruta San José - San Pedro
insert into public.paradas (ruta_id, nombre, latitud, longitud, orden) values
  ('b1000000-0000-0000-0000-000000000004', 'Ave Central (San José)', 9.9328, -84.0773, 1),
  ('b1000000-0000-0000-0000-000000000004', 'Cuesta de Moras', 9.9320, -84.0680, 2),
  ('b1000000-0000-0000-0000-000000000004', 'Fuente de la Hispanidad', 9.9350, -84.0520, 3),
  ('b1000000-0000-0000-0000-000000000004', 'UCR / San Pedro', 9.9370, -84.0440, 4);

-- Paradas de la ruta San José - Cartago
insert into public.paradas (ruta_id, nombre, latitud, longitud, orden) values
  ('b1000000-0000-0000-0000-000000000005', 'Terminal Lumaca (San José)', 9.9270, -84.0750, 1),
  ('b1000000-0000-0000-0000-000000000005', 'Zapote', 9.9220, -84.0620, 2),
  ('b1000000-0000-0000-0000-000000000005', 'Curridabat', 9.9130, -84.0430, 3),
  ('b1000000-0000-0000-0000-000000000005', 'Tres Ríos', 9.9050, -84.0120, 4),
  ('b1000000-0000-0000-0000-000000000005', 'Taras', 9.8890, -83.9720, 5),
  ('b1000000-0000-0000-0000-000000000005', 'Cartago Centro', 9.8640, -83.9194, 6);

-- Buses de ejemplo
insert into public.buses (id, empresa_id, ruta_id, placa, numero_unidad, capacidad, estado) values
  ('c1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'SJB-001', 'Unidad 101', 45, 'activo'),
  ('c1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'SJB-002', 'Unidad 102', 45, 'activo'),
  ('c1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003', 'HRD-001', 'Unidad 201', 40, 'activo'),
  ('c1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004', 'SPD-001', 'Unidad 301', 35, 'activo'),
  ('c1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000005', 'CTG-001', 'Unidad 401', 50, 'activo'),
  ('c1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000005', 'CTG-002', 'Unidad 402', 50, 'activo')
on conflict do nothing;
