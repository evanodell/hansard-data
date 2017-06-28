# Sentiment calculations -----------------------------------------------------------------

### Note that the methods used here are the consequence of my underpowered laptop being able to do everything at once, or at least be able to do everything at once and still be useable for other things. If you have a more powerful computer, or one that you can let sit and process for a few days, you can skip the process of splitting data by year.


pacman::p_load(readr)
pacman::p_load(magrittr)
pacman::p_load(dplyr)
pacman::p_load(stringr)
pacman::p_load(sentimentr)
pacman::p_load(progress)
pacman::p_load(lubridate)

system.time(
  debate <- read_rds("hansard_senti_post_V21.rds")
)


system.time(split_data <- split(debate, debate$year)) ### Splitting data variable

system.time(all_names <- names(split_data))

rm(debate)

gc()


pb <- progress_bar$new(total = length(all_names))

for (this_name in all_names) {
  save_name <- paste0(this_name, "dfx.rds")
  write_rds(split_data[[this_name]], path = save_name)
  pb$tick()
}

rm(split_data, all_names, save_name, this_name, pb)

gc()

#Coding sentiment now
afinn <- as_key(syuzhet:::afinn)

syuzhet <- as_key(syuzhet:::syuzhet_dict)

rheault <- as_key(read_csv("lexicon-polarity-ave.csv"))##Insert dataset

atemp <- list.files(pattern = "*dfx.rds")

# Looping for sentiment ---------------------
pb <- progress_bar$new(total = length(atemp))


for (i in atemp) {
  
  df <- read_rds(i)
  
  afinn_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = afinn))
  
  names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"
  
  names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"
  
  jockers_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = lexicon::hash_sentiment_jockers))
  
  names(jockers_vector)[names(jockers_vector) == "ave_sentiment"] <- "jockers_sentiment"
  
  names(jockers_vector)[names(jockers_vector) == "sd"] <- "jockers_sd"
  
  nrc_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = lexicon::hash_sentiment_nrc))
  
  names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"
  
  names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"
  
  sentiword_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = lexicon::hash_sentiment_sentiword))
  
  names(sentiword_vector)[names(sentiword_vector) == "ave_sentiment"] <- "sentiword_sentiment"
  
  names(sentiword_vector)[names(sentiword_vector) == "sd"] <- "sentiword_sd"
  
  hu_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = lexicon::hash_sentiment_huliu))
  
  names(hu_vector)[names(hu_vector) == "ave_sentiment"] <- "hu_sentiment"
  
  names(hu_vector)[names(hu_vector) == "sd"] <- "hu_sd"
  
  rheault_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = rheault))
                         
  names(rheault_vector)[names(rheault_vector) == "ave_sentiment"] <- "rheault_sentiment"
                         
  names(rheault_vector)[names(rheault_vector) == "sd"] <- "rheault_sd"
                         
   senti_full <- afinn_vector %>% 
     left_join(jockers_vector) %>% 
     left_join(nrc_vector) %>% 
     left_join(sentiword_vector) %>% 
     left_join(hu_vector) %>% 
     left_join(rheault_vector)
                         
  senti_full <- senti_full[, c("eo_id", "word_count", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment", "sentiword_sd", "hu_sentiment", "hu_sd", "rheault_sentiment", "rheault_sd")]
                         
  save_name <- paste0("full_data/senti_full_", i, "x.rds")
                         
  write_rds(senti_full, path = save_name)
  
  pb$tick()
                         
}


rm(list=ls())

# Looping to combine ---------------------

atemp <- list.files(pattern = "*dfx.rdsx.rds")

match_list <- vector("list", 39) 
pb <- progress_bar$new(total = 39)

for(i in atemp) {
  
  system.time(
    match_list[[i]] <- read_rds(i)
  )
  pb$tick()
}



look_list <- list("1", "2","3","4","5","6","7","8",'9',"0")

pb <- progress_bar$new(total = length(look_list))

for(j in look_list){
  atemp <- list.files(path ="full_data/", pattern = paste0("*", j, "dfx.rds.rds"))
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
