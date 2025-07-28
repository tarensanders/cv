#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param peer_reviewed
#' @param gscholar_data
#' @param jifs
#' @param short_pubs
#' @param top_five
update_peer_reviewed <- function(
    peer_reviewed, gscholar_data, jifs, short_pubs, top_five) {
  updated_peer_reviewed <-
    peer_reviewed %>%
    dplyr::mutate(
      annote = gsub("\\_", "_", annote, fixed = TRUE),
      annote = gsub("\\\n", "|", annote, fixed = TRUE),
      wos_id = stringr::str_extract(annote, "(?<=WOS:)[^\n]+"),
      scopus_id = stringr::str_extract(annote, "(?<=scopus_id:)[^\n]+"),
      scholar_id = stringr::str_extract(annote, "(?<=scholar_id:)[^|]+"),
      year = lubridate::year(as.Date(issued))
    ) %>%
    dplyr::left_join(
      dplyr::select(gscholar_data, pubid, cites),
      by = c("scholar_id" = "pubid")
    ) %>%
    dplyr::left_join(
      dplyr::rename(jifs, impact_factor = "Impact Factor"),
      by = c("container-title" = "Journal")
    ) %>%
    dplyr::arrange(desc(year), desc(impact_factor)) %>%
    dplyr::mutate(
      short_cv = wos_id %in% short_pubs,
      top_five = wos_id %in% top_five,
      cites = dplyr::if_else(is.na(cites), 0, cites),
      annote = dplyr::case_when(
        !is.na(impact_factor) ~
          glue::glue("{cites} citations | JIF: {round(impact_factor,1)}"),
        TRUE ~ paste0(" ", annote)
      ),
      order = dplyr::row_number()
    ) %>%
    dplyr::select(DOI:editor, short_cv, top_five, order, impact_factor, cites)

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
