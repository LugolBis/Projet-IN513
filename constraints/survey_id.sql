-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau survey
create or replace trigger survey_id before insert on Survey for each row
declare
    NEW_ID number := 0;
    CURSOR_ID number;
    cursor c1 is select distinct idsurvey
    from Survey order by idsurvey;
begin
    open c1;
loop
    EXIT when c1%NOTFOUND or NEW_ID < CURSOR_ID;
    fetch c1 into CURSOR_ID;
    NEW_ID := NEW_ID+1;
end loop;
    close c1;
    :new.idsurvey := NEW_ID;
end;
/