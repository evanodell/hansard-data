# Floor Crossers ------------

system.time(
  senti_df <- read_rds("senti_df.rds")
)


### Splitting between MPs who cross the floor and MPs who did not.

switchers <- read_csv("~/Documents/hansard1936-2016/switchers.csv", col_types = cols(crossing_one_date = col_date(format = "%Y-%m-%d"),
    crossing_three_date = col_date(format = "%Y-%m-%d"), crossing_two_date = col_date(format = "%Y-%m-%d")))

switchers$crossing_one_date[is.na(switchers$crossing_one_date)] <- Sys.Date()
switchers$crossing_two_date[is.na(switchers$crossing_two_date)] <- Sys.Date()
switchers$crossing_three_date[is.na(switchers$crossing_three_date)] <- Sys.Date()

senti_df$switch_match <- (senti_df$proper_id %in% switchers$proper_id)

crossers <- subset(senti_df, switch_match == TRUE)

stayers <- subset(senti_df, switch_match == FALSE)

rm(senti_df)

gc()

system.time(crossers <- crossers %>% left_join(switchers, by = "proper_id"))

crossers$party2 <- ifelse(crossers$crossing_one_date >= crossers$speech_date | crossers$crossing_two_date <= crossers$speech_date,
    crossers$crossing_one_to, crossers$crossing_one_from)

crossers$party3 <- ifelse(crossers$crossing_two_date >= crossers$speech_date | crossers$crossing_three_date <= crossers$speech_date,
    crossers$crossing_two_to, crossers$crossing_two_from)

crossers$party4 <- ifelse(crossers$crossing_three_date >= crossers$speech_date | crossers$crossing_three_date <= crossers$speech_date,
    crossers$crossing_three_to, crossers$crossing_three_from)

crossers$party3[is.na(crossers$party3)] <- as.character(crossers$party2[is.na(crossers$party3)])
crossers$party4[is.na(crossers$party4)] <- as.character(crossers$party3[is.na(crossers$party4)])


pat1 <- c("party4","party2","party3","party")

crossers[pat1] <- lapply(crossers[pat1], factor)

#summary(crossers)

crossers$party <- crossers$party4

dropping <- c("party4","party2","party3","proper_name.y", "crossing_one_date", "crossing_one_from", "crossing_one_to", "crossing_two_date", "crossing_two_from", "crossing_two_to", "crossing_three_date", "crossing_three_from", "crossing_three_to")

crossers <- crossers[,!names(crossers) %in% dropping]

names(crossers)[names(crossers) == "proper_name.x"] <- "proper_name"

names(crossers) == names(stayers)

senti_df <- bind_rows(crossers, stayers)

senti_df_nrow_crossed <- nrow(senti_df)

rm(crossers, stayers, switchers)

gc()

senti_df$party_group <- ifelse(senti_df$party == "Labour" |
                                 senti_df$party == "Labour (Co-op)", "Labour",
                               ifelse(senti_df$party == "Conservative", "Conservative",
                                      ifelse(senti_df$party == "Liberal Democrat", "Liberal Democrat",
                                             ifelse(senti_df$party == "Speaker", "Speaker", "Other"))))

senti_df$switch_match <- NULL

senti_df$gender <- as.character(senti_df$gender)

senti_df$gender[senti_df$gender=="M"] <- "Male"

senti_df$gender[senti_df$gender=="F"] <- "Female"

senti_df$gender <- as.factor(senti_df$gender)

#summary(senti_df)

write_rds(senti_df, "senti_df.rds")
