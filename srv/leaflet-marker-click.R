

observe({
  if (!is.null(input$map_marker_click)){
    e <- input$map_marker_click
    if (e$id %in% hydat.stations$STATION_NUMBER) {
      withProgress(message = paste0('Querying ', e$id, ".."), value = 0.1, {
        sta$name <- e$id
        qFlw(
          hy_daily_flows(e$id) %>%
            drop_na("Value") %>%
            mutate(Date=as.Date(Date))
        )
        
        setProgress(1)
      })      
    }
  }
})