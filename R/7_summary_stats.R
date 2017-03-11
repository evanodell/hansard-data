library(readr)
library(dplyr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)


## By MP -------- 
senti_mp <- group_by(senti_df, proper_id)

mp_senti_mean <- summarise(senti_mp,
                           afinn_sentiment = mean(afinn_sentiment, na.rm = TRUE),
                           bing_sentiment = mean(bing_sentiment, na.rm = TRUE),
                           nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                           sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                           hu_sentiment = mean(sentiword_sentiment),
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
                           bing_sentiment = mean(bing_sentiment, na.rm = TRUE),
                           nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                           sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                           hu_sentiment = mean(sentiword_sentiment),
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
                               bing_sentiment = mean(bing_sentiment, na.rm = TRUE),
                               nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                               sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                               hu_sentiment = mean(sentiword_sentiment),
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
                               bing_sentiment = mean(bing_sentiment, na.rm = TRUE),
                               nrc_sentiment = mean(nrc_sentiment, na.rm = TRUE),
                               sentiword_sentiment = mean(sentiword_sentiment, na.rm = TRUE),
                               hu_sentiment = mean(sentiword_sentiment),
                               tot_speeches = n_distinct(id),
                               tot_words = sum(word_count, na.rm = TRUE)
                               
)


party_group_senti_mean$avg_speech_length <- party_group_senti_mean$tot_words/party_group_senti_mean$tot_speeches

summary(party_group_senti_mean)

write_csv(party_group_senti_mean, "party_group_senti_mean.csv")

