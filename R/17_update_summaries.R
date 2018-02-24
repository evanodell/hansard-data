

library(readr)
library(dplyr)

senti_df <- read_rds("senti_df2.rds")

tibble::glimpse(senti_df)

senti_df$proper_name[senti_df$proper_name=="Jim Callaghan"] <- "James Callaghan"

senti_df$mnis_id[senti_df$mnis_id==769] <- 770

names <- readxl::read_xlsx("data/names.xlsx")

tibble::glimpse(names)

names$date_of_birth <- as.Date(names$date_of_birth)

senti_df <- left_join(senti_df, names)

summary(senti_df)

switchers <- read_csv("data/switchers.csv", 
                      col_types = cols(
                        crossing_one_date = col_date(format = "%Y-%m-%d"),
                        crossing_three_date = col_date(format = "%Y-%m-%d"), 
                        crossing_two_date = col_date(format = "%Y-%m-%d")))

switchers$crossing_one_date[is.na(switchers$crossing_one_date)] <- Sys.Date()
switchers$crossing_two_date[is.na(switchers$crossing_two_date)] <- Sys.Date()
switchers$crossing_three_date[is.na(switchers$crossing_three_date)] <- Sys.Date()

#switchers$mnis_id <- as.character(switchers$mnis_id)

senti_df$switch_match <- (senti_df$mnis_id %in% switchers$mnis_id)

crossers <- subset(senti_df, switch_match == TRUE)

#crossers$proper_name <- as.character(crossers$proper_name)

stayers <- subset(senti_df, switch_match == FALSE)

rm(senti_df)

gc()

system.time(crossers <- crossers %>% left_join(switchers))

crossers$party2 <- ifelse(crossers$crossing_one_date <= crossers$speech_date,
                          crossers$crossing_one_to, crossers$crossing_one_from)

crossers$party3 <- ifelse(crossers$crossing_two_date <= crossers$speech_date,
                          crossers$crossing_two_to, crossers$crossing_two_from)

crossers$party4 <- ifelse(crossers$crossing_three_date <= crossers$speech_date,
                          crossers$crossing_three_to, crossers$crossing_three_from)

crossers$party3[is.na(crossers$party3)] <- as.character(crossers$party2[is.na(crossers$party3)])
crossers$party4[is.na(crossers$party4)] <- as.character(crossers$party3[is.na(crossers$party4)])

pat1 <- c("party4","party2","party3","party")

crossers[pat1] <- lapply(crossers[pat1], factor)

#summary(crossers)

crossers$party <- crossers$party4

dropping <- c("party4","party2","party3","proper_name.y", "crossing_one_date", "crossing_one_from", "crossing_one_to", "crossing_two_date", "crossing_two_from", "crossing_two_to", "crossing_three_date", "crossing_three_from", "crossing_three_to")

crossers <- crossers[,!names(crossers) %in% dropping]

names(crossers) == names(stayers)

#crossers2 <- crossers

#crossers2$speech <- NULL

#write_csv(crossers2, "crossers2.csv")

senti_df <- bind_rows(crossers, stayers)

senti_df_nrow_crossed <- nrow(senti_df)

rm(crossers,crossers2, stayers, switchers,dropping,fac1,pat1,senti_df_nrow,senti_df2_nrow,senti_df_nrow_crossed)

gc()

senti_df$switch_match <- NULL

senti_df$gender <- as.character(senti_df$gender)

senti_df$gender[senti_df$gender=="M"] <- "Male"

senti_df$gender[senti_df$gender=="F"] <- "Female"

senti_df$gender <- as.factor(senti_df$gender)

#summary(senti_df)



# party_group  ------------
senti_df$party_group <- case_when(senti_df$party == "Labour" |
                                    senti_df$party == "Labour (Co-op)" ~ "Labour",
                                  senti_df$party == "Conservative" ~ "Conservative",
                                  senti_df$party == "Liberal Democrat" |
                                    senti_df$party == "Social Democrat" |
                                    senti_df$party == "Liberal" ~ "Liberal Democrat",
                                  senti_df$party == "Speaker" ~ "Speaker",
                                  TRUE ~  "Other"
                                  )
  
system.time(
  write_rds(senti_df, "senti_df.rds")
)

