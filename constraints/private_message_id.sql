-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau PrivateMessage
create or replace trigger private_message_id before insert on PrivateMessage for each row
declare
    NEW_ID number := 0;
begin
    select max(idpm)+1 into NEW_ID
    from PrivateMessage
    group by idpm;
    :new.idpm := NEW_ID;
end;
/