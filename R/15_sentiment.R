
library(readr)
library(progress)
library(sentimentr)
library(dplyr)

system.time(
  senti_df <- read_rds("senti_df2.rds")
)


system.time(
   senti_df <- mutate(senti_df, eo_id = rownames(senti_df))
)

write_rds(senti_df, "senti_df2.rds")

# sentiment analysis ------------------------------------------------------

system.time(split_data <- split(senti_df, senti_df$year)) ### Splitting data variable

system.time(all_names <- names(split_data))

pb <- progress_bar$new(total = length(all_names))

system.time(
  for (this_name in all_names) {
    save_name <- paste0(this_name, "dfx.rds")
    write_rds(split_data[[this_name]], path = save_name)
    pb$tick()
  }
)

rm(split_data, all_names, save_name, this_name, pb, senti_df)

gc()
gc()
gc()

#Coding sentiment now
#
##Loading Lexical Libraries
afinn <- as_key(read_csv("lex/afinn.csv"))

rheault <- as_key(read_csv("lex/rheault.csv"))


# jockers <- as_key(read_csv("lex/jockers.csv"))
# 
# 
# huliu <- as_key(readxl::read_excel("lex/huliu.xlsx"))
# 
# nrc <- as_key(read_csv("lex/nrc.csv"))

atemp <- list.files(pattern = "*dfx.rds")

# Looping for sentiment ---------------------
pb <- progress_bar$new(total = length(atemp))


for (i in atemp) {
  
  df <- read_rds(i)
  
  i <- gsub("dfx.rds", "", i)
  
  afinn_vector <- with(df, sentiment_by(get_sentences(speech), list(eo_id), polarity_dt = afinn))
  
  names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"
  
  names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"
  
  jockers_vector <- with(df, sentiment_by(get_sentences(speech), list(eo_id), polarity_dt = lexicon::hash_sentiment_jockers ))
  
  names(jockers_vector)[names(jockers_vector) == "ave_sentiment"] <- "jockers_sentiment"
  
  names(jockers_vector)[names(jockers_vector) == "sd"] <- "jockers_sd"
  
  nrc_vector <- with(df, sentiment_by(get_sentences(speech), list(eo_id), polarity_dt = lexicon::hash_sentiment_nrc ))
  
  names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"
  
  names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"
  
  huliu_vector <- with(df, sentiment_by(get_sentences(speech), list(eo_id), polarity_dt = lexicon::hash_sentiment_huliu))
  
  names(huliu_vector)[names(huliu_vector) == "ave_sentiment"] <- "huliu_sentiment"
  
  names(huliu_vector)[names(huliu_vector) == "sd"] <- "huliu_sd"
  
  rheault_vector <- with(df, sentiment_by(get_sentences(speech), list(eo_id), polarity_dt = rheault))
  
  names(rheault_vector)[names(rheault_vector) == "ave_sentiment"] <- "rheault_sentiment"
  
  names(rheault_vector)[names(rheault_vector) == "sd"] <- "rheault_sd"
  
  jockers_rinker_vector <- with(df, 
                                sentiment_by(get_sentences(speech),
                                             list(eo_id), 
                                             polarity_dt = lexicon::hash_sentiment_jockers_rinker ))
  
  names(jockers_rinker_vector)[names(jockers_rinker_vector) == "ave_sentiment"] <- "jockers_rinker_sentiment"
  
  names(jockers_rinker_vector)[names(jockers_rinker_vector) == "sd"] <- "jockers_rinker_sd"
  
  senticnet_vector <- with(df, 
                           sentiment_by(get_sentences(speech), 
                                        list(eo_id), 
                                        polarity_dt = lexicon::hash_sentiment_senticnet))
  
  names(senticnet_vector)[names(senticnet_vector) == "ave_sentiment"] <- "senticnet_sentiment"
  
  names(senticnet_vector)[names(senticnet_vector) == "sd"] <- "senticnet_sd"
  
  senti_full <- afinn_vector %>%
    left_join(jockers_vector) %>%
    left_join(nrc_vector) %>%
    left_join(huliu_vector) %>%
    left_join(rheault_vector) %>%
    left_join(jockers_rinker_vector) %>%
    left_join(senticnet_vector)
  
  # senti_full <- senti_full[, c("eo_id", "word_count", "afinn_sentiment",
  #                              "afinn_sd", "jockers_sentiment", "jockers_sd",
  #                              "nrc_sentiment", "nrc_sd", "huliu_sentiment",
  #                              "huliu_sd", "rheault_sentiment", "rheault_sd",
  #                              "jockers_rinker_sentiment", "jockers_rinker_sd",
  #                              "senticnet_sentiment", "senticnet_sd")] 
  
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



### check all this code, I think its fucked


senti_full <- bind_rows(match_list)

write_rds(senti_full, path = "senti_full.rds")

rm(match_list, i, pb, atemp)

gc()

system.time(
  senti_df <- read_rds("senti_df2.rds")
)


debate <- left_join(senti_df, senti_full)

write_rds(debate, "senti_df2.rds")
