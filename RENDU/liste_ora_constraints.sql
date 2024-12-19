select 
uc.table_name,
uc.constraint_name,
uc.constraint_type,
ucc.column_name,
ucc.position,
uc.search_condition as constraint_body
from user_constraints uc left join user_cons_columns ucc
on uc.constraint_name = ucc.constraint_name and uc.table_name = ucc.table_name
where uc.table_name in ('USERS', 'POST', 'SURVEY', 'OPTIONS', 'PRIVATEMESSAGE', 'RECEIVE', 'FOLLOW', 'DRAFT', 'VOTE', 'SIGNAL', 'ANSWER', 'HASHTAG', 'HASHASHTAG')
order by uc.table_name, uc.constraint_type, uc.constraint_name;