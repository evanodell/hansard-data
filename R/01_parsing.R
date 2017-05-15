
library(readr)
library(dplyr)
library(XML)
#library(RCurl)
library(progress)
library(reshape2)

#To do this, data must have already been downloaded from the parlparse service. I did this analysis on a small underpowered laptop, and more conventional methods of parsing all the XML files at once were crashing far too frequently.

look_list <- list("1", "2","3","4","5","6","7","8",'9',"0", "1a", "2a", "3a", "4a",
                   "5a", "6a", "7a", "8a", "9a", "0a", "b", "c", "d", "e", "f", "g")


name_match <- c("speaker", "chairman")

clean_fun <- function(htmlString) { ### Function to strip out HTML
  return(gsub("<.*?>", "", htmlString))
}


for(j in look_list){
  atemp <- list.files(path ="/Users/evanodell/Documents/scrapedxml/debates/", pattern = paste0("*", j, ".xml"))
  dat <- vector("list", length(atemp))
  minor_heading_dat <- vector("list", length(atemp))
  major_heading_dat <- vector("list", length(atemp))
  oral_heading_dat <- vector("list", length(atemp))
  pb <- progress_bar$new(total = length(atemp))
  
  for (i in atemp) {
    doc <- xmlTreeParse(paste0("/Users/evanodell/Documents/scrapedxml/debates/",i), useInternalNodes = TRUE)
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
    
    #Minor headings
    nodes2 <- getNodeSet(doc, "//minor-heading")
    minor_heading <- lapply(nodes2, function(x) xmlValue(x))
    id_minor <- lapply(nodes2, function(x) xmlGetAttr(x, "id", "NA"))
    nospeaker_minor <- lapply(nodes2, function(x) xmlGetAttr(x, "nospeaker", "NA"))
    colnum_minor <- lapply(nodes2, function(x) xmlGetAttr(x, "colnum", "NA"))
    time_minor <- lapply(nodes2, function(x) xmlGetAttr(x, "time", "NA"))
    url_minor <- lapply(nodes2, function(x) xmlGetAttr(x, "url", "NA"))
    
    minor_heading_dat[[i]] <- cbind(minor_heading, id_minor, nospeaker_minor, colnum_minor, time_minor, url_minor)
    
    #Major Headings
    nodes3 <- getNodeSet(doc, "//major-heading")
    major_heading <- lapply(nodes3, function(x) xmlValue(x))
    id_major <- lapply(nodes3, function(x) xmlGetAttr(x, "id", "NA"))
    nospeaker_major <- lapply(nodes3, function(x) xmlGetAttr(x, "nospeaker", "NA"))
    colnum_major <- lapply(nodes3, function(x) xmlGetAttr(x, "colnum", "NA"))
    time_major <- lapply(nodes3, function(x) xmlGetAttr(x, "time", "NA"))
    url_major <- lapply(nodes3, function(x) xmlGetAttr(x, "url", "NA"))

    major_heading_dat[[i]] <- cbind(major_heading, id_major, nospeaker_major, colnum_major, time_major, url_major)
    
    #Oral Headings
    nodes4 <- getNodeSet(doc, "//oral-heading")
    oral_heading <- lapply(nodes4, function(x) xmlValue(x))
    id_oral <- lapply(nodes4, function(x) xmlGetAttr(x, "id", "NA"))
    nospeaker_oral <- lapply(nodes4, function(x) xmlGetAttr(x, "nospeaker", "NA"))
    colnum_oral <- lapply(nodes4, function(x) xmlGetAttr(x, "colnum", "NA"))
    time_oral <- lapply(nodes4, function(x) xmlGetAttr(x, "time", "NA"))
    url_oral <- lapply(nodes4, function(x) xmlGetAttr(x, "url", "NA"))
    
    oral_heading_dat[[i]] <- cbind(oral_heading, id_oral, nospeaker_oral, colnum_oral, time_oral, url_oral)
    
  }
  
  #debate dfs
  debate <- do.call(rbind.data.frame, dat)
  
  char <- c("speech", "id", "hansard_membership_id", "speakerid", "person_id",
             "speakername", "colnum", "time", "url")
  
  debate[char] <- lapply(debate[char], as.character)
  
  debate$as_speaker <- grepl(paste(name_match, collapse = "|"), debate$speakername, ignore.case = TRUE)
  
  debate$speech <- clean_fun(debate$speech) ### Strip out HTML
  
  save_name <- paste0("./xmldata/debate_", j, "df.rds")
  
  write_rds(debate, path = save_name)
  
  minors <- do.call(rbind.data.frame, minor_heading_dat)
  
  char2 <- c("minor_heading", "id_minor", "nospeaker_minor", "colnum_minor", "time_minor", "url_minor")
  
  minors[char2] <- lapply(minors[char2], as.character)
  
  save_name <- paste0("./xmldata/df_", j, "minor.rds")
  
  write_rds(minors, path = save_name)
  
  majors <- do.call(rbind.data.frame, major_heading_dat)
  
  char3 <- c("major_heading", "id_major", "nospeaker_major", "colnum_major", "time_major", "url_major")
  
  majors[char3] <- lapply(majors[char3], as.character)
  
  save_name <- paste0("./xmldata/df_", j, "major.rds")
  
  write_rds(majors, path = save_name)
  
  # Making oral dfs
  orals  <- do.call(rbind.data.frame, oral_heading_dat)
  
  char4 <- c("oral_heading", "id_oral", "nospeaker_oral", "colnum_oral", "time_oral", "url_oral")
  
  orals[char4] <- lapply(orals[char4], as.character)
  
  save_name <- paste0("./xmldata/df_", j, "oral.rds")
  
  write_rds(orals, path = save_name)
  
  rm(save_name, debate, dat, minor_heading_dat, oral_heading_dat, major_heading_dat)
  
}

atemp <- list.files(path = "xmldata/", pattern = "*df.rds")

df.list <- sapply(paste0("xmldata/", atemp), read_rds, simplify = FALSE)

debate <- bind_rows(df.list)

rm(df.list)

write_rds(debate, "debate.rds")


