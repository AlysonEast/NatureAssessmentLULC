#!/usr/bin/env Rscript
library(networkD3)
library(dplyr)
library(ggplot2)
library(ggpubr)

setwd("/media/aly/Penobscot/UNB") 

NLCD_Changed_01_21_flow<-read.csv("./LCMAPChanged_1985to2021_reportFormated.csv", header = TRUE, sep = "")
head(NLCD_Changed_01_21_flow)
table(NLCD_Changed_01_21_flow$kms)

NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_2022!=7)
NLCD_Changed_01_21_flow<-subset(NLCD_Changed_01_21_flow, LC_1985!=7)



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


NLCD_Changed_01_21_flow$LC_1985 <- recode_LC(NLCD_Changed_01_21_flow$LC_1985)
NLCD_Changed_01_21_flow$LC_2022 <- recode_LC(NLCD_Changed_01_21_flow$LC_2022)

head(NLCD_Changed_01_21_flow)
table(NLCD_Changed_01_21_flow$LC_1985)
table(NLCD_Changed_01_21_flow$LC_2022)


links<-NLCD_Changed_01_21_flow 
colnames(links)<-c("source","target","value") 
links$source<-paste0("LC85_",links$source) 
links$target<-paste0("LC21_",links$target)

nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

links


color_scale <- data.frame(
  range = c("#ff0000","#be8c5a", "#e6f0d2", "#1c6330", "#0070ff","#b3d9ff","#b3aea3","#ff0000","#be8c5a", "#e6f0d2", "#1c6330", "#0070ff","#b3d9ff","#b3aea3"),
  nodes = nodes,
  stringsAsFactors = FALSE
)

# Using a custom array of hexadecimal color codes
colourScale = JS("d3.scaleOrdinal().range(['#ff0000','#be8c5a', '#e6f0d2', '#1c6330', '#0070ff',"#b3d9ff","#b3aea3","#ff0000","#be8c5a", "#e6f0d2", "#1c6330", "#0070ff","#b3d9ff","#b3aea3"]);")
)

p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE,
                   colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20b);"),
                   fontSize = 12, nodeWidth = 75, iterations = 100)

png("./Sankey.png", height = 4, width = 6, units = "in", res = 300)
sankeyNetwork(Links = links, Nodes = nodes,
              Source = "IDsource", Target = "IDtarget",
              Value = "value", NodeID = "name", 
              sinksRight=FALSE,
              fontSize = 12, nodeWidth = 75, iterations = 100)
dev.off()
