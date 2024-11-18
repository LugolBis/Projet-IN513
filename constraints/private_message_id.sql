-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau PrivateMessage
create or replace trigger private_message_id before insert on PrivateMessage for each row
declare
    NEW_ID number := 0;
begin
    select max(idpost)+1 into NEW_ID
    from Post
    group by idpost;
    :new.idpost := NEW_ID;
end;
/