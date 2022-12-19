

output$dnld <- downloadHandler(
  filename <- function() { paste0(sta$name, '.csv') },
  content <- function(file) {
    req(dly.flow <- qFlw())
    if(!is.null(dly.flow)) write.csv(dly.flow[!is.na(dly.flow$Value),], 
                                     file, 
                                     row.names = FALSE,
                                     na = ""
                                     )
  } 
)
