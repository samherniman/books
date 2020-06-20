#' read in the data from outlet tables
#'
#' @details The outlet files contain information about public library service outlets (central,  branch,  bookmobile,  and  books-by-mail-only  outlets)
#' @param directory The location of the folder containing out tables
#'
#' @return a dataframe containing data from the out tables
#' @export
#'
#' @examples
bk_read_out <- function(directory) {
  out_csv <- fs::dir_ls(directory,
                        regexp = ".*(o|O)(ut|UT).*csv"
  )

  out_csv_names <- out_csv %>%
    map(
      ~bk_list_names(.)
    ) %>%
    unlist %>%
    unique()

  out_csv_names[73] <- "year"

  out_df <- out_csv %>%
    map(
      function(x) bk_read_and_bind(x = x, names_df = out_csv_names)
    ) %>%
    bind_rows()

  return(out_df)
}
