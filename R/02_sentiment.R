# Sentiment calculations -----------------------------------------------------------------

### Note that the methods used here are the consequence of my underpowered laptop being able to do everything at once, or at least be able to do everything at once and still be usuable for other things. If you have a more powerful computer, or one that you can let sit and process for a few days, you can skip the process of splitting data by year.


library(readr)
library(magrittr)
library(dplyr)
library(stringr)
library(sentimentr)
library(progress)
library(lubridate)

system.time(
  debate <- read_rds("debate.rds")
  )

debate$date <- gsub("uk.org.publicwhip/debate/", "", debate$id)

debate$speakerid <- gsub("uk.org.publicwhip/member/", "", debate$speakerid)

debate$person_id <- gsub("uk.org.publicwhip/person/", "", debate$person_id)

debate$date <-  str_sub(debate$date,1,10)

debate$speech_date <- as.Date(debate$date)

debate$date <- NULL

debate$year <- year(debate$speech_date) ### Year variable

#debate <- subset(debate, year > 2009)

system.time(split_data <- split(debate, debate$year)) ### Splitting data variable

system.time(all_names <- names(split_data))

rm(debate)

gc()

for (this_name in all_names) {
  save_name <- paste0(this_name, "df.rds")
  write_rds(split_data[[this_name]], path = save_name)
}

rm(split_data, all_names, save_name)

gc()

#Coding sentiment now
afinn <- as_key(syuzhet:::afinn)

syuzhet <- as_key(syuzhet:::syuzhet_dict)

atemp <- list.files(pattern = "*df.rds")

# Looping ---------------------
pb <- progress_bar$new(total = length(atemp))


for (i in atemp) {
  
  df <- read_rds(i)
  
  pb$tick()
  
  afinn_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = afinn))
  
  names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"
  
  names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"
  
  jockers_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_jockers))
  
  names(jockers_vector)[names(jockers_vector) == "ave_sentiment"] <- "jockers_sentiment"
  
  names(jockers_vector)[names(jockers_vector) == "sd"] <- "jockers_sd"
  
  nrc_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_nrc))
  
  names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"
  
  names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"
  
  sentiword_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_sentiword))
  
  names(sentiword_vector)[names(sentiword_vector) == "ave_sentiment"] <- "sentiword_sentiment"
  
  names(sentiword_vector)[names(sentiword_vector) == "sd"] <- "sentiword_sd"
  
  hu_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_huliu))
  
  names(hu_vector)[names(hu_vector) == "ave_sentiment"] <- "hu_sentiment"
  
  names(hu_vector)[names(hu_vector) == "sd"] <- "hu_sd"
  
  senti_full <- df %>% 
    left_join(afinn_vector, by = c("id", "hansard_membership_id","speech_date", "year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>%
    left_join(jockers_vector, by = c("id", "hansard_membership_id","speech_date","year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>% 
    left_join(nrc_vector, by = c("id", "hansard_membership_id","speech_date","year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>%
    left_join(sentiword_vector, by = c("id", "hansard_membership_id","year", "speech_date","speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>%
    left_join(hu_vector, by = c("id", "hansard_membership_id", "speech_date","year", "speakerid", "person_id", "speakername", "colnum", "time", "url", "as_speaker"))
  
  #senti_full <- senti_full[senti_full$word_count.y >= 10, ]
  
  senti_full <- senti_full[, c("speech", "id", "hansard_membership_id","speech_date", "year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker", "word_count.y", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment", "sentiword_sd", "hu_sentiment", "hu_sd")]
  
  save_name <- paste0("full_data/senti_full_", i, ".rds")
  
  write_rds(senti_full, path = save_name)
  
  #rm(save_name, senti_full, hu_vector, afinn_vector, sentiword_vector, nrc_vector, jockers_vector, df)
  
}

rm(list=ls())

look_list <- list("1", "2","3","4","5","6","7","8",'9',"0")

pb <- progress_bar$new(total = length(look_list))

for(j in look_list){
  atemp <- list.files(path ="full_data/", pattern = paste0("*", j, "df.rds.rds"))
  df.list <- sapply(paste0("full_data/",atemp), read_rds, simplify = FALSE)
  df <- bind_rows(df.list)
  save_name <- paste0("senti_full_", j, ".rds")
  write_rds(df, path = save_name)
  
  gc()
  
  pb$tick()

}

rm(list=ls())



  atemp <- list.files(pattern = paste0("*.rds"))
  df.list <- sapply(atemp, read_rds, simplify = FALSE)
  df <- bind_rows(df.list)

  write_rds(df, path = "senti_full.rds")
  
  gc()
  

