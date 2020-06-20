#' read in the data from pld tables
#'
#' @param directory The location of the folder containing pld tables
#'
#' @return a dataframe containing data from the pld tables
#' @export
#'
#' @examples
bk_read_pld <- function(directory) {
  pld_csv <- fs::dir_ls(directory,
                        regexp = ".*(pld|PLD|AE).*csv"
  )

  pld_csv_names <- pld_csv %>%
    map(
      ~bk_list_names(.)
    ) %>%
    unlist %>%
    unique()
  pld_csv_names[274] <- "year"

  pld_df <- pld_csv %>%
    map(
      function(x) bk_read_and_bind(x = x, names_df = pld_csv_names)
    ) %>%
    bind_rows()

  return(pld_df)
}
