bk_list_names <- function(x) {
  vroom::vroom(x) %>%
    names()
}
