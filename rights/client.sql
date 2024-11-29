-- /!\ Attention ! On ne peut pas donner les droits sur les
--     procédures ici car les utilisateurs sont crées avant
--	   les procédures dans l'ordre d'execution spécifié dans
--	   le README.md. Je les ai déplacé à la fin de "rights/client_procedures.sql"

create role client;
grant create session to client;
grant create view to client;


-- Utilisateurs test, normalement les utilisateurs doivent
-- être crées par l'admin.
call add_user('jean', 'jean@jean.fr', 'pasteque');
call add_user('lola', 'lola@lola.fr', 'kiwi');
