

library(shiny)
data <- bk_read_in() %>%
    # tidyr::drop_na()
    dplyr::filter(!is.na(latitude))

server <- function(input, output, session) {

    # define colour pals
    pal <- colorNumeric(
        palette = "inferno", reverse = TRUE,
            # c('gold', 'orange', 'dark orange', 'orange red', 'red', 'dark red'),
        domain = data$hours_per_year)

    pal2 <- colorFactor(
        palette = c('blue', 'yellow', 'red'),
        domain = data$state_abbreviation
    )

    #create the map
    output$mymap <- renderLeaflet({
        leaflet(data) %>%
            setView(lng = -98.55, lat = 38.5, zoom = 4)  %>% # setting the view over ~ center of North America
            addTiles() %>%
            addCircles(
                data = data,
                lat = ~ latitude,
                lng = ~ longitude,
                weight = 1,
                radius = ~hours_per_year*2,
                popup = ~as.character(hours_per_year),
                label = ~as.character(paste0("Hours per year: ", sep = " ", hours_per_year)),
                color = ~pal(hours_per_year), fillOpacity = 0.5)
    })

    # observe boxes make checkboxes

    observe({
        proxy <- leafletProxy("mymap", data = data)
        proxy %>% clearMarkers()
        if (input$markers) {
            proxy %>% addCircleMarkers(
                stroke = FALSE,
                color = ~pal2(state_abbreviation),
                fillOpacity = 0.2,
                label = ~as.character(paste0("State: ", sep = " ", state_abbreviation))
                ) %>%
                addLegend("bottomright",
                          pal = pal2,
                          values = data$state_abbreviation,
                          title = "State",
                          opacity = 1)}
        else {
            proxy %>% clearMarkers() %>% clearControls()
        }
    })

    observe({
        proxy <- leafletProxy("mymap", data = data)
        proxy %>% clearMarkers()
        if (input$heat) {
            proxy %>%  addHeatmap(
                lng=~longitude,
                lat=~latitude,
                # intensity = ~positional_accuracy,
                blur =  10,
                max = 0.05,
                radius = 15
                # gradient = colorNumeric(palette = "magma")
            )
        }
        else{
            proxy %>% clearHeatmap()
        }


    })

}
