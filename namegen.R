library(readr)
library(tidyr)
library(dplyr)
library(magrittr)

csv_folder <- "offshore_leaks_csvs-20160524/"

Entities <- read_csv(paste0(csv_folder, "Entities.csv"))

Entities %<>%
  # get lower-case names
  mutate(n = name %>% tolower) %>%
  # get last "word" of name for corporation form (e.g. "ltd.")
  mutate(form = gsub(".* ", "", n))

# split the names into one column per "word"
Entities %<>% separate(n, paste0("n", 1:20), fill = "right")

# stopwords -- we don't want these in our companies
stop <- c(letters, "the", "com", "and", "of", "int", "pty", "samoa", "sdn", "europe", "ptc", "")

# first "word" of the company name
n <- "n1"
filter_criteria <- lazyeval::interp(~ ! col %in% stop & ! col %in% Entities$form, col = as.name(n))
first <- Entities %>% 
  group_by_(.dots = n) %>% 
  summarize(n = n()) %>% 
  filter_(filter_criteria) %>% 
  arrange(-n) %>% 
  .[[n]] %>% 
  head(31)
# birthdates: 31 days in a month, get top 31
paste(1:31, "=", first, "\n") %>% cat

# second "word" of company name
n <- "n2"
filter_criteria <- lazyeval::interp(~ ! col %in% c(stop, Entities$form, first), col = as.name(n))
second <- Entities %>% 
  group_by_(.dots = n) %>% 
  summarize(n = n()) %>% 
  filter_(filter_criteria) %>% 
  arrange(-n) %>% 
  .[[n]] %>% 
  head(26)
# family names: 26 letters in the alphabet
paste(letters, "=", second, "\n") %>% cat

# third "word" of company name
n <- "n3"
filter_criteria <- lazyeval::interp(~ ! col %in% c(stop, Entities$form, first, second), col = as.name(n))
third <- Entities %>% 
  group_by_(.dots = n) %>% 
  summarize(n = n()) %>% 
  filter_(filter_criteria) %>% 
  filter(!is.na(n3)) %>% 
  arrange(-n) %>% 
  .[[n]] %>% 
  head(26)
# first names: 26 letters in the alphabet
paste(letters, "=", third, "\n") %>% cat

# manual clean-up of corporation forms from 
# form <- Entities %>% group_by(form) %>% tally(sort = TRUE)
form <- c("ltd.", "inc.", "s.a.", "corp.", 
          "foundation", "trust", "gmbh", 
          "company", "associates", "group", 
          "fund", "partners")
paste(1:12, "=", form, "\n") %>% cat

# output all into a dataframe
namegen <- data.frame(
  order = c(
    rep(1:4, c(length(first), length(second), length(third), length(form)))
  ), 
  names = c(first, second, third, form)
)

# export to csv
write.csv(namegen, file = "names.csv", row.names = FALSE)



