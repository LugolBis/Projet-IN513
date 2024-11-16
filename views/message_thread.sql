-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW MessageThread';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/
-- Création de la vue
MessageFrom = (select PV.pseudo 
    from PrivateMessage PV, Receive R
    where R.idpm=PV.idpm and R.pseudo=&CURRENT_USER)

MessageTo = () 
create view MessageThread as (
     as MFROM;
    (select PV.pseudo 
    from PrivateMessage PV, Receive R
    where R.idpm=PV.idpm and R.pseudo=&CURRENT_USER) as MFROM;
    );