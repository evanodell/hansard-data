library(readr)
library(plyr)
library(dplyr)
library(XML)
library(xml2)
library(RCurl)
library(progress)
library(reshape2)

#To do this, data must have already been downloaded from the parlparse service. I did this analysis on a small underpowered laptop, and more conventional methods of parsing all the XML files at once were crashing far too frequently.


atemp <- list.files(pattern = "*0.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {
    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)




}

debates0 <- do.call(rbind.data.frame, dat)

save_rds(debates0, "debates0.rds")

rm(list = ls())

atemp <- list.files(pattern = "*1.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates1 <- do.call(rbind.data.frame, dat)

save_rds(debates1, "debates1.rds")

rm(list = ls())

atemp <- list.files(pattern = "*2.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates2 <- do.call(rbind.data.frame, dat)

save_rds(debates2, "debates2.rds")

rm(list = ls())

atemp <- list.files(pattern = "*3.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates3 <- do.call(rbind.data.frame, dat)

save_rds(debates3, "debates3.rds")

rm(list = ls())


atemp <- list.files(pattern = "*4.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates4 <- do.call(rbind.data.frame, dat)

save_rds(debates4, "debates4.rds")

rm(list = ls())

atemp <- list.files(pattern = "*5.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates5 <- do.call(rbind.data.frame, dat)

save_rds(debates5, "debates5.rds")

rm(list = ls())

atemp <- list.files(pattern = "*6.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates6 <- do.call(rbind.data.frame, dat)

save_rds(debates6, "debates6.rds")

rm(list = ls())

atemp <- list.files(pattern = "*7.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates7 <- do.call(rbind.data.frame, dat)

save_rds(debates7, "debates7.rds")

rm(list = ls())

atemp <- list.files(pattern = "*8.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates8 <- do.call(rbind.data.frame, dat)

save_rds(debates8, "debates8.rds")

rm(list = ls())

atemp <- list.files(pattern = "*9.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates9 <- do.call(rbind.data.frame, dat)

save_rds(debates9, "debates9.rds")

rm(list = ls())

atemp <- list.files(pattern = "*1a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

    }

debates1a <- do.call(rbind.data.frame, dat)

save_rds(debates1a, "1a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*2a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates2a <- do.call(rbind.data.frame, dat)

save_rds(debates2a, "2a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*3a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates3a <- do.call(rbind.data.frame, dat)

save_rds(debates3a, "3a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*4a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates4a <- do.call(rbind.data.frame, dat)

save_rds(debates4a, "4a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*5a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates5a <- do.call(rbind.data.frame, dat)

save_rds(debates5a, "5a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*6a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates6a <- do.call(rbind.data.frame, dat)

save_rds(debates6a, "6a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*7a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates7a <- do.call(rbind.data.frame, dat)

save_rds(debates7a, "7a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*8a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates8a <- do.call(rbind.data.frame, dat)

save_rds(debates8a, "8a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*9a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debates9a <- do.call(rbind.data.frame, dat)

save_rds(debates9a, "9a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*0a.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debates0a <- do.call(rbind.data.frame, dat)

save_rds(debates0a, "0a.rds")

rm(list = ls())

atemp <- list.files(pattern = "*b.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debatesb <- do.call(rbind.data.frame, dat)

save_rds(debatesb, "b.rds")

rm(list = ls())

atemp <- list.files(pattern = "*c.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debatesc <- do.call(rbind.data.frame, dat)

save_rds(debatesc, "c.rds")

rm(list = ls())

atemp <- list.files(pattern = "*d.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debatesd <- do.call(rbind.data.frame, dat)

save_rds(debatesd, "d.rds")

rm(list = ls())

atemp <- list.files(pattern = "*e.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debatese <- do.call(rbind.data.frame, dat)

save_rds(debatese, "e.rds")

rm(list = ls())

atemp <- list.files(pattern = "*f.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)

}

debatesf <- do.call(rbind.data.frame, dat)

save_rds(debatesf, "f.rds")

rm(list = ls())

atemp <- list.files(pattern = "*g.xml")
dat <- vector("list", length(atemp))
pb <- progress_bar$new(total = length(atemp))

for (i in atemp) {

    doc <- xmlTreeParse(i, useInternalNodes = TRUE)
    pb$tick()
    nodes <- getNodeSet(doc, "//speech")
    speech <- lapply(nodes, function(x) xmlValue(x))
    id <- lapply(nodes, function(x) xmlAttrs(x)["id"])
    hansard_membership_id <- lapply(nodes, function(x) xmlGetAttr(x, "hansard_membership_id", "NA"))
    speakerid <- lapply(nodes, function(x) xmlGetAttr(x, "speakerid", "NA"))
    speakername <- lapply(nodes, function(x) xmlGetAttr(x, "speakername", "NA"))
    colnum <- lapply(nodes, function(x) xmlGetAttr(x, "colnum", "NA"))
    time <- lapply(nodes, function(x) xmlGetAttr(x, "time", "NA"))
    url <- lapply(nodes, function(x) xmlGetAttr(x, "url", "NA"))
    dat[[i]] <- cbind(speech, id, hansard_membership_id, speakerid, speakername, colnum, time, url)
}

debatesg <- do.call(rbind.data.frame, dat)

save_rds(debatesg, "g.rds")

rm(list = ls())

save.image("analysis.RData")


# Combining things
setwd("~/Documents/hansard1936-2016")


debates0 <- read_rds("debates0.rds")


debates1 <- read_rds("debates1.rds")
debate <- rbind(debates0, debates1)
rm(debates0, debates1)
debates2 <- read_rds("debates2.rds")
debate <- rbind(debate, debates2)
rm(debates2)
debates3 <- read_rds("debates3.rds")
debate <- rbind(debate, debates3)
rm(debates3)
debates4 <- read_rds("debates4.rds")
debate <- rbind(debate, debates4)
rm(debates4)
debates5 <- read_rds("debates5.rds")
debate <- rbind(debate, debates5)
rm(debates5)
debates6 <- read_rds("debates6.rds")
debate <- rbind(debate, debates6)
rm(debates6)
debates7 <- read_rds("debates7.rds")
debate <- rbind(debate, debates7)
rm(debates7)
debates8 <- read_rds("debates8.rds")
debate <- rbind(debate, debates8)
rm(debates8)
debates9 <- read_rds("debates9.rds")
debate <- rbind(debate, debates9)
rm(debates9)

save_rds(debate, "debate.rds")

a0 <- read_rds("0a.rds")
debate <- rbind(debate, a0)
rm(a0)

a1 <- read_rds("1a.rds")
debate <- rbind(debate, a1)
rm(a1)

a2 <- read_rds("2a.rds")
debate <- rbind(debate, a2)
rm(a2)

a3 <- read_rds("3a.rds")
debate <- rbind(debate, a3)
rm(a3)

a4 <- read_rds("4a.rds")
debate <- rbind(debate, a4)
rm(a4)

a5 <- read_rds("5a.rds")
debate <- rbind(debate, a5)
rm(a5)

a6 <- read_rds("6a.rds")
debate <- rbind(debate, a6)
rm(a6)

a7 <- read_rds("7a.rds")
debate <- rbind(debate, a7)
rm(a7)

a8 <- read_rds("8a.rds")
debate <- rbind(debate, a8)
rm(a8)

a9 <- read_rds("9a.rds")
debate <- rbind(debate, a9)
rm(a9)
save_rds(debate, "debate_numbers.rds")

rm(list = ls())

b <- read_rds("b.rds")
c <- read_rds("c.rds")
debate_letters <- rbind(c, b)

rm(c, b)


d <- read_rds("d.rds")
debate_letters <- rbind(debate_letters, d)
rm(d)

e <- read_rds("e.rds")
debate_letters <- rbind(debate_letters, e)
rm(e)

f <- read_rds("f.rds")
debate_letters <- rbind(debate_letters, f)

g <- read_rds("g.rds")
debate_letters <- rbind(debate_letters, g)

rm(f, g)

debate_numbers <- read_rds("debate_numbers.rds")

debate <- rbind(debate_letters, debate_numbers)

rm(debate_letters, debate_numbers)

debate$speakerid <- gsub("uk.org.publicwhip/member/", "", debate$speakerid) #Removing extra text from IDs

debate$speech_date <- str_sub(gsub("uk.org.publicwhip/debate/", "", debate$id),1,10) #Removing extra text from IDs

debate$speech_date <- as.Date(debate$speech_date)

debate$cluster <- paste0(debate$hansard_membership$id, debate$speakerid, debate$speakername)

save_rds(debate, "debate_sample.rds")
