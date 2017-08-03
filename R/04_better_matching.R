### To do - get constituency data from 1979 onwards

pacman::p_load(readr)
pacman::p_load(dplyr)
pacman::p_load(progress)

system.time(
  senti_post <- read_rds("senti_post.rds")
)

senti_post <- senti_post[senti_post$word_count > 0,]

system.time(
  old_senti <- read_rds("hansard_senti_post_V23.rds")
)

old_senti$pp_id <- gsub("a\\.", ".", old_senti$pp_id)

old_senti$pp_id <- gsub("b\\.", ".", old_senti$pp_id)

old_senti$pp_id <- gsub("c\\.", ".", old_senti$pp_id)

old_senti$pp_id <- gsub("d\\.", ".", old_senti$pp_id)

old_senti$pp_id <- gsub("e\\.", ".", old_senti$pp_id)

old_senti$pp_id <- gsub("f\\.", ".", old_senti$pp_id)

old_senti$pp_id <- gsub("g\\.", ".", old_senti$pp_id)

head(old_senti$pp_id)

nrow_old_senti <- nrow(old_senti)

x <- old_senti$year

x <-  as.list(unique(x))

pb <- progress_bar$new(total = length(x))

for (i in x) {
  this_name2 <- distinct(old_senti[old_senti$year==i,], pp_id, mnis_id, .keep_all=TRUE)
  save_name <- paste0(i, "x.rds")
  write_rds(this_name2, path = save_name)
  pb$tick()
}

rm(x,old_senti,pb,save_name,i,this_name2)

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

V23_dupe_check <- V23_dupe_check[c("pp_id", "pp_id", "mnis_id")]

y <- nrow(senti_post)

senti_post <- left_join(senti_post, V23_dupe_check, by=c("pp_id"="pp_id"))

senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.1" & senti_post$speaker_name=="Mr. Rooker"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.2" & senti_post$speaker_name=="Mr. Greville Janner"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.3" & senti_post$speaker_name=="Sir Geoffrey Howe"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.4" & senti_post$speaker_name=="Mr. Rooker"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.5" & senti_post$speaker_name=="Mr. William Hamilton"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.6" & senti_post$speaker_name=="Mr. Russell Kerr"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.7" & senti_post$speaker_name=="Sir G. Howe"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.8" & senti_post$speaker_name=="Mr. Janner"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.597.9" & senti_post$speaker_name=="Sir G. Howe"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.614.1" & senti_post$speaker_name=="Mr. Freud"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.614.2" & senti_post$speaker_name=="Mr. Speaker"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.614.3" & senti_post$speaker_name=="Mr. Freud"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.614.4" & senti_post$speaker_name=="Mr. Skinner"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.614.5" & senti_post$speaker_name=="Mr. Freud"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.615.2" & senti_post$speaker_name=="Mrs. Dunwoody"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1979-12-06.615.3" & senti_post$speaker_name=="The Chief Secretary to the Treasury (Mr. John Biffen)"),]
senti_post <- senti_post[!(senti_post$pp_id=="uk.or.publicwhip/debate/1988-02-22.117.0" & senti_post$speaker_name=="Dr. Reid"),]


senti_post$mnis_id <- NA


senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.1" & senti_post$speaker_name=="Mr. Dunn"] <- 1194
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.1" & senti_post$speaker_name=="Mr. Leigh"] <- 1194
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.2" & senti_post$speaker_name=="Mr. Nellist"] <- 1199
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.2" & senti_post$speaker_name=="Mr. Radice"] <- 1199
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.3" & senti_post$speaker_name=="Mr. Dunn"] <- 1194
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.3" & senti_post$speaker_name=="Mr. Hancock"] <- 1194
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.4" & senti_post$speaker_name=="Mr. Maude"] <- 510
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.4" & senti_post$speaker_name=="Mr. Radice"] <- 1199
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.5" & senti_post$speaker_name=="Mr. Dunn"] <- 1194
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-05-21.840.5" & senti_post$speaker_name=="Mr. Holt"] <- 1194
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.0" & senti_post$speaker_name=="Mr. Field"] <- 478
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.0" & senti_post$speaker_name=="Mr. Fowler"] <- 315
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.1" & senti_post$speaker_name=="Mr. Campbell-Savours"] <- 499
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.1" & senti_post$speaker_name=="Mr. Field"] <- 478
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.2" & senti_post$speaker_name=="Mr. Field"] <- 478
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.3" & senti_post$speaker_name=="Mr. D. N. Campbell-Savours"] <- 499
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1985-06-27.1112.3" & senti_post$speaker_name=="Mr. Deputy Speaker (Mr. Ernest Armstrong)"] <- 968
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-02.990.1" & senti_post$speaker_name=="Mr. Hirst"] <- 867
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-02.990.1" & senti_post$speaker_name=="Mr. Norman Hogg"] <- 1131
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-02.990.2" & senti_post$speaker_name=="Mr. Stewart"] <- 1239
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-02.990.2" & senti_post$speaker_name=="The Parliamentary Under-Secretary of State for Scotland (Mr. Michael Ancram)"] <- 259
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-02.990.3" & senti_post$speaker_name=="Mr. Hirst"] <- 867
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-02.990.3" & senti_post$speaker_name=="Mr. Hugh Brown"] <- 1008
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.0" & senti_post$speaker_name=="Mr. Norman Buchan"] <- 969
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.0" & senti_post$speaker_name=="Mr. Younger"] <- 969
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.2" & senti_post$speaker_name=="Mr. Alexander Eadie"] <- 867
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.2" & senti_post$speaker_name=="Mr. Hirst"] <- 867
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.3" & senti_post$speaker_name=="Mr. Rifkind"] <- 1191
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.3" & senti_post$speaker_name=="Mr. Speaker"] <- 960
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.4" & senti_post$speaker_name=="Mr. Churchill"] <- 1081
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.4" & senti_post$speaker_name=="Mr. George Foulkes"] <- 1081
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.5" & senti_post$speaker_name=="Mr. Rifkind"] <- 1191
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.857.5" & senti_post$speaker_name=="Mr. Younger"] <- 969
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.858.1" & senti_post$speaker_name=="Mr. James Couchman"] <- 969
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.858.1" & senti_post$speaker_name=="Mr. Younger"] <- 969
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.858.2" & senti_post$speaker_name=="Mr. Denzil Davies"] <- 539
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-15.858.2" & senti_post$speaker_name=="Mr. Speaker"] <- 960
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-23.514.3" & senti_post$speaker_name=="Mr. Deputy Speaker"] <- 1096
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-23.514.3" & senti_post$speaker_name=="Mr. Gummer"] <- 137
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-23.514.4" & senti_post$speaker_name=="Mr. Deputy Speaker"] <- 1096
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-23.514.4" & senti_post$speaker_name=="Mr. Gummer"] <- 137
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-23.519.3" & senti_post$speaker_name=="Mr. Maclennan"] <- 578
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1986-07-23.519.3" & senti_post$speaker_name=="The Parliamentary Under-Secretary of State for Scotland (Mr. John MacKay)"] <- 1133
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1990-02-21.973.2" & senti_post$speaker_name=="Mr. Speaker"] <- 872
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1990-02-21.973.2" & senti_post$speaker_name=="Sir Geoffrey Howe"] <- 872
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1991-01-30.924.1" & senti_post$speaker_name=="Mr. Haynes"] <- 57
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1991-01-30.924.1" & senti_post$speaker_name=="Sir George Young"] <- 57
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.1" & senti_post$speaker_name=="Mr. Canavan"] <- 680
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.1" & senti_post$speaker_name=="Mr. Kirkwood"] <- 635
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.2" & senti_post$speaker_name=="Mr. Forsyth"] <- 1141
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.2" & senti_post$speaker_name=="Mr. Kynoch"] <- 1168
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.3" & senti_post$speaker_name=="Mr. Kirkwood"] <- 635
senti_post$mnis_id[senti_post$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.3" & senti_post$speaker_name=="Rev. Martin Smyth"] <- 644




post_el <- senti_post[senti_post$speech_date >= "2017-06-01",]

post_el$speech <- NULL

write_csv(post_el, "post_el.csv")

stupid_id190V3 <- read_csv("~/Documents/GitHub/hansard-data/old_matches/stupid_id190V3.csv", 
                           col_types = cols(hansard_membership_id_proper = col_character(), 
                                            mnis_id = col_character(), speakerid_proper = col_character()))

stupid_id190V3 <- rename(stupid_id190V3, pp_id = id, speaker_name = speakername)

stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1990-02-21.973.2" & stupid_id190V3$speaker_name=="Mr. Speaker"] <- 872
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1990-02-21.973.2" & stupid_id190V3$speaker_name=="Sir Geoffrey Howe"] <- 872
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1991-01-30.924.1" & stupid_id190V3$speaker_name=="Mr. Haynes"] <- 57
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1991-01-30.924.1" & stupid_id190V3$speaker_name=="Sir George Young"] <- 57
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.1" & stupid_id190V3$speaker_name=="Mr. Canavan"] <- 680
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.1" & stupid_id190V3$speaker_name=="Mr. Kirkwood"] <- 635
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.2" & stupid_id190V3$speaker_name=="Mr. Forsyth"] <- 1141
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.2" & stupid_id190V3$speaker_name=="Mr. Kynoch"] <- 1168
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.3" & stupid_id190V3$speaker_name=="Mr. Kirkwood"] <- 635
stupid_id190V3$mnis_id[stupid_id190V3$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.3" & stupid_id190V3$speaker_name=="Rev. Martin Smyth"] <- 644

stupid_id190V3$speaker_name <- NULL


x90 <- read_csv("199.csv")

x90$person_id_proper <- NULL

x90$hansard_membership_id_proper <- NULL

x90$speakerid_proper <- NULL

x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1990-02-21.973.2" & x90$speaker_name=="Mr. Speaker"] <- 872
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1990-02-21.973.2" & x90$speaker_name=="Sir Geoffrey Howe"] <- 872
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1991-01-30.924.1" & x90$speaker_name=="Mr. Haynes"] <- 57
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1991-01-30.924.1" & x90$speaker_name=="Sir George Young"] <- 57
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.1" & x90$speaker_name=="Mr. Canavan"] <- 680
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.1" & x90$speaker_name=="Mr. Kirkwood"] <- 635
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.2" & x90$speaker_name=="Mr. Forsyth"] <- 1141
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.2" & x90$speaker_name=="Mr. Kynoch"] <- 1168
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.3" & x90$speaker_name=="Mr. Kirkwood"] <- 635
x90$mnis_id[x90$pp_id=="uk.or.publicwhip/debate/1995-12-20.1522.3" & x90$speaker_name=="Rev. Martin Smyth"] <- 644

x1990s <- left_join(x90, stupid_id190V3, by=c("pp_id", "mnis_id"))

x1990s$mnis_id <- as.numeric(x1990s$mnis_id)

write_csv(x1990s, "completed-matches/199.csv")

### 2000s not working
stupid_id200V3 <- read_csv("~/Documents/GitHub/hansard-data/old_matches/stupid_id200V3.csv", 
                           col_types = cols(hansard_membership_id_proper = col_character(), 
                                            mnis_id = col_character(), speakerid_proper = col_character()))

drop_list <- read_csv("drop_list.csv")

nrow(stupid_id200V3)

stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id %in% drop_list$id),]

