library(tidyverse)

reddit_files_raw <-
    list.files('../../reddit/initial_analysis/nba_comments_repo/',
               pattern = '2020\\-02') %>%
    str_c('../../reddit/initial_analysis/nba_comments_repo/', .) %>%
    map(read_rds) %>%
    bind_rows()

reddit_post_conversations <-
    reddit_files_raw %>%
    mutate(permalink =
               str_remove(permalink, '/r/nba/comments/')) %>%
    #select(permalink) %>%
    separate(permalink,
             into = c('parent_post_id',
                      'parent_post_description',
                      'child_id'),
             sep = '/') %>%
    group_by(parent_post_id) %>%
    mutate(comment_cnt = n()) %>%
    filter(comment_cnt >= 18 &
               comment_cnt <= 210) %>%
    summarise(total_txt =
                  str_c(body, collapse = '\n'))

write_rds(reddit_post_conversations, 'reddit_post_conversations.rds')
