-- R26 : Quelles sont mes dernières discussions privées ?

-- R27 : Quelle est la proportion de messages envoyés/reçus entre [moi] et l'utilisateur [TARGET_USER] ?
create or replace function get_proportion_message(TARGET_USER in varchar2)
return number as
    total_messages number(6);
    total_send number(6);
begin
    select count(*) into total_messages
    from Receive R, PrivateMessage PM
    where R.idpm = PM.idpm
    and (
        (R.pseudo = lower(user) and PM.sender = TARGET_USER)
        or (R.pseudo = TARGET_USER and PM.sender = lower(user))
    )
    group by R.idpm;

    select count(*) into total_send
    from Receive R, PrivateMessage PM
    where R.idpm = PM.idpm
    and R.pseudo = TARGET_USER and PM.sender = lower(user)
    group by R.idpm;

    if total_messages < 1 then
        return 0;
    else
        return (total_send*100)/total_messages;
    end if;
end;
/

-- Droits d'éxécution des procédures/fonctions :
grant execute on get_proportion_message to client, moderator;