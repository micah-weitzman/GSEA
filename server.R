library(shiny)
library(ggplot2)
source("gsea.R")

shinyServer(function(input, output){
  
  # render uploaded file from user 
  Data <- reactive({
    inFile <- input$file1
    if (is.null(inFile)) { return(NULL) }
    read.delim(inFile$datapath, col.names=c("gene", "value")) 
  })
  
  # generate reactive gene set 
  geneSet <- reactive({
    unlist(strsplit(input$gSet, ","))
  })
  
   # render bar plot
  output$barPlot <- renderPlot({
    if (is.null(input$file1)) { return() }
    print(ggGSEA_Bar(Data(), "gene", "value", geneSet()))
  })
  
  # render density plot
  output$densPlot <- renderPlot({
    if (is.null(input$file1)) { return() }
    print(ggGSEA_Dens(Data(), "gene", "value", geneSet()))
  })
  
  # render box plot
  output$boxPlot <- renderPlot({
    if (is.null(input$file1)) { return() }
    print(ggGSEA_Bp(Data(), "gene", "value", geneSet()))
  })
  
  # render k-s plot
  output$ksPlot <- renderPlot({
    if (is.null(input$file1)) { return() }
    print(ggGSEA_Ks(Data(), "gene", "value", geneSet()))
  })
  
  # ks test p-value value of data
  output$kstp <- renderText({
    if (is.null(input$gSet) | is.null(input$file1)) { return() }
    ks.test(Data()[Data()[,"gene"]%in%geneSet(),"value"], Data()[!Data()[,"gene"]%in%geneSet(),"value"])$p.value
  })
  # ks statistic of data
  output$kst <- renderText({
    if (is.null(input$gSet) | is.null(input$file1) ) { return() }
    ks.test(Data()[Data()[,"gene"]%in%geneSet(),"value"], Data()[!Data()[,"gene"]%in%geneSet(),"value"])$statistic
  })
  
})