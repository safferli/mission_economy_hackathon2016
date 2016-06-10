#rm(list = ls()); gc(); gc()

options(bitmapType='cairo')
options(scipen = 999)

library(rvest)
library(dplyr)

# Define your workspace: "X:/xxx/"
wd <- "c:/github/mission_economy_hackathon2016/"
setwd(wd)


## List of Island States (wikipedia)
islands.url <-  "https://en.wikipedia.org/wiki/List_of_island_countries"

## read the page into R
islands.wiki <- read_html(islands.url, encoding = 'utf8')

#islands.wiki <- read_html(iconv(islands.url, to = "UTF-8"), encoding = 'utf8')



## sovereign states
islands.sov <- islands.wiki %>%
  html_nodes("table") %>%
  # first table in the page
  # [[2]], since the "this page needs verification" boilerplate on the page is a table
  .[[2]] %>%
  html_table() 

## dependencies and other notable regions
islands.dep <- islands.wiki %>%
  html_nodes("table") %>%
  # first table in the page
  .[[3]] %>%
  html_table() 