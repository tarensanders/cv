#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param peer_reviewed
#' @param incites_data
#' @param short_pubs
#' @param top_five
update_peer_reviewed <- function(
    peer_reviewed, incites_data, short_pubs, top_five) {
  updated_peer_reviewed <-
    peer_reviewed %>%
    left_join(incites_data,
      by = c("annote" = "ut", "container-title" = "container-title")
    ) %>%
    arrange(desc(format(year, "%Y")), desc(impact_factor)) %>%
    mutate(
      short_cv = annote %in% short_pubs,
      top_five = annote %in% top_five,
      annote = case_when(
        tot_cites > 0 & hot_paper ~
          glue::glue(
            "\\\ | Citations: {tot_cites}; JIF: {round(impact_factor,1)}; CNCI: {round(nci,1)}; WoS Hot Paper" # nolint
          ),
        tot_cites > 0 & !hot_paper ~
          glue::glue(
            "\\\ | Citations: {tot_cites}; JIF: {round(impact_factor,1)}; CNCI: {round(nci,1)}" # nolint
          ),
        !is.na(impact_factor) ~
          glue::glue("\\\ | JIF: {round(impact_factor,1)}"),
        TRUE ~ paste0(" ", annote)
      ),
      order = row_number()
    ) %>%
    select(DOI:issue, short_cv, top_five, order)

  updated_peer_reviewed$issued <-
    purrr::modify_depth(updated_peer_reviewed$issued, 1, replace_x)

  return(updated_peer_reviewed)
}

# https://github.com/mitchelloharawild/vitae/issues/227
replace_x <- function(x, replacement = NA_character_) {
  if (length(x) == 0 || length(x[[1]]) == 0) {
    replacement
  } else {
    x
  }
}
