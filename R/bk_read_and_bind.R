bk_read_and_bind <- function(x, names_df) {
  year <- x %>% # extract the year
    stringr::str_extract_all("\\d{2}", simplify = TRUE)
  year <- ifelse(dplyr::last(year) >= 89, # make the year four digits
                 stringr::str_c("19", dplyr::last(year)),
                 stringr::str_c("20", dplyr::last(year))
  )

  x <- vroom::vroom(x)
  x$year <- dplyr::last(year)


  y <- data.frame(matrix("", ncol = length(names_df), nrow = 0))

  colnames(y) <- names_df

  y <- y %>%
    mutate_all(., as.factor)

  x <- x %>%
    mutate_all(., as.factor)

  y <- bind_rows(y, x) %>%
    mutate_all(., as.factor)

}
