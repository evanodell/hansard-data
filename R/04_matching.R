# Matching speeches with MPs ------------

### The list of MPs comes from matching MPs from the parlparse data with their MNIS ID.

library(readr)
library(dplyr)
library(magrittr)
library(hms)
library(progress)


system.time(
  debate <- read_rds("debate.rds")
)

#gc()

#debate_nrows <- nrow(debate)

### Don't delete the speech dates, split based on them
system.time(
  senti_pre <- debate[debate$speech_date < "1979-05-03",]
)

write_rds(senti_pre, "senti_pre.rds")

#write_csv(senti_pre, "senti_pre_v2.csv")

rm(senti_pre)

system.time(
  senti_post <- debate[debate$speech_date >= "1979-05-03",]
)

write_rds(senti_post, "senti_post.rds")

rm(debate)
# 
# system.time(senti_post <- read_rds("senti_post.rds"))
# 
# #senti_post$speech_date <- NULL
# 
# #senti_post$month <- NULL
# 
# #senti_post$year <- NULL
# 
# #senti_post$time <- NULL
# 
# #senti_post$as_speaker <- NULL
# 
# #senti_post$url <- NULL
# 
# #atemp <- list.files(path = "data/", pattern = "*ed.csv")
# 
# #match_list <- sapply(paste0("data/", atemp), read_csv, col_types = cols(.default = "c"), simplify = FALSE)
# 
# #match_df <- bind_rows(match_list)
# 
# #rm(match_list, atemp)
# 
# #match_df$time <- as.hms(match_df$time)
# 
# #match_df$speech_date <- as.Date(match_df$speech_date)
# 
# senti_post <- as.data.table(senti_post)
# 
# match_df <- as.data.table(match_df)
# 
# #match_df <- as.data.frame(match_df)
# 
# #summary(match_df)
# 
# #match_df[is.na(match_df)] <- "NA"
# 
# #senti_post[is.na(senti_post)] <- "NA"
# 
# ### Need to combine with older version
# 
# nrows_senti_post <- nrow(senti_post)
# 
# system.time(senti_with_ids <- senti_post %>% left_join(match_df, by = "eo_id"))
# 
# senti_with_ids_nrow <- nrow(senti_with_ids)
# 
# #summary(senti_with_ids)
# 
# names(senti_with_ids)
# 
# senti_with_ids2 <- senti_with_ids[c("id.x", "eo_id", "speech", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment","sentiword_sd", "hu_sentiment", "hu_sd", "word_count", "speech_date", "time", "url", "as_speaker", "speakerid_proper", "person_id_proper", "hansard_membership_id_proper", "mnis_id")]
# 
# rm(senti_post, match_df, senti_with_ids, nrows_senti_post,senti_with_ids_nrow)
# 
# gc()
# 
# names(senti_with_ids2)
# 
# #senti_with_ids2$speakerid <- NULL
# 
# #senti_with_ids2$person_id <- NULL
# 
# #senti_with_ids2$hansard_membership_id <- NULL
# 
# names(senti_with_ids2)[names(senti_with_ids2)=="hansard_membership_id_proper"] <- "hansard_membership_id"
# 
# names(senti_with_ids2)[names(senti_with_ids2)=="speakerid_proper"] <- "speakerid"
# 
# names(senti_with_ids2)[names(senti_with_ids2)=="person_id_proper"] <- "person_id"
# 
# system.time(write_rds(senti_with_ids2, "senti_with_ids2.rds"))
# 
# gc()
# 
# #senti_with_ids2 <- read_rds("senti_with_ids2.rds")
# 
# names_df <- read_csv("~/Documents/GitHub/hansard-data/data/names.csv", 
#                      col_types = cols(date_of_birth = col_date(format = "%Y-%m-%d"), gender = col_factor(levels = c("F","M")), house_end_date = col_date(format = "%Y-%m-%d"), house_start_date = col_date(format = "%Y-%m-%d")))
# 
# names_df$mnis_id <- as.character(names_df$mnis_id)
# 
# system.time(senti_post2 <- senti_with_ids2 %>% left_join(names_df, by = "mnis_id"))
# 
# system.time(write_rds(senti_post2, "senti_post2.rds"))
# 
# rm(senti_with_ids2, names_df)
# gc()
# 
# 
# # Calculating age ------------
# 
# library(lubridate)
# age <- function(dob, age.day = senti_df$speech_date, units = "years", floor = TRUE) {
#   calc.age = interval(dob, age.day)/duration(num = 1, units = units)
#   if (floor)
#     return(as.integer(floor(calc.age)))
#   return(calc.age)
# }
# 
# senti_df$age <- age(senti_df$date_of_birth)
# 
# write_rds(senti_post2, "senti_post2.rds")
# 
# rm(list=ls())
# 
# gc()
# 

gc()

system.time(
  senti_post <- read_rds("senti_post.rds")
)

system.time(
  hansard_senti_post_V23 <- read_rds("hansard_senti_post_V23.rds")
)

debate$pp_id <- gsub("a\\.", ".", debate$pp_id)

