-- Procedure pour ajouter un nouveau Survey
create or replace procedure add_survey(QUESTION in varchar, ID_POST in number) as
begin 
    insert into Survey values(new_idsurvey, QUESTION, ID_POST);
end;
/

-- Procedure pour ajouter une nouvelle Option à un Survey
create or replace procedure add_option(CONTENT in varchar, ID_SURVEY in number) as
begin 
    insert into Options values(new_idoption, CONTENT, ID_SURVEY);
end;
/

-- Procedure pour répondre a un Survey
create or replace procedure add_answer(ID_OPTION in number) as
begin
    insert into Answer values(lower(user), ID_OPTION);
end;
/

-- R19 : Quels sont les sondages contenant [mot] dans sa question ?
select *
from Survey
where REGEXP_LIKE(question, 'genant', 'i') = TRUE;

-- R20 : Quels sont les sondages contenant [mot] dans ces options ?
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
select S.idsurvey, S.question, S.idpost, NVL(RES.rank, 0) as rank 
from Survey S
left join (
    select O.idsurvey as id, count(*) as rank
    from Answer A 
    left join Options O on A.idoption = O.idoption
    group by O.idsurvey
) RES
on S.idsurvey = RES.id
order by rank desc;

-- R23 : Quels sont les sondages contenant [N] options ?
select *
from Survey
where idsurvey in (
    select idsurvey
    from Options
    group by idsurvey
    having count(distinct idoption) = 2
);