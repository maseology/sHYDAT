
output$map <- renderLeaflet({

  leaflet(hydat.stations) %>%
    addTiles() %>%
    addMarkers(~LONGITUDE,~LATITUDE,
               label = ~paste0(STATION_NUMBER,": ",STATION_NAME))

})