# 
# members <- hansard::members()
# 
# constits <- mnis::mnis_constituencies()
# 
# stop_list <- c(members$additional_name_value, members$constituency_label_value, members$family_name_value, members$full_name_value, members$given_name_value, constits$display_as, constits$member_from)
# 
# stop_list <- stop_list[!is.na(stop_list) &
#                          stop_list!="Life peer" &
#                          stop_list!="Hereditary" &
#                          stop_list!="Life Peer (judicial)" &
#                          stop_list!="Excepted Hereditary"]
# 
# names <- stop_list %>% unique %>% quanteda::tokens() %>% as.character() %>% unique
# 
# towns <- read_csv("data/uk_towns_and_counties.csv")
# 
# towns <- unique(unlist(stri_split(towns$town, fixed=" ")))

parli_dict <- readr::read_rds("parli_dict.rds")

parli_dict <- unique(c(parli_dict,  "tarmacadamed", "Bonamia", "Exocet",
                       "mugwumps", "mugwump", "bleatings", "bleating", 
                       "gastarbeiters", "gastarbeiter", "comprehensivisation",
                       "Llowarch", "spatchcocked", "spatchcock", "timesheets",
                       "timesheet", "overstayers", "overstayer"
                       
))

readr::write_rds(parli_dict, "parli_dict.rds")

