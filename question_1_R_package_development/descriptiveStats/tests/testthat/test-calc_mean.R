test_that("calculates arithmetic mean correctly", {

  # Numeric vectors
  expect_equal(calc_mean(c(1,  2,  2,  3,  4,  5,  5,  5,  6,  10)),
               4.3)
  expect_equal(calc_mean(c(1, 2, 3, 4, 5)),
               3)
  expect_equal(calc_mean(c(10, 20, 30)),
               20)

  # Negative values
  expect_equal(calc_mean(c(-5, -10, -15)),
               -10)
  expect_equal(calc_mean(c(-5, 5)),
               0)

  # Zero values
  expect_equal(calc_mean(c(0, 0, 0)),
               0)
  expect_equal(calc_mean(c(0, 10, 20)),
               10)

  # Decimals
  expect_equal(calc_mean(c(1.5, 2.5, 3.5)),
               2.5)
  expect_equal(calc_mean(c(0.1, 0.2, 0.3)),
               0.2)

  # One numeric value
  expect_warning(expect_equal(calc_mean(5), 5),
                 "Input contains only one observation.")

  # NAs
  expect_equal(calc_mean(c(1, 2, NA, 3)),
               2)
  expect_equal(calc_mean(c(NA, 10, 20, NA)),
               15)

  # Invalid inputs
  expect_error(calc_mean("hello"),
               "Input must be a numeric vector.")

  expect_error(calc_mean(c("1", "2", "3")),
               "Input must be a numeric vector.")

  expect_error(calc_mean(TRUE),
               "Input must be a numeric vector.")

  expect_error(calc_mean(list(1, 2, 3)),
               "Input must be a numeric vector.")

  expect_error(calc_mean(1 + 2i),
               "Input must be a numeric vector.")

  # Empty vector
  expect_error(calc_mean(numeric(0)),
               "Input vector is empty.")

  # All missing values
  expect_error(calc_mean(c(NA, NA, NA)),
               "Error: Input contains only NA values.")

  # Special numeric values
  expect_true(is.infinite(calc_mean(c(Inf, 1))))
  expect_true(is.nan(calc_mean(c(Inf, -Inf))))
})
