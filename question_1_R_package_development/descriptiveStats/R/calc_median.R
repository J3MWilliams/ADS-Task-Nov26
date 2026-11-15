#' Median
#'
#' Compute the sample median.
#' @param x A vector of numeric elements
#'
#' @return A numeric value.
#' @export
#'
#' @examples
#' data <- c(1,  2,  2,  3,  4,  5,  5,  5,  6,  10)
#' calc_median(data)   # 4.5
calc_median <- function(x) {

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

  # Calculate median = middle value of vector
  x <- sort(x)

  n <- length(x)

  if (n %% 2 == 0) {
    out <- (x[n/2] +x[n/2 +1]) / 2
  } else {
    out <- x[(n+1)/2]
  }

  return(out)
}
