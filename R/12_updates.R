library(readr)
library(dplyr)
library(XML)
#library(RCurl)
library(progress)
library(reshape2)

look_list <- list("1", "2","3","4","5","6","7","8",'9',"0", "1a", "2a", "3a", "4a",
                  "5a", "6a", "7a", "8a", "9a", "0a", "b", "c", "d", "e", "f", "g")

name_match <- c("speaker", "chairman")

clean_fun <- function(htmlString) { ### Function to strip out HTML
  return(gsub("<.*?>", "", htmlString))
}


atemp <- list.files(path ="debates/", pattern = paste0("*.xml"))
dat <- vector("list", length(atemp))
minor_heading_dat <- vector("list", length(atemp))
major_heading_dat <- vector("list", length(atemp))
oral_heading_dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {
  doc <- xmlTreeParse(paste0("debates/",i), useInternalNodes = TRUE)
  pb$tick()
  #actual content
  nodes <- getNodeSet(doc, "//speech")
  speech <- lapply(nodes, function(x) xmlValue(x))
  id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
  hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
  speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
  person_id <- lapply(nodes, function(x) xmlGetAttr(x, "person_id", "NA"))
  speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
  colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
  time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
  url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
  
  dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, person_id, speakername, colnum, time, url)
  
}

#debate dfs
debate <- do.call(rbind.data.frame, dat)

char <- c("speech", "id", "hansard_membership_id", "speakerid", "person_id",
          "speakername", "colnum", "time", "url")

debate[char] <- lapply(debate[char], as.character)

debate$as_speaker <- grepl(paste(name_match, collapse = "|"), debate$speakername, ignore.case = TRUE)

debate$speech <- clean_fun(debate$speech) ### Strip out HTML

save_name <- paste0("debate2df.rds")

write_rds(debate, path = save_name)


# Sentiment calculations -----------------------------------------------------------------

### Note that the methods used here are the consequence of my underpowered laptop being able to do everything at once, or at least be able to do everything at once and still be usuable for other things. If you have a more powerful computer, or one that you can let sit and process for a few days, you can skip the process of splitting data by year.


library(readr)
library(magrittr)
library(dplyr)
library(stringr)
#library(data.table)
library(sentimentr)
library(progress)
library(lubridate)

debate2 <-debate

debate2$date <- gsub("uk.org.publicwhip/debate/", "", debate2$id)

debate2$speakerid <- gsub("uk.org.publicwhip/member/", "", debate2$speakerid)

debate2$person_id <- gsub("uk.org.publicwhip/person/", "", debate2$person_id)

debate2$date <-  str_sub(debate2$date,1,10)

debate2$speech_date <- as.Date(debate2$date)

debate2$date <- NULL

debate2$year <- year(debate2$speech_date) ### Year variable

#for (this_name in all_names) {
#  save_name <- paste0(this_name, "df.rds")
#  write_rds(split_data[[this_name]], path = save_name)
#}

#rm(split_data, all_names, save_name)

#gc()

#Coding sentiment now
afinn <- as_key(syuzhet:::afinn)

atemp <- list.files(pattern = "2017df.rds")

# Looping ---------------------

df <- debate2

### Remove as_speaker calculations from here

system.time(
  afinn_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = afinn))
)
names(afinn_vector)[names(afinn_vector) == "ave_sentiment"] <- "afinn_sentiment"

names(afinn_vector)[names(afinn_vector) == "sd"] <- "afinn_sd"

system.time(
  jockers_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_jockers))
)

names(jockers_vector)[names(jockers_vector) == "ave_sentiment"] <- "jockers_sentiment"

names(jockers_vector)[names(jockers_vector) == "sd"] <- "jockers_sd"

system.time(
  nrc_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_nrc))
)

names(nrc_vector)[names(nrc_vector) == "ave_sentiment"] <- "nrc_sentiment"

names(nrc_vector)[names(nrc_vector) == "sd"] <- "nrc_sd"

system.time(
  sentiword_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_sentiword))
)

names(sentiword_vector)[names(sentiword_vector) == "ave_sentiment"] <- "sentiword_sentiment"

names(sentiword_vector)[names(sentiword_vector) == "sd"] <- "sentiword_sd"

system.time(
  hu_vector <- with(df, sentiment_by(speech, list(id, hansard_membership_id, speech_date, year, speakerid, person_id, speakername, colnum, time, url, as_speaker), polarity_dt = lexicon::hash_sentiment_huliu))
)

names(hu_vector)[names(hu_vector) == "ave_sentiment"] <- "hu_sentiment"

names(hu_vector)[names(hu_vector) == "sd"] <- "hu_sd"

