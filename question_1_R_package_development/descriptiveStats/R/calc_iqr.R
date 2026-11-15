#' Interquartile Range
#'
#' Vector sum divided by vector length
#' @param x A vector of numeric elements
#'
#' @return A numeric value.
#' @export
#'
#' @examples
#' data <- c(1,  2,  2,  3,  4,  5,  5,  5,  6,  10)
#' calc_iqr(data)      # 2.75
calc_iqr <- function(x) {

  # Quality Standards
  # Type
  if (!is.numeric(x) || is.complex(x)) {
    stop("Error: Input must be a numeric vector.")
  }

  # Empty vector
  if (length(x) == 0) {
    stop("Error: Input vector is empty.")
  }

  # Missing values?
  x <- x[!is.na(x)]

  # All values are missing?
  if (length(x) == 0) {
    stop("Error: Input contains only NA values.")
  }

  # Single value?
  if (length(x) == 1) {
    warning("Input contains only one observation.")
  }

  x <- sort(x)

  n <- length(x)

  # Calculate q1
  q1 <- 1 + (n - 1) * 0.25

  lwr <- floor(q1)
  upr <- ceiling(q1)

  q1 <- x[lwr] + (q1-lwr)*(x[upr] - x[lwr])

  # Calculate q3
  q3 <- 1 + (n - 1) * 0.75

  lwr <- floor(q3)
  upr <- ceiling(q3)

  q3 <- x[lwr] + (q3 - lwr) * (x[upr] - x[lwr])

  out <- q3 - q1

  return(out)
}
