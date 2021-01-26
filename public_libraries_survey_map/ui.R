
library(shiny)
library(leaflet)
library(dplyr)
library(leaflet.extras)

# data <- bk_read_in()

# Define UI for application
ui <- fluidPage(
    mainPanel(
        leafletOutput(outputId = "mymap"),
        absolutePanel(top = 60, left = 20,
                      checkboxInput("markers", "State", FALSE),
                      checkboxInput("heat", "Heatmap", FALSE)
        )
    ))
