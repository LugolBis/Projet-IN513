-- On empêche les utilisateur de voter pour leurs propres posts
create or replace trigger vote_self before insert on Vote for each row
declare
    POST_PSEUDO varchar2(15);
begin
    select pseudo into POST_PSEUDO
    from Post
    where idpost = :new.idpost;
    if :new.pseudo = POST_PSEUDO then
        RAISE_APPLICATION_ERROR(-20030, '' || :new.pseudo || ' tried to vote his own post');
    end if;
end;
/

-- On empêche les utilisateurs de voter pour un post qui n'existe pas
create or replace trigger vote_real before insert on Vote for each row
declare
    RESULT number(1);
begin
    select count(*) into RESULT
    from Post
    where idpost = :new.idpost
    group by idpost;

    if RESULT != 1 then
        RAISE_APPLICATION_ERROR(-20030, '' || :new.pseudo || ' tried to vote to a non-existent post.');
    end if;
end;
/

-- On empêche les utilisateurs de s'envoyer des messages à eux même
create or replace trigger recipient_self before insert on Receive for each row
declare
    SENDER varchar2(15);
    RECIPIENT number(5);
begin
    select sender into SENDER
    from PrivateMessage
    where idpm = :new.idpm;

    if SENDER = :new.pseudo then
        select count(*) into RECIPIENT
        from Receive
        where idpm = :new.idpm
        group by pseudo;

        if RECIPIENT = 0 then
            delete from PrivateMessage where idpm = :new.idpm;
            RAISE_APPLICATION_ERROR(-20030, '' || :new.pseudo || ' tried to send a private message to himself.');
        end if;
    end if;
end;
/

-- Un draft est posté, puis supprimé
create or replace trigger post_draft after update of state on Draft for each row
begin
    if :new.state = TRUE then
        add_post(:new.message, null, null);
        delete from Draft where iddraft = :new.iddraft;
    else
        delete from Draft where iddraft = :new.iddraft;
    end if; 
end;
/

-- On ajoute un utilisateur de la BD à chaque insertion dans la table Users
create or replace trigger user_creation before insert on Users for each row
declare
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    execute immediate 'alter session set "_oracle_script" = true';
    execute immediate 'create user ' || :new.pseudo || ' identified by ' || 'changeme';
    execute immediate 'grant client to ' || :new.pseudo;
end;
/

-- Insertion automatique des hashtags d'un post
create or replace trigger extract_hashtags after insert on Post for each row
begin
    admin.parse_hashtags(:new.idpost, :new.message);
end;
/