nrow(stupid_id200V3)

stupid_id200V3$pp_id <- gsub("a\\.", ".", stupid_id200V3$pp_id)

stupid_id200V3$pp_id <- gsub("b\\.", ".", stupid_id200V3$pp_id)

stupid_id200V3$pp_id <- gsub("c\\.", ".", stupid_id200V3$pp_id)

stupid_id200V3$pp_id <- gsub("d\\.", ".", stupid_id200V3$pp_id)

stupid_id200V3$pp_id <- gsub("e\\.", ".", stupid_id200V3$pp_id)

stupid_id200V3$pp_id <- gsub("f\\.", ".", stupid_id200V3$pp_id)

stupid_id200V3$pp_id <- gsub("g\\.", ".", stupid_id200V3$pp_id)

nrow(stupid_id200V3)
# 
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2009-10-26.136.0" & stupid_id200V3$speaker_name=="Bill Rammell"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-03-15.1509.1" & stupid_id200V3$speaker_name=="John Bercow"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-03-15.1510.1" & stupid_id200V3$speaker_name=="James Clappison"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-09.224.0" & stupid_id200V3$speaker_name=="Desmond Swayne"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-10.343.2" & stupid_id200V3$speaker_name=="Owen Paterson"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-10.400.0" & stupid_id200V3$speaker_name=="Dominic Grieve"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-12.602.0" & stupid_id200V3$speaker_name=="Maria Miller"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-12.624.2" & stupid_id200V3$speaker_name=="Shailesh Vara"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-15.712.1" & stupid_id200V3$speaker_name=="Oliver Heald"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2006-05-22.1263.1" & stupid_id200V3$speaker_name=="Gerald Howarth"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2008-01-10.524.3" & stupid_id200V3$speaker_name=="Helen Jones"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2008-01-10.608.0" & stupid_id200V3$speaker_name=="Bob Ainsworth"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2009-10-26.136.0" & stupid_id200V3$speaker_name=="Bill Rammell"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2009-11-26.784.0" & stupid_id200V3$speaker_name=="Patrick McFadden"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2009-11-26.785.1" & stupid_id200V3$speaker_name=="Patrick McFadden"),]
stupid_id200V3 <- stupid_id200V3[!(stupid_id200V3$pp_id=="uk.or.publicwhip/debate/2009-11-26.785.3" & stupid_id200V3$speaker_name=="Patrick McFadden"),]


