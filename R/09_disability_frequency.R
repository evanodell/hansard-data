


senti_df$count_dis_person <- str_count(senti_df$speech, regex('disabled person', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('disabled person', ignore_case = TRUE))

senti_df$count_dis_child <- str_count(senti_df$speech, regex('disabled child', ignore_case = TRUE))

senti_df$count_dis_people_with <- str_count(senti_df$speech, regex('person with a disability', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('people with a disability', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('people with disabilities', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('person with disabilities', ignore_case = TRUE))

senti_df$count_dis_women <- str_count(senti_df$speech, regex('disabled women', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('disabled woman', ignore_case = TRUE))

senti_df$count_dis_men <- str_count(senti_df$speech, regex('disabled men', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('disabled man', ignore_case = TRUE))

senti_df$count_dis_child_with <- str_count(senti_df$speech, regex('children with disabilities', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('child with disabilities', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('children with a disability', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('child with a disability', ignore_case = TRUE))

senti_df$count_dis_any_with <- str_count(senti_df$speech, regex('with disabilities', ignore_case = TRUE)) +
  str_count(senti_df$speech, regex('with a disability', ignore_case = TRUE))

senti_df$count_ind_living <- str_count(senti_df$speech, regex('independent living', ignore_case = TRUE))

senti_df$count_wheelchair <- str_count(senti_df$speech, regex('wheelchair', ignore_case = TRUE))

senti_df$count_paralympic <- str_count(senti_df$speech, regex('paralympic', ignore_case = TRUE))

senti_df$count_afflict <- str_count(senti_df$speech, regex('afflicted', ignore_case = TRUE))

senti_df$count_spastic <- str_count(senti_df$speech, regex('spastic', ignore_case = TRUE))

senti_df$count_sub_normal <- str_count(senti_df$speech, regex('sub-normal', ignore_case = TRUE))+ ### Need to check this to make sure it doesn't return the same thing multiple times
str_count(senti_df$speech, regex('sub normal', ignore_case = TRUE)) +
str_count(senti_df$speech, regex('subnormal', ignore_case = TRUE))

senti_df$count_amputee <- str_count(senti_df$speech, regex('amputee', ignore_case = TRUE))

senti_df$count_retard <- str_count(senti_df$speech, regex('retard', ignore_case = TRUE))

senti_df$count_cripple <- str_count(senti_df$speech, regex('cripple', ignore_case = TRUE))
