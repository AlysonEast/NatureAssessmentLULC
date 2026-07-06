#!/usr/bin/env Rscript
library(networkD3)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(tidyverse) 

setwd("/media/aly/Penobscot/UNB") 

df <- read.delim("hindcastLULC_1650to2020_report.tsv", sep = "|")   # treat blanks as NA

clean_df <- df[df[,3] != "", ]
colnames(clean_df)<-c("LC_1650","LC_2020","sqMi")
clean_df$LC_1650<-c(0,1,rep(2, each=4),3,rep(4, each=6),rep(5:6, each=5),7,8,9)
table(clean_df$LC_1650,clean_df$LC_2020) #Should only see 1s or 0s. 

write.csv(clean_df, "hindcastLULC_1650to2020_reportFormated.csv", row.names = FALSE)


NLCD_Changed_01_21_flow<-read.csv("./hindcastLULC_1650to2020_reportFormated.csv", header = TRUE, sep = ",")
head(NLCD_Changed_01_21_flow)
NLCD_Changed_01_21_flow<-NLCD_Changed_01_21_flow[-1,]
NLCD_Changed_01_21_flow$sqMi <- gsub("\\,", "", NLCD_Changed_01_21_flow$sqMi)
NLCD_Changed_01_21_flow$sqMi<-as.numeric(NLCD_Changed_01_21_flow$sqMi)
table(NLCD_Changed_01_21_flow$sqMi)
NLCD_Changed_01_21_flow$sqMi

NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_2020!=7)
NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_1650!=7)
NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_2020!=8)
NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_1650!=8)
NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_2020!=9)
NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_1650!=9)



# Custom color palette (same order as your land cover types)
Index_pallet <- c("#ff0000",  # Developed
                  "#be8c5a",  # Cropland
                  "#e6f0d2",  # Grass/Shrub
                  "#1c6330",  # Forest
                  "#0070ff",  # Water
                  "#b3d9ff",  # Wetland
                  "#b3aea3")  # Barren

# Recode numeric classes to names for both years
recode_LC <- function(x) {
  recode(x,
         `1` = "Developed",
         `2` = "Cropland",
         `3` = "Grass/Shrub",
         `4` = "Forest",
         `5` = "Water",
         `6` = "Wetland",
         `8` = "Barren")
}


NLCD_Changed_01_21_flow$LC_1650 <- recode_LC(NLCD_Changed_01_21_flow$LC_1650)
NLCD_Changed_01_21_flow$LC_2020 <- recode_LC(NLCD_Changed_01_21_flow$LC_2020)

head(NLCD_Changed_01_21_flow)
table(NLCD_Changed_01_21_flow$LC_1650)
table(NLCD_Changed_01_21_flow$LC_2020)


links<-NLCD_Changed_01_21_flow 
colnames(links)<-c("source","target","value") 
links$source<-paste0("LC1650_",links$source) 
links$target<-paste0("LC2020_",links$target)

nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

links


color_scale <- data.frame(
  range = c("#ff0000","#be8c5a", "#ABA300", "#1c6330", "#e6f0d2", "#e6f0d2","#ff0000","#be8c5a", "#ABA300", "#1c6330", "#e6f0d2", "#e6f0d2"),
  nodes = nodes,
  stringsAsFactors = FALSE
)

# Using a custom array of hexadecimal color codes
colourScale = JS("d3.scaleOrdinal(,
                 ['#ff0000','#be8c5a', '#ABA300', '#1c6330', '#e6f0d2', '#e6f0d2','#ff0000','#be8c5a', '#ABA300', '#1c6330', '#e6f0d2', '#e6f0d2']);")

# Give a color for each group:
my_color <- 'd3.scaleOrdinal() .domain([ "1","2","3","4","5","6" ]) .range(["#ff0000","#be8c5a", "#ABA300", "#1c6330", "#e6f0d2", "#e6f0d2")'

links$group <- substr(links$target, 8,8)
links$group <- as.factor(links$group)

nodes$group <- substr(nodes$name, 8,8)
nodes$group <- as.factor(nodes$group)


p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE,
                   # colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20b);"),
                   colourScale=my_color,
                   fontSize = 12, nodeWidth = 75, iterations = 100)

png("./Sankey.png", height = 4, width = 6, units = "in", res = 300)
sankeyNetwork(Links = links, Nodes = nodes,
              Source = "IDsource", Target = "IDtarget",
              Value = "value", NodeID = "name", 
              sinksRight=FALSE,
              # colourScale=my_color, LinkGroup="group", NodeGroup="group",
              fontSize = 12, nodeWidth = 75, iterations = 100)
dev.off()

#Summary Values
subset(NLCD_Changed_01_21_flow, LC_2020==1)
sum(subset(NLCD_Changed_01_21_flow, LC_2020==1)[-c(1,2,3),3]) # sq miles to developed 


subset(NLCD_Changed_01_21_flow, LC_2020==2)
sum(subset(NLCD_Changed_01_21_flow, LC_2020==2)[-c(1),3])
