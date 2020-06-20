library(rvest)
libraries <- read_html("https://www.imls.gov/research-evaluation/data-collection/public-libraries-survey")
csvs <- html_nodes(libraries, xpath = '//td[(((count(preceding-sibling::*) + 1) = 2) and parent::*)]//*[(((count(preceding-sibling::*) + 1) = 1) and parent::*)] | //*[(@id = "content")]//li[(((count(preceding-sibling::*) + 1) = 1) and parent::*)]//*[contains(concat( " ", @class, " " ), concat( " ", "tabstop-processed", " " )) and (((count(preceding-sibling::*) + 1) = 1) and parent::*)]')

