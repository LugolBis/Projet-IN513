-- R24 : Quel est le brouillon le plus récent que j'ai rédigé ?
create or replace function get_last_draft return number as
    RESULT number(5);
begin
    select max(iddraft) into RESULT
    from Draft
    where pseudo = lower(user);

    return RESULT;
end;
/

-- R25 : Quel est la proportion de messages envoyés/reçus entre [moi] et l'utilisateur [TARGET_USER] ?
create or replace function get_longest_draft return varchar2 as
    RESULT varchar2(280) := '';
begin
    select message into RESULT
    from Draft
    order by length(message) desc
    fetch first 1 rows only;

    return RESULT;
end;
/

-- Droits d'éxécution des procédures/fonctions :
grant execute on get_last_draft to client, moderator;
grant execute on get_longest_draft to client, moderator;