# Sentiment calculations -----------------------------------------------------------------

### Note that the methods used here are the consequence of my underpowered laptop being able to do everything at once, or at least be able to do everything at once and still be useable for other things. If you have a more powerful computer, or one that you can let sit and process for a few days, you can skip the process of splitting data by year.

pacman::p_load(readr)
pacman::p_load(magrittr)
pacman::p_load(dplyr)
pacman::p_load(stringr)
pacman::p_load(sentimentr)
pacman::p_load(progress)

system.time(
  debate <- read_rds("debate.rds")
)

system.time(split_data <- split(debate, debate$year)) ### Splitting data variable

system.time(all_names <- names(split_data))

rm(debate)

gc()

pb <- progress_bar$new(total = length(all_names))

system.time(
  for (this_name in all_names) {
    save_name <- paste0(this_name, "dfx.rds")
    write_rds(split_data[[this_name]], path = save_name)
    pb$tick()
  }
)

rm(split_data, all_names, save_name, this_name, pb)

gc()
gc()
gc()
gc()
gc()
gc()
gc()
gc()
gc()
gc()
gc()

#Coding sentiment now
#
##Loading Lexical Libraries
afinn <- as_key(read_csv("lex/afinn.csv"))

jockers <- as_key(read_csv("lex/jockers.csv"))

rheault <- as_key(read_csv("lex/rheault.csv"))

huliu <- as_key(readxl::read_excel("lex/huliu.xlsx"))

nrc <- as_key(read_csv("lex/nrc.csv"))

atemp <- list.files(pattern = "*dfx.rds")

# Looping for sentiment ---------------------
pb <- progress_bar$new(total = length(atemp))


for (i in atemp) {
  
  df <- read_rds(i)
  
  i <- gsub("dfx.rds", "", i)
  
  afinn_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = afinn))
  
  names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"
  
  names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"
  
  jockers_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = jockers))
  
  names(jockers_vector)[names(jockers_vector) == "ave_sentiment"] <- "jockers_sentiment"
  
  names(jockers_vector)[names(jockers_vector) == "sd"] <- "jockers_sd"
  
  nrc_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = nrc))
  
  names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"
  
  names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"
  
  #sentiword_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = lexicon::hash_sentiment_sentiword))
  
  #names(sentiword_vector)[names(sentiword_vector) == "ave_sentiment"] <- "sentiword_sentiment"
  
  #names(sentiword_vector)[names(sentiword_vector) == "sd"] <- "sentiword_sd"
  
  huliu_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = huliu))
  
  names(huliu_vector)[names(huliu_vector) == "ave_sentiment"] <- "huliu_sentiment"
  
  names(huliu_vector)[names(huliu_vector) == "sd"] <- "huliu_sd"
  
  rheault_vector <- with(df, sentiment_by(speech, list(eo_id), polarity_dt = rheault))
  
  names(rheault_vector)[names(rheault_vector) == "ave_sentiment"] <- "rheault_sentiment"
  
  names(rheault_vector)[names(rheault_vector) == "sd"] <- "rheault_sd"
  
  senti_full <- afinn_vector %>%
    left_join(jockers_vector) %>%
    left_join(nrc_vector) %>%
    left_join(huliu_vector) %>%
    left_join(rheault_vector) # %>%
    #left_join(sentiword_vector)
  
  senti_full <- senti_full[, c("eo_id", "word_count", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "huliu_sentiment", "huliu_sd", "rheault_sentiment", "rheault_sd")] #"sentiword_sentiment", "sentiword_sd",
  
  save_name <- paste0("senti_full_", i, "sf.rds")
  
  write_rds(senti_full, path = save_name)
  
  pb$tick()
  
}


rm(list=ls())

gc()

# Looping to combine ---------------------

atemp <- list.files(pattern = "*sf.rds")

match_list <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for(i in atemp) {
  
  system.time(
    match_list[[i]] <- read_rds(i)
  )
  pb$tick()
}

senti_full <- bind_rows(match_list)

write_rds(senti_full, path = "senti_full.rds")

rm(match_list, i, pb, atemp)

gc()

system.time(
  senti_full <- read_rds("senti_full.rds")
)

system.time(
  debate <- read_rds("debate.rds")
)

debate <- left_join(debate, senti_full)

y <- as.Date("1983-02-13")
z <- as.Date("1984-02-13")

debate$speech_date[debate$speech_date==y] <- z

write_rds(debate, "debate.rds")



