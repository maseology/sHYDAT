

library(shiny)
library(shinyjs)
library(leaflet)
library(dygraphs)
library(dplyr)
library(lubridate)
library(xts)
library(tidyr)
library(tidyhydat)




# need to run the following periodically, especially on first runs
# download_hydat()




hydat.stations <- hy_stations() %>%
  filter(PROV_TERR_STATE_LOC == c("MB","SK","ON")) %>%
  inner_join(hy_stn_data_coll(), by = "STATION_NUMBER") %>%
  filter(DATA_TYPE == "Flow")




ui <- bootstrapPage(
  
  useShinyjs(),
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  tags$head(includeCSS("srv/styles.css")),
  
  leafletOutput("map", width = "100%", height = "100%"),
  
  # modified from superZip (http://shiny.rstudio.com/gallery/superzip-example.html)
  absolutePanel(id = "panl", class = "panel panel-default", fixed = TRUE,
                draggable = FALSE, top = 10, left = "auto", right = 10, bottom = "auto",
                width = 360, height = "auto",
                
                h2("Hydrograph explorer"),
                sliderInput("YRrng", "Select date envelope", min(hydat.stations$Year_from), max(hydat.stations$Year_to),
                            # value = c(max(hydat.stations$Year_to)-30,max(hydat.stations$Year_to)), 
                            value = c(min(hydat.stations$Year_from),max(hydat.stations$Year_to)), 
                            sep="", width = "auto"),
                
                selectInput("POR", "minimum period of length/count of data", c("no limit" = 0, "5yr" = 5, "10yr" = 10, "30yr" = 30, "50yr" = 50, "75yr" = 75, "100yr" = 100)),
                
                # h4("Hydrograph preview:"),
                div(textOutput("legendDivID")),
                dygraphOutput("hydgrph", height = 240), br(),
                # div(style="display:inline-block",actionButton("expnd", "Analyze")),
                div(style="display:inline-block",downloadButton('dnld', 'Download CSV'))                  
  ),
)

server <- function(input, output, session) {
  # showNotification("Map is loading...",type="message", duration=30)
  source("srv/server.R", local = TRUE)$value
  session$onSessionEnded(stopApp)
}


shinyApp(ui, server)


             