x200 <- read_csv("200.csv")

dupes <- x200[duplicated(x200$pp_id),]

dupes <- stupid_id200V3[duplicated(stupid_id200V3$pp_id),]

stupid_id200V3$eo_id <- NULL

x2000s <- left_join(x200, stupid_id200V3, by=c("pp_id"))

x2000s <- x2000s[!duplicated(x2000s$eo_id),]

write_csv(x2000s, "completed-matches/200.csv")


x201 <- read_csv("201.csv",col_types = cols(.default = "c"))


x201 <- x201[c("pp_id", "eo_id", "speaker_name", "speech_date")]

stupid_id210 <- read_csv("~/Documents/GitHub/hansard-data/old_matches/stupid_id210V4.csv", 
                           col_types = cols(.default = "c"))

nrow(stupid_id210)

drop_list <- read_csv("drop_list.csv")

stupid_id210 <- stupid_id210[!(stupid_id210$pp_id %in% drop_list$id),]

nrow(stupid_id210)

stupid_id210$pp_id <- gsub("a\\.", ".", stupid_id210$pp_id)

stupid_id210$pp_id <- gsub("b\\.", ".", stupid_id210$pp_id)

stupid_id210$pp_id <- gsub("c\\.", ".", stupid_id210$pp_id)

stupid_id210$pp_id <- gsub("d\\.", ".", stupid_id210$pp_id)

stupid_id210$pp_id <- gsub("e\\.", ".", stupid_id210$pp_id)

stupid_id210$pp_id <- gsub("f\\.", ".", stupid_id210$pp_id)

stupid_id210$pp_id <- gsub("g\\.", ".", stupid_id210$pp_id)

stupid_id210$speaker_name <- NULL

x2010s <- left_join(x201, stupid_id210, by=c("pp_id"))

x2010s <- x2010s[!duplicated(x2010s$eo_id),]

x2010s$speaker_name[x2010s$speaker_name=="Diana R. Johnson"] <- 	"Diana Johnson"
x2010s$speaker_name[x2010s$speaker_name=="Dr Caroline Johnson"] <-	"Caroline Johnson"
x2010s$speaker_name[x2010s$speaker_name=="John Martin McDonnell"] <-	"John McDonnell"
x2010s$speaker_name[x2010s$speaker_name=="Lee Benjamin Rowley"] <-	"Lee Rowley"
x2010s$speaker_name[x2010s$speaker_name=="Mike Wood"] <-	"Mike Wood (Dudley South)"
x2010s$speaker_name[x2010s$speaker_name=="Paul Daniel Williams"] <-	"Paul Williams"
x2010s$speaker_name[x2010s$speaker_name=="Robert Alexander Courts"] <-	"Robert Courts"
x2010s$speaker_name[x2010s$speaker_name=="Steve Pound"] <-	"Stephen Pound"
x2010s$speaker_name[x2010s$speaker_name=="Tanmanjit Singh Dhesi"] <-	"Tanmanjit Singh Dhesi"
  
