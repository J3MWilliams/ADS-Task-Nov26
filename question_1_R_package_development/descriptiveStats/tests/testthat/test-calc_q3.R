test_that("calculates first quartile correctly", {

  # Standard example
  expect_equal(
    calc_q3(c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)),
    5
  )

  # Odd number of observations
  expect_equal(calc_q3(c(1, 2, 3, 4, 5)),
               4)

  # Even number of observations
  expect_equal(calc_q3(c(1, 2, 3, 4)),
               3.25)

  # Unsorted values
  expect_equal(calc_q3(c(9, 1, 5, 3, 7)),
               7)

  # Negative values
  expect_equal(calc_q3(c(-5, -10, -15)),
               -7.5)

  # Missing values
  expect_equal(calc_q3(c(1, 2, NA, 3)),
               2.5)

  # Single observation
  expect_warning(calc_q3(5))

  # Empty vector
  expect_error(calc_q3(numeric(0)),
               "Input vector is empty.")

  # All missing values
  expect_error(
    calc_q3(c(NA_real_, NA_real_)),
    "Input contains only NA values."
  )

})
