library(readr)
library(dplyr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)

## By MP -------- 
senti_mp <- group_by(senti_df, mnis_id)

mp_senti_mean <- summarise(senti_mp,
                           afinn_sentiment = mean(afinn_sentiment, na.rm = TRUE),
                           jockers_sentiment = mean(jockers_sentiment, na.rm = TRUE),
                           nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                           sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                           hu_sentiment = mean(hu_sentiment, na.rm = TRUE),
                           tot_speeches = n_distinct(id),
                           tot_words = sum(word_count, na.rm = TRUE)
)

mp_senti_mean$avg_speech_length <- mp_senti_mean$tot_words/mp_senti_mean$tot_speeches

summary(mp_senti_mean)

write_csv(mp_senti_mean, "mp_senti_mean.csv")

## By Gender -------- 
senti_gender <- group_by(senti_df, gender)

gender_senti_mean <- summarise(senti_gender,
                               afinn_sentiment = mean(afinn_sentiment, na.rm = TRUE),
                               jockers_sentiment = mean(jockers_sentiment, na.rm = TRUE),
                               nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                               sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                               hu_sentiment = mean(hu_sentiment, na.rm = TRUE),
                               tot_speeches = n_distinct(id),
                               tot_words = sum(word_count, na.rm = TRUE)
                               
)

gender_senti_mean$avg_speech_length <- gender_senti_mean$tot_words/gender_senti_mean$tot_speeches

summary(gender_senti_mean)

write_csv(gender_senti_mean, "gender_senti_mean.csv")


## By Party -------- 
senti_party <- group_by(senti_df, party)

party_senti_mean <- summarise(senti_party,
                              afinn_sentiment = mean(afinn_sentiment, na.rm = TRUE),
                              jockers_sentiment = mean(jockers_sentiment, na.rm = TRUE),
                              nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                              sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                              hu_sentiment = mean(hu_sentiment, na.rm = TRUE),
                              tot_speeches = n_distinct(id),
                              tot_words = sum(word_count, na.rm = TRUE)
                              
)


party_senti_mean$avg_speech_length <- party_senti_mean$tot_words/party_senti_mean$tot_speeches

summary(party_senti_mean)

write_csv(party_senti_mean, "party_senti_mean.csv")

## By Party Group -------- 
senti_party_group <- group_by(senti_df, party_group)

party_group_senti_mean <- summarise(senti_party_group,
                                    afinn_sentiment = mean(afinn_sentiment, na.rm = TRUE),
                                    jockers_sentiment = mean(jockers_sentiment, na.rm = TRUE),
                                    nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                                    sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                                    hu_sentiment = mean(hu_sentiment, na.rm = TRUE),
                                    tot_speeches = n_distinct(id),
                                    tot_words = sum(word_count, na.rm = TRUE)
                                    
)


party_group_senti_mean$avg_speech_length <- party_group_senti_mean$tot_words/party_group_senti_mean$tot_speeches

summary(party_group_senti_mean)

write_csv(party_group_senti_mean, "party_group_senti_mean.csv")

## Government/Opposition -------- 

senti_gov <- group_by(senti_df, government)

gov_senti_mean <- summarise(senti_gov,
                            afinn_sentiment = mean(afinn_sentiment, na.rm = TRUE),
                            jockers_sentiment = mean(jockers_sentiment, na.rm = TRUE),
                            nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                            sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                            hu_sentiment = mean(hu_sentiment, na.rm = TRUE),
                            tot_speeches = n_distinct(id),
                            tot_words = sum(word_count, na.rm = TRUE)
                            
)

gov_senti_mean$avg_speech_length <- gov_senti_mean$tot_words/gov_senti_mean$tot_speeches

summary(gov_senti_mean)

write_csv(gov_senti_mean, "gov_senti_mean.csv")

library(openxlsx)
list_of_datasets <- list("gov_senti_mean" = gov_senti_mean, "party_group_senti_mean" = party_group_senti_mean, "party_senti_mean"= party_senti_mean, "gender_senti_mean" = gender_senti_mean, "mp_senti_mean"=mp_senti_mean)
write.xlsx(list_of_datasets, file = "hansard_summary_stats.xlsx")

system.time(
  write_rds(senti_df, "senti_df.rds")
)

system.time(
  write_csv(senti_df, "senti_post_v2.csv")
)


rm(senti_gender,senti_gov,senti_mp, senti_party_group, senti_party)

