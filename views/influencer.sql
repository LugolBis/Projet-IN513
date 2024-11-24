-- Procédure créant ou remplaçant la vue Influencer
-- Vue modélisant les utilisateurs faisant parti du N%
-- des utilisateurs en fonction de leur rank

-- /!\ ATTENTION ce fichier doit être éxécuté après le fichier 'user_rank.sql'

create or replace procedure get_influencer(N in number) as
    TOTAL_USERS number;
begin
    execute immediate 'user.get_rank';

    select count(*) in TOTAL_USERS
    from Rank;

    execute immediate
    'create or replace view Influencer as
     select pseudo, rank
     from Rank
     order by rank desc
     fetch first ' || floor(TOTAL_USERS*N/100) || ' rows only';
    exception
        when OTHERS then
            if SQLCODE != -955 then
                raise;
            end if;
end;
/

grant execute on admin.get_influencer to client;