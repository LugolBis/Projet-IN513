-- Supression de la vue
begin
   EXECUTE IMMEDIATE 'DROP VIEW Tendance';
EXCEPTION
   when OTHERS then
        if SQLCODE != -942 then
         RAISE;
        end if;
end;
/

create view Tendance as
select HH.hashtag, count(HH.idpost) as nb_posts
from HasHashtag HH, Post P
where P.idpost=HH.idpost and P.date_post>=(SYSDATE-7)
group by HH.hashtag
order by order_datetime desc 
fetch first 10 rows only;