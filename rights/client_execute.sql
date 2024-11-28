-- Droits d'exécution des Fonctions / Procédures utilisées par le role client :

-- activities :

grant execute on is_post_cooldown_up to client, moderator;
grant execute on add_hashtag to client, moderator;
grant execute on parse_hashtags to client, moderator;
grant execute on new_idpost to client, moderator;
grant execute on update_location to client, moderator;
grant execute on add_post to client, moderator;
grant execute on validate_draft to client, moderator;

-- draft :

grant execute on get_last_draft to client, moderator;
grant execute on get_longest_draft to client, moderator;

-- hashtag :

grant execute on get_post_hashtags_tendance to client, moderator;
grant execute on get_proportion_hashtag to client, moderator;
grant execute on get_hashtag_day to client, moderator;

-- message_thread :

grant execute on get_proportion_message to client, moderator;

-- post :

grant execute on get_post_target_user to client, moderator;
grant execute on get_post_target_location to client, moderator;
grant execute on get_post_time to client, moderator;
grant execute on get_some_post to client, moderator;
grant execute on word_parser to client, moderator;
grant execute on post_with_word to client, moderator;
grant execute on post_with_hashtag to client, moderator;
grant execute on post_most_upvoted to client, moderator;
grant execute on post_most_downvoted to client, moderator;

-- survey :

grant execute on survey_with_word to client, moderator;
grant execute on survey_option to client, moderator;
grant execute on survey_result to client, moderator;
grant execute on survey_tendance to client, moderator;
grant execute on survey_option_number to client, moderator;

-- users :

grant execute on get_hashtag_used to client, moderator;
grant execute on get_average_rank_post to client, moderator;
grant execute on get_linked_user to client, moderator;
grant execute on get_mutual_follower to client, moderator;
grant execute on get_followers to client, moderator;
grant execute on get_impostors to client, moderator;
grant execute on get_fans to client, moderator;
grant execute on get_haters to client, moderator;