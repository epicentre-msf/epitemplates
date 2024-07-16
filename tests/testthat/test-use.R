
#--------------- using quarto documents--------------------

# test for creating a new qmd file
test_that(
  "downloading and creating quarto extension works",
  {

    tmp = tmp_loc("test-temp")

    # test that everything works fine
      expect_true(epi_qmd(fs::path(tmp, "test.qmd")))


    # test for existence of the extension folder
    ext_dir = fs::path(tmp, "_extensions")

      expect_true(fs::dir_exists(ext_dir))


    # test for existence of the test qmd file
    testfile = fs::path(tmp, "test.qmd")
    expect_true(fs::file_exists(testfile))


    quietly_delete(tmp)
  }
)

# test for adding a qmd file
test_that(
  "creating new quarto document in a non empty folder works",
  {
    tmp = tmp_loc("test-temp-full")


      epi_qmd(fs::path(tmp, "test-one.qmd"))
      epi_qmd(fs::path(tmp, "test-two.qmd"))


    test_two_file = fs::path(tmp, "test-two.qmd")
    expect_true(fs::file_exists(test_two_file))

    quietly_delete(tmp)
  }
  )

test_that(
  "overwriting existing quarto file generates an error",
  {
    tmp = tmp_loc("test-temp-error")

    epi_qmd(fs::path(tmp, "test-one.qmd"))


    expect_error(epi_qmd(fs::path(tmp, "test-one.qmd")))

    quietly_delete(tmp)
  }
)

test_that(
  "can create quarto file with unknown extension",
  {
    tmp = tmp_loc("test-temp-ext")

    epi_qmd(fs::path(tmp, "test-bad-ext.htp"))

    testfile = fs::path(tmp, "test-bad-ext.qmd")
    expect_true(fs::file_exists(testfile))

    quietly_delete(tmp)
  }
)


test_that(
  "can create quarto file with empty extension",
  {
    tmp = tmp_loc("test-temp-ext")
    epi_qmd(fs::path(tmp, "test-empt-ext"))

    testfile = fs::path(tmp, "test-empt-ext.qmd")
    expect_true(fs::file_exists(testfile))

    quietly_delete(tmp)
  }
)

#---- using rmarkdown documents ------------------------

test_that(
  "creating rmd document works",
  {
    tmp = tmp_loc("test-temp-rmd")
    ext_dir = fs::path(tmp, "assets")

    # test that everything works fine
    expect_true(epi_rmd(fs::path(tmp, "test.Rmd")))

    # test for existence of the extension folder
    expect_true(fs::dir_exists(ext_dir))

    # test for existence of the test qmd file
    testfile = fs::path(tmp, "test.Rmd")
    expect_true(fs::file_exists(testfile))

    quietly_delete(tmp)
  }
)

# test for adding a rmd file
test_that(
  "adding a new rmd document in a non empty folder works",
  {
    tmp = tmp_loc("test-temp-full")

    epi_rmd(fs::path(tmp, "test-one.Rmd"))
    epi_rmd(fs::path(tmp, "test-two.Rmd"))

    test_two_file = fs::path(tmp, "test-two.Rmd")
    expect_true(fs::file_exists(test_two_file))

    quietly_delete(tmp)
  }
)

test_that(
  "overwriting existing Rmd file generates an error",
  {
    tmp = tmp_loc("test-temp-error")
    epi_rmd(fs::path(tmp, "test-error.Rmd"))

    expect_error(epi_qmd(fs::path(tmp, "test-error.Rmd")))

    quietly_delete(tmp)
  }
)


test_that(
  "can create Rmd file with empty extension",
  {
    tmp = tmp_loc("test-temp-ext")
    epi_rmd(fs::path(tmp, "test-empt-ext"))

    testfile = fs::path(tmp, "test-empt-ext.Rmd")
    expect_true(fs::file_exists(testfile))

    quietly_delete(tmp)
  }
)



