samherniman [at] posteo [dot] net
# specify data locations --------------------------------------------------

library(dplyr)
library(purrr)
# purrr::reduce(list_of_dfs, full_join, by = "id_column_name")

out_csv <- fs::dir_ls(here::here("data"),
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
out_csv_names[73] <- "year"

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


