test_that("calculates first quartile correctly", {

  # Standard example
  expect_equal(
    calc_q1(c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)),
    2.25
  )

  # Odd number of observations
  expect_equal(calc_q1(c(1, 2, 3, 4, 5)), 2)

  # Even number of observations
  expect_equal(calc_q1(c(1, 2, 3, 4)), 1.75)

  # Unsorted values
  expect_equal(calc_q1(c(9, 1, 5, 3, 7)), 3)

  # Negative values
  expect_equal(calc_q1(c(-5, -10, -15)), -12.5)

  # Missing values
  expect_equal(calc_q1(c(1, 2, NA, 3)), 1.5)

  # Single observation
  expect_warning(calc_q1(5))

  # Empty vector
  expect_error(calc_q1(numeric(0)), "Input vector is empty.")

  # All missing values
  expect_error(
    calc_q1(c(NA_real_, NA_real_)),
    "Input contains only NA values."
  )

})