write_csv(x2010s, "completed-matches/210.csv")

x201post <- subset(x201, speech_date >= "2017-06-08")

write_csv(x201post, "x201post.csv")

senti_post <- read_rds("senti_post.rds")

match_list <- c("lever", "dunnett", "trippier", "tripper", "tripier", "bates", "bate")

system.time(## Re-write this so it excludes ``disabuse'' and ``disable''
  senti_post$check <- grepl(paste(match_list, collapse = "|"), senti_post$speaker_name, ignore.case = TRUE)
)

checking <- senti_post[ senti_post$check==TRUE,]

write_csv(checking, "checking.csv")

x2010s <- read_csv("completed-matches/210.csv")

x1990s <- read_csv("completed-matches/199.csv")

x1990s$mnis_id[x1990s$mnis_id==1616] <- 1091

x1990s$trip <- grepl("trippier", x1990s$speaker_name, ignore.case = TRUE)

x1990s$mnis_id[x1990s$trip==TRUE] <- 955

write_csv(x1990s, "completed-matches/199.csv")


x1980s <- read_csv("completed-matches/198.csv")



## if mnis_id ==1616, change to 1091
## 
## if speaker_name contains trippier, change mnis to 995
## 
## 

atemp <- list.files(path = "completed-matches/", pattern = "*.csv")

match_list <- sapply(paste0("completed-matches/", atemp), read_csv, col_types = cols(.default = "c"), simplify = FALSE)
 
match_df <- bind_rows(match_list)

match_df$speaker_id <- gsub("uk.org.publicwhip/member/", "", match_df$speaker_id)

names(match_df)

match_df <- match_df[c("eo_id", "mnis_id", "speaker_id", "person_id", "hansard_membership_id")]

match_df <- distinct(match_df, eo_id, .keep_all=TRUE)#2179625

senti_post$speaker_id <- NULL
senti_post$mnis_id <- NULL
senti_post$person_id <- NULL
senti_post$hansard_membership_id <- NULL

### Retrieve actual speeches from older version of senti_post

nrow(senti_post)

system.time(senti_post <- senti_post %>% left_join(match_df, by = "eo_id"))

nrow(senti_post)

test <- subset(senti_post, is.na(mnis_id)==TRUE)

test$speech <- NULL

write_csv(test, "test.csv")

senti_post$trip <- grepl("trippier", senti_post$speaker_name, ignore.case = TRUE)

senti_post$mnis_id[senti_post$trip==TRUE] <- 955

senti_post$mnis_id[senti_post$mnis_id==1616] <- 1091

senti_post$trip <- NULL

write_rds(senti_post, "senti_post.rds")


extra_match <- read_csv("test.csv", col_types = cols(.default = "c"))

extra_match$eo_id <- as.character(extra_match$eo_id)

system.time(senti_post <- senti_post %>% left_join(extra_match, by=("eo_id"))) #2441992

nrow(senti_post)

senti_post$mnis_id.y <- as.numeric(senti_post$mnis_id.y)

senti_post$mnis_id.x <- as.numeric(senti_post$mnis_id.x)

senti_post$mnis_id.x[is.na(senti_post$mnis_id.x)] <- senti_post$mnis_id.y[is.na(senti_post$mnis_id.x)] 

summary(senti_post$mnis_id.x)

names(senti_post)[names(senti_post)=="mnis_id.x"] <- "mnis_id"

senti_post$mnis_id.y <- NULL

senti_post <- senti_post[senti_post$speaker_name!="NA",]

summary(senti_post$mnis_id)

senti_post <- subset(senti_post, is.na(mnis_id)==FALSE)

write_rds(senti_post, "senti_post.rds")

