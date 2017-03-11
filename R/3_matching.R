# Matching speeches with MPs ------------

### The list of MPs comes from matching MPs from the parlparse data with their MNIS ID.

library(readr)
library(plyr)
library(dplyr)

system.time(senti_no_mp <- read_rds("senti_no_mp.rds"))

gc()

senti_no_mp_nrows <- nrow(senti_no_mp)

atemp <- list.files(path = "data/", pattern = "*ed.csv")

match_list <- sapply(atemp, read_csv, simplify = FALSE)

match_df <- bind_rows(match_list)

rm(match_list, atemp)

write_rds(match_df, 'match_df.rds')

system.time(senti_with_ids <- senti_no_mp %>% left_join(match_df, by = c("id", "cluster")))

senti_with_ids_nrow <- nrow(senti_with_ids)

rm(senti_no_mp, match_df)

gc()

names_df <- read_csv("~/Documents/hansard1936-2016/names.csv", col_types = cols(date_of_birth = col_date(format = "%Y-%m-%d"),
    house_start_date = col_date(format = "%Y-%m-%d")))

system.time(senti_df <- senti_with_ids %>% left_join(names_df, by = c("proper_id")))
rm(senti_with_ids, names_df)
gc()

senti_df_nrow <- nrow(senti_df)

names(senti_df)[names(senti_df) == "word_count.y"] <- "word_count"

# Calculating age ------------

library(lubridate)
age <- function(dob, age.day = senti_df$speech_date, units = "years", floor = TRUE) {
    calc.age = interval(dob, age.day)/duration(num = 1, units = units)
    if (floor)
        return(as.integer(floor(calc.age)))
    return(calc.age)
}

senti_df$age <- age(senti_df$date_of_birth)

gc()

write_rds(senti_df, "senti_df.rds")
