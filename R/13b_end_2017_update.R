#16


# End of 2017 update ------------------------------------------------------

library(readr)
library(dplyr)


system.time(
  senti_df <- read_rds("hansard_senti_post_V242.rds")
)

senti_df$proper_name <- gsub("Julia Dockerill", "Julia Lopez", senti_df$proper_name)

debate <- read_rds("debate-2017.rds")

debate <- debate[debate$speaker_name!="NA"&
                   debate$speaker_name!="Several hon. Members",]

debate$speaker_name <- gsub("Marsha de Cordova", "Marsha De Cordova", debate$speaker_name)

debate$speaker_name <- gsub("Ian Paisley Jnr", "Ian Paisley Jr", debate$speaker_name)

debate$speaker_name <- gsub("Dr Caroline Johnson", "Caroline Johnson", debate$speaker_name)

debate$speaker_name <- gsub("Diana R. Johnson", "Diana Johnson", debate$speaker_name)

debate$speaker_name <- gsub("Vincent Cable", "Vince Cable", debate$speaker_name)

debate$speaker_name <- gsub("Andrew Slaughter", "Andy Slaughter", debate$speaker_name)

debate$speaker_name <- gsub("Steve Pound", "Stephen Pound", debate$speaker_name)

debate$speaker_name <- gsub("Chris Leslie", "Christopher Leslie", debate$speaker_name)

debate$speaker_name <- gsub("Nicholas Dakin", "Nic Dakin", debate$speaker_name)

debate$speaker_name <- gsub("John Martin McDonnell", "John McDonnell", debate$speaker_name)

debate$speaker_name <- gsub("Steve McCabe", "Stephen McCabe", debate$speaker_name)

debate$speaker_name <- gsub("Mike Wood", "Mike Wood (Dudley South)", debate$speaker_name)

debate$speaker_name <- gsub("Jeffrey M. Donaldson", "Jeffrey Donaldson", debate$speaker_name)

names <- read_csv("data/names.csv")

test1 <- left_join(debate, names, by=c("speaker_name"="proper_name"))

names(test1)[names(test1)=="speaker_name"] <- "proper_name"

names(test1) %in% names(senti_df)


names(test1)

senti_df2 <- bind_rows(senti_df, test1)

write_rds(senti_df2, "senti_df2.rds")






