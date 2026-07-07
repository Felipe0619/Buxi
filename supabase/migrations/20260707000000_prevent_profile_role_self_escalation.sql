-- Cierra una escalada de privilegios en public.profiles.
--
-- La política "Users can update their own profile" (migración inicial) permite
-- a un usuario actualizar CUALQUIER columna de su propio perfil, incluida `rol`.
-- Sin esta protección, un pasajero autenticado podía hacer
--   update profiles set rol = 'admin_jirb' where id = auth.uid()
-- y tomar control total de la plataforma. Las políticas RLS son permisivas
-- (se combinan con OR), así que las reglas más estrictas no lo impedían.
--
-- Este trigger impide que un usuario cambie su propio `rol` o `empresa_id`,
-- salvo que YA sea admin_jirb. Los flujos legítimos NO se ven afectados:
--   * un admin (jirb o empresa) que cambia el rol de OTRO usuario al crear un
--     chofer / admin_empresa -> auth.uid() <> new.id, no se bloquea.
--   * el service_role (edge functions) y el SQL editor corren sin JWT
--     -> auth.uid() es null, no se bloquea.
--
-- Falla en cerrado: si el rol no se puede determinar, se trata como no-jirb.

create or replace function public.prevent_self_role_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (new.rol is distinct from old.rol
      or new.empresa_id is distinct from old.empresa_id)
     and auth.uid() = new.id
     and coalesce(public.get_my_role(), '') <> 'admin_jirb'
  then
    raise exception 'No autorizado: no puedes cambiar tu propio rol o empresa';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_prevent_self_role_change on public.profiles;

create trigger trg_prevent_self_role_change
  before update on public.profiles
  for each row
  execute function public.prevent_self_role_change();
