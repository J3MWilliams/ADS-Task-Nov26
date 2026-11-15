#' Mode
#'
#' Calculate the mode (most frequent) value(s) from a sample
#' @param x A vector of numeric elements
#'
#' @return Single mode: Numeric Value. Multiple modes: Vector of numeric elements.
#' Returns "No mode" if no repeated value exists.
#' @export
#'
#' @examples
#' data <- c(1,  2,  2,  3,  4,  5,  5,  5,  6,  10)
#' calc_mode(data)     # 5
calc_mode <- function(x) {

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
    return(x)
  }

  if (is.numeric(x)) {

    # Get frequencies
    freq <- table(x)

    # Get most frequent obs
    max_freq <- max(freq)

    all_modes <- as.numeric(names(freq)[freq == max_freq])

    # No mode
    if (max_freq == 1) {
      out <- "No mode"

      # Multiple modes
    } else if (length(all_modes) > 1) {
      out <- all_modes

      # Single mode
    } else {
      out <- all_modes
    }

  } else {
    warning("Numeric values only.")
  }
  return(out)
}
