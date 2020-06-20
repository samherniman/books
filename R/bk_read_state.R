#' read in the data from state tables
#'
#' @param directory The location of the folder containing state tables
#'
#' @return a dataframe containing data from the state tables
#' @export
#'
#' @examples
bk_read_state <- function(directory) {
  state_csv <- fs::dir_ls(directory,
                          regexp = ".*((S|s)tate|sum|SUM).*csv"
  )

  state_csv_names <- state_csv %>%
    map(
      ~bk_list_names(.)
    ) %>%
    unlist %>%
    unique()
  state_csv_names[221] <- "year"

  state_df <- state_csv %>%
    map(
      function(x) bk_read_and_bind(x = x, names_df = state_csv_names)
    ) %>%
    bind_rows()

  return(state_df)
}
