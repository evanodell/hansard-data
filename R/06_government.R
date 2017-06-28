

library(readr)
library(dplyr)
system.time(senti_df <- read_rds("senti_df.rds"))

senti_df$speech_date <- as.Date(senti_df$speech_date)

senti_df$house <- NULL

names(senti_df)[names(senti_df)=="id.x"] <- "id"



# Post 1979 Election Labelling --------
Thatcher1 <- subset(senti_df, speech_date >= "1979-05-04" & speech_date < "1983-06-09")
Thatcher2 <- subset(senti_df, speech_date >= "1983-06-09" & speech_date < "1987-06-11")
Thatcher3 <- subset(senti_df, speech_date >= "1987-06-11" & speech_date < "1990-11-28")
Major1 <- subset(senti_df, speech_date >= "1990-11-28" & speech_date < "1992-04-10")
Major2 <- subset(senti_df, speech_date >= "1992-04-10" & speech_date < "1997-05-02")
Blair1 <- subset(senti_df, speech_date >= "1997-05-02" & speech_date < "2001-06-07")
Blair2 <- subset(senti_df, speech_date >= "2001-06-07"& speech_date < "2005-05-05")
Blair3 <- subset(senti_df, speech_date >= "2005-05-05"& speech_date < "2007-06-27")
Brown <- subset(senti_df, speech_date >= "2007-06-27" & speech_date < "2010-05-11")
Cameron1 <- subset(senti_df, speech_date >= "2010-05-11" & speech_date < "2015-05-08")
Cameron2 <- subset(senti_df, speech_date >= "2015-05-08" & speech_date < "2016-07-13")
May <- subset(senti_df, speech_date >= "2016-07-13")

senti_df_nrow <- nrow(senti_df)

rm(senti_df)
gc()


Thatcher1$ministry <- "Thatcher1"
Thatcher1$government <- ifelse(Thatcher1$party_group == "Conservative",
                               "Government", "Opposition")

Thatcher2$ministry <- "Thatcher2"
Thatcher2$government <- ifelse(Thatcher2$party_group == "Conservative",
                               "Government", "Opposition")

Thatcher3$ministry <- "Thatcher3"
Thatcher3$government <- ifelse(Thatcher3$party_group == "Conservative",
                               "Government", "Opposition")

Major1$ministry <- "Major1"
Major1$government <- ifelse(Major1$party_group == "Conservative",
                            "Government", "Opposition")

Major2$ministry <- "Major2"
Major2$government <- ifelse(Major2$party_group == "Conservative",
                            "Government", "Opposition")


Blair1$ministry <- "Blair1"
Blair1$government <- ifelse(Blair1$party_group == "Labour",
                            "Government", "Opposition")

Blair2$ministry <- "Blair2"
Blair2$government <- ifelse(Blair2$party_group == "Labour",
                            "Government", "Opposition")

Blair3$ministry <- "Blair3"
Blair3$government <- ifelse(Blair3$party_group == "Labour",
                            "Government", "Opposition")

Brown$ministry <- "Brown"
Brown$government <- ifelse(Brown$party_group == "Labour",
                           "Government", "Opposition")

Cameron1$ministry <- "Cameron1"
Cameron1$government <- ifelse(Cameron1$party_group == "Conservative" |
                                Cameron1$party_group == "Liberal Democrat" ,
                              "Government", "Opposition")

Cameron2$ministry <- "Cameron2"
Cameron2$government <- ifelse(Cameron2$party_group == "Conservative",
                              "Government", "Opposition")

May$ministry <- "May"
May$government <- ifelse(May$party_group == "Conservative",
                         "Government", "Opposition")

senti_df <- bind_rows(Blair1, Blair2, Blair3, Brown, Cameron1, Cameron2, May, Thatcher1, Thatcher2, Thatcher3, Major1, Major2)

senti_df_nrow <- nrow(senti_df) ## Check that they're still the same length

rm(Blair1, Blair2, Blair3, Brown, Cameron1, Cameron2, May, Thatcher1, Thatcher2, Thatcher3, Major1, Major2)

gc()

fac1 <- c("government", "ministry", "party_group", "party", "proper_name")

senti_df[fac1] <- lapply(senti_df[fac1], factor)

rm(fac1,senti_df_nrow,senti_df_nrow)

#senti_df$id <- gsub("uk.org.publicwhip/debate/","",senti_df$id) ### Strip out some extra text to save size

system.time(
  write_rds(senti_df, "hansard_senti_post_V21.rds")
)

