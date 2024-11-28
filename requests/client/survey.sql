-- /!\ DEPENCANCE : Le script suivant à besoin de la fonction 'word_parser' 
-- (inclue dans @examples/post_request)

-- R19 : Quels sont les sondages contenant [mot] dans sa question ?
-- Procedure instable
create or replace procedure survey_with_word(WORD in varchar2) as
begin
    execute immediate
    'select *
     from Survey
     where word_parser(question, ''' || WORD || ''') = TRUE';
end;
/

-- R20 : Quels sont les sondages contenant [mot] dans ces options ?
-- Procedure instable
create or replace procedure survey_option(WORD in varchar2) as
begin
    execute immediate
    'select *
     from Survey
     where idsurvey in (
         select idsurvey
         from Options
         where word_parser(content, ''' || WORD || ''') = TRUE
     )';
end;
/

-- R21 : Quel est le pourcentage d'uilisateur ayant choisi cette [option] à cette [question] ?
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
create or replace procedure survey_tendance as
begin
    execute immediate
    'select S.idsurvey, S.question, S.idpost, count(*) as nb_voters
     from Options O, Survey S
     where O.idsurvey = S.idsurvey
     group by S.idsurvey
     order by nb_voters desc';
end;
/

-- R23 : Quels sont les sondages contenant [N] options ?
create or replace procedure survey_option_number(N in number) as
begin
    execute immediate
    'select S.idsurvey, S.question, S.idpost
     from Options O, Survey S
     where O.idsurvey = S.idsurvey
     group by S.idsurvey
     having count(distinct O.idoption) = ' || N;
end;
/