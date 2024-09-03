# test for applying rules from the yaml file

test_that(
  "Able to convert filetypes to regex",
  {
    regex_data = test_path("data", "yamltemplate.rds") |> readRDS()
    ext = regex_data |> purrr::pluck("extensions")
    ext_regex = purrr::lmap(ext, convert_ext_to_regex)

    # same length
    expect_equal(length(ext), length(ext_regex))

    # a list
    expect_true(is.list(ext_regex))

    # names
    expect_true(all(names(ext_regex[[1]]) %in% c("regex", "folder")))

    # folder and regex of pdf
    folder_pdf = ext_regex |> pluck(1) |> pluck("folder")
    regex_pdf = ext_regex |> pluck(1) |> pluck("regex")
    expect_equal(folder_pdf, "local/pdf")
    expect_equal(regex_pdf, "\\.(pdf)$")
  }
)

test_that(
  "Able to apply rules from yaml on a directory",
  {
    tmp = tmp_loc("test-ymlrules")
    yml_file = fs::path(tmp, "_outputs.yml")

    #files for rendering exist
    fs::dir_create(tmp)
    fs::file_copy(test_path("data", "_outputs.yml"), tmp)
    expect_true(fs::file_exists(yml_file))

    suppressMessages({
      expect_true(epi_qmd(fs::path(tmp, "report.qmd")))
      expect_true(epi_qmd(fs::path(tmp, "test.qmd")))
      expect_true(epi_rmd(fs::path(tmp, "test.Rmd")))
      expect_true(epi_rmd(fs::path(tmp, "report.Rmd")))
    })

    withr::with_dir(
      tmp,
      {
        epi_render(tmp, quiet = TRUE)
      }
    )

    out_local_html = fs::path(tmp, "local", "html", "test.html")
    out_local_test = fs::path(tmp, "local", "test", "test.html")
    out_local_report = fs::path(tmp, "local", "reports", "report.html")

    # test if some of the files have been added
    expect_true(fs::file_exists(out_local_html))
    expect_true(fs::file_exists(out_local_test))
    expect_true(fs::file_exists(out_local_report))

    # test if some of the files have been removed
    quietly_delete(tmp)
  }
)

test_that(
  "Able to apply rules from yaml on a file",
  {
    tmp = tmp_loc("test-ymlrules")
    output_dir = tmp_loc("output-dir")
    yml_file = fs::path(tmp, "_outputs.yml")

    #files for rendering exist
    fs::dir_create(tmp)
    fs::file_copy(test_path("data", "_outputs.yml"), tmp)
    expect_true(fs::file_exists(yml_file))

    suppressMessages({
      expect_true(epi_qmd(fs::path(tmp, "report.qmd")))
      expect_true(epi_rmd(fs::path(tmp, "report.Rmd")))
    })

    withr::with_dir(
      tmp,
      {
        epi_render(fs::path(tmp, "report.Rmd"), output_dir = output_dir, output_format = "pdf_document", quiet = TRUE)
        epi_render(fs::path(tmp, "report.qmd"), quiet = TRUE, output_dir = output_dir)
      }
    )

    out_local_pdf = fs::path(tmp, "local", "pdf", "report.pdf")
    out_local_report = fs::path(tmp, "local", "reports", "report.html")
    out_local_html = fs::path(tmp, "local", "html", "report.html")

    # test if some of the files have been added
    expect_true(fs::file_exists(out_local_pdf))
    expect_true(fs::file_exists(out_local_report))
    expect_true(fs::file_exists(out_local_html))
    expect_true(fs::file_exists(fs::path(output_dir, "report.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "report.pdf")))

    quietly_delete(tmp)
    quietly_delete(output_dir)
  }
)


test_that(
  "Able to apply rules from yaml on a mix of file and folders",
  {
    output_dir = tmp_loc("output-dir")
    tmp_rmd = tmp_loc("test-temp-rmd")
    tmp_qmd = tmp_loc("test-temp-qmd")
    tmp = tmp_loc("test-temp")

    suppressMessages({
      expect_true(epi_rmd(fs::path(tmp_rmd, "test-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp_qmd, "test-qmd.qmd")))
      expect_true(epi_rmd(fs::path(tmp_rmd, "report-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp_qmd, "report-qmd.qmd")))
    })

    fs::dir_create(tmp_rmd)
    fs::file_copy(test_path("data", "_outputs.yml"), tmp_rmd)

    fs::dir_create(tmp_qmd)
    fs::file_copy(test_path("data", "_outputs.yml"), tmp_qmd)

    fs::dir_create(tmp)

    mixed_els = c(tmp_rmd, fs::path(tmp_qmd, "test-qmd.qmd"), fs::path(tmp_qmd, "report-qmd.qmd"))

    withr::with_dir(
      tmp,
      epi_render(mixed_els, output_dir = output_dir, quiet = TRUE)
    )

    out_local_pdf = fs::path(tmp, "local", "pdf", "report-rmd.pdf")
    out_local_report = fs::path(tmp, "local", "reports", "report-qmd.html")
    out_local_html = fs::path(tmp, "local", "html", "report-rmd.html")

    # print(fs::dir_ls(tmp, recurse = TRUE))

    # test if some of the files have been added
    expect_true(fs::file_exists(out_local_pdf))
    expect_true(fs::file_exists(out_local_report))
    expect_true(fs::file_exists(out_local_html))
    expect_true(fs::file_exists(fs::path(output_dir, "test-qmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.pdf")))

    quietly_delete(tmp)
    quietly_delete(tmp_rmd)
    quietly_delete(tmp_qmd)
    quietly_delete(output_dir)
  }
)


test_that(
  "Able to apply rules from yaml on a mix of file and folders and remove rendering folders",
  {
    output_dir = tmp_loc("output-dir")
    tmp_rmd = tmp_loc("test-temp-rmd")
    tmp_qmd = tmp_loc("test-temp-qmd")
    tmp = tmp_loc("test-temp")

    suppressMessages({
      expect_true(epi_rmd(fs::path(tmp_rmd, "test-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp_qmd, "test-qmd.qmd")))
      expect_true(epi_rmd(fs::path(tmp_rmd, "report-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp_qmd, "report-qmd.qmd")))
    })

    fs::dir_create(tmp_rmd)
    fs::file_copy(test_path("data", "_outputs.yml"), tmp_rmd)

    fs::dir_create(tmp_qmd)
    fs::file_copy(test_path("data", "_outputs.yml"), tmp_qmd)

    fs::dir_create(tmp)

    mixed_els = c(tmp_rmd, fs::path(tmp_qmd, "test-qmd.qmd"), fs::path(tmp_qmd, "report-qmd.qmd"))

    withr::with_dir(
      tmp,
      epi_render(mixed_els, output_dir = output_dir, quiet = TRUE)
    )

    out_local_pdf = fs::path(tmp, "local", "pdf", "report-rmd.pdf")
    out_local_report = fs::path(tmp, "local", "reports", "report-qmd.html")
    out_local_html = fs::path(tmp, "local", "html", "report-rmd.html")

    print(fs::dir_ls(tmp, recurse = TRUE))

    # test if some of the files have been added
    expect_true(fs::file_exists(out_local_pdf))
    expect_true(fs::file_exists(out_local_report))
    expect_true(fs::file_exists(out_local_html))
    expect_false(fs::file_exists(fs::path(tmp_qmd, "test-qmd.html")))
    expect_false(fs::file_exists(fs::path(tmp_rmd, "test-rmd.pdf")))

    quietly_delete(tmp)
    quietly_delete(tmp_rmd)
    quietly_delete(tmp_qmd)
    quietly_delete(output_dir)
  }
)