debate$pp_id <- gsub("b\\.", ".", debate$pp_id)

debate$pp_id <- gsub("c\\.", ".", debate$pp_id)

debate$pp_id <- gsub("d\\.", ".", debate$pp_id)

debate$pp_id <- gsub("e\\.", ".", debate$pp_id)

debate$pp_id <- gsub("f\\.", ".", debate$pp_id)

debate$pp_id <- gsub("g\\.", ".", debate$pp_id)


nrow_hansard_senti_post_V23 <- nrow(hansard_senti_post_V23)

x <- hansard_senti_post_V23$year

x <-  as.list(unique(x))

pb <- progress_bar$new(total = length(x))



dupes$speech <- NULL

#### Match dupes to corresponding V23 


for (i in x) {
  this_name2 <- distinct(hansard_senti_post_V23[hansard_senti_post_V23$year==i,], pp_id, .keep_all=TRUE)
  save_name <- paste0(i, "x.rds")
  write_rds(this_name2, path = save_name)
  pb$tick()
}

rm(x,hansard_senti_post_V23,pb,save_name,i)

gc()

gc()

gc()

gc()

gc()

gc()

gc()

gc()

atemp <- list.files(pattern = "*x.rds")

match_list <- vector("list", length(atemp)) 
pb <- progress_bar$new(total = length(atemp))

for(i in atemp) {
  
  system.time(
    match_list[[i]] <- read_rds(i)
  )
  pb$tick()
}

V23_dupe_check <- bind_rows(match_list)

dupes <- duplicated(V23_dupe_check$pp_id)

dupes <- V23_dupe_check[V23_dupe_check$pp_id %in% V23_dupe_check$pp_id[duplicated(V23_dupe_check$pp_id)],]

rm(match_list,pb,i,atemp)




names(hansard_senti_post_V23)[names(hansard_senti_post_V23)=="speakerid"] <- "speaker_id"

hansard_senti_post_V23 <- hansard_senti_post_V23[c("pp_id", "as_speaker", "speaker_id", "person_id", "hansard_membership_id", "mnis_id","dods_id", "pims_id", "proper_name", "party_group",  "party", "government",  "age", "gender", "date_of_birth", "house_start_date", "house_end_date", "ministry" )]

hansard_senti_post_V23 <- right_join(senti_post, hansard_senti_post_V23, by=c("pp_id"))

names(hansard_senti_post_V23)

head(hansard_senti_post_V23)

hansard_senti_post_V23$person_id.x <- NULL
hansard_senti_post_V23$speaker_id.x <- NULL
hansard_senti_post_V23$as_speaker.x <- NULL
hansard_senti_post_V23$hansard_membership_id.x <- NULL

names(hansard_senti_post_V23)[names(hansard_senti_post_V23)=="as_speaker.y"] <- "as_speaker"

names(hansard_senti_post_V23)[names(hansard_senti_post_V23)=="speaker_id.y"] <- "speaker_id"

names(hansard_senti_post_V23)[names(hansard_senti_post_V23)=="hansard_membership_id.y"] <- "hansard_membership_id"

names(hansard_senti_post_V23)[names(hansard_senti_post_V23)=="person_id.y"] <- "person_id"

hansard_senti_post_V23 <- hansard_senti_post_V23[c("pp_id",
                                                   "eo_id",
                                                   "speech",
                                                   "afinn_sentiment",
                                                   "afinn_sd",
                                                   "jockers_sentiment",
                                                   "jockers_sd",
                                                   "nrc_sentiment",
                                                   "nrc_sd",
                                                   "huliu_sentiment",
                                                   "huliu_sd",
                                                   "rheault_sentiment",
                                                   "rheault_sd",
                                                   "word_count",
                                                   "speech_date",
                                                   "year",
                                                   "time",
                                                   "url",
                                                   "as_speaker",
                                                   "speaker_id",
                                                   "person_id",
                                                   "hansard_membership_id",
                                                   "mnis_id",
                                                   "dods_id",
                                                   "pims_id",
                                                   "proper_name",
                                                   "party_group",
                                                   "party",
                                                   "government",
                                                   "speaker_office",
                                                   "age",
                                                   "gender",
                                                   "date_of_birth",
                                                   "house_start_date",
                                                   "house_end_date",
                                                   "ministry")]


hansard_senti_post_V23 <- read_rds("hansard_senti_post_V23.rds")

hansard_senti_post_V23$pp_id <- gsub("a.", ".", hansard_senti_post_V23$pp_id)

hansard_senti_post_V23$pp_id <- gsub("b.", ".", hansard_senti_post_V23$pp_id)

hansard_senti_post_V23$pp_id <- gsub("c.", ".", hansard_senti_post_V23$pp_id)

hansard_senti_post_V23$pp_id <- gsub("d.", ".", hansard_senti_post_V23$pp_id)

hansard_senti_post_V23$pp_id <- gsub("e.", ".", hansard_senti_post_V23$pp_id)

hansard_senti_post_V23$pp_id <- gsub("f.", ".", hansard_senti_post_V23$pp_id)

