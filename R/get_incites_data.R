#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param peer_reviewed
get_incites_data <- function(peer_reviewed, jifs) {
  uts <- peer_reviewed %>%
    dplyr::filter(grepl("WOS", annote)) %>%
    tidyr::drop_na(annote) %>%
    dplyr::pull(annote)

  incites_data <- wosr::pull_incites(uts)

  incites_data_joined <-
    incites_data %>%
    as_tibble() %>%
    select(ut, tot_cites, impact_factor, percentile, nci, hot_paper) %>%
    full_join(
      select(peer_reviewed, annote, issued, `container-title`),
      by = c("ut" = "annote")
    ) %>%
    mutate(year = as.Date(issued))

  incites_data_joined_updated <-
    incites_data_joined %>%
    select(-impact_factor) %>%
    left_join(
      dplyr::rename(jifs, impact_factor = "Impact Factor"),
      by = c("container-title" = "Journal")
    ) %>%
    select(-issued)

  return(incites_data_joined_updated)
}
