# Floor Crossers ------------

library(readr)
library(dplyr)
library(magrittr)

system.time(
  senti_post <- read_rds("senti_post.rds")
)

senti_post <- senti_post[c(1:26)]

names <- read_csv("data/names.csv")

names(names)

senti_post <- left_join(senti_post, names)

switchers <- read_csv("data/switchers.csv", col_types = cols(crossing_one_date = col_date(format = "%Y-%m-%d"),
    crossing_three_date = col_date(format = "%Y-%m-%d"), crossing_two_date = col_date(format = "%Y-%m-%d")))

switchers$crossing_one_date[is.na(switchers$crossing_one_date)] <- Sys.Date()
switchers$crossing_two_date[is.na(switchers$crossing_two_date)] <- Sys.Date()
switchers$crossing_three_date[is.na(switchers$crossing_three_date)] <- Sys.Date()

#switchers$mnis_id <- as.character(switchers$mnis_id)

senti_post$switch_match <- (senti_post$mnis_id %in% switchers$mnis_id)

crossers <- subset(senti_post, switch_match == TRUE)

#crossers$proper_name <- as.character(crossers$proper_name)

stayers <- subset(senti_post, switch_match == FALSE)

rm(senti_post)

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

senti_post <- bind_rows(crossers, stayers)

senti_post_nrow_crossed <- nrow(senti_post)

rm(crossers,crossers2, stayers, switchers,dropping,fac1,pat1,senti_post_nrow,senti_post2_nrow,senti_post_nrow_crossed)

gc()

senti_post$switch_match <- NULL

senti_post$gender <- as.character(senti_post$gender)

senti_post$gender[senti_post$gender=="M"] <- "Male"

senti_post$gender[senti_post$gender=="F"] <- "Female"

senti_post$gender <- as.factor(senti_post$gender)

#summary(senti_post)



# party_group  ------------
senti_post$party_group <- ifelse(senti_post$party == "Labour" |
                                  senti_post$party == "Labour (Co-op)", "Labour",
                                  ifelse(senti_post$party == "Conservative", "Conservative",
                                         ifelse(senti_post$party == "Liberal Democrat" | senti_post$party == "Social Democrat" | senti_post$party == "Liberal", "Liberal Democrat",
                                                ifelse(senti_post$party == "Speaker", "Speaker", "Other"))))
system.time(
  write_rds(senti_post, "senti_post.rds")
)
