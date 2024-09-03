# scripts for rendering and saving documents


#'Render rmarkdown or quarto documents/
#'
#'Provide a wrapper to `rmarkdown::render` and `quarto::quarto_render`.
#'
#'
#' @param path Character vector, paths fo files to render
#' @param output_format Output format, default is all ie renders to all output
#' @param output_dir Where to save all output files. Default is the same folder as `path`
#' @param apply_rules Boolean. Whether to apply rules in _outputs.yml files or not. Default is TRUE
#' @param remove_renders Boolean. Remove output files of the rendering process. Default is FALSE
#' @param ... other parameters passed to `rmarkdown::render` or `quarto::render`
#'
#'@importFrom fs is_dir
#'@importFrom fs dir_ls
#'@importFrom fs file_exists
#'@importFrom cli cli_abort
#'@importFrom xfun file_ext
#'@importFrom fs path_dir
#'@importFrom fs dir_create
#'@importFrom fs path
#'@importFrom fs dir_create
#'@importFrom xfun with_ext
#'@importFrom xfun sans_ext
#'@importFrom purrr pluck
#'@export
#'@examples
#'\dontrun{
#' epi_qmd()
#' epi_render(path = "template.qmd")
#'}
epi_render = function(path, output_format = "all", output_dir = NULL, apply_rules = TRUE, remove_renders = FALSE, ...){

    if (length(path) > 1){
      lapply(path, epi_render, output_format, output_dir, apply_rules, remove_renders, ...)
      return(invisible())
    }

    # rendering all files of a directory
    if (fs::is_dir(path)) {
        paths = fs::dir_ls(path, regexp = "\\.((rmd)|(qmd)|(rmarkdown))$", ignore.case = TRUE)
        if(length(paths) > 0) lapply(paths, epi_render, output_format, output_dir, apply_rules = FALSE, ...)

        # apply rules to the directory if there is a _outputs.yml file
        if (apply_rules) apply_yml_rules(path, output_dir, remove_renders)
        return(invisible())
    }

    # rendering only one file (rmd or qmd)
    if (length(path) == 1) render_one_file(path, output_format = output_format, ...)

    if (apply_rules) apply_yml_rules(path, output_dir, remove_renders)
}


#Render a single Rmd or qmd file
#'@noRd
#'@importFrom xfun file_ext
#'@importFrom fs file_exists
#'@importFrom cli cli_abort
#'@importFrom quarto quarto_render
#'@importFrom rmarkdown render
render_one_file = function(path, output_format, ...){
  # Check for file existence
  if (!fs::is_file(path)){
    cli::cli_abort(
      "Unable for find the file {path}"
    )
  }

  # Rendering documents depending on extension
  ext = xfun::file_ext(path) |> tolower()
  if (!(ext %in% c("qmd", "rmd", "rmarkdown"))) {
    cli::cli_abort(
      "Unknown file extension",
      "i" = "check extension of {path}, should be qmd or rmd"
    )
  }

  # render quarto
  if(ext == "qmd"){
    quarto::quarto_render(input = path, output_format = output_format, ...)
  }

  # render rmarkdown
  if (ext == "rmd" || ext == "rmarkdown"){
    rmarkdown::render(input = path, output_format = output_format, ...)
  }
}
