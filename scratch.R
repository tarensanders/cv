library(scholar)
library(dplyr)
id <- "8KNzhS4AAAAJ"
prof <- get_profile(id)
pubs <- get_publications(id, flush = TRUE)
pub <- get_publication_data_extended(id, "Mojj43d5GZwC")

pub$`Total citations`


as_tibble(pubs) %>%
  select(title, pubid) %>%
  arrange(title) %>%
  print(n = 100) %>%
  readr::write_csv("pubs.csv")

get_citation_history("8KNzhS4AAAAJ")

predict_h_index("8KNzhS4AAAAJ")

scholar::get_article_cite_history("8KNzhS4AAAAJ", "Mojj43d5GZwC")

mean(peer_reviewed_citations$impact_factor, na.rm = TRUE)

tinytex::tlmgr_install("enumitem")
