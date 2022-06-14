#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param gscholar_profile
#' @param incites_data
#' @param peer_reviewed_citations
make_profile <- function(gscholar_profile, incites_data,
                         peer_reviewed_citations) {
  profile <- list()
  profile$pubs <- nrow(peer_reviewed_citations)
  profile$h_index <- gscholar_profile$h_index
  profile$cites <- gscholar_profile$total_cites
  profile$mean_cnci <- round(mean(incites_data$nci, na.rm = TRUE), 1)
  profile$mean_jif <- round(mean(incites_data$impact_factor, na.rm = TRUE), 1)

  return(profile)
}