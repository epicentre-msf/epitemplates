# functions for Rstudio api.

# create a qmd from a directory

#' @noRd
#' @importFrom rstudioapi selectFile
addin_quarto_doc = function() {
  tmp = rstudioapi::selectFile(existing = FALSE)
  epi_qmd(tmp, quiet = FALSE)
}

#' @noRd
#' @importFrom rstudioapi selectFile
addin_quarto_book = function() {
  tmp = rstudioapi::selectFile(existing = FALSE)
  epi_qmd(tmp, project_type = "book", quiet = FALSE)
}

#'@noRd
#'@importFrom rstudioapi selectFile
addin_rmd_doc = function(){
  tmp = rstudioapi::selectFile(existing = FALSE)
  epi_rmd(tmp, quiet)
}
