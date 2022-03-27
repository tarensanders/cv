#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

auth_datasources <- function() {
  if (!gargle:::secret_can_decrypt("cv")) {
    stop(paste(
      "Cannot decrypt cv secret.",
      "Is the file and environment variable available?"
    ))
  }

  path <- "./inst/secret/cv-auth.json"
  raw <- readBin(path, "raw", file.size(path))
  json <- sodium::data_decrypt(
    bin = raw,
    key = gargle:::secret_pw_get("cv"),
    nonce = gargle:::secret_nonce()
  )

  googlesheets4::gs4_auth(path = rawToChar(json))
  googledrive::drive_auth(path = rawToChar(json))
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_sheet
get_date_modified <- function(data_sheet) {
  x <- googledrive::drive_get(id = googledrive::as_id(data_sheet))
  return(x$drive_resource[[1]]$modifiedTime)
}
