-- Procédure créant ou remplaçant la vue Tendance
-- Vue modélisant les hashtags (tendance) des 7 derniers jours

create or replace procedure get_tendance as
begin
   execute immediate
   'create or replace view Tendance as
    select HH.hashtag, count(HH.idpost) as nb_posts
    from HasHashtag HH, Post P
    where P.idpost=HH.idpost and P.date_post>=(SYSDATE-7)
    group by HH.hashtag
    order by nb_posts desc 
    fetch first 10 rows only;';
   exception
      when OTHERS then
         if SQLCODE != -955 then
            raise;
         end if;
end;
/

/*
DEPRECATED

create view Tendance as
select HH.hashtag, count(HH.idpost) as nb_posts
from HasHashtag HH, Post P
where P.idpost=HH.idpost and P.date_post>=(SYSDATE-7)
group by HH.hashtag
order by nb_posts desc 
fetch first 10 rows only;
*/