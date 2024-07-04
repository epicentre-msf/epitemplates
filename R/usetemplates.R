#' Use quarto EpiDS templates
#'
#' Download and use the EpiDS document/book quarto template.
#'
#' The provided directory should be empty.
#'
#' @param dir The directory where to download the quarto document
#' @param quiet Suppress warnings and messages
#' @param add_project Boolean. Add a Rstudio project to the document folder.
#' @param project_type A character of length 1, specifying which qmd type to download. Could be one of ("document", "book"). Default is "document".
#' @importFrom quarto quarto_use_template
#' @importFrom rstudioapi openProject
#' @export
#' @examples
#' \dontrun{
#' epids_qmd_doc(dir = ".", quiet = TRUE)
#' epids_qmd_book(dir = ".", quiet = TRUE)
#' }
epids_qmd <- function(
    dir = ".",
    quiet = FALSE,
    project_type = "document",
    add_project = (project_type == "book")) {
  if (length(list.files(dir)) > 0) stop("Please provide an empty directory")
  if ((length(project_type) > 1) | !(project_type %in% c("document", "book"))) stop("Invalid value for project_type")
  previous_wd <- getwd()
  setwd(dir)

  template_dir <- ifelse(project_type == "document", "epicentre-msf/epitemplates-report", "epicentre-msf/epitemplates-book")
  quarto::quarto_use_template(
    template = "epicentre-msf/epitemplates-report",
    no_prompt = TRUE,
    quiet = quiet
  )
  setwd(previous_wd)

  try({
    if (add_project) rstudioapi::openProject(dir)
  }, silent = TRUE)
}

#' @noRd
#' @importFrom rstudioapi selectDirectory
epids_interactive_doc <- function() {
  epids_qmd(rstudioapi::selectDirectory(), add_project = TRUE)
}
#' @noRd
#' @importFrom rstudioapi selectDirectory
epids_interactive_book <- function() {
  epids_qmd(rstudioapi::selectDirectory(), project_type = "book")
}
