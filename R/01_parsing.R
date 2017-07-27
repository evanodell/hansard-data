
### NEED TO ADD SCRIPT TO CLEAN UP TEXT. CHECK EMOTION MASTER!

pacman::p_load(readr)
pacman::p_load(dplyr)
pacman::p_load(XML)
#pacman::p_load(RCurl)
pacman::p_load(progress)
pacman::p_load(reshape2)
pacman::p_load(xml2)
pacman::p_load(stringr)
pacman::p_load(lubridate)


#To do this, data must have already been downloaded from the parlparse service. I did this analysis on a small underpowered laptop, and more conventional methods of parsing all the XML files at once were crashing far too frequently.

look_list <- list("1", "2","3","4","5","6","7","8",'9',"0", "1a", "2a", "3a", "4a", "5a", "6a", "7a", "8a", "9a", "0a", "b", "c", "d", "e", "f", "g")


name_match <- c("speaker", "chairman")

clean_fun <- function(htmlString) { ### Function to strip out HTML
  return(gsub("<.*?>", "", htmlString))
}

pb1 <- progress_bar$new(total = length(look_list))

for(j in look_list){
  atemp <- list.files(path ="/Users/evanodell/Documents/scrapedxml/debates/", pattern = paste0("*", j, ".xml"))
  dat <- vector("list", length(atemp))
  pb <- progress_bar$new(total = length(atemp))
  
  for (i in atemp) {
    x <- read_xml(paste0("/Users/evanodell/Documents/scrapedxml/debates/",i))
    doc <- xmlTreeParse(x, useInternalNodes = TRUE)
    pb$tick()
    #checking to see if latest scrape
    
    nodes2 <- getNodeSet(doc, "//publicwhip") 
    latest <- lapply(nodes2, function(x) xmlGetAttr(x, "latest", "NA"))
    
    if(latest=="yes"){
      
      #actual content
      nodes <- getNodeSet(doc, "//speech") ## convert the children of nodes to a list or character vector
      speech <- lapply(nodes, function(x) as.character(getChildrenStrings(x)))
      pp_id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
      hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
      speaker_id <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
      person_id <- lapply(nodes, function(x) xmlGetAttr(x, "person_id", "NA"))
      speaker_name <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
      speaker_office <- lapply(nodes, function(x) xmlGetAttr(x, "speakeroffice", "NA"))
      colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
      time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
      url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
      
      dat[[i]] <- as.data.frame(cbind(speech, pp_id, hansard_membership_id, speaker_id, speaker_office, person_id, speaker_name, colnum, time, url))
    }
    
  }
  
  pb1$tick()
  
  #debate dfs
  debate <- bind_rows(dat)
  
  debate$speech <- sapply(debate$speech, paste, "\n", sep="")
  
  #debate$speech <- gsub("[:alpha:][:punct:][:alpha:]", "\\1\\2 \\3", debate$speech)
  
  debate$speech <- gsub(",([[:alpha:]])", ", \\1", debate$speech)
  
  debate$speech <- gsub("\\?([[:alpha:]])", "? \\1", debate$speech)
  
  debate$speech <- gsub("\\.([[:alpha:]])", ". \\1", debate$speech)
  
  debate$speech <- gsub("\\!([[:alpha:]])", "! \\1", debate$speech)
  
  debate$speech <- gsub(":([[:alpha:]])", ": \\1", debate$speech)
  
  debate$speech <- gsub(";([[:alpha:]])", "; \\1", debate$speech)
  
  debate$speech <- gsub("([[:lower:]])\n", "\\1 ", debate$speech)
  
  debate$speech <- gsub(" playa ", " play a ", debate$speech)
  
  debate$speech <- gsub(" orginal ", " original ", debate$speech)
  
  debate$speech <- gsub(" inc rease ", " increase ", debate$speech)  
  
  debate$speech <- gsub(" enderly ", " elderly ", debate$speech) 
  
  debate$speech <- gsub(" poli- cies ", " policies ", debate$speech) 
  
  debate$speech <- gsub(" introducting ", " introducing ", debate$speech) 
  
  debate$speech <- gsub(" stateament ", " statement ", debate$speech) 
  
  debate$speech <- gsub(" govenment ", " government ", debate$speech) 
  
  debate$speech <- gsub(" dfficulty ", "difficult", debate$speech) 
  
  debate$speech <- gsub(" assesment ", "assessment ", debate$speech) 
  
  debate$speech <- gsub(" Secretrary ", " Secretary ", debate$speech) 
  
  debate$speech <- gsub(" alowed ", " allowed ", debate$speech) 
  
  debate$speech <- gsub(" housng ", " housing ", debate$speech) 
  
  debate$speech <- gsub(" rsources ", " resources ", debate$speech) 
  
  debate$speech <- gsub(" unlikey ", " unlikely ", debate$speech) 
  
  debate$speech <- gsub(" reduncancy ", " redundancy ", debate$speech) 
  
  debate$speech <- gsub(" potentional ", " potential ", debate$speech) 
  
  debate$speech <- gsub(" improvment ", " improvement ", debate$speech) 
  
  debate$speech <- gsub(" prefessional ", " professional ", debate$speech) 
  
  debate$speech <- gsub(" entited ", " entitled ", debate$speech) 
  
  debate$speech <- gsub(" wil ", " will ", debate$speech) 
  
  debate$speech <- gsub(" somehing ", " something ", debate$speech) 
  
  debate$speech <- gsub(" unplublicised ", " unpublicised ", debate$speech) 
  
  debate$speech <- gsub(" adminster ", " administer ", debate$speech) 
  
  debate$speech <- gsub(" concensus ", " consensus ", debate$speech) 
  
  debate$speech <- gsub(" damagiang ", " damaging ", debate$speech) 
  
  debate$speech <- gsub(" O. A. P. s. ", " OAPs ", debate$speech) 
  
  debate$speech <- gsub(" V. A. T. ", " VAT ", debate$speech) 
  
  debate$speech <- gsub("½", ".5", debate$speech)
  
  debate$speech <- gsub("¾", ".75", debate$speech)
  
  debate$speech <- gsub("¼", ".25", debate$speech)
  
  debate$speech <- gsub("·", ".", debate$speech)
  
  debate$speech <- gsub("\n\n", " ", debate$speech)
  
  debate$speech <- gsub("  ", " ", debate$speech)
  
  debate$pp_id2 <- gsub("a\\.", ".", debate$pp_id)
  
  debate$pp_id2 <- gsub("b\\.", ".", debate$pp_id2)
  
  debate$pp_id2 <- gsub("c\\.", ".", debate$pp_id2)
  
  debate$pp_id2 <- gsub("d\\.", ".", debate$pp_id2)
  
  debate$pp_id2 <- gsub("e\\.", ".", debate$pp_id2)
  
  debate$pp_id2 <- gsub("f\\.", ".", debate$pp_id2)
  
  debate$pp_id2 <- gsub("g\\.", ".", debate$pp_id2)
  
  char <- c("pp_id", "hansard_membership_id", "speaker_id", "person_id", "speaker_name", "speaker_office", "colnum", "time", "url")
  
  debate[char] <- lapply(debate[char], as.character)
  
  debate$as_speaker <- grepl(paste(name_match, collapse = "|"), debate$speaker_name, ignore.case = TRUE)
  
  debate$speech <- clean_fun(debate$speech) ### Strip out HTML
  
  debate$speech <- as.character(debate$speech)
  
  save_name <- paste0("./xmldata/debate_", j, "df.rds")
  
  debate$speech_date <- gsub("uk.or.publicwhip/debate/", "", debate$pp_id)
  
  debate$speaker_id <- gsub("uk.or.publicwhip/member/", "", debate$speaker_id)
  
  debate$person_id <- gsub("uk.or.publicwhip/person/", "", debate$person_id)
  
  debate$speech_date <-  str_sub(debate$speech_date,1,10)
  
  debate$speech_date <- as.Date(debate$speech_date)
  
  debate$time <- str_sub(debate$time,-8,-1)
  
  debate$year <- year(debate$speech_date) ### Year variable
  
  write_rds(debate, path = save_name)
  
  rm(save_name, debate, dat)
  
  gc()## garbage collection to hopefully speed things up a bit
  
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
gc()
gc()
gc()

gc()

gc()

atemp <- list.files(path = "xmldata/", pattern = "*df.rds")

system.time(
  df.list <- sapply(paste0("xmldata/", atemp), read_rds, simplify = FALSE)
)

debate <- bind_rows(df.list)

rm(df.list, atemp)

gc()

debate$eo_id <- rownames(debate)

write_rds(debate, "debate.rds")

rm(list=ls())

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



source("R/02_sentiment.R")


