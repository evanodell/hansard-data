pacman::p_load(readr)
pacman::p_load(dplyr)
pacman::p_load(Hmisc)

system.time(
  senti_df <- read_rds("hansard_senti_post_V21.rds")
)

## By MP --------
senti_mp <- group_by(senti_df, mnis_id, proper_name)

system.time(
mp_senti_mean <- summarise(senti_mp,
                           afinn_sentiment_avg = mean(afinn_sentiment, na.rm = TRUE),
                           afinn_sd_avg = mean(afinn_sd, na.rm=TRUE),
                           afinn_sentiment_wtd = weighted.mean(x=afinn_sentiment, w=word_count, na.rm = TRUE),
                           afinn_sd_wtd = weighted.mean(afinn_sd, word_count, na.rm=TRUE),
                           jockers_sentiment_avg = mean(jockers_sentiment, na.rm = TRUE),
                           jockers_sd_avg = mean(jockers_sd, na.rm=TRUE),
                           jockers_sentiment_wtd = weighted.mean(jockers_sentiment, word_count, na.rm = TRUE),
                           jockers_sd_wtd = weighted.mean(jockers_sd, word_count, na.rm=TRUE),
                           nrc_sentiment_avg =mean(nrc_sentiment, na.rm = TRUE),
                           nrc_sd_avg = mean(nrc_sd, na.rm=TRUE),
                           nrc_sentiment_wtd = weighted.mean(nrc_sentiment, word_count, na.rm = TRUE),
                           nrc_sd_wtd = weighted.mean(nrc_sd, word_count, na.rm=TRUE),
                           sentiword_sentiment_avg =mean(sentiword_sentiment, na.rm = TRUE),
                           sentiword_sd_avg = mean(sentiword_sd, na.rm=TRUE),
                           sentiword_sentiment_wtd = weighted.mean(sentiword_sentiment, word_count, na.rm = TRUE),
                           sentiword_sd_wtd = weighted.mean(sentiword_sd, word_count, na.rm = TRUE),
                           hu_sentiment_avg =mean(hu_sentiment, na.rm = TRUE),
                           hu_sd_avg = mean(hu_sd, na.rm=TRUE),
                           hu_sentiment_wtd = weighted.mean(hu_sentiment, word_count, na.rm = TRUE),
                           hu_sd_wtd = weighted.mean(hu_sd, word_count, na.rm=TRUE),
                           rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                           rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                           rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                           rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                           tot_speeches = n_distinct(eo_id),
                           tot_words = sum(word_count)
)
)

mp_senti_mean$avg_speech_length <- mp_senti_mean$tot_words/mp_senti_mean$tot_speeches

summary(mp_senti_mean)

write_csv(mp_senti_mean, "mp-senti-mean-v21.csv")

rm(senti_mp)

## By Gender --------
senti_gender <- group_by(senti_df, gender)

system.time(
gender_senti_mean <- summarise(senti_gender,
                               afinn_sentiment_avg = mean(afinn_sentiment, na.rm = TRUE),
                               afinn_sd_avg = mean(afinn_sd, na.rm=TRUE),
                               afinn_sentiment_wtd = weighted.mean(x=afinn_sentiment, w=word_count, na.rm = TRUE),
                               afinn_sd_wtd = weighted.mean(afinn_sd, word_count, na.rm=TRUE),
                               jockers_sentiment_avg = mean(jockers_sentiment, na.rm = TRUE),
                               jockers_sd_avg = mean(jockers_sd, na.rm=TRUE),
                               jockers_sentiment_wtd = weighted.mean(jockers_sentiment, word_count, na.rm = TRUE),
                               jockers_sd_wtd = weighted.mean(jockers_sd, word_count, na.rm=TRUE),
                               nrc_sentiment_avg =mean(nrc_sentiment, na.rm = TRUE),
                               nrc_sd_avg = mean(nrc_sd, na.rm=TRUE),
                               nrc_sentiment_wtd = weighted.mean(nrc_sentiment, word_count, na.rm = TRUE),
                               nrc_sd_wtd = weighted.mean(nrc_sd, word_count, na.rm=TRUE),
                               sentiword_sentiment_avg =mean(sentiword_sentiment, na.rm = TRUE),
                               sentiword_sd_avg = mean(sentiword_sd, na.rm=TRUE),
                               sentiword_sentiment_wtd = weighted.mean(sentiword_sentiment, word_count, na.rm = TRUE),
                               sentiword_sd_wtd = weighted.mean(sentiword_sd, word_count, na.rm = TRUE),
                               hu_sentiment_avg =mean(hu_sentiment, na.rm = TRUE),
                               hu_sd_avg = mean(hu_sd, na.rm=TRUE),
                               hu_sentiment_wtd = weighted.mean(hu_sentiment, word_count, na.rm = TRUE),
                               hu_sd_wtd = weighted.mean(hu_sd, word_count, na.rm=TRUE),
                               rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                               rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                               rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                               rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                               tot_speeches = n_distinct(eo_id),
                               tot_words = sum(word_count)
)
)