senti_df$ministry <- case_when(
  senti_df$speech_date >= "1979-05-04" & senti_df$speech_date < "1983-06-09" ~ "Thatcher1",
  senti_df$speech_date >= "1983-06-09" & senti_df$speech_date < "1987-06-11" ~ "Thatcher2",
  senti_df$speech_date >= "1987-06-11" & senti_df$speech_date < "1990-11-28" ~ "Thatcher3",
  senti_df$speech_date >= "1990-11-28" & senti_df$speech_date < "1992-04-10" ~ "Major1",
  senti_df$speech_date >= "1992-04-10" & senti_df$speech_date < "1997-05-02" ~ "Major2",
  senti_df$speech_date >= "1997-05-02" & senti_df$speech_date < "2001-06-07" ~ "Blair1",
  senti_df$speech_date >= "2001-06-07" & senti_df$speech_date < "2005-05-05" ~ "Blair2",
  senti_df$speech_date >= "2005-05-05" & senti_df$speech_date < "2007-06-27" ~ "Blair3",
  senti_df$speech_date >= "2007-06-27" & senti_df$speech_date < "2010-05-11" ~ "Brown",
  senti_df$speech_date >= "2010-05-11" & senti_df$speech_date < "2015-05-08" ~ "Cameron1",
  senti_df$speech_date >= "2015-05-08" & senti_df$speech_date < "2016-07-13" ~ "Cameron2",
  senti_df$speech_date >= "2016-07-13" & senti_df$speech_date < "2017-06-07" ~ "May1",
  senti_df$speech_date >= "2017-06-08" ~ "May2"
)

senti_df$ministry <- as.factor(senti_df$ministry)

summary(senti_df$ministry)

tories <- c("Cameron1, Cameron2", "Major1", "Major2", "May1",
            "May2", "Thatcher1", "Thatcher2", "Thatcher3")

labour <- c("Blair1","Blair2","Blair3","Brown")

senti_df$government <- case_when(senti_df$ministry %in% tories &
                                  senti_df$party_group == "Conservative" ~ TRUE,
                                 senti_df$ministry == "Cameron1" &
                                   senti_df$party_group == "Liberal Democrat" ~ TRUE,
                                 senti_df$ministry %in% labour &
                                   senti_df$party_group == "Labour" ~ TRUE,
                                 TRUE ~ FALSE
                                 )


senti_df$pp_id2 <- NULL
senti_df$eo_id2 <- NULL

senti_df <- senti_df[order(senti_df$speech_date, senti_df$colnum,
                           senti_df$pp_id),]


tibble::glimpse(senti_df)

## Summary Stats -----------

## By MP --------
senti_mp <- group_by(senti_df, mnis_id, proper_name)

system.time(
  mp_senti_mean <- summarise(senti_mp,
                             afinn_sentiment_avg = mean(afinn_sentiment, na.rm = TRUE),
                             afinn_sd_avg = mean(afinn_sd, na.rm=TRUE),
                             afinn_sentiment_wtd = weighted.mean(
                               x=afinn_sentiment, w=word_count, na.rm = TRUE
                               ),
                             afinn_sd_wtd = weighted.mean(
                               afinn_sd, word_count, na.rm=TRUE
                               ),
                             jockers_sentiment_avg = mean(
                               jockers_sentiment, na.rm = TRUE
                               ),
                             jockers_sd_avg = mean(
                               jockers_sd, na.rm=TRUE
                               ),
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
                             jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                             jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                             jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                             jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                             senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                             senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                             senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                             senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                             
                             
                             tot_speeches = n_distinct(eo_id),
                             tot_words = sum(word_count)
  )
)

mp_senti_mean$avg_speech_length <- mp_senti_mean$tot_words/mp_senti_mean$tot_speeches

summary(mp_senti_mean)

write_csv(mp_senti_mean, "summaries/mp-senti-mean-V250.csv")

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
                                 huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                 huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                 huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                 huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                                 rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                 rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                 rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                 rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                 jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                                 jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                                 jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                                 jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                                 senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                                 senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                                 senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                                 senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                                 tot_speeches = n_distinct(eo_id),
                                 tot_words = sum(word_count)
  )
)

gender_senti_mean$avg_speech_length <- gender_senti_mean$tot_words/gender_senti_mean$tot_speeches

