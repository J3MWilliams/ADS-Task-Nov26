test_that("calculates interquartile range correctly", {

  # Numeric vectors
  expect_equal(
    calc_iqr(c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)),
    2.75
  )

  # Odd number of observations
  expect_equal(calc_iqr(c(1, 2, 3, 4, 5)), 2)

  # Even number of observations
  expect_equal(calc_iqr(c(1, 2, 3, 4)), 1.5)

  # Unsorted values
  expect_equal(calc_iqr(c(9, 1, 5, 3, 7)), 4)

  # Negative values
  expect_equal(calc_iqr(c(-5, -10, -15)), 5)

  # Missing values
  expect_equal(calc_iqr(c(1, 2, NA, 3)), 1)

  # Single observation
  expect_warning(calc_iqr(5))

  # Empty vector
  expect_error(
    calc_iqr(numeric(0)),
    "Input vector is empty."
  )

  # All missing values
  expect_error(
    calc_iqr(c(NA_real_, NA_real_)),
    "Input contains only NA values."
  )

})
