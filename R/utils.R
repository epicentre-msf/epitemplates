
#'Move files from one repository to another
#'@noRd
#'@importFrom fs file_copy
#'@importFrom fs file_delete
#'@importFrom fs is_file
#'@importFrom fs is_dir
#'@importFrom fs dir_copy
#'@importFrom fs dir_delete
move_file = function(f, output_folder){

  if (length(f) > 1){
    lapply(f, move_file, output_folder = output_folder)
    return(invisible())
  }

  if (fs::is_file(f)) {
    fs::file_copy(f, output_folder, overwrite = TRUE)
    fs::file_delete(f)
  }

  if (fs::is_dir(f)){
    fs::dir_copy(f, output_folder, overwrite = TRUE)
    fs::dir_delete(f)
  }
}


#'check directory and filenames
#'
#'@noRd
#'@importFrom fs path_dir
check_dir = function(filepath){
  dir = filepath  |> fs::path_dir()
  if (dir == "") dir = "."
  dir
}

#'@noRd
#'@importFrom fs path_file
#'@importFrom fs file_exists
#'@importFrom fs path_ext_remove
#'@importFrom fs path_sanitize
#'@importFrom fs path_ext_set
check_filename = function(filepath, ext = ".qmd"){

  if (fs::file_exists(filepath)){
    cli::cli_abort(
      "{filepath} already exists"
    )
  }

  filename = filepath  |>
    fs::path_ext_remove() |>
    fs::path_file() |>
    fs::path_sanitize()
  if (filename == "") filename = "template"

  filename  |> fs::path_ext_set(ext)
}
