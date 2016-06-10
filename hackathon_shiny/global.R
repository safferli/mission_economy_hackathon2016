require(httr)
require(jsonlite)
require(png)
library(stringi)
library(DT)
library(shiny)
library(shinydashboard)
library(dplyr)
library(stringr)

counter = 3

selected_jurisdiction <- ""

corp_names <- read.csv("names.csv")
intermed_countries <- read.csv("intermed_countries.csv")
jurisdiction_images <- read.csv("jurisdiction_beaches.csv")

f.generate_random_name <- function(words = 3) {
  name <- corp_names %>%
    filter(order <= words | order == 4) %>%
    group_by(order) %>%
    sample_n(1)
  stri_trans_totitle(paste0(name$names, collapse=" "))
}

f.get_intermediaries <- function(country, rows=5) {
  ent_setup_count <- intermed_countries %>%
    filter(grepl(tolower(country), tolower(ent_countries))) %>%
    ungroup()
  ent_setup_count$int_address <- mapply(gsub, ent_setup_count$int_name, "", ent_setup_count$int_address)
  ent_setup_count <- ent_setup_count %>%
    mutate(int_address = str_trim(int_address)) %>%
    ungroup() %>% arrange(desc(count)) %>%
    slice(1:rows) %>%
    select(Intermediary = int_name, Address = int_address, Country = ent_countries, CorpsSetupPreviously = count) %>%
    mutate(Address = paste0("<a href=\"https://www.google.ca/maps/search/", Address, "\">", Address, "</a>"))
}

f.get_pictures <- function(n) {
  tmp <- jurisdiction_images %>%
    sample_n(n)
}

f.get_active_corps_by_jurisdictions <- function(jurisdiction) {
  tmp <- jurisdiction_images %>%
    filter(jurisdiction_description == jurisdiction)
  return(tmp$n[1])
}
