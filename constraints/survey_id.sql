-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau post
create or replace trigger survey_id before insert on Survey for each row
declare
    NEW_ID number;
begin
    select max(idsurvey)+1 into NEW_ID
    from Survey
    group by idsurvey;

    :new.idsurvey := NEW_ID;
end;
/