
library(readr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)

system.time(
  write_rds(senti_df, "senti_df.rds")
)

# Pre 1979 Election Labelling --------

library(dplyr)

system.time(
  senti_pre <- read_rds("senti_pre.rds")
)

senti_pre$speech_date <- as.Date(senti_pre$speech_date)

senti_pre$ministry <- NA

# I know this isn't the best way of doing this but other ways seemed to overload my computer. 
Baldwin2 <- subset(senti_pre, speech_date >= "1935-11-14" & speech_date < "1937-05-28")
Chamberlain1 <- subset(senti_pre, speech_date >= "1937-05-28" & speech_date < "1939-09-03")
Chamberlain2 <- subset(senti_pre, speech_date >= "1939-09-03" & speech_date < "1940-05-10")
Churchill1 <- subset(senti_pre, speech_date >= "1940-05-10" & speech_date < "1945-05-23")
Churchill2 <- subset(senti_pre, speech_date >= "1945-05-23" & speech_date < "1945-06-26")
Atlee1 <- subset(senti_pre, speech_date >= "1945-06-26" & speech_date < "1950-02-23")
Atlee2 <- subset(senti_pre, speech_date >= "1950-02-23" & speech_date < "1951-10-26")
Churchill3 <- subset(senti_pre, speech_date >= "1951-10-26" & speech_date < "1955-04-06")
Eden1 <- subset(senti_pre, speech_date >= "1955-04-06" & speech_date < "1955-05-29")
Eden2 <- subset(senti_pre, speech_date >= "1955-05-29" & speech_date < "1957-01-10")
Macmillan1 <- subset(senti_pre, speech_date >= "1957-01-10" & speech_date < "1959-10-09")
Macmillan2 <- subset(senti_pre, speech_date >= "1959-10-09" & speech_date < "1963-10-19")
DouglasHome <- subset(senti_pre, speech_date >= "1963-10-19" & speech_date < "1964-10-16")
Wilson1 <- subset(senti_pre, speech_date >= "1964-10-16" & speech_date < "1966-04-01")
Wilson2 <- subset(senti_pre, speech_date >= "1966-04-01" & speech_date < "1970-06-18")
Heath <- subset(senti_pre, speech_date >= "1970-06-19" & speech_date < "1974-03-04")
Wilson3 <- subset(senti_pre, speech_date >= "1974-03-04" & speech_date < "1976-04-05")
Callaghan <- subset(senti_pre, speech_date >= "1976-04-05" & speech_date < "1979-05-04")

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

senti_pre2 <- bind_rows(Callaghan, Wilson3, Wilson2, Wilson1, Heath, DouglasHome, Macmillan1, Macmillan2, Eden2, Eden1, Baldwin2, Chamberlain1, Chamberlain2, Churchill1, Churchill2, Churchill3, Atlee1, Atlee2)

rm(Callaghan, Wilson3, Wilson2, Wilson1, Heath, DouglasHome, Macmillan1, Macmillan2, Eden2, Eden1, Baldwin2, Chamberlain1, Chamberlain2, Churchill1, Churchill2, Churchill3, Atlee1, Atlee2, senti_pre)



system.time(
  write_csv(senti_pre, "senti_pre_v2.csv")  ###Writing as CSV for distribution
)


system.time(
  senti_pre <- read_rds("senti_pre.rds")
)