senti_full <- df %>% 
  left_join(afinn_vector, by = c("id", "hansard_membership_id","speech_date", "year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>%
  left_join(jockers_vector, by = c("id", "hansard_membership_id","speech_date","year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>% 
  left_join(nrc_vector, by = c("id", "hansard_membership_id","speech_date","year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>%
  left_join(sentiword_vector, by = c("id", "hansard_membership_id","year", "speech_date","speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker")) %>%
  left_join(hu_vector, by = c("id","hansard_membership_id", "speech_date","year", "speakerid", "person_id", "speakername", "colnum", "time", "url", "as_speaker"))

#senti_full <- senti_full[senti_full$word_count.y >= 10, ]

senti_full <- senti_full[, c("speech", "id","hansard_membership_id","speech_date", "year", "speakerid", "person_id", "speakername",  "colnum", "time", "url", "as_speaker", "word_count.y", "afinn_sentiment", "afinn_sd", "jockers_sentiment", "jockers_sd", "nrc_sentiment", "nrc_sd", "sentiword_sentiment", "sentiword_sd", "hu_sentiment", "hu_sd")]

save_name <- paste0("update.rds")

write_rds(senti_full, path = save_name)

debate2 <- senti_full

names_df <- read_csv("~/Documents/GitHub/hansard-data/data/names.csv", 
                     col_types = cols(date_of_birth = col_date(format = "%Y-%m-%d"), gender = col_factor(levels = c("F","M")), house_end_date = col_date(format = "%Y-%m-%d"), house_start_date = col_date(format = "%Y-%m-%d")))

names_df$mnis_id <- as.character(names_df$mnis_id)

debate2$speakername[debate2$speakername=="John Martin McDonnell"] <- "John McDonnell"

debate2$speakername[debate2$speakername=="Steve McCabe"] <- "Stephen McCabe"

debate2$speakername[debate2$speakername=="Bill Cash"] <- "William Cash"

debate2$speakername[debate2$speakername=="Chris Leslie"] <- "Christopher Leslie"

debate2$speakername[debate2$speakername=="Dr Caroline Johnson"] <- "Caroline Johnson"

debate2$speakername[debate2$speakername=="Ed Vaizey"] <- "Edward Vaizey"

debate2$speakername[debate2$speakername=="Mike Wood"] <- "Mike Wood (Dudley South)"

debate2$speakername[debate2$speakername=="Neil Carmichael"] <- "Neil Carmichael (Stroud)"

debate2$speakername[debate2$speakername=="Pat McFadden"] <- "Patrick McFadden"

debate2$speakername[debate2$speakername=="Rob Flello"] <- "Robert Flello"

debate2$speakername[debate2$speakername=="Steve Pound"] <- "Stephen Pound"

system.time(debate2 <- debate2 %>% left_join(names_df, by = c("speakername"="proper_name")))

debate2$gender <- as.character(debate2$gender)

debate2$gender[debate2$gender=="F"] <- "Female"

debate2$gender[debate2$gender=="F"] <- "Female"

debate2$as_speaker <- ifelse(debate2$mnis_id == 467 |
                               debate2$mnis_id == 1705 |
                               debate2$mnis_id == 36 |
                               debate2$mnis_id == 17, 
                             TRUE, FALSE)

save_name <- paste0("update.rds")

write_rds(debate2, path = save_name)



#rm(save_name, senti_full, hu_vector, afinn_vector, sentiword_vector, nrc_vector, jockers_vector, df)

# Floor Crossers ------------
### Do on 09-05-2017
library(readr)
library(dplyr)
library(magrittr)

system.time(
  senti_df2 <- read_rds("update.rds")
)

names(senti_df2)[names(senti_df2)=="speakername"] <- "proper_name"

switchers <- read_csv("data/switchers.csv", col_types = cols(crossing_one_date = col_date(format = "%Y-%m-%d"),
                                                             crossing_three_date = col_date(format = "%Y-%m-%d"), crossing_two_date = col_date(format = "%Y-%m-%d")))

switchers$crossing_one_date[is.na(switchers$crossing_one_date)] <- Sys.Date()
switchers$crossing_two_date[is.na(switchers$crossing_two_date)] <- Sys.Date()
switchers$crossing_three_date[is.na(switchers$crossing_three_date)] <- Sys.Date()

switchers$mnis_id <- as.character(switchers$mnis_id)

senti_df2$mnis_id <- as.character(senti_df2$mnis_id)

senti_df2$switch_match <- (senti_df2$mnis_id %in% switchers$mnis_id)

crossers <- subset(senti_df2, switch_match == TRUE)

crossers$proper_name <- as.character(crossers$proper_name)

stayers <- subset(senti_df2, switch_match == FALSE)

rm(senti_df2)

gc()

system.time(crossers <- crossers %>% left_join(switchers))

crossers$party2 <- ifelse(crossers$crossing_one_date <= crossers$speech_date, 
                          crossers$crossing_one_to, crossers$crossing_one_from)

crossers$party3 <- ifelse(crossers$crossing_two_date <= crossers$speech_date,
                          crossers$crossing_two_to, crossers$crossing_two_from)

crossers$party4 <- ifelse(crossers$crossing_three_date <= crossers$speech_date, 
                          crossers$crossing_three_to, crossers$crossing_three_from)

crossers$party3[is.na(crossers$party3)] <- as.character(crossers$party2[is.na(crossers$party3)])
crossers$party4[is.na(crossers$party4)] <- as.character(crossers$party3[is.na(crossers$party4)])

pat1 <- c("party4","party2","party3","party")

crossers[pat1] <- lapply(crossers[pat1], factor)

#summary(crossers)

crossers$party <- crossers$party4

dropping <- c("party4","party2","party3","proper_name.y", "crossing_one_date", "crossing_one_from", "crossing_one_to", "crossing_two_date", "crossing_two_from", "crossing_two_to", "crossing_three_date", "crossing_three_from", "crossing_three_to")

crossers <- crossers[,!names(crossers) %in% dropping]

names(crossers) == names(stayers)

crossers2 <- crossers

crossers2$speech <- NULL

write_csv(crossers2, "crossers2.csv")

senti_df2 <- bind_rows(crossers, stayers)




### for 2.4.2

senti_df_nrow_crossed <- nrow(senti_df)

rm(crossers,crossers2, stayers, switchers,dropping,fac1,pat1,senti_df_nrow,senti_post2_nrow,senti_df_nrow_crossed)

gc()

senti_df2$switch_match <- NULL

senti_df2$gender <- as.character(senti_df2$gender)

senti_df2$gender[senti_df2$gender=="M"] <- "Male"

senti_df2$gender[senti_df2$gender=="F"] <- "Female"

senti_df2$gender <- as.factor(senti_df2$gender)

senti_df <- senti_df2

#summary(senti_df)

# party_group  ------------
senti_df$party_group <- ifelse(senti_df$party == "Labour" |
                                 senti_df$party == "Labour (Co-op)", "Labour",
                               ifelse(senti_df$party == "Conservative", "Conservative",
                                      ifelse(senti_df$party == "Liberal Democrat" | senti_df$party == "Social Democrat" | senti_df$party == "Liberal", "Liberal Democrat",
                                             ifelse(senti_df$party == "Speaker", "Speaker", "Other"))))

senti_df$ministry <- "May"
senti_df$government <- ifelse(senti_df$party_group == "Conservative",
                              "Government", "Opposition")

system.time(
  write_rds(senti_df, "senti_df2.rds")
)

update <- read_rds("senti_df2.rds")

system.time(
  senti_df <- read_rds("senti_df.rds")
)





hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==1224] <- as.POSIXct("1987-06-11")

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==4084] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==534] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==3976] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==188] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==252] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==3968] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==1513] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==382] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==450] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==207] <- NA

