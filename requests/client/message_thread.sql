-- R26 : Quelles sont mes dernières discussions privées ?
select distinct pseudo
from(
	select a.pseudo as pseudo, a.date_send
	from (
		select recipient as pseudo, date_send
		from admin.MyMessages
		where sender = lower(user)
		union
		select sender as pseudo, date_send
		from admin.MyMessages
		where recipient = lower(user)
	) a
	order by a.date_send
);

-- R27 : Quelle est la proportion de messages envoyés/reçus entre [moi] et l'utilisateur [TARGET_USER] ?
create or replace function get_proportion_message(TARGET_USER in varchar2)
return number as
    total_messages number(6);
    total_send number(6);
begin
    select count(*) into total_messages
    from Receive R, PrivateMessage PM
    where R.idpm = PM.idpm
    and (
        (R.pseudo = lower(user) and PM.sender = TARGET_USER)
        or (R.pseudo = TARGET_USER and PM.sender = lower(user))
    )
    group by R.idpm;

    select count(*) into total_send
    from Receive R, PrivateMessage PM
    where R.idpm = PM.idpm
    and R.pseudo = TARGET_USER and PM.sender = lower(user)
    group by R.idpm;

    if total_messages < 1 then
        return 0;
    else
        return (total_send*100)/total_messages;
    end if;
end;
/

create or replace function new_id_private_message return number AS
	RESULT number(6);
begin
	select NVL(max(idpm)+1, 0) into RESULT
	from PrivateMessage;

	return RESULT;
end;
/

create or replace procedure send_message(msg IN varchar, recipients_csv IN varchar) as
	new_id number(6)      := new_id_private_message;
	field_index number(6) := 0;
	current varchar(1)    := '';
	buffer varchar(64)    := '';

begin

	insert into PrivateMessage values (new_id, msg, current_date, lower(user));

	-- Pour chaque champ du CSV, on insert dans Receive.

	-- On itère sur chaque caractère du CSV.
	for j in 1..length(recipients_csv) loop

		current := substr(recipients_csv, j, 1);

		-- Fin d'un champ
		if current = ',' then
			dbms_output.put_line('new receive : {'||new_id||','||buffer||'}');

			insert into Receive values (new_id, buffer);
			buffer := '';
			field_index := field_index + 1; 
		else
			buffer := buffer || current;
		end if;

	end loop;
	
	dbms_output.put_line('buffer : '||buffer);
	-- On envoie le dernier champ si le CSV de se finit pas par ','
	if length(buffer) > 0 then
		dbms_output.put_line('new receive : {'||new_id||','||buffer||'}');
		insert into Receive values (new_id, buffer);
	end if;

end;
/