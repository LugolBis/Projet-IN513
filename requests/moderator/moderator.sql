-- R28 : Quelle est l'adresse IP de pseudo ?
create or replace function get_IPadress(TARGET_USER in varchar2)
return varchar2 as
    RESULT varchar2(15) := '';
begin
    select IPaddress into RESULT
    from Users
    where pseudo = TARGET_USER;

    return RESULT;
end;
/

-- Droits d'éxécution des procédures/fonctions :
grant execute on get_IPadress to moderator;