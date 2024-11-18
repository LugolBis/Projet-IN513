-- Un draft est posté, puis supprimé
create or replace trigger post_draft before delete on Draft for each row
begin
    insert into Post values(0, :old.message, SYSDATE, null, null, :old.pseudo);
end;
/