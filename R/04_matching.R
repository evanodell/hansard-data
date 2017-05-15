# Matching speeches with MPs ------------

### The list of MPs comes from matching MPs from the parlparse data with their MNIS ID.

library(readr)
library(dplyr)
library(magrittr)
library(hms)
library(data.table)


system.time(
  senti_full <- read_rds("senti_full.rds")
)

#gc()

#senti_full_nrows <- nrow(senti_full)

### Don't delete the speech dates, split based on them

senti_pre <- senti_full[senti_full$speech_date < "1979-05-03",]

write_rds(senti_pre, "senti_pre.rds")

write_csv(senti_pre, "senti_pre_v2.csv")

rm(senti_pre)

senti_post <- senti_full[senti_full$speech_date >= "1979-05-03",]

write_rds(senti_post, "senti_post.rds")

rm(senti_full)

system.time(senti_post <- read_rds("senti_post.rds"))

senti_post$speech_date <- NULL

senti_post$month <- NULL

senti_post$year <- NULL

senti_post$time <- NULL

senti_post$as_speaker <- NULL

senti_post$url <- NULL

atemp <- list.files(path = "data/", pattern = "*ed.csv")

match_list <- sapply(paste0("data/", atemp), read_csv, col_types = cols(.default = "c"), simplify = FALSE)

match_df <- bind_rows(match_list)

rm(match_list, atemp)

#match_df$time <- as.hms(match_df$time)

#match_df$speech_date <- as.Date(match_df$speech_date)

senti_post <- as.data.table(senti_post)

match_df <- as.data.table(match_df)

#match_df <- as.data.frame(match_df)

#summary(match_df)

#match_df[is.na(match_df)] <- "NA"

#senti_post[is.na(senti_post)] <- "NA"

nrows_senti_post <- nrow(senti_post)

system.time(senti_with_ids <- senti_post %>% left_join(match_df, by = "eo_id"))

senti_with_ids_nrow <- nrow(senti_with_ids)

#summary(senti_with_ids)

names(senti_with_ids)

senti_with_ids2 <- senti_with_ids[c("id.x", "eo_id", "speech", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment","sentiword_sd", "hu_sentiment", "hu_sd", "word_count", "speech_date", "time", "url", "as_speaker", "speakerid_proper", "person_id_proper", "hansard_membership_id_proper", "mnis_id")]

rm(senti_post, match_df, senti_with_ids, nrows_senti_post,senti_with_ids_nrow)

gc()

names(senti_with_ids2)

#senti_with_ids2$speakerid <- NULL

#senti_with_ids2$person_id <- NULL

#senti_with_ids2$hansard_membership_id <- NULL

names(senti_with_ids2)[names(senti_with_ids2)=="hansard_membership_id_proper"] <- "hansard_membership_id"

names(senti_with_ids2)[names(senti_with_ids2)=="speakerid_proper"] <- "speakerid"

names(senti_with_ids2)[names(senti_with_ids2)=="person_id_proper"] <- "person_id"

system.time(write_rds(senti_with_ids2, "senti_with_ids2.rds"))

gc()

#senti_with_ids2 <- read_rds("senti_with_ids2.rds")

names_df <- read_csv("~/Documents/GitHub/hansard-data/data/names.csv", 
                     col_types = cols(date_of_birth = col_date(format = "%Y-%m-%d"), gender = col_factor(levels = c("F","M")), house_end_date = col_date(format = "%Y-%m-%d"), house_start_date = col_date(format = "%Y-%m-%d")))

names_df$mnis_id <- as.character(names_df$mnis_id)

system.time(senti_post2 <- senti_with_ids2 %>% left_join(names_df, by = "mnis_id"))

system.time(write_rds(senti_post2, "senti_post2.rds"))

rm(senti_with_ids2, names_df)
gc()


# Calculating age ------------

library(lubridate)
age <- function(dob, age.day = senti_df$speech_date, units = "years", floor = TRUE) {
  calc.age = interval(dob, age.day)/duration(num = 1, units = units)
  if (floor)
    return(as.integer(floor(calc.age)))
  return(calc.age)
}

senti_df$age <- age(senti_df$date_of_birth)

write_rds(senti_post2, "senti_post2.rds")

rm(list=ls())

gc()