summary(gender_senti_mean)

write_csv(gender_senti_mean, "summaries/gender-senti-mean-V250.csv")

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
                                huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                                rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                                jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                                jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                                jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                                senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                                senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                                senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                                senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                                tot_speeches = n_distinct(eo_id),
                                tot_words = sum(word_count)
  )
)

party_senti_mean$avg_speech_length <- party_senti_mean$tot_words/party_senti_mean$tot_speeches

summary(party_senti_mean)

write_csv(party_senti_mean, "summaries/party-senti-mean-V250.csv")

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
                                      huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                                      huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                                      huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                                      huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                                      rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                                      rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                                      rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                                      rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                                      jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                                      jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                                      jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                                      jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                                      senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                                      senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                                      senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                                      senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                                      tot_speeches = n_distinct(eo_id),
                                      tot_words = sum(word_count)
  )
)

party_group_senti_mean$avg_speech_length <- party_group_senti_mean$tot_words/party_group_senti_mean$tot_speeches

summary(party_group_senti_mean)

write_csv(party_group_senti_mean, "summaries/party-group-senti-mean-V250.csv")

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
                              huliu_sentiment_avg =mean(huliu_sentiment, na.rm = TRUE),
                              huliu_sd_avg = mean(huliu_sd, na.rm=TRUE),
                              huliu_sentiment_wtd = weighted.mean(huliu_sentiment, word_count, na.rm = TRUE),
                              huliu_sd_wtd = weighted.mean(huliu_sd, word_count, na.rm=TRUE),
                              rheault_sentiment_avg = mean(rheault_sentiment, na.rm = TRUE),
                              rheault_sd_avg = mean(rheault_sd, na.rm=TRUE),
                              rheault_sentiment_wtd = weighted.mean(rheault_sentiment, word_count, na.rm = TRUE),
                              rheault_sd_wtd = weighted.mean(rheault_sentiment, word_count, na.rm=TRUE),
                              jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                              jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                              jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                              jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                              senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                              senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                              senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                              senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                              tot_speeches = n_distinct(eo_id),
                              tot_words = sum(word_count)
  )
)

gov_senti_mean$avg_speech_length <- gov_senti_mean$tot_words/gov_senti_mean$tot_speeches

summary(gov_senti_mean)

write_csv(gov_senti_mean, "summaries/gov-senti-mean-V250.csv")

rm(senti_gov)


## Ministry --------

senti_ministry <- group_by(senti_df, ministry)

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
                                   jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                                   jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                                   jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                                   jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                                   senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                                   senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                                   senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                                   senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                                   tot_speeches = n_distinct(eo_id),
                                   tot_words = sum(word_count)
  )
)

ministry_senti_mean$avg_speech_length <- ministry_senti_mean$tot_words/ministry_senti_mean$tot_speeches

summary(ministry_senti_mean)

write_csv(ministry_senti_mean, "summaries/ministry-senti-mean-V250.csv")

rm(senti_ministry)


## Year --------

senti_year <- group_by(senti_df, year)

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
                               jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                               jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                               jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                               jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                               senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                               senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                               senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                               senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                               tot_speeches = n_distinct(eo_id),
                               tot_words = sum(word_count)
  )
)

year_senti_mean$avg_speech_length <- year_senti_mean$tot_words/year_senti_mean$tot_speeches

summary(year_senti_mean)

write_csv(year_senti_mean, "summaries/year-senti-mean-V250.csv")

rm(senti_year)


## Quarter --------

senti_df$quarter <-  lubridate::quarter(senti_df$speech_date, with_year = TRUE)

senti_quarter <- group_by(senti_df, quarter)

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
                                  jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                                  jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                                  jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                                  jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                                  senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                                  senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                                  senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                                  senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                                  tot_speeches = n_distinct(eo_id),
                                  tot_words = sum(word_count)
  )
)

quarter_senti_mean$avg_speech_length <- quarter_senti_mean$tot_words/quarter_senti_mean$tot_speeches

summary(quarter_senti_mean)

write_csv(quarter_senti_mean, "summaries/quarter-senti-mean-V250.csv")

rm(senti_quarter)

## Month --------

