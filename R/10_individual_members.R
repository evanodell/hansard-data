
library(readr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)


system.time(split_data <- split(senti_df, senti_df$proper_name))

system.time(all_names <- names(split_data))

rm(senti_df)

gc()

for (this_name in all_names) {
  save_name <- paste0(this_name, "df.rds")
  write_rds(split_data[[this_name]], path = save_name)
}

rm(split_data, all_names, save_name, this_name)

gc()
