

library(readr)
library(stringr)
library(stringi)
library(lubridate)
library(dplyr)

system.time(
  debate <- read_rds("debate.rds")
)

#names(debate)

#debate$word_count <- stringi::stri_count_words(debate$speech)

#summary(debate)

debate$month <- month(debate$speech_date)

debate$decade <- str_sub(debate$year,1,3)

debate$decade <- as.factor(debate$decade)

undf <-  unique(debate[c("hansard_membership_id", "year", "month", "speakerid", "person_id", "speakername")])

write_csv(undf, "undf.csv")

debate$speech <- NULL

system.time(split_data <- split(debate, debate$decade)) ### Splitting data variable

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



