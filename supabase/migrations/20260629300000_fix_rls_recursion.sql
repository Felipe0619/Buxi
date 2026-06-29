-- Eliminar las políticas que causan recursión infinita en profiles
DROP POLICY IF EXISTS "JIRB read all profiles" ON public.profiles;
DROP POLICY IF EXISTS "JIRB update all profiles" ON public.profiles;

-- Crear función helper que lee el rol sin pasar por RLS
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT rol FROM public.profiles WHERE id = auth.uid()
$$;

-- Recrear políticas de profiles usando la función helper
CREATE POLICY "JIRB read all profiles" ON public.profiles FOR SELECT
  USING (auth.uid() = id OR public.get_my_role() = 'admin_jirb');

CREATE POLICY "JIRB update all profiles" ON public.profiles FOR UPDATE
  USING (auth.uid() = id OR public.get_my_role() = 'admin_jirb');

-- Actualizar todas las demás políticas JIRB para usar la función helper
DROP POLICY IF EXISTS "JIRB manage empresas" ON public.empresas;
CREATE POLICY "JIRB manage empresas" ON public.empresas FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB manage rutas" ON public.rutas;
CREATE POLICY "JIRB manage rutas" ON public.rutas FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB manage paradas" ON public.paradas;
CREATE POLICY "JIRB manage paradas" ON public.paradas FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB manage buses" ON public.buses;
CREATE POLICY "JIRB manage buses" ON public.buses FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB manage bus_locations" ON public.bus_locations;
CREATE POLICY "JIRB manage bus_locations" ON public.bus_locations FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB manage horarios" ON public.horarios;
CREATE POLICY "JIRB manage horarios" ON public.horarios FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB manage calificaciones" ON public.calificaciones;
CREATE POLICY "JIRB manage calificaciones" ON public.calificaciones FOR ALL
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB read favoritos" ON public.favoritos;
CREATE POLICY "JIRB read favoritos" ON public.favoritos FOR SELECT
  USING (public.get_my_role() = 'admin_jirb');

DROP POLICY IF EXISTS "JIRB read preferences" ON public.user_preferences;
CREATE POLICY "JIRB read preferences" ON public.user_preferences FOR SELECT
  USING (public.get_my_role() = 'admin_jirb');

-- También arreglar admin_empresa policies que pueden tener el mismo problema
DROP POLICY IF EXISTS "Admin empresa manage buses" ON public.buses;
CREATE POLICY "Admin empresa manage buses" ON public.buses FOR ALL
  USING (
    public.get_my_role() = 'admin_empresa'
    AND empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
  );

DROP POLICY IF EXISTS "Admin empresa manage rutas" ON public.rutas;
CREATE POLICY "Admin empresa manage rutas" ON public.rutas FOR ALL
  USING (
    public.get_my_role() = 'admin_empresa'
    AND empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
  );

DROP POLICY IF EXISTS "Admin empresa read own empresa" ON public.empresas;
CREATE POLICY "Admin empresa read own empresa" ON public.empresas FOR SELECT
  USING (
    public.get_my_role() = 'admin_empresa'
    AND id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
  );

DROP POLICY IF EXISTS "Admin empresa manage paradas" ON public.paradas;
CREATE POLICY "Admin empresa manage paradas" ON public.paradas FOR ALL
  USING (
    public.get_my_role() = 'admin_empresa'
    AND EXISTS (
      SELECT 1 FROM public.rutas
      WHERE rutas.id = paradas.ruta_id
        AND rutas.empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
    )
  );

DROP POLICY IF EXISTS "Admin empresa manage horarios" ON public.horarios;
CREATE POLICY "Admin empresa manage horarios" ON public.horarios FOR ALL
  USING (
    public.get_my_role() = 'admin_empresa'
    AND EXISTS (
      SELECT 1 FROM public.rutas
      WHERE rutas.id = horarios.ruta_id
        AND rutas.empresa_id = (SELECT empresa_id FROM public.profiles WHERE id = auth.uid())
    )
  );
