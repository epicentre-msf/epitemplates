# Parse the yml file

#'@noRd
#'@importFrom fs path_dir
#'@importFrom yaml read_yaml
#'@importFrom fs path
#'@importFrom cli cli_abort
#'@importFrom purrr lmap
#'@importFrom purrr walk
#'@importFrom purrr pluck
#'@importFrom xfun try_silent
#'@importFrom fs file_delete

apply_yml_rules = function(path, output_dir = NULL){

  # path could be either a repository or a file path
  source_dir = path
  if (fs::is_file(path)) source_dir = fs::path_dir(path)

  source_files = path
  if (fs::is_dir(path)) source_files = fs::dir_ls(path, regexp =  "\\.((rmd)|(qmd)|(rmarkdown))$", ignore.case = TRUE)

  target_folder = source_dir

  # moving files to output directory
  if (!is.null(output_dir)){
    #move all the outputs to the output_folder
    fs::dir_create(output_dir)

    output_files = source_files |> xfun::sans_ext()
    ext = c("html", "pdf", "pptx", "docx")
    output_files = xfun::with_ext(rep(output_files, each = length(ext)), rep(ext, length(output_files)))

    # we have four different outputs: html, pdf, pptx, docx, just copy them
    move_file(output_files, output_dir)
    target_folder = output_dir
  }

  # reading and applying the yaml output file and its rules
  yml_file = fs::path(source_dir, "_outputs.yml")

  if (fs::file_exists(yml_file)) {

    yml_list = yaml::read_yaml(yml_file, readLines.warn = FALSE)
    yml_names = names(yml_list)

    # check the yaml tags
    unkown_tags = setdiff(yml_names, c("extensions", "files"))
    if (length(unkown_tags) > 0){
      cli::cli_abort(
        "Unknown keys in yaml:",
        "i" = "{paste0(unkown_tags, collapse = ', ')}"
      )
    }

    #getting the targeted output files

    allowed_ext = c("pdf", "html", "pptx", "docx")
    allowed_ext_reg = paste0("\\.(", paste0("(", allowed_ext, ")", collapse = "|"), ")$")
    target_files = fs::dir_ls(target_folder, regexp = allowed_ext_reg)

    # look at regex to apply
    regex_list = yml_list |> purrr::pluck("files") |> lapply(unlist)

    # look a tags in extensions
    ext = yml_list  |> purrr::pluck("extensions")

    if (!is.null(ext)) {
      if (!(all(names(ext) %in% allowed_ext))){
        cli::cli_abort(
          "Unknown extension(s) when parsing yaml",
          "i" = "Allowed extensions are {paste0(allowed_ext, collapse = ', ')}."
        )
      }

      ext = purrr::lmap(ext, convert_ext_to_regex)
      regex_list = c(regex_list, ext)
    }

    # apply all the regular expressions to the
    purrr::walk(regex_list, apply_expressions, files = fs::path_file(target_files), source_dir = target_folder)
  }
}



# convert the extensions part into regular expression
#'@noRd
convert_ext_to_regex = function(ext){

  expr = c(
    "pdf" = "\\.(pdf)$",
    "html" = "\\.(html)$",
    "docx" = "\\.(docx)$",
    "pptx"= "\\.(pptx)$"
  )

  regchunk = c(expr[names(ext)], unlist(ext))
  names(regchunk) = c("regex", "folder")
  list(regchunk)
}


# apply all the regular expression rules
#'@importFrom cli cli_abort
#'@importFrom fs dir_create
#'@importFrom purrr pluck
apply_expressions = function(regex_list, files, source_dir){

  regex_names = names(regex_list)
  remain_names = setdiff(regex_names, c("regex", "folder"))

  if (length(remain_names) > 0){
    cli::cli_abort(
      "Unknown keys in yaml:",
      "i" = "{paste0(remain_names, collapse = ', ')}"
    )
  }

  regex = regex_list |> purrr::pluck("regex")
  folder = regex_list |> purrr::pluck("folder")
  targ_files = NULL

  xfun::try_silent({
    targ_files = grep(regex, files, value = TRUE)
  })



  if (length(targ_files) != 0 ){

    cli::cli_alert_success(
      "regular expresion: {regex} ==> matches files: {paste0(targ_files, collapse = ', ')} saved to: {folder}",
    )

    fs::dir_create(folder)

    # this could fail, maybe come back to deal with that
    xfun::try_silent({
      fs::file_copy(
        fs::path(source_dir, targ_files),
        folder,
        overwrite = TRUE
      )
    })
  }
}

