
construct_count_prefix <- function(dir, suffix) {
  if (stringr::str_detect(suffix, "R$")) {
    file_has_extension <- stringr::str_detect(list.files(dir), "\\.[Rr]$")
  } else if (stringr::str_detect(suffix, "[Rr][Mm][Dd]$")) {
    file_has_extension <- stringr::str_detect(list.files(dir), "\\.[Rr][Mm][Dd]$")
  } else if (stringr::str_detect(suffix, "[Qq][Mm][Dd]$")) {
    file_has_extension <- stringr::str_detect(list.files(dir), "\\.[Qq][Mm][Dd]$")
  }

  pad <- getOption("organizr.padding", default = 3)
  nfiles <- sum(file_has_extension)
  prefix <- sprintf(stringr::str_glue("%0{pad}d"), nfiles + 1)
  prefix
}

construct_date_prefix <- function(fmt) {
  now <- Sys.time()
  prefix <- strftime(now, fmt)

  prefix
}

construct_filename <- function(prefix, name, suffix) {
  delim <- getOption("organizr.prefix_delim", default = "_")
  name <- paste(prefix, name, sep = delim)

  suffix_starts_with_dot <- stringr::str_detect(suffix, "^\\.")
  if (suffix_starts_with_dot) stop(paste("Invalid suffix:", suffix))

  pattern <- stringr::str_glue("\\.{suffix}$")
  has_suffix <- stringr::str_detect(name, pattern)
  if (!has_suffix) {
    name <- stringr::str_glue("{name}.{suffix}")
  }

  name
}

construct_prefix <- function(dir, prefix_by, suffix) {
  if (is.null(prefix_by)) {
    prefix_by <- getOption("organizr.prefix_by", default = prefix_by)
  }

  if (prefix_by == "count") {
    name_prefix <- construct_count_prefix(dir, suffix)
  } else if (prefix_by == "date") {
    fmt <- getOption("organizr.prefix_date_format", default = "%Y-%m-%d")
    name_prefix <- construct_date_prefix(fmt)
  } else {
    msg <- stringr::str_glue("Unrecognized value '{prefix_by}' for argument prefix_by.")
    stop(msg)
  }

  name_prefix
}

check_filepath <- function(path) {
  if (file.exists(path)) {
    msg <- stringr::str_glue("The file '{path}' already exists.")
    stop(msg)
  }
}

create_file <- function(name, prefix_by, suffix, content = "", start_line = 1) {
  dir <- usethis::proj_path(suffix)

  prefix <- construct_prefix(dir, prefix_by = prefix_by, suffix = suffix)
  filename <- construct_filename(prefix, name, suffix = suffix)
  filepath <- usethis::proj_path(suffix, filename)

  check_filepath(filepath)

  filepath <- fs::path_expand(filepath)
  dir <- fs::path_dir(filepath)
  fs::dir_create(dir)
  fs::file_create(filepath)
  if (!is.null(content)) {
    readr::write_lines(content, filepath)
  }

  rstudioapi::navigateToFile(filepath, line = start_line)
  filepath
}

init_r <- function() {
  if (!getOption("organizr.r.init_with_date", default = TRUE)) {
    return()
  }
  fmt <- getOption("organizr.r.date_format", default = "%Y-%m-%d %H:%M")
  now <- Sys.time()
  timestamp <- strftime(now, fmt)
  content <- paste0("# Created: ", timestamp, " by {organizr}", "\n")
  list(content=content, start_line=3)
}

init_qmd <- function(name) {

  title <- paste("title:", name)
  output <- paste("format:", "html")

  content <- c("---", title, output, "---")

  list(content=content, start_line=5)
}


init_rmd <- function(name) {

  title <- paste("title:", name)
  output <- paste("output:", "html_document")

  content <- c("---", title, output, "---")

  list(content=content, start_line=5)
}


#' Create files.
#'
#' @param name A character string; name of the script.
#' @param prefix_by Which prefix to use.
#'
#' @description
#' `r()` creates an R script.
#'
#' `rmd()` creates an Rmarkdown document.
#'
#' `qmd()` creates a Quarto document.
#'
#' @export
r <- function(name, prefix_by = c("count", "date")) {
  prefix_by <- match.arg(prefix_by)
  content <- init_r()
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "R",
    content = content$content,
    start_line = content$start_line
  )
}

#' @export
#' @rdname r
qmd <- function(name, prefix_by = c("count", "date")) {
  prefix_by <- match.arg(prefix_by)
  content <- init_qmd(name)
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "qmd",
    content = content$content,
    start_line = content$start_line
  )
}

#' @export
#' @rdname r
rmd <- function(name, prefix_by = c("count", "date")) {
  prefix_by <- match.arg(prefix_by)
  content <- init_rmd(name)
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "rmd",
    content = content$content,
    start_line = content$start_line
  )
}
