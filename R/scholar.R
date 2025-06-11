get_gscholar_data_robust <- function(
    id,
    cache_path = "data/gscholar_data_last_good.rds") {
  out <- tryCatch(
    scholar::get_publications(id),
    error = function(e) NULL,
    warning = function(w) NULL
  )
  # If new data was fetched, save as last good version
  if (!is.null(out) && nrow(out) > 0) {
    saveRDS(out, cache_path)
    return(out)
  }
  # If failed, try to read from cache
  if (file.exists(cache_path)) {
    message("Failed to fetch new data; using cached last good version.")
    return(readRDS(cache_path))
  } else {
    stop("No cached data available and failed to fetch new data.")
  }
}

get_gscholar_profile_robust <- function(
    id,
    cache_path = "data/gscholar_profile_last_good.rds") {
  out <- tryCatch(
    scholar::get_profile(id),
    error = function(e) NULL,
    warning = function(w) NULL
  )
  if (!is.null(out) && length(out) > 0) {
    saveRDS(out, cache_path)
    return(out)
  }
  if (file.exists(cache_path)) {
    message("Failed to fetch new profile; using cached last good version.")
    return(readRDS(cache_path))
  } else {
    stop("No cached profile available and failed to fetch new data.")
  }
}
