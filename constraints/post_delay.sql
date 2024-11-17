-- Trigger vérifiant que le délai enytre la publication de deux posts est rescpecté

create or replace trigger post_delay before insert on Post for each row
declare
    CURRENT_TIME date := SYSDATE;
    LAST_TIME date; -- Date du dernier post de l'utilisateur
begin
    select max(date_post) into LAST_TIME
    from Post
    where pseudo = :new.pseudo;

    if LAST_TIME >= (CURRENT_TIME-(1/(24*60*60))*2) then
        update table Users set ban_end=CURRENT_TIME+1, ban_reason='Violation of the time limit between the publication of two posts.'
        where pseudo = :new.pseudo;
        RAISE_APPLICATION_ERROR(-20030, 'Violation of the time limit between the publication of two posts, user : ' || :new.pseudo);
    end if;

    :new.date_post := CURRENT_TIME;
end;
/