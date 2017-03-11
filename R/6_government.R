# Government Labelling --------

library(readr)
library(dplyr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)

senti_df$ministry <- NA

senti_df$government <- NA

# I know this isn't the best way of doing this but other ways seemed to overload my computer. 
Baldwin2 <- subset(senti_df, speech_date >= "1935-11-14" & speech_date < "1937-05-28")
Chamberlain1 <- subset(senti_df, speech_date >= "1937-05-28" & speech_date < "1939-09-03")
Chamberlain2 <- subset(senti_df, speech_date >= "1939-09-03" & speech_date < "1940-05-10")
Churchill1 <- subset(senti_df, speech_date >= "1940-05-10" & speech_date < "1945-05-23")
Churchill2 <- subset(senti_df, speech_date >= "1945-05-23" & speech_date < "1945-06-26")
Atlee1 <- subset(senti_df, speech_date >= "1945-06-26" & speech_date < "1950-02-23")
Atlee2 <- subset(senti_df, speech_date >= "1950-02-23" & speech_date < "1951-10-26")
Churchill3 <- subset(senti_df, speech_date >= "1951-10-26" & speech_date < "1955-04-06")
Eden1 <- subset(senti_df, speech_date >= "1955-04-06" & speech_date < "1955-05-29")
Eden2 <- subset(senti_df, speech_date >= "1955-05-29" & speech_date < "1957-01-10")
Macmillan1 <- subset(senti_df, speech_date >= "1957-01-10" & speech_date < "1959-10-09")
Macmillan2 <- subset(senti_df, speech_date >= "1959-10-09" & speech_date < "1963-10-19")
DouglasHome <- subset(senti_df, speech_date >= "1963-10-19" & speech_date < "1964-10-16")
Wilson1 <- subset(senti_df, speech_date >= "1964-10-16" & speech_date < "1966-04-01")
Wilson2 <- subset(senti_df, speech_date >= "1966-04-01" & speech_date < "1970-06-18")
Heath <- subset(senti_df, speech_date >= "1970-06-19" & speech_date < "1974-03-04")
Wilson3 <- subset(senti_df, speech_date >= "1974-03-04" & speech_date < "1976-04-05")
Callaghan <- subset(senti_df, speech_date >= "1976-04-05" & speech_date < "1979-05-04")
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
May <- subset(senti_df, speech_date >= "2016-07-13" & speech_date < "2016-12-31")

senti_df_nrow <- nrow(senti_df)

rm(senti_df)
gc()
Baldwin2$ministry <- "Baldwin2"
#Baldwin2$government <- ifelse(Baldwin2$party_group == "Conservative",
#                              "Government", "Opposition")

Chamberlain1$ministry <- "Chamberlain1"
#Chamberlain1$government <- ifelse(Chamberlain1$party_group == "Conservative",
#                                  "Government", "Opposition")

Chamberlain2$ministry <- "Chamberlain2"
#Chamberlain2$government <- ifelse(Chamberlain2$party_group == "Conservative",
#                                  "Government", "Opposition")

Churchill1$ministry <- "Churchill1"
#Churchill1$government <- ifelse(Churchill1$party_group == "Conservative",
#                                "Government", "Opposition")

Churchill2$ministry <- "Churchill2"
#Churchill2$government <- ifelse(Churchill2$party_group == "Conservative",
#                                "Government", "Opposition")

Atlee1$ministry <- "Atlee1"
#Atlee1$government <- ifelse(Atlee1$party_group == "Labour",
#                            "Government", "Opposition")

Atlee2$ministry <- "Atlee2"
#Atlee2$government <- ifelse(Atlee2$party_group == "Labour",
#                            "Government", "Opposition")

Churchill3$ministry <- "Churchill3"
#Churchill3$government <- ifelse(Churchill3$party_group == "Conservative",
#                                "Government", "Opposition")

Eden1$ministry <- "Eden1"
#Eden1$government <- ifelse(Eden1$party_group == "Conservative",
#                           "Government", "Opposition")

Eden2$ministry <- "Eden2"
#Eden2$government <- ifelse(Eden2$party_group == "Conservative",
#                           "Government", "Opposition")

Macmillan1$ministry <- "Macmillan1"
#Macmillan1$government <- ifelse(Macmillan1$party_group == "Conservative",
#                                "Government", "Opposition")

Macmillan2$ministry <- "Macmillan2"
#Macmillan2$government <- ifelse(Macmillan2$party_group == "Conservative",
#                                "Government", "Opposition")

DouglasHome$ministry <- "DouglasHome"
#DouglasHome$government <- ifelse(DouglasHome$party_group == "Conservative",
#                                 "Government", "Opposition")

Wilson1$ministry <- "Wilson1"
#Wilson1$government <- ifelse(Wilson1$party_group == "Labour",
#                             "Government", "Opposition")

Wilson2$ministry <- "Wilson2"
#Wilson2$government <- ifelse(Wilson2$party_group == "Labour",
#                             "Government", "Opposition")

Heath$ministry <- "Heath"
#Heath$government <- ifelse(Heath$party_group == "Conservative",
#                           "Government", "Opposition")

Wilson3$ministry <- "Wilson3"
#Wilson3$government <- ifelse(Wilson3$party_group == "Labour",
#                             "Government", "Opposition")

Callaghan$ministry <- "Callaghan"
#Callaghan$government <- ifelse(Callaghan$party_group == "Labour",
#                               "Government", "Opposition")

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



senti_df <- bind_rows(Blair1, Blair2, Blair3, Brown, Cameron1, Cameron2,May,
                        Baldwin2, Chamberlain1, Chamberlain2, Churchill1, Churchill2,
                        Atlee1, Atlee2, Churchill3, Eden1, Eden2, Macmillan1, Macmillan2,
                        DouglasHome, Wilson1, Wilson2, Heath, Wilson3, Callaghan,
                        Thatcher1, Thatcher2, Thatcher3, Major1, Major2)

senti_df_nrow2 <- nrow(senti_df) ## Check that they're still the same length

rm(Blair1, Blair2, Blair3, Brown, Cameron1, Cameron2, May, Baldwin2,
   Chamberlain1, Chamberlain2, Churchill1, Churchill2,Atlee1, Atlee2,
   Churchill3, Eden1, Eden2, Macmillan1, Macmillan2, DouglasHome,
   Wilson1, Wilson2, Heath, Wilson3, Callaghan,Thatcher1, Thatcher2,
   Thatcher3, Major1, Major2)
gc()

senti_df$government <- ifelse(senti_df$party_group=="Speaker", "Speaker", senti_df$government)

fac1 <- c("government", "ministry", "party_group", "party", "proper_name")

senti_df[fac1] <- lapply(senti_df[fac1], factor)

senti_df$id <- gsub("uk.org.publicwhip/debate/","",senti_df$id) ### Strip out some extra text to save size

system.time(
  write_rds(senti_df, "senti_df.rds")
)

system.time(
  write_csv(senti_df, "senti_df.csv")  ###Writing as CSV for distribution
)