hansard_senti_post_V23$pp_id <- gsub("g.", ".", hansard_senti_post_V23$pp_id)

x <- hansard_senti_post_V23$year

x <-  as.list(unique(x))

pb <- progress_bar$new(total = length(x))

for (i in x) {
  this_name2 <- distinct(hansard_senti_post_V23[hansard_senti_post_V23$year==i,], pp_id, mnis_id, .keep_all=TRUE)
  save_name <- paste0(i, "x.rds")
  write_rds(this_name2, path = save_name)
  pb$tick()
}

rm(list=ls())

gc()

gc()

gc()

gc()

gc()

gc()

gc()

gc()

atemp <- list.files(pattern = "*x.rds")

match_list <- vector("list", length(atemp)) 
pb <- progress_bar$new(total = length(atemp))

for(i in atemp) {
  
  system.time(
    match_list[[i]] <- read_rds(i)
  )
  pb$tick()
}

hansard_senti_post_V23 <- bind_rows(match_list)

rm(match_list,pb,i,atemp)

gc()

nrow(hansard_senti_post_V23)

## V2.1 was 2234091 rows

hansard_senti_post_V23 <- subset(hansard_senti_post_V23, is.na(mnis_id)==FALSE)

nrow(hansard_senti_post_V23)

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$mnis_id=="1391"] <- "Sion Simon"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$mnis_id=="1573"] <- "Sion James"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$proper_name=="J. Enoch Powell"] <- "Enoch Powell"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$proper_name=="W. R. Rees-Davies"] <- "William Rees-Davies"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$proper_name=="J. Dickson Mabon"] <- "Dickson Mabon"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$proper_name=="J. D. Concannon"] <- "Don Concannon"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$proper_name=="R. B. Cant"] <- "Robert Cant"

hansard_senti_post_V23$proper_name[hansard_senti_post_V23$proper_name=="R. C. Mitchell"] <- "Bob Mitchell"

hansard_senti_post_V23$eo_id <- row.names(hansard_senti_post_V23)

nrow(hansard_senti_post_V23)

names(hansard_senti_post_V23)

write_rds(hansard_senti_post_V23, "hansard_senti_post_V23.rds")

rm(list=ls())

gc()
gc()
gc()
gc()
gc()
gc()
gc()


system.time(
  hansard_senti_pre_V23 <- read_rds("senti_pre.rds")
)

#hansard_senti_pre_V23$eo_id <- as.character(as.numeric(row.names(hansard_senti_pre_V23))+2230357)

names(hansard_senti_pre_V23)[names(hansard_senti_pre_V23)=="speakername"] <- "speaker_name"

hansard_senti_pre_V23 <- subset(hansard_senti_pre_V23, is.na(year)==FALSE)

hansard_senti_pre_V23 <- hansard_senti_pre_V23[c("pp_id",
                                                 "eo_id",
                                                 "speech",
                                                 "speaker_name",
                                                 "afinn_sentiment",
                                                 "afinn_sd",
                                                 "jockers_sentiment",
                                                 "jockers_sd",
                                                 "nrc_sentiment",
                                                 "nrc_sd",
                                                 "huliu_sentiment",
                                                 "huliu_sd",
                                                 "rheault_sentiment",
                                                 "rheault_sd",
                                                 "word_count",
                                                 "speech_date",
                                                 "year",
                                                 "time",
                                                 "url",
                                                 "as_speaker",
                                                 "speaker_id",
                                                 "person_id",
                                                 "hansard_membership_id")]


x <- hansard_senti_pre_V23$year

x <-  as.list(unique(x))

pb <- progress_bar$new(total = length(x))

for (i in x) {
  this_name2 <- distinct(hansard_senti_pre_V23[hansard_senti_pre_V23$year==i,], pp_id,speaker_id, speech, .keep_all=TRUE)
  save_name <- paste0(i, "x.rds")
  write_rds(this_name2, path = save_name)
  pb$tick()
}

rm(list=ls())

gc()

gc()

gc()

gc()

gc()

gc()

gc()

gc()

atemp <- list.files(pattern = "*x.rds")

match_list <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for(i in atemp) {

  system.time(
    match_list[[i]] <- read_rds(i)
  )
  pb$tick()
}

hansard_senti_pre_V23 <- bind_rows(match_list)

rm(i,atemp,match_list,pb)

hansard_senti_pre_V23 <- subset(hansard_senti_pre_V23, is.na(year)==FALSE)

hansard_senti_pre_V23$eo_id <- as.character(as.numeric(row.names(hansard_senti_pre_V23))+2230357)

names(hansard_senti_pre_V23)

nrow(hansard_senti_pre_V23)

sum(hansard_senti_pre_V23$word_count)

write_rds(hansard_senti_pre_V23, "hansard_senti_pre_V23.rds")
# 
# hansard_senti_pre_V23 <- read_rds("hansard_senti_pre_V23.rds")
# 
# write_csv(hansard_senti_pre_V23, "hansard_senti_pre_V23.csv")
