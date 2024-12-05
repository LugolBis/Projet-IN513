
-- R19 : Quels sont les sondages contenant [mot] dans sa question ?
select *
from Survey
where REGEXP_LIKE(question, 'Élection', 'i') = TRUE;

-- R20 : Quels sont les sondages contenant [mot] dans ces options ?
-- Procedure instable
select *
from Survey
where idsurvey in (
    select idsurvey
    from Options
    where REGEXP_LIKE(content, 'Oui', 'i') = TRUE
);

-- R21 : Quel est le pourcentage d'utilisateurs ayant choisi cette [option] à cette [question] ?
create or replace function survey_result(TARGET_OPTION in varchar2, TARGET_SURVEY in number)
return number as
    VOTED number(3);
    TOTAL_VOTERS number(7);
begin
    select count(*) into VOTED
    from Options O, Survey S
    where O.idsurvey = S.idsurvey
    and O.content = TARGET_OPTION
    and S.idsurvey = TARGET_SURVEY
    group by O.idoption;

    select count(*) into TOTAL_VOTERS
    from Options O, Survey S
    where O.idsurvey = S.idsurvey
    and S.idsurvey = TARGET_SURVEY;

    return VOTED/TOTAL_VOTERS;
end;
/

-- R22 : Quels sont les sondages contenant le plus de votants ?
select S.idsurvey, S.question, S.idpost, count(*) as nb_voters
from Options O, Survey S
where O.idsurvey = S.idsurvey
group by S.idsurvey
order by nb_voters desc;

-- R23 : Quels sont les sondages contenant [N] options ?
select S.idsurvey, S.question, S.idpost
from Options O, Survey S
where O.idsurvey = S.idsurvey
group by S.idsurvey
having count(distinct O.idoption) = 2;