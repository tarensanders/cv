#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author Taren Sanders
#' @export
get_sjr_data <- function() {
  sjr_url <- "https://www.scimagojr.com/journalrank.php?out=xls"

  temp_file <- tempfile()
  download.file(sjr_url, temp_file)

  sjr <- readr::read_csv2(temp_file, lazy = FALSE)

  unlink(temp_file)
  return(sjr)
}
