test_that("calculates mode correctly", {

  # Numeric vectors
  expect_equal(calc_mode(c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)),
               5)

  expect_equal(calc_mode(c(1, 1, 2, 3, 4)),
               1)

  expect_equal(calc_mode(c(10, 20, 20, 30, 40)),
               20)

  # Multiple modes
  expect_equal(calc_mode(c(1, 1, 2, 2, 3)),
               c(1, 2))

  expect_equal(calc_mode(c(1, 1, 2, 2, 3, 3)),
               c(1, 2, 3))

  # No mode
  expect_equal(calc_mode(c(1, 2, 3, 4, 5)),
               "No mode")

  expect_equal(calc_mode(c(10, 20, 30)),
               "No mode")

  # Unsorted vectors
  expect_equal(calc_mode(c(5, 2, 5, 1, 5, 2)),
               5)

  expect_equal(calc_mode(c(3, 1, 2, 1, 2)),
               c(1, 2))

  # Negative values
  expect_equal(calc_mode(c(-5, -5, -10, -15)),
               -5)

  expect_equal(calc_mode(c(-1, -1, -2, -2)),
               c(-2, -1))

  # Zero values
  expect_equal(calc_mode(c(0, 0, 1, 2)),
               0)

  expect_equal(calc_mode(c(0, 0, 1, 1)),
               c(0, 1))

  # Decimal values
  expect_equal(calc_mode(c(1.5, 1.5, 2.5, 3.5)),
               1.5)

  expect_equal(calc_mode(c(0.1, 0.1, 0.2, 0.2)),
               c(0.1, 0.2))

  # Repeated values
  expect_equal(calc_mode(c(2, 2, 2, 2, 2)),
               2)

  expect_equal(calc_mode(c(1, 1, 2, 2, 3, 3, 4)),
               c(1, 2, 3))

  # One numeric value
  expect_warning(
    expect_equal(calc_mode(5), 5),
    "Input contains only one observation."
  )

  # NAs
  expect_equal(calc_mode(c(1, 2, NA, 2, 3)),
               2)

  expect_equal(calc_mode(c(NA, 10, 10, 20, NA)),
               10)

  # Missing values with multiple modes
  expect_equal(calc_mode(c(1, 1, 2, 2, NA)),
               c(1, 2))

  # Invalid inputs
  expect_error(calc_mode("hello"),
               "Input must be a numeric vector.")

  expect_error(calc_mode(c("1", "2", "3")),
               "Input must be a numeric vector.")

  expect_error(calc_mode(TRUE),
               "Input must be a numeric vector.")

  expect_error(calc_mode(list(1, 2, 3)),
               "Input must be a numeric vector.")

  expect_error(calc_mode(1 + 2i),
               "Input must be a numeric vector.")

  # Empty vector
  expect_error(calc_mode(numeric(0)),
               "Input vector is empty.")

  # All missing values
  expect_error(calc_mode(c(NA_real_, NA_real_, NA_real_)),
               "Input contains only NA values.")

  # Special numeric values
  expect_equal(calc_mode(c(Inf, 1, 1)),
               1)

})
