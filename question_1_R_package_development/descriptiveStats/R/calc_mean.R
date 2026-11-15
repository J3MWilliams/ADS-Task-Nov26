#' Arithmetic mean
#'
#' Vector sum divided by vector length
#'
#' @param x A vector of numeric elements
#'
#' @return A numeric value.
#' @export
#'
#' @examples
#' data <- c(1,  2,  2,  3,  4,  5,  5,  5,  6,  10)
#' calc_mean(data)     # 4.3
calc_mean <- function(x) {


  # Quality Standards
  # Type
  if (!is.numeric(x) || is.complex(x)) {
    if (!(is.logical(x) && all(is.na(x)))) {
      stop("Error: Input must be a numeric vector.")
    }
  }

  # Empty vector
  if (length(x) == 0) {
    stop("Error: Input vector is empty.")
  }

  # Missing values? Remove
  x <- x[!is.na(x)]

  # All values are NAs and have been removed
  if (length(x) == 0) {
    stop("Error: Input contains only NA values.")
  }

  # Single value?
  if (length(x) == 1) {
    warning("Input contains only one observation.")
  }

  out <- sum(x)/length(x)

  return(out)
}
