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
create or replace trigger post_draft before update of state on Draft for each row
begin
    if :new.state = TRUE then
        add_post(:new.message, null, null);
    else
        delete from Draft where iddraft = :new.iddraft;
    end if; 
end;
/