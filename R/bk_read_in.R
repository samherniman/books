bk_read_in <- function() {
  vroom::vroom(here::here("data", "derived_data", "out_df.csv")) %>%
    dplyr::select(
      state_abbreviation,
      libid,
      outlet_square_feet,
      hours_per_year,
      weeks_open_per_year,
      longitude,
      latitude,
      county_population,
      lib_name,
      number_of_bookmobiles,
      year_submission,
      outlet_type,
      address_cat
    ) %>%
    dplyr::group_by(lib_name) %>%
    dplyr::slice_max(year_submission, n = 1)
}
