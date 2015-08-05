library(shiny)
library(ggplot2)
source("gsea.R")
numGenes <- 10000
geneList <- paste("Gene", c(1:numGenes), sep="")
#100 in the gene set
geneSet <- sample(geneList, 100)
#create data frame, roughly normal distribution
geneDF <- data.frame(geneList, rnorm(numGenes))
#Add a little extra to the genes in the geneSet
geneDF[geneDF[,1]%in%geneSet,2] <- 1+geneDF[geneDF[,1]%in%geneSet,2]
#change colnames
colnames(geneDF) <- c("gene", "value")


shinyServer(function(input, output){
  # render bar plot
  output$barPlot <- renderPlot({
    print(ggGSEA_Bar(geneDF, "gene", "value", geneSet))
  })
  # render density plot
  output$densPlot <- renderPlot({
    print(ggGSEA_Dens(geneDF, "gene", "value", geneSet))
  })
  # render box plot
  output$boxPlot <- renderPlot({
    print(ggGSEA_Bp(geneDF, "gene", "value", geneSet))
  })
  # render k-s plot
  output$ksPlot <- renderPlot({
    print(ggGSEA_Ks(geneDF, "gene", "value", geneSet))
  })
})