create or replace function private.contact_sync_charroleass_to_char() returns trigger as $$
declare
  datatype text;
  id integer;
  state boolean;
begin

  -- set variables
  
  if ( TG_OP  = 'INSERT' ) then
    datatype := private.get_charrole_type_name(new.charroleass_charrole_id);
    id := new.charroleass_char_id;
    state := true;
  elseif ( TG_OP = 'DELETE' ) then
    datatype := private.get_charrole_type_name(old.charroleass_charrole_id);
    id := old.charroleass_char_id;
    state := false;
  else
    raise exception 'Operation % not supported', TG_OP;
  end if;

  -- update table
  
  if ( datatype = 'Contact' ) then

    -- disable trigger on inverse side to avoid recursion

    alter table public.char disable trigger "contact_sync_char_to_charroleass";
    
    update public.char set
      char_contacts = state
    where ( char_id = id );

    -- clean up

    alter table public.char enable trigger "contact_sync_char_to_charroleass";

  end if;

  return new;
  
end;
$$ language 'plpgsql';
