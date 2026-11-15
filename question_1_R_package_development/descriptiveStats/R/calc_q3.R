#' Third Quartile
#'
#'
#' @param x A vector of numeric elements
#'
#' @return A numeric value.
#' @export
#'
#' @examples
#' data <- c(1,  2,  2,  3,  4,  5,  5,  5,  6,  10)
#' calc_q1(data)       # 2.5
#' calc_q3(data)       # 3.5
#' calc_iqr(data)      # 3
calc_q3 <- function(x) {

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

  q3 <- 1 + (n - 1) * 0.75

  lwr <- floor(q3)
  upr <- ceiling(q3)

  out <- x[lwr] + (q3 - lwr) * (x[upr] - x[lwr])

  return(out)
}
