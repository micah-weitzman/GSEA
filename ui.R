library(shiny)

shinyUI(fluidPage(
  
  titlePanel("GSEA Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      h2("Input"),
      fileInput('file1', 'Choose CSV File',
               accept=c('text/csv', 
                        'text/comma-separated-values,text/plain', 
                        '.csv')),
      textInput("gSet", label="Gene Set", value="Enter,genes,seperated,by,commas"),
      p("Genes used: ", textOutput("num_used", inline=TRUE)),
      tags$hr(),
      h2("Results"),
      h4("P-Value: ", textOutput("kstp")),
      h4("KS Stat: ", textOutput("kst"))
      
    ),
    
    mainPanel(tabsetPanel(type = "tabs", 
                          
      tabPanel("Bar Plot", plotOutput("barPlot")),
      
      tabPanel("Density Plot", plotOutput("densPlot")), 
      
      tabPanel("Box Plot", plotOutput("boxPlot")),
      
      tabPanel("K-S PLot", plotOutput("ksPlot"))
    )
  )

)))