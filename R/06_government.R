

library(readr)
library(dplyr)
system.time(hansard_senti_post_V242 <- read_rds("hansard_senti_post_V242.rds"))

hansard_senti_post_V242_nrow <- nrow(hansard_senti_post_V242)

hansard_senti_post_V242$speech_date <- as.Date(hansard_senti_post_V242$speech_date)

hansard_senti_post_V242$house <- NULL

# Post 1979 Election Labelling --------
Thatcher1 <- subset(hansard_senti_post_V242, speech_date >= "1979-05-04" & speech_date < "1983-06-09")
Thatcher2 <- subset(hansard_senti_post_V242, speech_date >= "1983-06-09" & speech_date < "1987-06-11")
Thatcher3 <- subset(hansard_senti_post_V242, speech_date >= "1987-06-11" & speech_date < "1990-11-28")
Major1 <- subset(hansard_senti_post_V242, speech_date >= "1990-11-28" & speech_date < "1992-04-10")
Major2 <- subset(hansard_senti_post_V242, speech_date >= "1992-04-10" & speech_date < "1997-05-02")
Blair1 <- subset(hansard_senti_post_V242, speech_date >= "1997-05-02" & speech_date < "2001-06-07")
Blair2 <- subset(hansard_senti_post_V242, speech_date >= "2001-06-07"& speech_date < "2005-05-05")
Blair3 <- subset(hansard_senti_post_V242, speech_date >= "2005-05-05"& speech_date < "2007-06-27")
Brown <- subset(hansard_senti_post_V242, speech_date >= "2007-06-27" & speech_date < "2010-05-11")
Cameron1 <- subset(hansard_senti_post_V242, speech_date >= "2010-05-11" & speech_date < "2015-05-08")
Cameron2 <- subset(hansard_senti_post_V242, speech_date >= "2015-05-08" & speech_date < "2016-07-13")
May1 <- subset(hansard_senti_post_V242, speech_date >= "2016-07-13" & speech_date < "2017-06-07")
May2 <- subset(hansard_senti_post_V242, speech_date >= "2017-06-08")

hansard_senti_post_V242_nrow <- nrow(hansard_senti_post_V242)

rm(hansard_senti_post_V242)
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

May2$ministry <- "May2"
May2$government <- ifelse(May2$party_group == "Conservative",
                         "Government", "Opposition")

May1$ministry <- "May1"
May1$government <- ifelse(May1$party_group == "Conservative",
                          "Government", "Opposition")

hansard_senti_post_V242 <- bind_rows(Blair1, Blair2, Blair3, Brown, Cameron1, Cameron2, May1, May2, Thatcher1, Thatcher2, Thatcher3, Major1, Major2)

hansard_senti_post_V242_nrow2 <- nrow(hansard_senti_post_V242) ## Check that they're still the same length

hansard_senti_post_V242_nrow==hansard_senti_post_V242_nrow2

rm(Blair1, Blair2, Blair3, Brown, Cameron1, Cameron2, May1, May2, Thatcher1, Thatcher2, Thatcher3, Major1, Major2)

gc()

fac1 <- c("government", "ministry", "party_group", "party", "proper_name")

hansard_senti_post_V242[fac1] <- lapply(hansard_senti_post_V242[fac1], factor)

rm(fac1,hansard_senti_post_V242_nrow2,hansard_senti_post_V242_nrow)

#hansard_senti_post_V242$id <- gsub("uk.org.publicwhip/debate/","",hansard_senti_post_V242$id) ### Strip out some extra text to save size

system.time(
  write_rds(hansard_senti_post_V242, "hansard_senti_post_V242.rds")
)
