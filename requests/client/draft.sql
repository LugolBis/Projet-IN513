-- R24 : Quel est le brouillon le plus récent que j'ai rédigé ?
select message
from MyDraft
fetch first 1 rows only;

-- R?? : Quel est le draft (brouillon) le plus long que j'ai rédigé ?
select message
from MyDraft
where length(message) = (select max(length(message)) from MyDraft);