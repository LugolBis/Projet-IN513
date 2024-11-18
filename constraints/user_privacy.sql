-- Encodage des données personnelles de chaque utilisateur
create or replace trigger user_privacy before insert on Users for each row
begin
    :new.mail := STANDARD_HASH(:new.mail, 'SHA256');
    :new.password := STANDARD_HASH(:new.password, 'SHA256');
    :new.IPaddress := STANDARD_HASH(:new.IPaddress, 'SHA256');
end;    
/