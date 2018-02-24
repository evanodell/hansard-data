
pacman::p_load(readr)
#pacman::p_load(reticulate)
pacman::p_load(feather)

system.time(
  senti_df <- read_rds("senti_df2.rds")
)

#py_save_object(senti_df, "test.pkl", pickle = "pickle")


path <- "senti_df.feather"
write_feather(senti_df, path)

x <- read_feather("senti_df.feather")

drops <- c("party_group", "party", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "huliu_sentiment", "huliu_sd", "rheault_sentiment", "rheault_sd", "age", "gender", "government", "government", "ministry", "house_end_date", "house_start_date", "word_count", "speaker_office", "date_of_birth", "dods_id", "pims_id")

senti_df <- senti_df[ , !(names(senti_df) %in% drops)]

names(senti_df)


write_rds(senti_df, "senti_df2.rds")

senti_df_pre <- senti_df[senti_df$speech_date<="1980-01-01",]

write_rds(senti_df_pre, "senti_df_pre.rds")

