-- Droits d'exécution des Fonctions / Procédures utilisées par le role client :

-- activities :

grant execute on is_post_cooldown_up to client, moderator;
grant execute on add_hashtag to client, moderator;
grant execute on parse_hashtags to client, moderator;
grant execute on new_idpost to client, moderator;
grant execute on new_idsurvey to client, moderator;
grant execute on new_idoption to client, moderator;
grant execute on update_location to client, moderator;
grant execute on add_post to client, moderator;
grant execute on validate_draft to client, moderator;
grant execute on add_vote to client, moderator;

-- hashtag :

grant execute on get_proportion_hashtag to client, moderator;
grant execute on max_frequency_hashtag to client, moderator;
grant execute on get_hashtag_day to client, moderator;

-- message_thread :

grant execute on get_proportion_message to client, moderator;
grant execute on new_id_private_message to client, moderator;
grant execute on send_message to client, moderator;

-- survey :

grant execute on add_survey to client, moderator;
grant execute on add_option to client, moderator;
grant execute on add_answer to client, moderator;
grant execute on survey_result to client, moderator;

-- users :

grant execute on get_average_rank_post to client, moderator;
grant execute on get_linked_user to client, moderator;

-- views/grades :
grant execute on get_user_count to client, moderator;