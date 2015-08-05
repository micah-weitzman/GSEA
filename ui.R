library(shiny)

shinyUI(fluidPage(
  
  titlePanel("GSEA Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Input")
    ),
    
    mainPanel(tabsetPanel(type = "tabs", 
      tabPanel("Bar Plot", plotOutput("barPlot")), 
      tabPanel("Density Plot", plotOutput("densPlot")), 
      tabPanel("Box Plot", plotOutput("boxPlot")),
      tabPanel("K-S PLot", plotOutput("ksPlot"))
    )
  )

)))