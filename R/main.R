
construct_count_prefix <- function(dir, suffix) {
  if (stringr::str_detect(suffix, "R$")) {
    file_has_extension <- stringr::str_detect(fs::dir_ls(dir), "\\.[Rr]$")
  } else if (stringr::str_detect(suffix, "[Rr][Mm][Dd]$")) {
    file_has_extension <- stringr::str_detect(fs::dir_ls(dir), "\\.[Rr][Mm][Dd]$")
  } else if (stringr::str_detect(suffix, "[Qq][Mm][Dd]$")) {
    file_has_extension <- stringr::str_detect(fs::dir_ls(dir), "\\.[Qq][Mm][Dd]$")
  } else if (stringr::str_detect(suffix, "py")) {
    file_has_extension <- stringr::str_detect(fs::dir_ls(dir), "\\.py$")
  } else {
    stop(stringr::str_glue("Unknown extension: {suffix}"))
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

create_file <- function(
    name,
    prefix_by,
    suffix,
    directory = NULL,
    content = "",
    start_line = 1,
    proj_path = NULL,
    open = NULL
  ) {
  if (missing(proj_path)) proj_path <- here::here()
  if (missing(open)) open <- rlang::is_interactive()
  if (missing(directory)) directory <- suffix

  dir <- fs::path(proj_path, directory)
  fs::dir_create(dir)

  prefix <- construct_prefix(dir, prefix_by = prefix_by, suffix = suffix)
  filename <- construct_filename(prefix, name, suffix = suffix)
  filepath <- fs::path(dir, filename)

  check_filepath(filepath)

  filepath <- fs::path_expand(filepath)
  fs::file_create(filepath)
  if (any(content != "")) {
    readr::write_lines(content, filepath)
  }

  if (!open) {
    return(invisible(filepath))
  }

  if (rstudioapi::hasFun("navigateToFile")) {
    rstudioapi::navigateToFile(filepath, line = start_line)
  }

  invisible(filepath)
}

init_r <- function() {
  if (!getOption("organizr.r.init_with_date", default = TRUE)) {
    return()
  }
  fmt <- getOption("organizr.r.date_format", default = "%Y-%m-%d %H:%M")
  now <- Sys.time()
  timestamp <- strftime(now, fmt)
  content <- paste0("# Created: ", timestamp, " by {organizr}", "\n")
  list(content = content, start_line = 3)
}

init_py <- function() {
  if (!getOption("organizr.py.init_with_date", default = TRUE)) {
    return()
  }
  fmt <- getOption("organizr.py.date_format", default = "%Y-%m-%d %H:%M")
  now <- Sys.time()
  timestamp <- strftime(now, fmt)
  content <- paste0("# Created: ", timestamp, " by {organizr}", "\n")
  list(content = content, start_line = 3)
}

init_qmd <- function(name) {
  title <- paste("title:", name)
  output <- paste("format:", "html")

  content <- c("---", title, output, "---")

  list(content = content, start_line = 5)
}

init_rmd <- function(name) {
  title <- paste("title:", name)
  output <- paste("output:", "html_document")

  content <- c("---", title, output, "---")

  list(content = content, start_line = 5)
}

#' Quickly create files with consistent prefixes.
#'
#' Details go here.
#'
#' @param name A character string; name of the script.
#' @param prefix_by Which prefix to use. Can be `"count"` or `"date"`.
#' @param proj_path Project path.
#' @param open If `TRUE`, tries to open the file with RStudio after creation.
#'
#' @description
#' `r()` creates an R script.
#'
#' `rmd()` creates an Rmarkdown document.
#'
#' `qmd()` creates a Quarto document.
#'
#' @returns The filepath as a character string.
#'
#' @export
r <- function(name, prefix_by = c("count", "date"), proj_path = here::here(), open = rlang::is_interactive()) {
  prefix_by <- match.arg(prefix_by)
  content <- init_r()
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "R",
    directory = getOption("organizr.r.directory", default = "R"),
    content = content$content,
    start_line = content$start_line,
    proj_path = proj_path,
    open = open
  )

  invisible(filepath)
}

#' @export
#' @rdname r
qmd <- function(name, prefix_by = c("count", "date"), proj_path = here::here(), open = rlang::is_interactive()) {
  prefix_by <- match.arg(prefix_by)
  content <- init_qmd(name)
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "qmd",
    directory = getOption("organizr.qmd.directory", default = "qmd"),
    content = content$content,
    start_line = content$start_line,
    proj_path = proj_path,
    open = open
  )
  invisible(filepath)
}

#' @export
#' @rdname r
rmd <- function(name, prefix_by = c("count", "date"), proj_path = here::here(), open = rlang::is_interactive()) {
  prefix_by <- match.arg(prefix_by)
  content <- init_rmd(name)
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "rmd",
    directory = getOption("organizr.rmd.directory", default = "rmd"),
    content = content$content,
    start_line = content$start_line,
    proj_path = proj_path,
    open = open
  )
  invisible(filepath)
}


#' @export
#' @rdname r
py <- function(name, prefix_by = c("count", "date"), proj_path = here::here(), open = rlang::is_interactive()) {
  prefix_by <- match.arg(prefix_by)
  content <- init_py()
  filepath <- create_file(
    name,
    prefix_by,
    suffix = "py",
    directory = getOption("organizr.py.directory", default = "py"),
    content = content$content,
    start_line = content$start_line,
    proj_path = proj_path,
    open = open
  )
  invisible(filepath)
}
