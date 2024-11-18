-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau survey
create or replace trigger survey_id before insert on Survey for each row
declare
    NEW_ID number := 0;
begin
    select max(idpost)+1 into NEW_ID
    from Post
    group by idpost;
    :new.idpost := NEW_ID;
end;
/