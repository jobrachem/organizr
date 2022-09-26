test_that("Count prefix works", {
  tmp <- fs::path_temp()
  r("test", proj_path = tmp, open = FALSE)
  qmd("test", proj_path = tmp, open = FALSE)
  rmd("test", proj_path = tmp, open = FALSE)

  r_files <- stringr::str_detect(fs::dir_ls(fs::path(tmp, "R")), "\\.[Rr]$")
  qmd_files <- stringr::str_detect(fs::dir_ls(fs::path(tmp, "qmd")), "\\.[Qq][Mm][Dd]$")
  rmd_files <- stringr::str_detect(fs::dir_ls(fs::path(tmp, "rmd")), "\\.[Rr][Mm][Dd]$")
  files <- list(r_files, qmd_files, rmd_files)
  dirs <- c("R", "qmd", "rmd")

  for (i in seq_along(files)) {
    nfiles <- sum(files[[i]])
    prefix <- sprintf(stringr::str_glue("%03d"), nfiles + 1)
    suffix <- dirs[i]
    path <- fs::path(tmp, suffix)
    expect_equal(prefix, construct_count_prefix(path, suffix))
  }
})

test_that("Date prefix works", {
  now <- Sys.time()
  prefix <- strftime(now, "%Y-%m-%d")

  expect_equal(prefix, construct_date_prefix("%Y-%m-%d"))
})


test_that("File creation with count prefix works", {
  tmp <- fs::path_temp()
  path <- fs::path(tmp, "R")
  prefix <- construct_count_prefix(path, "R")
  fp <- create_file("test", prefix = "count", suffix = "R", proj_path = tmp, open = FALSE)

  expect_true(stringr::str_starts(fs::path_file(fp), prefix))

  prefix_after <- construct_count_prefix(path, "R")
  expect_true(!stringr::str_starts(fs::path_file(fp), prefix_after))
})

test_that("File creation with date prefix works", {
  tmp <- fs::path_temp()
  path <- fs::path(tmp, "R")
  prefix <- construct_date_prefix("%Y-%m-%d")

  fp <- create_file("test", prefix = "date", suffix = "R", proj_path = tmp, open = FALSE)
  expect_true(stringr::str_starts(fs::path_file(fp), prefix))

  expect_error(
    create_file("test", prefix = "date", suffix = "R", proj_path = tmp, open = FALSE)
  )
})

test_that("R file creation works.", {
  tmp <- fs::path_temp()
  fp <- r("test", proj_path = tmp, open = FALSE)
  dir <- fs::path_dir(fp)

  expect_true(fs::file_exists(fp))
  expect_true(stringr::str_detect(dir, "R$"))
})

test_that("R file timestamp works.", {
  tmp <- fs::path_temp()
  fp <- r("test", proj_path = tmp, open = FALSE)
  content <- readr::read_lines(fp, n_max = 1)

  expect_true(stringr::str_detect(content, "^# Created:"))
  expect_true(stringr::str_detect(content, "\\{organizr\\}$"))
})


test_that("QMD file creation works.", {
  tmp <- fs::path_temp()
  fp <- qmd("test", proj_path = tmp, open = FALSE)
  dir <- fs::path_dir(fp)

  expect_true(fs::file_exists(fp))
  expect_true(stringr::str_detect(dir, "qmd$"))
})

test_that("QMD file content works.", {
  tmp <- fs::path_temp()
  fp <- qmd("test", proj_path = tmp, open = FALSE)
  content <- readr::read_lines(fp, n_max = 4)

  expect_true(stringr::str_detect(content[1], "---"))
  expect_true(stringr::str_detect(content[2], "^title:"))
  expect_true(stringr::str_detect(content[3], "^format: html"))
  expect_true(stringr::str_detect(content[4], "---"))
})

test_that("RMD file creation works.", {
  tmp <- fs::path_temp()
  fp <- rmd("test", proj_path = tmp, open = FALSE)
  dir <- fs::path_dir(fp)

  expect_true(fs::file_exists(fp))
  expect_true(stringr::str_detect(dir, "rmd$"))
})

test_that("RMD file content works.", {
  tmp <- fs::path_temp() |> fs::path_abs()
  fp <- rmd("test", proj_path = tmp, open = FALSE)
  content <- readr::read_lines(fp, n_max = 4)

  expect_true(stringr::str_detect(content[1], "---"))
  expect_true(stringr::str_detect(content[2], "^title:"))
  expect_true(stringr::str_detect(content[3], "^output: html_document"))
  expect_true(stringr::str_detect(content[4], "---"))
})


