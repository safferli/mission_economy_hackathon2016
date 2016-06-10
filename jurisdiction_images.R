library(readr)
library(dplyr)
library(stringr)

f.query_picture_url <- function(country) {
  request <- httr::GET(paste0("https://www.googleapis.com/customsearch/v1?q=", gsub(" ","+", country), "+beach&cx=004736961430996953281%3Aazmxm9up1cu&searchType=image&imageType=photo&key=", "YOURAPIKEY"))
  json_data <- httr::content(request, as = "text")
  list_data <- jsonlite::fromJSON(json_data)
  image_url <- list_data$items$link[1]
}

csv_folder <- "/Users/colin/Downloads/offshore_leaks_csvs-20160524/"

Entities <- read_csv(paste0(csv_folder, "Entities.csv"))

jurisdictions <- Entities %>%
  filter(!(jurisdiction_description %in% c("Undetermined","Recorded in leaked files as \"fund\""))) %>%
  select(jurisdiction_description) %>%
  distinct(jurisdiction_description)
jurisdictions$beach_url <- mapply(f.query_picture_url, jurisdictions$jurisdiction_description)
temp <- Entities %>%
  filter(tolower(status) == "active") %>%
  group_by(jurisdiction_description) %>%
  tally()
jurisdictions <- inner_join(jurisdictions, temp, by=c("jurisdiction_description"))

#write.csv(jurisdictions, file = "jurisdiction_beaches.csv", row.names = FALSE)
