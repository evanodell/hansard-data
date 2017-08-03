

library(readr)
library(stringr)
library(stringi)
library(lubridate)
library(dplyr)

system.time(
  debate <- read_rds("debate.rds")
)

senti_post <- senti_post[senti_post$speaker_name!="NA",]

#names(senti_post)

#senti_post$word_count <- stringi::stri_count_words(senti_post$speech)

#summary(senti_post)

#senti_post$month <- month(senti_post$speech_date)

#undf <-  unique(senti_post[c("hansard_membership_id", "year", "month", "speaker_id", "person_id", "speaker_name")])

#write_csv(undf, "undf.csv")

#senti_post$speech <- NULL

senti_post$decade <- str_sub(senti_post$year,1,3)

senti_post$decade <- as.factor(senti_post$decade)

system.time(split_data <- split(senti_post, senti_post$decade)) ### Splitting data variable

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



