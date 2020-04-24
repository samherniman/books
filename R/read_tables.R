samherniman [at] posteo [dot] net
# specify data locations --------------------------------------------------

library(dplyr)
library(purrr)
# purrr::reduce(list_of_dfs, full_join, by = "id_column_name")

out_csv <- fs::dir_ls(here::here("sample"),
                      regexp = ".*(o|O)(ut|UT).*csv"
)

# pld_csv <- fs::dir_ls(here::here("data"),
#   regexp = ".*(pld|PLD|AE).*csv"
# )
#
# state_csv <- fs::dir_ls(here::here("data"),
#   regexp = ".*((S|s)tate|sum|SUM).*csv"
# )


list_names <- function(x) {
  vroom::vroom(x) %>%
    names()
}

out_csv_names <- out_csv %>%
  map(
  ~list_names(.)
  ) %>%
  unlist %>%
  unique()
out_csv_names[65] <- "year"

read_and_bind <- function(x, names_df) {
  year <- x %>% # extract the year
    stringr::str_extract_all("\\d{2}", simplify = TRUE)
  year <- ifelse(dplyr::last(year) >= 89, # make the year four digits
                 stringr::str_c("19", dplyr::last(year)),
                 stringr::str_c("20", dplyr::last(year))
  )

  x <- vroom::vroom(x)
  x$year <- dplyr::last(year)

  names_df <- tibble(out_csv_names) %>%
    mutate_all(., as.factor)

  y <- bind_rows(names_df, x)%>%
    mutate_all(., as.factor)



    # vctrs::vec_rbind(names_df, x, .ptype = x) %>%
    # as_tibble()
}

out_df <- out_csv %>%
  map(
    function(x) read_and_bind(x = x, names_df = out_csv_names)
  ) %>%
  bind_rows()


# read data in and combine ------------------------------------------------

read_and_combine <- function(csvs) {
  x <- vroom::vroom(csvs) # read in a csv
  year <- csvs %>% # extract the year
    stringr::str_extract_all("\\d{2}", simplify = TRUE)
  year <- ifelse(dplyr::last(year) >= 89, # make the year four digits
    stringr::str_c("19", dplyr::last(year)),
    stringr::str_c("20", dplyr::last(year))
  )
  x$year <- dplyr::last(year)
  x$unique_id <- stringr::str_c(x[,2], x$year)

  # x <- x %>%
  #   tidyr::pivot_longer(-c(year, unique_id, ))
    # tidyr::gather(-c(year, unique_id), key = "metric", value = "value")
  # %>%
  #   tibble::rowid_to_column()
  tibble(x)
}

read_and_combine <- function(csvs) {
  x <- vroom::vroom(csvs) # read in a csv


  # year <- csvs %>% # extract the year
  #   stringr::str_extract_all("\\d{2}", simplify = TRUE)
  # year <- ifelse(dplyr::last(year) >= 89, # make the year four digits
  #                stringr::str_c("19", dplyr::last(year)),
  #                stringr::str_c("20", dplyr::last(year))
  # )
  # x$year <- dplyr::last(year)
  # x$unique_id <- stringr::str_c(x[,2], x$year)
  #
  # # x <- x %>%
  # #   tidyr::pivot_longer(-c(year, unique_id, ))
  # # tidyr::gather(-c(year, unique_id), key = "metric", value = "value")
  # # %>%
  # #   tibble::rowid_to_column()
  tibble(x)
}

read_and_combine <- function(csvs) {
  x <- vroom::vroom(csvs) # read in a csv


  year <- csvs %>% # extract the year
    stringr::str_extract_all("\\d{2}", simplify = TRUE)
  year <- ifelse(dplyr::last(year) >= 89, # make the year four digits
                 stringr::str_c("19", dplyr::last(year)),
                 stringr::str_c("20", dplyr::last(year))
  )
  x$year <- dplyr::last(year)
  x$unique_id <- stringr::str_c(x[,2], x$year)

  # x <- x %>%
  #   tidyr::pivot_longer(-c(year, unique_id, ))
  # tidyr::gather(-c(year, unique_id), key = "metric", value = "value")
  # %>%
  #   tibble::rowid_to_column()
  tibble(x)
}

out_all <- out_csv %>%
  purrr::map(read_and_combine) #%>%
  dplyr::bind_rows() #%>%
  # dplyr::mutate(
  #   metric = dplyr::recode(
  #     metric,
  #     LIBNAME = "lib_name",
  #     LIB_NAME = "lib_name",
  #     PHONE = "phone",
  #     LIB_PHONE = "phone",
  #     LIB_CITY = "city",
  #     CITY = "city",
  #     LIB_ZIP = "zip",
  #     ZIP = "zip",
  #     LIB_ZIP4 = "zip4",
  #     ZIP4 = "zip4",
  #     LIB_CNTY = "county",
  #     C_OUT_TY = "county_type",
  #     C_OUT_TYP = "county_type",
  #     YR_SUM = "YR",
  #     STABR = "state_abbreviation"
  #   )
  # )

out_tbl <- out_all %>%
  tibble(libs = .) %>%
  tidyr::unnest_longer(libs)

test <- out_all %>%
  tibble::rowid_to_column() %>%
  tidyr::spread(key = metric, value = value, -c(uniquie_id))



# sandbox -----------------------------------------------------------------

out_all %>%
  group_by(metric) %>%
  skimr::skim()
