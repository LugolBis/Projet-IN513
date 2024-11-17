-- A voir si on garde cette fonctionnalitée sous forme d'un trigger ou si on l'inclue directement dans une fonction permettant d'insérer un nouveau post
create or replace trigger post_id before insert on Post for each row
declare
    NEW_ID number;
begin
    select max(idpost)+1 into NEW_ID
    from Post
    group by idpost;

    :new.idpost := NEW_ID;
end;
/

-- L'ajout de cette fonctionnalitée permet d'insérer un nouveau Post sans se préoccuper de la valeur de son 'idpost'.

/*
L'implémentation ci dessus est une implémentation assez naïve.
Elle ne prend pas en compte la suppression de posts et par extension l'optimisation des ID.

Pour remédier à ce problème on pourrait uriliser un curseur qui itère sur tous les id de la table et lorsque
l'id extrait est strictement supérieur au COMPTEUR on arrête la boucle et on l'utilise comme id d'insertion du nouveau post !

*/