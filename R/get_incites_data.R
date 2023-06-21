#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param peer_reviewed
get_incites_data <- function(peer_reviewed, sjr_data) {
  uts <- peer_reviewed %>%
    tidyr::drop_na(annote) %>%
    dplyr::pull(annote)

  incites_data <- wosr::pull_incites(uts)

  incites_data_joined <-
    incites_data %>%
    as_tibble() %>%
    select(ut, tot_cites, impact_factor, percentile, nci, hot_paper) %>%
    left_join(
      select(peer_reviewed, annote, issued, `container-title`),
      by = c("ut" = "annote")
    ) %>%
    mutate(year = as.Date(issued))

  journals <-
    incites_data_joined %>%
    arrange(desc(impact_factor)) %>%
    distinct(`container-title`, .keep_all = TRUE) %>%
    select(`container-title`, impact_factor)

  incites_data_joined_updated <-
    incites_data_joined %>%
    select(-impact_factor) %>%
    left_join(journals, by = "container-title") %>%
    group_by(`container-title`) %>%
    tidyr::fill(impact_factor) %>%
    ungroup() %>%
    select(-issued, -`container-title`)

  return(incites_data_joined_updated)
}