hansard_senti_post_V242$house_end_date[hansard_senti_post_V242$mnis_id==4062] <- NA

date_check <- hansard_senti_post_V242[hansard_senti_post_V242$speech_date > hansard_senti_post_V242$house_end_date
                                      & is.na(hansard_senti_post_V242$house_end_date)==FALSE,]



date_check$proper_name <- as.factor(as.character(date_check$proper_name))

summary(date_check$proper_name)

date_check$mnis_id[date_check$mnis_id==1300] <- 960

date_check$mnis_id[date_check$mnis_id==3326] <- 770

date_check$mnis_id[date_check$mnis_id==769] <- 770

date_check$mnis_id[date_check$mnis_id==1100] <- 308

date_check$mnis_id[date_check$mnis_id==536] <- 569

date_check$mnis_id[date_check$mnis_id==30] <- 1564

date_check$mnis_id[date_check$mnis_id==1314] <- 1556

date_check$mnis_id[date_check$mnis_id==716] <- 1213

date_check$speech_date[date_check$mnis_id==1300] <- as.Date("1983-02-13")

test2 <- hansard_senti_post_V242[!(hansard_senti_post_V242$eo_id %in% date_check$eo_id),]

#test2 <- senti_df[senti_df$proper_name=="Jim Cunningham",]
drop_list <- c("proper_name",	"house_start_date",	"house_end_date",	"date_of_birth",	"gender",	"party",	"dods_id",	"pims_id")
date_check <- date_check[, !colnames(date_check) %in% drop_list]
#date_check$mnis_id <- ifelse(date_check$speech_date >= "1983-06-09" && date_check$proper_name=="George Cunningham", 308, date_check$mnis_id)


summary(date_check$mnis_id)

elect2 <- readxl::read_excel("~/Documents/GitHub/hansard-data/elect2.xlsx")
date_check <- dplyr::left_join(date_check, elect2, by= "mnis_id")

summary(date_check$house_start_date)
date_check$date_of_birth <- as.Date(date_check$date_of_birth)
date_check$house_start_date <- as.Date(date_check$house_start_date)
date_check$house_end_date <- as.Date(date_check$house_end_date)
summary(date_check$speech_date)
rm(hansard_senti_post_V242)
hansard_senti_post_V242 <- dplyr::bind_rows(date_check, test2)

date_check2 <- hansard_senti_post_V242[hansard_senti_post_V242$speech_date > hansard_senti_post_V242$house_end_date
                                       & is.na(hansard_senti_post_V242$house_end_date)==FALSE,]






