
### Removing duplicate speeches, unidentified braying, etc.


# Removing and recoding duplicates --------


system.time(
  senti_df <- read_rds("senti_df.rds")
)

library(readr)
library(magrittr)
library(plyr)
library(dplyr)
# library(tm)
library(tidytext)
library(data.table)
library(syuzhet)
library(sentimentr)

system.time(
  senti_df <- read_rds("senti_df.rds")
)

dupes_table <- senti_df[duplicated(senti_df[,1:2]),]

dupes_table <- as.data.frame(dupes_table)

summary(dupes_table)

n_occur <- data.frame(table(dupes_table$id))

n_occur <- n_occur[n_occur$Freq > 1,]

dupes <- senti_df[senti_df$id %in% n_occur$Var1,]

no_dupes <- senti_df[!(senti_df$id %in% n_occur$Var1),]

removed_dupes <- unique(dupes)

removed_dupes <- with(removed_dupes, removed_dupes[order(id),])

removed_dupes$id[1] <- "uk.org.publicwhip/debate/1982-07-13a.987.0"
removed_dupes$id[2] <- "uk.org.publicwhip/debate/1982-07-13a.987.0"
removed_dupes$id[3] <- "uk.org.publicwhip/debate/1986-07-23a.519.4a"
removed_dupes$id[4] <- "uk.org.publicwhip/debate/1986-07-23a.519.4b"
removed_dupes$id[5] <- "uk.org.publicwhip/debate/1993-02-25a.1000.1a"
removed_dupes$id[6] <- "uk.org.publicwhip/debate/1993-02-25a.1000.1b"

removed_dupes <- removed_dupes[, c("id", "cluster", "speech", "word_count", "speech_date",
                                      "year", "proper_id", "proper_name", "house_start_date",
                                      "date_of_birth","gender", "party", "age",
                                      "party_group")]


bing <- as_key(syuzhet:::bing)
afinn <- as_key(syuzhet:::afinn)
nrc <- data.frame(words = rownames(syuzhet:::nrc), polarity = syuzhet:::nrc[, "positive"] - syuzhet:::nrc[, "negative"],
                  stringsAsFactors = FALSE) %>% {
                    as_key(.[.[["polarity"]] != 0, ])
                  }


afinn_vector <- with(removed_dupes, sentiment_by(speech, list(id, cluster), polarity_dt = afinn))

names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"

names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"

Sys.setlocale(locale = "C")

bing_vector <- with(removed_dupes, sentiment_by(speech, list(id, cluster), polarity_dt = bing))

names(bing_vector)[names(bing_vector) == "ave_sentiment"] <- "bing_sentiment"

names(bing_vector)[names(bing_vector) == "sd"] <- "bing_sd"

nrc_vector <- with(removed_dupes, sentiment_by(speech, list(id, cluster), polarity_dt = nrc))

names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"

names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"

sentiword_vector <- with(removed_dupes, sentiment_by(speech, list(id, cluster), polarity_dt = lexicon::hash_sentiment_sentiword))

names(sentiword_vector)[names(sentiword_vector) == "ave_sentiment"] <- "sentiword_sentiment"

names(sentiword_vector)[names(sentiword_vector) == "sd"] <- "sentiword_sd"

hu_vector <- with(removed_dupes, sentiment_by(speech, list(id, cluster)))

names(hu_vector)[names(hu_vector) == "ave_sentiment"] <- "hu_sentiment"

names(hu_vector)[names(hu_vector) == "sd"] <- "hu_sd"

senti_full_dupes <- removed_dupes %>%
  left_join(afinn_vector, by = c("id", "cluster")) %>%
  left_join(bing_vector, by = c("id", "cluster")) %>%
  left_join(nrc_vector, by = c("id", "cluster")) %>%
  left_join(sentiword_vector, by = c("id", "cluster")) %>%
  left_join(hu_vector, by = c("id", "cluster"))

senti_full_dupes <- senti_full_dupes[senti_full_dupes$word_count.y >= 10, ]

senti_full_dupes <- senti_full_dupes[, c("id", "cluster", "speech", "word_count.y", "speech_date", "year", "afinn_sentiment",
                             "afinn_sd", "bing_sentiment", "bing_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment",
                             "sentiword_sd", "hu_sentiment", "hu_sd", "proper_id", "proper_name", "house_start_date", "date_of_birth",
                             "gender", "party", "age", "party_group")]

names(senti_full_dupes)[names(senti_full_dupes) == "word_count.y"] <- "word_count"


names(senti_full_dupes)

names(senti_full_dupes)==names(no_dupes)

senti_df <- bind_rows(senti_full_dupes, no_dupes)


# ----- Remove 'speeches' that aren't actually speeches
senti_df <- senti_df[senti_df$cluster != "NANANA"
                      & !grepl("Several", senti_df$cluster, ignore.case = TRUE)
                      & !grepl("members", senti_df$cluster, ignore.case = TRUE)
                      & !grepl("Hon.", senti_df$cluster, ignore.case = TRUE),]

senti_df$cluster <- NULL

write_rds(senti_df, "senti_df.rds")

rm(list=ls())

gc()
