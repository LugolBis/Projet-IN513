-- /!\ Attention ! On ne peut pas donner les droits sur les
--     procédures ici car les utilisateurs sont crées avant
--	   les procédures dans l'ordre d'execution spécifié dans
--	   le README.md. Je les ai déplacé à la fin de "rights/client_procedures.sql"

create role client;
grant create session to client;
grant create view to client;

-- Droits de sélection sur certaines tables :
grant select on Post to client, moderator;
grant select on Survey to client, moderator;
grant select on Options to client, moderator;
grant select on Follow to client, moderator;
grant select on Vote to client, moderator;
grant select on Hashtag to client, moderator;
grant select on HasHashtag to client, moderator;

-- Utilisateurs test, normalement les utilisateurs doivent
-- être crées par l'admin.
call add_user('jean', 'jean@jean.fr', 'pasteque');
call add_user('lola', 'lola@lola.fr', 'kiwi');
