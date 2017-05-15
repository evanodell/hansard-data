

library(readr)
library(stringr)
library(stringi)
library(lubridate)
library(dplyr)

system.time(
  senti_full <- read_rds("senti_full.rds")
)

#names(senti_full)

senti_full$word_count <- stringi::stri_count_words(senti_full$speech)

senti_full$speakerid <- gsub("uk.org.publicwhip/member/", "", senti_full$speakerid)

senti_full$person_id <- gsub("uk.org.publicwhip/person/", "", senti_full$person_id)

#summary(senti_full)

senti_full <- mutate(senti_full, eo_id = rownames(senti_full))

senti_full2 <- senti_full

write_rds(senti_full, "senti_full.rds")

rm(senti_full)

senti_full2$month <- month(senti_full2$speech_date)

senti_full2$decade <- str_sub(senti_full2$year,1,3)

senti_full2$decade <- as.factor(senti_full2$decade)

undf <-  unique(senti_full2[c("hansard_membership_id", "year", "month", "speakerid", "person_id", "speakername")])

write_csv(undf, "undf.csv")

senti_full2$speech <- NULL

system.time(split_data <- split(senti_full2, senti_full2$decade)) ### Splitting data variable

system.time(all_names <- names(split_data))

for (this_name in all_names) {
  save_name <- paste0(this_name, ".csv")
  write_csv(split_data[[this_name]], path = save_name)
}

atemp <- list.files(pattern = "*.csv")

match_list <- sapply(atemp, read_csv, col_types = cols(.default = "c"), simplify = FALSE)

for(i in atemp){
  v <- read_csv(paste0(i), col_types = cols(.default = "c"))
  v <- as.data.frame(v)
  newdata <- v[c("eo_id", "id", "hansard_membership_id", "speech_date", "month", "year", "speakerid", "person_id", "speakername", "colnum", "time", "url", "as_speaker" )]
  write_csv(newdata, path = paste0(i))
}



