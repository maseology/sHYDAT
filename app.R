

library(shiny)
library(shinyjs)
library(leaflet)
library(dplyr)
library(lubridate)
library(tidyhydat)

# download_hydat()
hydat.stations <- hy_stations() %>%
  filter(PROV_TERR_STATE_LOC == "ON")

# query date ranges
YRb <- vector('numeric',length = nrow(hydat.stations))
YRe <- vector('numeric',length = nrow(hydat.stations))
i <- 0
for (s in hydat.stations$STATION_NUMBER) {
  i=i+1
  tryCatch({
    q <- hy_daily_flows(s)
    # print(paste0(s," ", year(min(q$Date)), " ", year(max(q$Date)) ))
    YRb[i] <- year(min(q$Date))
    YRe[i] <- year(max(q$Date))
  }, error=function(e){
    YRb[i] <- NA
    YRe[i] <- NA
  }) #{cat("ERROR: ",s," has no data\n")})
}




hy_daily_flows(prov_terr_state_loc = "ON")




ui <- bootstrapPage(
  
  useShinyjs(),
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  tags$head(includeCSS("srv/styles.css")),
  
  leafletOutput("map", width = "100%", height = "100%"),
  
  # modified from superZip (http://shiny.rstudio.com/gallery/superzip-example.html)
  absolutePanel(id = "panl", class = "panel panel-default", fixed = TRUE,
                draggable = FALSE, top = 10, left = "auto", right = 10, bottom = "auto",
                width = 430, height = "auto",
                
                h2("Hydrograph explorer"),
                # sliderInput("YRrng", "Select date envelope", min(hydat.stations$YRb), max(hydat.stations$YRe),
                #             value = c(max(hydat.stations$YRe)-30,max(hydat.stations$YRe)), sep="", width = "auto"),
                
                selectInput("POR", "minimum period of length/count of data", c("no limit" = 0, "5yr" = 5, "10yr" = 10, "30yr" = 30, "50yr" = 50, "75yr" = 75, "100yr" = 100)),
                
                # h4("Hydrograph preview:"),
                div(textOutput("legendDivID")),
                # dygraphOutput("hydgrph", height = 240), br(),
                # div(style="display:inline-block",actionButton("expnd", "Analyze")),
                div(style="display:inline-block",downloadButton('dnld', 'Download CSV'))                  
  ),
)

server <- function(input, output, session) {
  # showNotification("Map is loading...",type="message", duration=30)
  source("srv/leaflet.R", local = TRUE)$value
  session$onSessionEnded(stopApp)
}


shinyApp(ui, server)


             