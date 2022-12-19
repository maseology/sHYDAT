

filteredData <- reactive({
  p <- as.numeric(input$POR)
  yrb <- hydat.stations$Year_from
  yre <- hydat.stations$Year_to
  hydat.stations[yre >= input$YRrng[1] & yrb <= input$YRrng[2] & (yre-yrb) > p,]
})

output$map <- renderLeaflet({
  leaflet(filteredData()) %>%
    addTiles() %>%
    addMarkers(~LONGITUDE,~LATITUDE,
               layerId = ~STATION_NUMBER,
               label = ~paste0(STATION_NUMBER,": ",STATION_NAME),
               popup = ~paste0(STATION_NUMBER,': ',STATION_NAME,
                               '<br>status: ',HYD_STATUS,
                               '<br>data type: ',DATA_TYPE,
                               '<br>drainage area: ',DRAINAGE_AREA_GROSS,' km2',
                               '<br>POR: ',Year_from,' to ',Year_to
                               ),
              )

})