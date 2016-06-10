library(readr)
library(dplyr)
library(RNeo4j)

csv_folder <- "/Users/colin/Downloads/offshore_leaks_csvs-20160524/"

Entities <- read_csv(paste0(csv_folder, "Entities.csv"))
Intermediaries <- read.csv(paste0(csv_folder, "Intermediaries.csv"))
Officers <- read.csv(paste0(csv_folder, "Officers.csv"))
Addresses <- read.csv(paste0(csv_folder, "Addresses.csv"))

Edges <- read.csv(paste0(csv_folder, "all_edges.csv"))

important_edges <- unique(Edges$rel_type[grepl("benefic | sole | chairman | director", Edges$rel_type, ignore.case = TRUE)])
important_edges <- unique(important_edges[!grepl("nominee", important_edges, ignore.case = TRUE)])

# ll <- Officers %>%
#   left_join(Edges, c("node_id"="node_1")) %>%
#   filter(grepl("intermediary", tolower(rel_type))) %>%
#   group_by(countries) %>%
#   summarize(n = n_distinct(name))
# qq <- Intermediaries %>%
#   group_by(countries) %>%
#   summarize(n = n_distinct(name))
# 
# 
# graph = startGraph("http://localhost:7474/db/data", username="neo4j", password="colinwins2")
# 
# query = "
# MATCH
# (n:Intermediary)-[r:*]->(e:Entity)
# RETURN n.name, r, e.name
# LIMIT 25
# "
# 
# ll <- cypherToList(graph, query)

