library(readr)
library(dplyr)
library(magrittr)

csv_folder <- "offshore_leaks_csvs-20160524/"

Entities <- read_csv(paste0(csv_folder, "Entities.csv"))

Entities %<>%
  mutate(n = name %>% tolower) %>%
  mutate(form = gsub(".* ", "", n))

Entities %<>% separate(n, paste0("n", 1:20), fill = "right")

stop <- c(letters, "the", "com", "and", "of", "int", "pty", "samoa", "sdn", "europe", "ptc", "")
n <- "n1"
filter_criteria <- lazyeval::interp(~ ! col %in% stop & ! col %in% Entities$form, col = as.name(n))
first <- Entities %>% group_by_(.dots = n) %>% summarize(n = n()) %>% filter_(filter_criteria) %>% arrange(-n) %>% .[[n]] %>% head(31)
paste(1:31, "=", first, "\n") %>% cat

n <- "n2"
filter_criteria <- lazyeval::interp(~ ! col %in% c(stop, Entities$form, first), col = as.name(n))
second <- Entities %>% group_by_(.dots = n) %>% summarize(n = n()) %>% filter_(filter_criteria) %>% arrange(-n) %>% .[[n]] %>% head(26)
paste(letters, "=", second, "\n") %>% cat

n <- "n3"
filter_criteria <- lazyeval::interp(~ ! col %in% c(stop, Entities$form, first, second), col = as.name(n))
third <- Entities %>% group_by_(.dots = n) %>% summarize(n = n()) %>% filter_(filter_criteria) %>% filter(!is.na(n3)) %>% arrange(-n) %>% .[[n]] %>% head(26)
paste(letters, "=", third, "\n") %>% cat

form <- c("ltd.", "inc.", "s.a", "corp.", "foundation", "trust", "gmbh", "company", "associates", "group", "fund", "partners")
paste(1:12, "=", form, "\n") %>% cat