senti_df$month <-  format(as.Date(senti_df$speech_date), "%Y-%m")

senti_month <- group_by(senti_df, month)

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
                                jockers_rinker_sentiment_avg = mean(jockers_rinker_sentiment, na.rm = TRUE),
                                jockers_rinker_sd_avg = mean(jockers_rinker_sd, na.rm=TRUE),
                                jockers_rinker_sentiment_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm = TRUE),
                                jockers_rinker_sd_wtd = weighted.mean(jockers_rinker_sentiment, word_count, na.rm=TRUE),
                                senticnet_sentiment_avg = mean(senticnet_sentiment, na.rm = TRUE),
                                senticnet_sd_avg = mean(senticnet_sd, na.rm=TRUE),
                                senticnet_sentiment_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm = TRUE),
                                senticnet_sd_wtd = weighted.mean(senticnet_sentiment, word_count, na.rm=TRUE),
                                tot_speeches = n_distinct(eo_id),
                                tot_words = sum(word_count)
  )
)

month_senti_mean$avg_speech_length <- month_senti_mean$tot_words/month_senti_mean$tot_speeches

summary(month_senti_mean)

write_csv(month_senti_mean, "summaries/month-senti-mean-V250.csv")

rm(senti_month)


list_of_datasets <- list("gov_senti_mean" = gov_senti_mean, "party_group_senti_mean" = party_group_senti_mean, "party_senti_mean"= party_senti_mean, "gender_senti_mean" = gender_senti_mean, "mp_senti_mean" = mp_senti_mean, "ministry_senti_mean"=ministry_senti_mean, "year_senti_mean"=year_senti_mean,"quarter_senti_mean"=quarter_senti_mean,  "month_senti_mean"=month_senti_mean)

openxlsx::write.xlsx(list_of_datasets, file = "summaries/hansard-summary-stats-V250.xlsx")

row.names(senti_df) <- c(1:nrow(senti_df))

row.names(senti_df)

senti_df$eo_id <- row.names(senti_df)

#senti_df$eo_id <- row.names(senti_df)

senti_df$quarter <- NULL

senti_df$month <- NULL 


library(lubridate)
age <- function(dob, age.day = senti_df$speech_date,
                units = "years", floor = TRUE) {
 calc.age = interval(dob, age.day)/duration(num = 1, units = units)
     if (floor)
       return(as.integer(floor(calc.age)))
     return(calc.age)
   }

senti_df$age <- age(senti_df$date_of_birth)

write_rds(senti_df, "hansard_post_V250.rds")

#senti_df$speech_date <- as.Date(senti_df$speech_date)

# library(lubridate)
# age <- function(dob, age.day = senti_df$speech_date, units = "years", floor = TRUE) {
#    calc.age = interval(dob, age.day)/duration(num = 1, units = units)
#    if (floor)
#      return(as.integer(floor(calc.age)))
#    return(calc.age)
#  }
# 
# senti_df$age <- age(senti_df$date_of_birth)
# 
senti_df <- senti_df[c("pp_id",
                                                     "eo_id",
                                                     "eo_id2",
                                                     "colnum",
                                                     "speech",
                                                     "afinn_sentiment",
                                                     "afinn_sd",
                                                     "jockers_sentiment",
                                                     "jockers_sd",
                                                     "nrc_sentiment",
                                                     "nrc_sd",
                                                     "huliu_sentiment",
                                                     "huliu_sd",
                                                     "rheault_sentiment",
                                                     "rheault_sd",
                                                     "word_count",
                                                     "speech_date",
                                                     "year",
                                                     "time",
                                                     "url",
                                                     "as_speaker",
                                                     "speaker_id",
                                                     "person_id",
                                                     "hansard_membership_id",
                                                     "mnis_id",
                                                     "dods_id",
                                                     "pims_id",
                                                     "proper_name",
                                                     "party_group",
                                                     "party",
                                                     "government",
                                                     "speaker_office",
                                                     "age",
                                                     "gender",
                                                     "date_of_birth",
                                                     "house_start_date",
                                                     "house_end_date",
                                                     "ministry")]


# system.time(
#   senti_df$pp_id <- gsub("uk.or.publicwhip/debate/", "", senti_df$pp_id)
# )

write_rds(senti_df, "senti_df.rds")

