-- Un utilisateur ne peut pas se suivre lui même
alter table Follow add constraint follow_self check (pseudo!=follower);

-- Un utilisateur ne peut pas s'envoyer de message privé à lui même
create or replace trigger recipient_self before insert on Receive for each row
declare
    SENDER varchar2(15);
    RECIPIENT number;
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
        end if;

        RAISE_APPLICATION_ERROR(-20030, '' || :new.pseudo || ' tried to send a private message to himself.');
    end if;
end;
/

-- Un utilisateur ne peut pas upvoter/downvoter ses propres posts
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

-- Unicité du mail de chaque utilisateur
create or replace trigger mail_unicity before insert on Users for each row
declare
    MAIL_EXIST varchar2(15);
begin
    select mail into MAIL_EXIST
    from Users
    where mail = :new.mail;

    if MAIL_EXIST != 'null' then
        RAISE_APPLICATION_ERROR(-20030, 'Violation of email unicity. Mail : ' || :new.pseudo || ' already used.');
    end if;
end;
/