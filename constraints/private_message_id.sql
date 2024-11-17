-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau PrivateMessage
create or replace trigger private_message_id before insert on PrivateMessage for each row
declare
    NEW_ID number := 0;
    CURSOR_ID number;
    cursor c1 is select distinct idpm
    from PrivateMessage order by idpm;
begin
    open c1;
loop
    EXIT when c1%NOTFOUND or NEW_ID < CURSOR_ID;
    fetch c1 into CURSOR_ID;
    NEW_ID := NEW_ID+1;
end loop;
    close c1;
    :new.idpm := NEW_ID;
end;
/