gender_senti_mean$avg_speech_length <- gender_senti_mean$tot_words/gender_senti_mean$tot_speeches

summary(gender_senti_mean)

write_csv(gender_senti_mean, "gender-senti-mean-v21.csv")

rm(senti_gender)

## By Party --------
senti_party <- group_by(senti_df, party)

system.time(
party_senti_mean <- summarise(senti_party,
                              afinn_sentiment_avg = mean(afinn_sentiment, na.rm = TRUE),
                              afinn_sd_avg = mean(afinn_sd, na.rm=TRUE),
                              afinn_sentiment_wtd = weighted.mean(x=afinn_sentiment, w=word_count, na.rm = TRUE),
                              afinn_sd_wtd = weighted.mean(afinn_sd, word_count, na.rm=TRUE),
                              jockers_sentiment_avg = mean(jockers_sentiment, na.rm = TRUE),
                              jockers_sd_avg = mean(jockers_sd, na.rm=TRUE),
                              jockers_sentiment_wtd = weighted.mean(jockers_sentiment, word_count, na.rm = TRUE),
                              jockers_sd_wtd = weighted.mean(jockers_sd, word_count, na.rm=TRUE),
                              nrc_sentiment_avg =mean(nrc_sentiment, na.rm = TRUE),
                              nrc_sd_avg = mean(nrc_sd, na.rm=TRUE),
                              nrc_sentiment_wtd = weighted.mean(nrc_sentiment, word_count, na.rm = TRUE),
                              nrc_sd_wtd = weighted.mean(nrc_sd, word_count, na.rm=TRUE),
                              sentiword_sentiment_avg =mean(sentiword_sentiment, na.rm = TRUE),
                              sentiword_sd_avg = mean(sentiword_sd, na.rm=TRUE),
                              sentiword_sentiment_wtd = weighted.mean(sentiword_sentiment, word_count, na.rm = TRUE),
                              sentiword_sd_wtd = weighted.mean(sentiword_sd, word_count, na.rm = TRUE),
                              hu_sentiment_avg =mean(hu_sentiment, na.rm = TRUE),
                              hu_sd_avg = mean(hu_sd, na.rm=TRUE),
                              hu_sentiment_wtd = weighted.mean(hu_sentiment, word_count, na.rm = TRUE),
                              hu_sd_wtd = weighted.mean(hu_sd, word_count, na.rm=TRUE),
                              rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                              rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                              rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                              rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                              tot_speeches = n_distinct(eo_id),
                              tot_words = sum(word_count)
)
)

party_senti_mean$avg_speech_length <- party_senti_mean$tot_words/party_senti_mean$tot_speeches

summary(party_senti_mean)

write_csv(party_senti_mean, "party-senti-mean-v21.csv")

rm(senti_party)

## By Party Group --------
senti_party_group <- group_by(senti_df, party_group)

