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