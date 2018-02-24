
pacman::p_load(readr)
pacman::p_load(hunspell)
pacman::p_load(magrittr)
pacman::p_load(stringi)
#pacman::p_load(progress)
pacman::p_load(dplyr)

system.time(
  senti_df <- read_rds("senti_df2.rds")
)

system.time(
  check <- hunspell(senti_df$speech[500001:735000], format= "text", dict=hunspell::dictionary("en_GB"))
)

#dictionary(lang = "en_GB", affix = NULL, add_words = parli_dict, cache = TRUE)

x <- unique(unlist(check))

stripped <- x[!(x %in% parli_dict) &
              !(x %in% replace_table$wrong)]

y <- stripped[c(grepl("^[[:upper:]]+'?s?$", stripped))]

z <- stripped[c(grepl("^[[:lower:]].*$", stripped))]

a <- stripped[!(stripped %in% z) & !(stripped %in% y)]

stripped

# "overook" - need to find

# replace_table <- unique(tibble::new_tibble(list(wrong = paste0(members$family_name_value,"rose"), right = paste0(members$family_name_value," rose"))))

#replace_table <- unique(tibble::new_tibble(list(wrong = paste0(members$family_name_value,"indicated"), right = paste0(members$family_name_value," indicated"))))

replace_table2 <- replace_table_stage

replace_table2$wrong <- gsub(" ", " ?\n ?", replace_table2$wrong)

replace_table3 <- replace_table_stage

replace_table3$wrong <- gsub(" ", " ?- ?", replace_table3$wrong)

replace_table_regex <- unique(bind_rows(replace_table3, replace_table2, replace_table_stage))

replace_table_regex$wrong <- stri_replace_all_fixed(replace_table_regex$wrong, "\n", "\\n")

replace_table_regex$right <- stri_replace_all_fixed(replace_table_regex$right, "'", "\'")

#replace_table_regex$right <- stri_replace_all_fixed(replace_table_regex$right, "[", "\\[")

replace_table_regex$wrong <- paste0("([[\\s][\\p{Z}][\\p{P}]])", replace_table_regex$wrong, "([[\\s][\\p{Z}][\\p{P}]])")

replace_table_regex$right <- paste0("$1", replace_table_regex$right, "$2")

replace_table_regex

#  replace_table <- unique(tibble::new_tibble(list(wrong = paste0(members$family_name_value,"rose"), right =paste0(members$family_name_value," rose"))))
#   also fixed Libera] and all tripple lower-case letters

 # c <- c("A test case for com-puters, pri- vate activities, con-sidered, Shef -field types, sen sible, sen\nsible, sen \nsible. sen\n sible things. fornight's are didn 't thing.")
 # 
 # d <- stri_replace_all_regex(c, replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
 # 
 # d

# 
# system.time(
#     senti_df$speech <- stri_replace_all_fixed(senti_df$speech, "ordinated", "ordinated ", vectorize_all=FALSE)
# )



# library(progress)
# 
# pb <- progress_bar$new(total = 1056325, format = "[:bar] :percent :current/:total :elapsed :eta",
#                        clear = FALSE)
# 
# for (i in 1:1056325) {
#   senti_df$speech[i] <- stri_replace_all_regex(senti_df$speech[i], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
#   
#   pb$tick()
#   
# }

gc()

system.time(
  senti_df$speech[1:10000] <- stri_replace_all_regex(senti_df$speech[1:10000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

system.time(
  senti_df$speech[10001:25000] <- stri_replace_all_regex(senti_df$speech[10001:25000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[25001:50000] <- stri_replace_all_regex(senti_df$speech[25001:50000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)


write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[50001:70000] <- stri_replace_all_regex(senti_df$speech[50001:70000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[70001:90000] <- stri_replace_all_regex(senti_df$speech[70001:90000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[90001:100000] <- stri_replace_all_regex(senti_df$speech[90001:100000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()


system.time(
  senti_df$speech[100001:110000] <- stri_replace_all_regex(senti_df$speech[100001:110000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[110001:120000] <- stri_replace_all_regex(senti_df$speech[110001:120000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[120001:200000] <- stri_replace_all_regex(senti_df$speech[120001:200000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")


system.time(
  senti_df$speech[200001:300000] <- stri_replace_all_regex(senti_df$speech[200001:300000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[300001:400000] <- stri_replace_all_regex(senti_df$speech[300001:400000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")



gc()

system.time(
  senti_df$speech[400001:500000] <- stri_replace_all_regex(senti_df$speech[400001:500000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()


gc()

system.time(
  senti_df$speech[500001:600000] <- stri_replace_all_regex(senti_df$speech[500001:600000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()


system.time(
  senti_df$speech[600001:700000] <- stri_replace_all_regex(senti_df$speech[600001:700000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[700001:800000] <- stri_replace_all_regex(senti_df$speech[700001:800000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()


system.time(
  senti_df$speech[800001:900000] <- stri_replace_all_regex(senti_df$speech[800001:900000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()

system.time(
  senti_df$speech[900001:1000000] <- stri_replace_all_regex(senti_df$speech[900001:1000000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()


system.time(
  senti_df$speech[1000001:1100000] <- stri_replace_all_regex(senti_df$speech[1000001:1100000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")

gc()


system.time(
  senti_df$speech[1100001:1250000] <- stri_replace_all_regex(senti_df$speech[1100001:1250000], replace_table_regex$wrong, replace_table_regex$right, vectorize_all=FALSE)
)

write_rds(senti_df, "senti_df2.rds")



# 
# system.time(
#   senti_df <- mutate(senti_df, eo_id = rownames(senti_df2))
# )
# 
# 
# system.time(senti_df$speech <- stri_replace_all_fixed(senti_df$speech, 
#                                                       c("aaa", "bbb", "ccc", "ddd", "eee", "fff", "ggg",
#                                                         "hhh", "iii", "jjj", "kkk", "lll", "mmm", "nnn",
#                                                         "ooo", "ppp", "qqq", "rrr", "sss", "ttt", "uuu",
#                                                         "vvv", "www", "xxx", "yyy", "zzz"),
#                                                       c("aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh",
#                                                         "ii", "jj", "kk", "ll", "mm", "nn", "oo", "pp",
#                                                         "qq", "rr", "ss", "tt", "uu", "vv", "ww", "xx",
#                                                         "yy", "zz"), vectorize_all = FALSE))
# 
