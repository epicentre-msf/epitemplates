# tests for rendering the document
test_that(
  "Rendering unkown file extension generates an error",
  {
    skip_on_cran()

    tmp = tmp_loc("test-temp")
    testfile = fs::path(tmp, "test.tks")

    # test that everything works fine
    expect_true(epi_qmd(testfile))
    expect_error(epi_render(testfile))
    quietly_delete(tmp)
  }
)


test_that(
  "Can render qmd to the file repository",
  {
    skip_on_cran()

    tmp = tmp_loc("test-temp")
    testfile = fs::path(tmp, "test.qmd")

    expect_true(epi_qmd(testfile))

    epi_render(testfile, quiet = FALSE)
    outfile = fs::path(tmp, "test.html")
    # test that everything works fine
    expect_true(fs::file_exists(outfile))
    quietly_delete(tmp)
  }
)

test_that(
  "Can render rmd to the file repository",
  {
    skip_on_cran()

    tmp = tmp_loc("test-temp")
    testfile = fs::path(tmp, "test.Rmd")
    suppressMessages({
      ret = epi_rmd(testfile)
    })

    epi_render(testfile, quiet = TRUE)
    outfile = fs::path(tmp, "test.pdf")
    # test that everything works fine
    expect_true(ret)
    expect_true(fs::file_exists(outfile))
    quietly_delete(tmp)
  }
)

# rendering to output folder

test_that(
  "Can render qmd to a provided output repository",
  {
    skip_on_cran()

    tmp = tmp_loc("test-temp")
    output_dir = tmp_loc("output-dir")
    testfile = fs::path(tmp, "test.qmd")

    suppressMessages({
      ret = epi_qmd(testfile)
    })

    epi_render(testfile, output_dir = output_dir, quiet = TRUE)

    # test that everything works fine
    expect_true(ret)
    expect_true(fs::file_exists(fs::path(output_dir, "test.html")))
    expect_false(fs::file_exists(fs::path(output_dir, "test.pdf")))

    quietly_delete(tmp)
    quietly_delete(output_dir)
  }
)

test_that(
  "Can render Rmd to a provided output repository",
  {
    skip_on_cran()

    tmp = tmp_loc("test-temp")
    output_dir = tmp_loc("output-dir")
    testfile = fs::path(tmp, "test.Rmd")

    suppressMessages({
      ret = epi_rmd(testfile)
    })

    epi_render(testfile, output_dir = output_dir, quiet = TRUE)

    # test that everything works fine
    expect_true(ret)
    expect_true(fs::file_exists(fs::path(output_dir, "test.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "test.pdf")))
    expect_true(fs::file_exists(fs::path(output_dir, "test.docx")))

    quietly_delete(tmp)
    quietly_delete(output_dir)
  }
)

test_that(
  "Can render files in a directory",
  {
    skip_on_cran()

    tmp = tmp_loc("test-temp")
    output_dir = tmp_loc("output-dir")


    suppressMessages({
      expect_true(epi_rmd(fs::path(tmp, "test-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp, "test-qmd.qmd")))
      expect_true(epi_rmd(fs::path(tmp, "report-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp, "report-qmd.qmd")))
    })

    epi_render(tmp, output_dir = output_dir, quiet = TRUE)

    # test that test.rmd files have been saved to output_dir
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.pdf")))
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.docx")))

    # test that test.rmd files have been removed from tmp
    expect_false(fs::file_exists(fs::path(tmp, "test-rmd.html")))
    expect_false(fs::file_exists(fs::path(tmp, "test-rmd.pdf")))
    expect_false(fs::file_exists(fs::path(tmp, "test-rmd.docx")))

    # test that report.rmd have been saved to output_dir
    expect_true(fs::file_exists(fs::path(output_dir, "report-rmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "report-rmd.pdf")))
    expect_true(fs::file_exists(fs::path(output_dir, "report-rmd.docx")))

    # test that report output files have been removed from tmp
    expect_false(fs::file_exists(fs::path(tmp, "report-rmd.html")))
    expect_false(fs::file_exists(fs::path(tmp, "report-rmd.pdf")))
    expect_false(fs::file_exists(fs::path(tmp, "report-rmd.docx")))

    # test that test.qmd and report.qmd files have been saved to output_dir
    expect_true(fs::file_exists(fs::path(output_dir, "test-qmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "report-qmd.html")))

    # test that test.qmd and report.qmd files have been deleted from tmp
    expect_false(fs::file_exists(fs::path(tmp, "test-qmd.html")))
    expect_false(fs::file_exists(fs::path(tmp, "report-qmd.html")))


    quietly_delete(tmp)
    quietly_delete(output_dir)
  }
)



test_that(
  "Can render a mix of files and directories",
  {
    skip_on_cran()

    tmp_rmd = tmp_loc("test-temp-rmd")
    tmp_qmd = tmp_loc("test-temp-qmd")
    output_dir = tmp_loc("output-dir")

    suppressMessages({
      expect_true(epi_rmd(fs::path(tmp_rmd, "test-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp_qmd, "test-qmd.qmd")))
      expect_true(epi_rmd(fs::path(tmp_rmd, "report-rmd.Rmd")))
      expect_true(epi_qmd(fs::path(tmp_qmd, "report-qmd.qmd")))
    })

    mixed_els = c(tmp_rmd, fs::path(tmp_qmd, "test-qmd.qmd"), fs::path(tmp_qmd, "report-qmd.qmd"))
    epi_render(mixed_els, output_dir = output_dir, quiet = TRUE)

    # test that everything works fine
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.pdf")))
    expect_true(fs::file_exists(fs::path(output_dir, "test-rmd.docx")))

    expect_true(fs::file_exists(fs::path(output_dir, "report-rmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "report-rmd.pdf")))
    expect_true(fs::file_exists(fs::path(output_dir, "report-rmd.docx")))

    expect_true(fs::file_exists(fs::path(output_dir, "test-qmd.html")))
    expect_true(fs::file_exists(fs::path(output_dir, "report-qmd.html")))

    quietly_delete(tmp_rmd)
    quietly_delete(tmp_qmd)
    quietly_delete(output_dir)
  }
)
