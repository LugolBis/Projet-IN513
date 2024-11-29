create or replace function mail_unicity(new_mail in varchar) return number as
	result number(1) := 0;
begin
	select count(*) into result
	from Users
	where mail = new_mail;
	if result > 0 then
		return 1;
	else
		return 0;
	end if;
end;
/

-- Procédure permettant l'ajout d'un nouveau post
create or replace procedure add_user(pseudo IN varchar, mail IN varchar, password in VARCHAR) as
begin
	if mail_unicity(mail) = 0 then
		insert into Users values (pseudo, null, null, mail, 'unknown', null, null, null);
		execute immediate 'create user ' || pseudo || ' identified by ' || password;
		execute immediate 'grant client to ' || pseudo;
	else
		RAISE_APPLICATION_ERROR(-20589, 'The adress mail : ' || mail || ' is already used.');
	end if;
end;
/