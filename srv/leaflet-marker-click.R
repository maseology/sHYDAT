
observe({
  if (!is.null(input$map_marker_click)){
    e <- input$map_marker_click
    if (e$id %in% hydat.stations$STATION_NUMBER) {
      withProgress(message = paste0('Querying ', e$id, ".."), value = 0.1, {
        sta$name <- e$id
        df.realtime <- realtime_dd(e$id) %>% drop_na("Value") %>% filter(Parameter == "Flow")
        if (nrow(df.realtime)==0) {
          qFlw(
            hy_daily_flows(e$id) %>%
              drop_na("Value") %>%
              mutate(Date=as.Date(Date))
          )
        } else {
          setProgress(.45,message = paste0('Querying ', e$id, " from Datamart"))
          qFlw(
            hy_daily_flows(e$id) %>%
              drop_na("Value") %>%
              mutate(Date=as.Date(Date)) %>%
              rbind(df.realtime %>%
                  select(c("STATION_NUMBER","Date","Parameter","Value")) %>%
                  mutate(Date=as.Date(Date)) %>%
                  group_by(STATION_NUMBER,Date,Parameter) %>%
                  summarise(Value = mean(Value, na.rm = TRUE)) %>%
                  mutate(Symbol="raw"))
          )
        }

        setProgress(1)
      })      
    }
  }
})
