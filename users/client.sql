create role client;
grant create session to client;

--  Procédures permises
grant execute on admin.add_post to client;

-- Utilisateurs test, normalement les utilisateurs doivent
-- être crées par l'admin.
create user sama identified by pasteque;
grant client to sama;