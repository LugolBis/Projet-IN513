-- Gère les droits de l'utilisateur en fonction de l'état de son banissement
create or replace trigger ban_user after update of ban_end on Users for each row
begin
    if :new.ban_end is null then
        if lower(user) = 'moderator' then
		    execute immediate 'grant client to ' || :new.pseudo;
        end if;
    else
        if current_date < :new.ban_end then
            execute immediate 'revoke client from ' || :new.pseudo;
        else
            execute immediate 'grant client to ' || :new.pseudo;
        end if;
    end if;
end;
/