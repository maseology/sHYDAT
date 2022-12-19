



# Dygraph hydrograph preview in absolutePanel
output$hydgrph <- renderDygraph({
  req(dly.flow <- qFlw())
  if (!is.null(dly.flow)){
    qxts <- xts(dly.flow$Value, order.by = dly.flow$Date)
    lw <- max(20,25 + (log10(max(dly.flow$Value))-2)*8) # dynamic plot fitting
    colnames(qxts) <- 'Discharge'
    dygraph(qxts) %>%
      dySeries("Discharge", color = "blue") %>%
      # dyLegend(show = 'always') %>%
      dyOptions(axisLineWidth = 1.5, fillGraph = TRUE, stepPlot = TRUE) %>%
      dyAxis(name='y', labelWidth=0, axisLabelWidth=lw) %>%
      dyRangeSelector(strokeColor = '') %>% 
      dyLegend(labelsDiv = "legendDivID")
  }
})