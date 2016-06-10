#rm(list = ls()); gc(); gc()

options(bitmapType='cairo')
options(scipen = 999)

library(rvest)
library(dplyr)

# Define your workspace: "X:/xxx/"
wd <- "c:/github/mission_economy_hackathon2016/"
setwd(wd)


f.convert.to.numeric <- function(x) {
  as.numeric(gsub(",", "", x))
}




## List of Island States (wikipedia)
islands.url <-  "https://en.wikipedia.org/wiki/List_of_island_countries"

## Windows, I hate you...
# Sys.setlocale("LC_CTYPE", "en_GB.UTF-8")
# Sys.setlocale(category="LC_ALL", locale = "English_United States.1252")
# Sys.setlocale(category="LC_ALL", locale = "English_United States.UTF-8")
# getOption("encoding")
# Encoding(islands.sov$Name)
# Sys.getlocale()


## read the page into R
islands.wiki <- read_html(islands.url, encoding = 'UTF-8')

#islands.wiki <- read_html(iconv(islands.url, to = "UTF-8"), encoding = 'utf8')




## sovereign states
islands.sov <- islands.wiki %>%
  html_nodes("table") %>%
  # first table in the page
  # [[2]], since the "this page needs verification" boilerplate on the page is a table
  .[[2]] %>%
  html_table() %>% 
  # select by column number, since utf8 and windows and f&%!
  # Name, Population, Area, Geographic location
  select(1, 4:5, 7) %>%
  # make R-safe column names
  setNames(make.names(names(.), unique = TRUE)) %>% 
  # stupid Windows and utf8 in Area
  select(Name, Population, Area = starts_with("Area"), everything()) %>% 
  # get only Oceanic and Carribean islands
  filter(
    grepl("(Caribbean Sea)|(Pacific Ocean)", Geographic.location)
  ) %>% 
  mutate(
    Population = f.convert.to.numeric(Population),
    Area = f.convert.to.numeric(Area),
    # to merge later on
    Sovereign.state = NA
  ) %>% 
  # remove large countries
  filter(Population < 1000000) 


## dependencies and other notable regions
islands.dep <- islands.wiki %>%
  html_nodes("table") %>%
  # fourth table in the page, [[5]], because see comment above
  .[[5]] %>%
  html_table() %>% 
  # select by column number, since utf8 and windows and f&%!
  # Name, SOvereign, Population, Area, Geographic location
  select(1, 4:6, 8) %>%
  # make R-safe column names
  setNames(make.names(names(.), unique = TRUE)) %>% 
  # stupid Windows and utf8 in Area
  select(Name, Population, Area = starts_with("Area"), everything()) %>% 
  rename(Geographic.location = Geographic.Location) %>% 
  # get only Oceanic and Carribean islands
  filter(
    grepl("(Caribbean Sea)|(Pacific Ocean)|(English Channel)", Geographic.location)
  ) %>% 
  mutate(
    Population = f.convert.to.numeric(Population),
    Area = f.convert.to.numeric(Area)
  ) %>% 
  # remove large countries
  filter(Population < 1000000) 



islands <- bind_rows(islands.dep, islands.sov)

write.csv(islands, file = "islandnations.csv", row.names = FALSE)





