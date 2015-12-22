####################################
# Code to visualize GSEA results
#
# Micah Weitzman
#
####################################

# Call libraries
library(ggplot2)
library(gridExtra)

# 1) First we can do a bar plot with genes in the set colored
ggGSEA_Bar <- function(resDF, gCol, vCol, geneSet)
{
  tmpDF <- resDF[,c(gCol, vCol)]
  rownames(tmpDF) <- resDF[,1]
  tmpVCol <- tmpDF[,vCol]
  tmpDF <- tmpDF[order(tmpVCol),]
  xMax <- max(tmpVCol)
  xMin <- min(tmpVCol)
  tmpDF <- tmpDF[tmpDF[,gCol]%in%geneSet,]
  colnames(tmpDF)[1:2] <- c("Gene", "Value") 
  qplot(0,0)+geom_point(colour="white")+geom_vline(xintercept=tmpDF[,"Value"], colour="red", alpha = .3, size = .5)+theme_bw()+scale_x_continuous(limits = c(xMin, xMax))+xlab("Distribution")+ylab("")+theme(axis.ticks.y=element_blank(), axis.text.y=element_blank(), panel.background=element_blank(),panel.grid.major=element_blank())+ggtitle("Bar Plot")
}


# 2) Let's do a density plot showing distribution of the gene set and distribution of genes not in the set
ggGSEA_Dens <- function(resDF, gCol, vCol, geneSet)
{
  tmpDF <- resDF[,c(gCol, vCol)];
  rownames(tmpDF) <- resDF[,1];
  tmpDF[,"In_Set"] <- "No";
  tmpDF[tmpDF[,gCol]%in%geneSet,"In_Set"] <- "Yes";
  colnames(tmpDF)[1:2] <- c("Gene", "Value");
  ggplot(tmpDF, aes(Value, fill=In_Set))+geom_density(alpha=.4)+theme_bw()+scale_fill_manual(values=c("gray", "red"))+geom_vline(xintercept=c(median(tmpDF[tmpDF[,"In_Set"]=="No","Value"]), median(tmpDF[tmpDF[,"In_Set"]=="Yes","Value"])), colour=c("gray", "red"))+ggtitle("Distribution")+guides(fill=F)
}

# 3) Let's do a boxplot as well

ggGSEA_Bp <- function(resDF, gCol, vCol, geneSet)
{
  tmpDF <- resDF[,c(gCol, vCol)];
  rownames(tmpDF) <- resDF[,1];
  tmpDF[,"In_Set"] <- "No";
  tmpDF[tmpDF[,gCol]%in%geneSet,"In_Set"] <- "Yes";
  colnames(tmpDF)[1:2] <- c("Gene", "Value");
  ggplot(tmpDF, aes(In_Set, Value, fill=In_Set))+geom_boxplot(alpha=.4)+theme_bw()+scale_fill_manual(values=c("gray", "red"))+coord_flip()+xlab("In Set")+ylab("")+ggtitle("Box Plot")+guides(fill=F)
}

# 4) Lets do a K-S test
ggGSEA_Ks <- function(resDF, gCol, vCol, geneSet)
{
  tmpDF <- resDF[,c(gCol, vCol)]
  rownames(tmpDF) <- resDF[,1]
  tmpVCol <- tmpDF[,vCol]
  tmpDF <- tmpDF[tmpDF[,gCol]%in%geneSet,];
  ed <- ecdf(tmpDF$value)
  maxdiffidx <<- which.max(abs(ed(tmpDF$value)-pnorm(tmpDF$value)))
  maxdiffat <- tmpDF$value[maxdiffidx]
  ggplot(tmpDF, aes(value)) + stat_ecdf(colour="red") + stat_function(fun = pnorm, colour = "black") + ggtitle("KS Plot") + geom_vline(x=maxdiffat, lty=2) + theme_bw() + annotate("text", label=paste("Max Diff:",maxdiffidx), x=0, y=0, size=6, family="Helvetica")+ylab("")
}


# 5) Combine them all together
ggGSEA_Comb <- 
  function(resDF, gCol, vCol, geneSet)
{
  kst <- ks.test(resDF[resDF[,gCol]%in%geneSet,vCol], resDF[!resDF[,gCol]%in%geneSet,vCol])
  a <- ggplot_gtable(ggplot_build(ggGSEA_Bar(resDF, gCol, vCol, geneSet)))
  b <- ggplot_gtable(ggplot_build(ggGSEA_Dens(resDF, gCol, vCol, geneSet)+guides(fill=F)))
  c <- ggplot_gtable(ggplot_build(ggGSEA_Bp(resDF, gCol, vCol, geneSet)+guides(fill=F)))
  d <- ggplot_gtable(ggplot_build(ggGSEA_Ks(resDF, gCol, vCol, geneSet)))
  a$widths <- b$widths
  grid.arrange(arrangeGrob(a,c,b,d, ncol=2, nrow=2, top = paste("GSEA Visualization"), bottom=paste("Red = Gene Set \n Grey = Gene List \n KS test:",kst), right=paste()))
}
#create fake data and try it

#10000 genes
numGenes <- 10000
geneList <- paste("Gene", c(1:numGenes), sep="")

#100 in the gene set
geneSet <- sample(geneList, 100);

#create data frame, roughly normal distribution
geneDF <- data.frame(geneList, rnorm(numGenes));

#Add a little extra to the genes in the geneSet
geneDF[geneDF[,1]%in%geneSet,2] <- 1+geneDF[geneDF[,1]%in%geneSet,2];

#change colnames
colnames(geneDF) <- c("gene", "value");

ggGSEA_Comb(geneDF, "gene", "value", geneSet)