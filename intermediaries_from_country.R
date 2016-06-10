library(readr)
library(dplyr)
library(stringr)
library(RNeo4j)

csv_folder <- "/Users/colin/Downloads/offshore_leaks_csvs-20160524/"

Entities <- read_csv(paste0(csv_folder, "Entities.csv"))
Intermediaries <- read.csv(paste0(csv_folder, "Intermediaries.csv"))
Officers <- read.csv(paste0(csv_folder, "Officers.csv"))
Addresses <- read.csv(paste0(csv_folder, "Addresses.csv"))

Edges <- read.csv(paste0(csv_folder, "all_edges.csv"))

# important_edges <- unique(Edges$rel_type[grepl("benefic|sole|chairman|director", Edges$rel_type, ignore.case = TRUE)])
# important_edges <- unique(important_edges[!grepl("nominee", important_edges, ignore.case = TRUE)])
# 
# ll <- Officers %>%
#   left_join(Edges, c("node_id"="node_1")) %>%
#   filter(grepl("intermediary", tolower(rel_type))) %>%
#   group_by(countries) %>%
#   summarize(n = n_distinct(name))
# qq <- Intermediaries %>%
#   group_by(countries) %>%
#   summarize(n = n_distinct(name))


# Intermediaries who set up companies in different contries
ints <- Intermediaries %>% select(name, address, country_codes, countries, status, node_id) %>%
  filter(tolower(status) == "active", address != "")
colnames(ints) <- paste0("int_", colnames(ints))
# 
ents <- Entities %>% select(name, address, country_codes, countries, jurisdiction, jurisdiction_description, node_id)
colnames(ents) <- paste0("ent_", colnames(ents))
# All active intermediaries and the entities they set up
inter_and_ent <- ints %>%
  inner_join(Edges, by=c("int_node_id"="node_1")) %>%
  inner_join(ents, by=c("node_2"="ent_node_id"))

# Count of offshore corporations set up in the given country, and by whom
Country <- "Germany"
ent_setup_count <- inter_and_ent %>%
  group_by(int_name, int_address, ent_countries) %>%
  summarize(count=n_distinct(ent_name))
ent_setup_count$int_address <- mapply(gsub, ent_setup_count$int_name, "", ent_setup_count$int_address)
ent_setup_count <- ent_setup_count %>% ungroup() %>%
  mutate(int_address = str_trim(int_address))
#write.csv(ent_setup_count, "intermed_countries.csv", row.names = FALSE)
ent_setup_count <- ent_setup_count %>%
  filter(grepl(tolower(Country), tolower(ent_countries))) %>%
  ungroup()
ent_setup_count <- ent_setup_count %>%
  ungroup() %>% arrange(desc(count))








