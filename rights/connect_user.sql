create or replace package auth_pkg is
    CURRENT_USER varchar2(15); -- Variable globale pour stocker le pseudo
end;
/

create or replace function C##client.connect_user
(PSEUDO in varchar2, PASSWORD in varchar2)
return number is
password_encoded varchar2(256);
begin
    select password into password_encoded
    from Users
    where pseudo = PSEUDO;

    if password_encoded = STANDARD_HASH(PASSWORD, 'SHA256') then
        auth_pkg.CURRENT_USER := PSEUDO;
        return 1;
    else
        return 0;
    end if;
end;
/