alter session set "_ORACLE_SCRIPT"=TRUE;

@users/admin.sql -- Peut administrer la BD, chargé de créer les tables, les triggers, les fonctions, etc...
@users/moderator.sql -- Modère le réseau social en lui-même
@users/client.sql -- Role utilisateur du client classique.
