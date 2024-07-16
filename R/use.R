#' Use quarto report or book templates
#'
#' Download and use document/book quarto template.
#'
#'
#' @param path The path to the quarto document
#' @param quiet Suppress messages
#' @param add_project Boolean. Add a Rstudio project to the new document folder.
#' @param project_type A character of length 1, specifying which qmd repo to download. Could be one of ("document", "book"). Default is "document".
#' @importFrom quarto quarto_use_template
#' @importFrom rstudioapi openProject
#' @importFrom rstudioapi isAvailable
#' @importFrom cli cli_abort
#' @importFrom xfun try_silent
#' @importFrom fs path
#' @importFrom fs path_temp
#' @importFrom fs file_copy
#' @importFrom fs file_exists
#' @importFrom fs dir_exists
#' @importFrom fs dir_create
#' @importFrom fs dir_copy
#' @importFrom fs dir_delete
#' @importFrom withr with_dir
#' @export
#' @examples
#' \dontrun{
#' epi_qmd(path = ".", quiet = TRUE, project_type = "document")
#' epi_qmd(path = ".", quiet = TRUE, project_type = "book")
#' }
epi_qmd = function(
    path = ".",
    quiet = TRUE,
    project_type = "document",
    add_project = (project_type == "book")) {

  # provide correct project type
  if ((length(project_type) > 1) | !(project_type %in% c("document", "book"))){
    cli::cli_abort(
      "{.var project_type} must be of length 1 and have one of the two values: 'document', 'book'"
    )
  }

  dir = check_dir(path)
  filename = check_filename(path)
  #new file path avec checking names
  filepath = fs::path(dir, filename)

  # do not download extensions, copy template file and rename it
  if (fs::dir_exists(fs::path(dir, "_extensions"))) {
    mock_file = fs::path(dir, "_extensions", "epicentre-msf", "epitemplates-report", "mock", "template.qmd")
    if (!fs::file_exists(mock_file)) {
      cli::cli_abort(
        "Unable to locate a template mock file in _extensions folder",
        "i" = "Are you using the epitemplates-report extension?"
      )
    }
    # creating the new file
    fs::file_copy(mock_file, filepath, overwrite = TRUE)

    if (!quiet){
      cli::cli_inform(
        "{filepath} created"
      )
    }

    return(invisible(TRUE))
  }
  # The extension folder does not exists, create a new one

  fs::dir_create(dir)
  # download template to temporary directory
  tmp = fs::path_temp("template")

  fs::dir_create(tmp)
  gh_repo = ifelse(project_type == "document", "epicentre-msf/epitemplates-report", "epicentre-msf/epitemplates-book")

  withr::with_dir(
    tmp,
    {
      # download the template from github repository
      quarto::quarto_use_template(
        template = gh_repo,
        no_prompt = TRUE,
        quiet = quiet
      )
    }
  )

  # copy files from the temporary directory to the new directory
  move_file(tmp, dir)

  # rename the "template file"
  xfun::try_silent({
    file.rename(
      from = fs::path(dir, "template.qmd"),
      to = filepath
    )
    # remove the temporary directory
    fs::dir_delete(tmp)
  })

  if (add_project && rstudioapi::isAvailable()){
    xfun::try_silent({
      rstudioapi::openProject(dir)
    })
  }

  if (!quiet){
    cli::cli_inform(
      "{filepath} created"
    )
  }

  invisible(TRUE)
}

#' Use Rmarkdown template
#'
#' Import and use Rmarkdown's template.
#'
#'@inheritParams epi_qmd
#'@importFrom rmarkdown draft
#'@importFrom fs path_package
#'@importFrom fs path
#'@importFrom fs file_copy
#'@importFrom fs dir_create
#'@importFrom xfun try_silent
#'@importFrom withr with_dir
#'@importFrom rstudioapi openProject
#'@importFrom rstudioapi isAvailable
#'@export
#'@examples
#' \dontrun{
#' epi_rmd(path = ".")
#'}
epi_rmd = function(path, add_project = FALSE, quiet = TRUE){

  dir = check_dir(path)
  filename = check_filename(path, ext = ".Rmd")
  # new file path avec checking names
  filepath = fs::path(dir, filename)
  # if there is already an assets folder, only
  # find and copy the relevant file from the package directory
  if (fs::dir_exists(fs::path(dir, "assets"))){

    skeleton_path = fs::path_package(
      package = "epitemplates",
      "rmarkdown", "templates", "epicentre-rmd",
      "skeleton", "skeleton.Rmd"
    )

    fs::file_copy(skeleton_path, filepath, overwrite = TRUE)

    if (!quiet){
      cli::cli_inform(
        "{filepath} created"
      )
    }

    return(invisible(TRUE))
  }

  # assets directory does not exists

  fs::dir_create(dir)
  withr::with_dir(
    dir,
    {
    # create the draft from Rmarkdown because it does not exists
      rmarkdown::draft(
        file = filename,
        template = "epicentre-rmd",
        package = "epitemplates",
        create_dir = FALSE,
        edit = FALSE
      )
    }
  )

  # add the procject
  if (add_project && rstudioapi::isAvailable()){
    xfun::try_silent({
      rstudioapi::openProject(dir)
    })
  }

  if (!quiet){
    cli::cli_inform(
      "{filepath} created"
    )
  }

  invisible(TRUE)
}
