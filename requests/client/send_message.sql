create or replace procedure send_message(msg IN varchar, recipients_csv IN varchar) as
	new_id number(6)      := 0;
	nbr_pm number(6)      := 0;
	field_index number(6) := 0;
	current varchar(1)    := '';
	buffer varchar(64)    := '';

begin
	
	-- On vérifie qu'au moins un PrivateMessage existe.
	
	select count(idpm) into nbr_pm from PrivateMessage;

	if nbr_pm > 0 then
		select max(idpm)+1 into new_id from PrivateMessage;
	end if;

	dbms_output.put_line('new message : {'||new_id||','||msg||','||lower(user)||'}');
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