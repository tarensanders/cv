#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param gscholar_profile
#' @param peer_reviewed_citations
make_profile <- function(gscholar_profile, peer_reviewed_citations) {
  profile <- list()
  profile$pubs <- nrow(peer_reviewed_citations)
  profile$h_index <- gscholar_profile$h_index
  profile$cites <- gscholar_profile$total_cites
  profile$mean_jif <-
    round(mean(peer_reviewed_citations$impact_factor, na.rm = TRUE), 1)

  return(profile)
}