system.time(
party_group_senti_mean <- summarise(senti_party_group,
                                    afinn_sentiment_avg = mean(afinn_sentiment, na.rm = TRUE),
                                    afinn_sd_avg = mean(afinn_sd, na.rm=TRUE),
                                    afinn_sentiment_wtd = weighted.mean(x=afinn_sentiment, w=word_count, na.rm = TRUE),
                                    afinn_sd_wtd = weighted.mean(afinn_sd, word_count, na.rm=TRUE),
                                    jockers_sentiment_avg = mean(jockers_sentiment, na.rm = TRUE),
                                    jockers_sd_avg = mean(jockers_sd, na.rm=TRUE),
                                    jockers_sentiment_wtd = weighted.mean(jockers_sentiment, word_count, na.rm = TRUE),
                                    jockers_sd_wtd = weighted.mean(jockers_sd, word_count, na.rm=TRUE),
                                    nrc_sentiment_avg =mean(nrc_sentiment, na.rm = TRUE),
                                    nrc_sd_avg = mean(nrc_sd, na.rm=TRUE),
                                    nrc_sentiment_wtd = weighted.mean(nrc_sentiment, word_count, na.rm = TRUE),
                                    nrc_sd_wtd = weighted.mean(nrc_sd, word_count, na.rm=TRUE),
                                    sentiword_sentiment_avg =mean(sentiword_sentiment, na.rm = TRUE),
                                    sentiword_sd_avg = mean(sentiword_sd, na.rm=TRUE),
                                    sentiword_sentiment_wtd = weighted.mean(sentiword_sentiment, word_count, na.rm = TRUE),
                                    sentiword_sd_wtd = weighted.mean(sentiword_sd, word_count, na.rm = TRUE),
                                    hu_sentiment_avg =mean(hu_sentiment, na.rm = TRUE),
                                    hu_sd_avg = mean(hu_sd, na.rm=TRUE),
                                    hu_sentiment_wtd = weighted.mean(hu_sentiment, word_count, na.rm = TRUE),
                                    hu_sd_wtd = weighted.mean(hu_sd, word_count, na.rm=TRUE),
                                    rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                    rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                    rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                    rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                    tot_speeches = n_distinct(eo_id),
                                    tot_words = sum(word_count)
)
)

party_group_senti_mean$avg_speech_length <- party_group_senti_mean$tot_words/party_group_senti_mean$tot_speeches

summary(party_group_senti_mean)

write_csv(party_group_senti_mean, "party-group-senti-mean-v21.csv")

## Government/Opposition --------

rm(senti_party_group)

senti_gov <- group_by(senti_df, government)

system.time(
gov_senti_mean <- summarise(senti_gov,
                            afinn_sentiment_avg = mean(afinn_sentiment, na.rm = TRUE),
                            afinn_sd_avg = mean(afinn_sd, na.rm=TRUE),
                            afinn_sentiment_wtd = weighted.mean(x=afinn_sentiment, w=word_count, na.rm = TRUE),
                            afinn_sd_wtd = weighted.mean(afinn_sd, word_count, na.rm=TRUE),
                            jockers_sentiment_avg = mean(jockers_sentiment, na.rm = TRUE),
                            jockers_sd_avg = mean(jockers_sd, na.rm=TRUE),
                            jockers_sentiment_wtd = weighted.mean(jockers_sentiment, word_count, na.rm = TRUE),
                            jockers_sd_wtd = weighted.mean(jockers_sd, word_count, na.rm=TRUE),
                            nrc_sentiment_avg =mean(nrc_sentiment, na.rm = TRUE),
                            nrc_sd_avg = mean(nrc_sd, na.rm=TRUE),
                            nrc_sentiment_wtd = weighted.mean(nrc_sentiment, word_count, na.rm = TRUE),
                            nrc_sd_wtd = weighted.mean(nrc_sd, word_count, na.rm=TRUE),
                            sentiword_sentiment_avg =mean(sentiword_sentiment, na.rm = TRUE),
                            sentiword_sd_avg = mean(sentiword_sd, na.rm=TRUE),
                            sentiword_sentiment_wtd = weighted.mean(sentiword_sentiment, word_count, na.rm = TRUE),
                            sentiword_sd_wtd = weighted.mean(sentiword_sd, word_count, na.rm = TRUE),
                            hu_sentiment_avg =mean(hu_sentiment, na.rm = TRUE),
                            hu_sd_avg = mean(hu_sd, na.rm=TRUE),
                            hu_sentiment_wtd = weighted.mean(hu_sentiment, word_count, na.rm = TRUE),
                            hu_sd_wtd = weighted.mean(hu_sd, word_count, na.rm=TRUE),
                            rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                            rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                            rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                            rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                            tot_speeches = n_distinct(eo_id),
                            tot_words = sum(word_count)
                      )
)

gov_senti_mean$avg_speech_length <- gov_senti_mean$tot_words/gov_senti_mean$tot_speeches

summary(gov_senti_mean)

write_csv(gov_senti_mean, "gov-senti-mean-v21.csv")

rm(senti_gov)

library(openxlsx)
list_of_datasets <- list("gov_senti_mean" = gov_senti_mean, "party_group_senti_mean" = party_group_senti_mean, "party_senti_mean"= party_senti_mean, "gender_senti_mean" = gender_senti_mean, "mp_senti_mean" = mp_senti_mean)
write.xlsx(list_of_datasets, file = "hansard-summary-stats-v21.xlsx")

