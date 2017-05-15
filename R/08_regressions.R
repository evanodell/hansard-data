
# Regressions -------------------------------------------------------------

library(aod)
library(readr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)


senti_lm1 <- lm(afinn_sentiment ~ party_group + government, data = senti_df)
summary(senti_lm1)

senti_lm2 <- lm(afinn_sentiment ~ party_group:government, data = senti_df)
summary(senti_lm2)

senti_lm3 <- lm(afinn_sentiment ~ word_count, data = senti_df)
summary(senti_lm3)

words_lm1 <- lm(word_count ~ government, data = senti_df)
summary(words_lm1)

words_lm2 <- lm(word_count ~ party_group, data = senti_df)
summary(words_lm2)

afinn1 <- lm(afinn_sentiment ~ age + gender + house_start_date + date_of_birth + party_group:government, weights = word_count, data = senti_df)

summary(afinn1)

nrc1 <- lm(nrc_sentiment ~ age + gender + house_start_date + date_of_birth + party_group:government, weights = word_count, data = senti_df)

summary(nrc1)


sentiword1 <- lm(sentiword_sentiment ~ age + gender + house_start_date + date_of_birth + party_group:government, weights = word_count, data = senti_df)

summary(sentiword1)

hu1 <- lm(hu_sentiment ~ age + gender + house_start_date + date_of_birth + party_group:government, weights = word_count, data = senti_df)

summary(hu1)
