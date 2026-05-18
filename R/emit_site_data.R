#' Emit JSON sidecar files for the Quarto website.
#'
#' These functions consume the same enriched targets used by the CV pipeline
#' and write JSON that the Quarto listing pages read at render time. Each
#' function returns the path it wrote so it can be tracked as a
#' `format = "file"` target.

#' @param peer_reviewed_citations enriched data frame from update_peer_reviewed
#' @param path destination JSON path
emit_publications_json <- function(peer_reviewed_citations, path) {
  df <- peer_reviewed_citations

  authors <- vapply(df$author, function(a) {
    if (is.null(a) || length(a) == 0) {
      return("")
    }
    if (is.data.frame(a)) {
      given <- if ("given" %in% names(a)) a$given else rep("", nrow(a))
      family <- if ("family" %in% names(a)) a$family else rep("", nrow(a))
      paste(trimws(paste(given, family)), collapse = ", ")
    } else if (is.list(a)) {
      paste(vapply(a, function(x) {
        paste(trimws(paste(x[["given"]] %||% "", x[["family"]] %||% "")),
          collapse = " "
        )
      }, character(1)), collapse = ", ")
    } else {
      as.character(a)
    }
  }, character(1))

  year <- df$year
  date <- sprintf("%04d-01-01", as.integer(year))

  doi <- df$DOI
  doi_url <- ifelse(is.na(doi) | doi == "", NA_character_,
    paste0("https://doi.org/", doi)
  )

  records <- lapply(seq_len(nrow(df)), function(i) {
    list(
      title = unbox_or_na(df$title[i]),
      author = unbox_or_na(authors[i]),
      year = unbox_or_na(year[i]),
      date = unbox_or_na(date[i]),
      journal = unbox_or_na(df[["container-title"]][i]),
      volume = unbox_or_na(df$volume[i]),
      issue = unbox_or_na(df$issue[i]),
      pages = unbox_or_na(df$page[i]),
      doi = unbox_or_na(doi[i]),
      path = unbox_or_na(doi_url[i]),
      cites = unbox_or_na(df$cites[i]),
      impact_factor = unbox_or_na(round_or_na(df$impact_factor[i], 1)),
      wos_id = unbox_or_na(df$wos_id[i]),
      scopus_id = unbox_or_na(df$scopus_id[i]),
      scholar_id = unbox_or_na(df$scholar_id[i]),
      abstract = unbox_or_na(df$abstract[i]),
      categories = list(as.character(year[i]))
    )
  })

  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  jsonlite::write_json(records, path, pretty = TRUE, na = "null",
    auto_unbox = FALSE)
  path
}

#' @param research_profile list produced by make_profile()
#' @param gscholar_profile raw profile from scholar::get_profile()
#' @param path destination JSON path
emit_profile_json <- function(research_profile, gscholar_profile, path) {
  out <- list(
    cites = research_profile$cites,
    h_index = research_profile$h_index,
    i10_index = research_profile$i10_index %||% gscholar_profile$i10_index,
    pubs = research_profile$pubs,
    mean_jif = research_profile$mean_jif,
    updated = format(Sys.Date(), "%Y-%m-%d")
  )
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  jsonlite::write_json(out, path, pretty = TRUE, auto_unbox = TRUE,
    na = "null")
  path
}

#' @param software data frame from the Software sheet
#' @param path destination JSON path
emit_software_json <- function(software, path) {
  records <- lapply(seq_len(nrow(software)), function(i) {
    list(
      title = unbox_or_na(software$Package[i]),
      description = unbox_or_na(software$Desc[i]),
      details = unbox_or_na(software$Details[i]),
      path = unbox_or_na(software$Link[i]),
      language = unbox_or_na(software$Language[i]),
      categories = list(as.character(software$Language[i] %||% "Other"))
    )
  })
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  jsonlite::write_json(records, path, pretty = TRUE, na = "null",
    auto_unbox = FALSE)
  path
}

# helpers --------------------------------------------------------------------

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || is.na(a[1])) b else a

unbox_or_na <- function(x) {
  if (is.null(x) || length(x) == 0) return(NA)
  if (is.na(x[1])) return(NA)
  jsonlite::unbox(x[1])
}

round_or_na <- function(x, digits) {
  if (is.null(x) || length(x) == 0 || is.na(x[1])) NA_real_ else round(x[1], digits)
}
