pacman::p_load(readr)
pacman::p_load(dplyr)
pacman::p_load(Hmisc)
pacman::p_load(openxlsx)
pacman::p_load(progress)

system.time(
  hansard_senti_post_V23 <- read_rds("hansard_senti_post_V23.rds")
)



## By MP --------
senti_mp <- group_by(hansard_senti_post_V23, mnis_id, proper_name)

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
                             huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                             huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                             huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                             huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
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

write_csv(mp_senti_mean, "summaries/mp-senti-mean-V23.csv")

rm(senti_mp)

## By Gender --------
senti_gender <- group_by(hansard_senti_post_V23, gender)

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
                                 huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                 huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                 huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                 huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
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

write_csv(gender_senti_mean, "summaries/gender-senti-mean-V23.csv")

rm(senti_gender)

## By Party --------
senti_party <- group_by(hansard_senti_post_V23, party)

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
                                huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
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

write_csv(party_senti_mean, "summaries/party-senti-mean-V23.csv")

rm(senti_party)

## By Party Group --------
senti_party_group <- group_by(hansard_senti_post_V23, party_group)

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
                                      huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                      huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                      huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                      huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
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

write_csv(party_group_senti_mean, "summaries/party-group-senti-mean-V23.csv")

## Government/Opposition --------

rm(senti_party_group)

senti_gov <- group_by(hansard_senti_post_V23, government)

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
                              huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                              huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                              huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                              huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
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

write_csv(gov_senti_mean, "summaries/gov-senti-mean-V23.csv")

rm(senti_gov)


## Ministry --------

senti_ministry <- group_by(hansard_senti_post_V23, ministry)

system.time(
  ministry_senti_mean <- summarise(senti_ministry,
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
                                   huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                   huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                   huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                   huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                                   rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                   rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                   rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                   rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                   tot_speeches = n_distinct(eo_id),
                                   tot_words = sum(word_count)
  )
)

ministry_senti_mean$avg_speech_length <- ministry_senti_mean$tot_words/ministry_senti_mean$tot_speeches

summary(ministry_senti_mean)

write_csv(ministry_senti_mean, "summaries/ministry-senti-mean-V23.csv")

rm(senti_ministry)


## Year --------

senti_year <- group_by(hansard_senti_post_V23, year)

system.time(
  year_senti_mean <- summarise(senti_year,
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
                               huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                               huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                               huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                               huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                               rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                               rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                               rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                               rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                               tot_speeches = n_distinct(eo_id),
                               tot_words = sum(word_count)
  )
)

year_senti_mean$avg_speech_length <- year_senti_mean$tot_words/year_senti_mean$tot_speeches

summary(year_senti_mean)

write_csv(year_senti_mean, "summaries/year-senti-mean-V23.csv")

rm(senti_year)


## Quarter --------

hansard_senti_post_V23$quarter <-  lubridate::quarter(hansard_senti_post_V23$speech_date, with_year = TRUE)

senti_quarter <- group_by(hansard_senti_post_V23, quarter)

system.time(
  quarter_senti_mean <- summarise(senti_quarter,
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
                                  huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                  huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                  huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                  huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                                  rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                  rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                  rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                  rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                  tot_speeches = n_distinct(eo_id),
                                  tot_words = sum(word_count)
  )
)

quarter_senti_mean$avg_speech_length <- quarter_senti_mean$tot_words/quarter_senti_mean$tot_speeches

summary(quarter_senti_mean)

write_csv(quarter_senti_mean, "summaries/quarter-senti-mean-V23.csv")

rm(senti_quarter)

## Month --------

hansard_senti_post_V23$month <-  format(as.Date(hansard_senti_post_V23$speech_date), "%Y-%m")

senti_month <- group_by(hansard_senti_post_V23, month)

system.time(
  month_senti_mean <- summarise(senti_month,
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
                                huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                                rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                tot_speeches = n_distinct(eo_id),
                                tot_words = sum(word_count)
  )
)

month_senti_mean$avg_speech_length <- month_senti_mean$tot_words/month_senti_mean$tot_speeches

summary(month_senti_mean)

write_csv(month_senti_mean, "summaries/month-senti-mean-V23.csv")

rm(senti_month)


list_of_datasets <- list("gov_senti_mean" = gov_senti_mean, "party_group_senti_mean" = party_group_senti_mean, "party_senti_mean"= party_senti_mean, "gender_senti_mean" = gender_senti_mean, "mp_senti_mean" = mp_senti_mean, "ministry_senti_mean"=ministry_senti_mean, "year_senti_mean"=year_senti_mean,"quarter_senti_mean"=quarter_senti_mean,  "month_senti_mean"=month_senti_mean)

write.xlsx(list_of_datasets, file = "summaries/hansard-summary-stats-V23.xlsx")

hansard_senti_post_V23$eo_id <- row.names(hansard_senti_post_V23)

write_rds(hansard_senti_post_V23, "hansard_senti_post_V23.rds")

write_csv(hansard_senti_post_V23, "hansard_senti_post_V23.csv")

eo_idpre <- nrow(hansard_senti_post_V23)

rm(hansard_senti_post_V23)

hansard_senti_pre_V23 <- read_rds("hansard_senti_pre_V23.rds")

hansard_senti_pre_V23$eo_id <- as.character(as.numeric(row.names(hansard_senti_pre_V23))+eo_idpre)



gc()
gc()
gc()
gc()

write_csv(hansard_senti_pre_V23, "hansard_senti_pre_V23.csv")

write_rds(hansard_senti_pre_V23, "hansard_senti_pre_V23.rds")
