test_that("calculates median correctly", {

  # Numeric vectors
  expect_equal(calc_median(c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)),
               4.5)

  expect_equal(calc_median(c(1, 2, 3, 4, 5)),
               3)

  expect_equal(calc_median(c(10, 20, 30)),
               20)

  # Odd number of observations
  expect_equal(calc_median(c(1, 3, 5, 7, 9)),
               5)

  # Even number of observations
  expect_equal(calc_median(c(1, 2, 3, 4)),
               2.5)

  expect_equal(calc_median(c(10, 20, 30, 40)),
               25)

  # Unsorted vectors
  expect_equal(calc_median(c(9, 1, 5, 3, 7)),
               5)

  expect_equal(calc_median(c(8, 2, 6, 4)),
               5)

  # Negative values
  expect_equal(calc_median(c(-5, -10, -15)),
               -10)

  expect_equal(calc_median(c(-5, 5)),
               0)

  # Zero values
  expect_equal(calc_median(c(0, 0, 0)),
               0)

  expect_equal(calc_median(c(0, 10, 20)),
               10)

  # Decimal values
  expect_equal(calc_median(c(1.5, 2.5, 3.5)),
               2.5)

  expect_equal(calc_median(c(0.1, 0.2, 0.3, 0.4)),
               0.25)

  # Repeated values
  expect_equal(calc_median(c(2, 2, 2, 2, 2)),
               2)

  expect_equal(calc_median(c(1, 1, 2, 2)),
               1.5)

  # One numeric value
  expect_warning(
    expect_equal(calc_median(5), 5),
    "Input contains only one observation."
  )

  # NAs
  expect_equal(calc_median(c(1, 2, NA, 3)),
               2)

  expect_equal(calc_median(c(NA, 10, 20, NA)),
               15)

  # Invalid inputs
  expect_error(calc_median("hello"),
               "Input must be a numeric vector.")

  expect_error(calc_median(c("1", "2", "3")),
               "Input must be a numeric vector.")

  expect_error(calc_median(TRUE),
               "Input must be a numeric vector.")

  expect_error(calc_median(list(1, 2, 3)),
               "Input must be a numeric vector.")

  expect_error(calc_median(1 + 2i),
               "Input must be a numeric vector.")

  # Empty vector
  expect_error(calc_median(numeric(0)),
               "Input vector is empty.")

  # All missing values
  expect_error(calc_median(c(NA_real_, NA_real_, NA_real_)),
               "Input contains only NA values.")

  # Special numeric values
  expect_true(is.infinite(calc_median(c(Inf, 1))))

  expect_true(is.nan(calc_median(c(Inf, -Inf))))

})
