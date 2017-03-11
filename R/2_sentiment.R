# Sentiment calculations -----------------------------------------------------------------

### Note that the methods used here are the consequence of my underpowered laptop being able to do everything at once, or at least be able to do everything at once and still be usuable for other things. If you have a more powerful computer, or one that you can let sit and process for a few days, you can skip the process of splitting data by year.


library(readr)
library(magrittr)
library(plyr)
library(dplyr)
library(RPostgreSQL)
# library(tm)
library(tidytext)
library(data.table)
library(syuzhet)
library(sentimentr)
library(lubridate)

system.time(debate_sample <- read_rds("debate_sample.rds"))

debate_sample <- debate_sample[, c("id", "cluster", "speech", "word_count", "speech_date")]


clean_fun <- function(htmlString) { ### Function to strip out HTML
    return(gsub("<.*?>", "", htmlString))
}

debate_sample$speech <- clean_fun(debate_sample$speech) ### Strip out HTML

debate_sample$year <- year(debate_sample$speech_date) ### Year variable

system.time(split_data <- split(debate_sample, debate_sample$year)) ### Splitting data variable

system.time(all_names <- names(split_data))

rm(debate_sample)

gc()

for (this_name in all_names) {
    save_name <- paste0(this_name, "df.rds")
    write_rds(split_data[[this_name]], path = save_name)
}

rm(split_date, all_names, save_name)

gc()


bing <- as_key(syuzhet:::bing)
afinn <- as_key(syuzhet:::afinn)
nrc <- data.frame(words = rownames(syuzhet:::nrc), polarity = syuzhet:::nrc[, "positive"] - syuzhet:::nrc[, "negative"],
    stringsAsFactors = FALSE) %>% {
    as_key(.[.[["polarity"]] != 0, ])
}

atemp <- list.files(pattern = "*df.rds")

# Looping ---------------------

for (i in atemp) {

    df <- read_rds(i)

    afinn_vector <- with(df, sentiment_by(speech, list(id, cluster), polarity_dt = afinn))

    names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"

    names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"

    Sys.setlocale(locale = "C")

    bing_vector <- with(df, sentiment_by(speech, list(id, cluster), polarity_dt = bing))

    names(bing_vector)[names(bing_vector) == "ave_sentiment"] <- "bing_sentiment"

    names(bing_vector)[names(bing_vector) == "sd"] <- "bing_sd"

    nrc_vector <- with(df, sentiment_by(speech, list(id, cluster), polarity_dt = nrc))

    names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"

    names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"

    sentiword_vector <- with(df, sentiment_by(speech, list(id, cluster), polarity_dt = lexicon::hash_sentiment_sentiword))

    names(sentiword_vector)[names(sentiword_vector) == "ave_sentiment"] <- "sentiword_sentiment"

    names(sentiword_vector)[names(sentiword_vector) == "sd"] <- "sentiword_sd"

    hu_vector <- with(df, sentiment_by(speech, list(id, cluster)))

    names(hu_vector)[names(hu_vector) == "ave_sentiment"] <- "hu_sentiment"

    names(hu_vector)[names(hu_vector) == "sd"] <- "hu_sd"

    senti_full <- df %>% left_join(afinn_vector, by = c("id", "cluster")) %>% left_join(bing_vector, by = c("id",
        "cluster")) %>% left_join(nrc_vector, by = c("id", "cluster")) %>% left_join(sentiword_vector, by = c("id",
        "cluster")) %>% left_join(hu_vector, by = c("id", "cluster"))

    senti_full <- senti_full[senti_full$word_count.y >= 10, ]

    senti_full <- senti_full[, c("id", "cluster", "speech", "word_count.y", "speech_date", "year", "afinn_sentiment",
        "afinn_sd", "bing_sentiment", "bing_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment", "sentiword_sd",
        "hu_sentiment", "hu_sd")]

    save_name <- paste0("./full_data/senti_full_", i)

    write_rds(senti_full, path = save_name)

    rm(save_name, senti_full, hu_vector, afinn_vector, sentiword_vector, nrc_vector, bing_vector, df)

    gc()

}

rm(afinn, bing, nrc, i)



atemp <- list.files(pattern = "*0df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df0 <- bind_rows(df.list)

write_rds(df0, "df0.rds")

rm(df0)
gc()


atemp <- list.files(pattern = "*1df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df1 <- bind_rows(df.list)

write_rds(df1, "df1.rds")

rm(df1)

gc()


atemp <- list.files(pattern = "*2df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df2 <- bind_rows(df.list)

write_rds(df2, "df2.rds")

rm(df2)

gc()

atemp <- list.files(pattern = "*3df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df3 <- bind_rows(df.list)

write_rds(df3, "df3.rds")

rm(df3)

gc()

atemp <- list.files(pattern = "*4df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df4 <- bind_rows(df.list)

write_rds(df4, "df4.rds")

rm(df4)
gc()


atemp <- list.files(pattern = "*5df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df5 <- bind_rows(df.list)

write_rds(df5, "df5.rds")

rm(df5)


gc()
atemp <- list.files(pattern = "*6df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df6 <- bind_rows(df.list)

write_rds(df6, "df6.rds")

rm(df6)


gc()
atemp <- list.files(pattern = "*7df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df7 <- bind_rows(df.list)

write_rds(df7, "df7.rds")

rm(df7)

gc()

atemp <- list.files(pattern = "*8df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df8 <- bind_rows(df.list)

write_rds(df8, "df8.rds")

rm(df8)


gc()
atemp <- list.files(pattern = "*9df.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

df9 <- bind_rows(df.list)

write_rds(df9, "df9.rds")

rm(df9)


gc()

rm(df.list)

atemp <- list.files(pattern = "*.rds")

df.list <- sapply(atemp, read_rds, simplify = FALSE)

senti_no_mp <- bind_rows(df.list)

write_rds(senti_no_mp, "senti_no_mp.rds")

gc()
