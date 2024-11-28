alter session set "_ORACLE_SCRIPT"=TRUE;

@rights/admin.sql -- Peut administrer la BD, chargé de créer les tables, les triggers, les fonctions, etc...
@rights/moderator.sql -- Modère le réseau social en lui-même
@rights/client.sql -- Role utilisateur du client classique.
