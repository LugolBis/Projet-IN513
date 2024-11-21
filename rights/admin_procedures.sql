create or replace procedure add_user(pseudo IN varchar, mail IN varchar, password in VARCHAR) as
begin
	insert into Users values (pseudo, null, null, mail, 'unknown', null, null, null);
	execute immediate 'create user ' || pseudo || ' identified by ' || password;
	execute immediate 'grant Client to ' || pseudo; 
end;
/
