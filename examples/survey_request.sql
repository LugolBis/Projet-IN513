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
create or replace function survey_result(TARGET_OPTION in varchar2, TARGET_SURVEY in varchar2)
return number as
    RESULT number(3);
begin
    select count(*) into RESULT
    from Options O, Survey S
    where O.idsurvey = S.idsurvey
    and O.content = TARGET_OPTION
    and S.question = TARGET_SURVEY
    group by O.idoption;

    return RESULT;
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

-- Droits d'éxécution des procédures/fonctions :
grant execute on survey_with_word to client, moderator;
grant execute on survey_option to client, moderator;
grant execute on survey_result to client, moderator;
grant execute on survey_tendance to client, moderator;
grant execute on survey_option_number to client, moderator;