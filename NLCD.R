#!/usr/bin/env Rscript
setwd("/media/aly/Penobscot/UNB")

NLCD_Changed_01_21<-read.csv("./NLCD_Date_ChangeIndex_Formatted.csv", header = TRUE)
NLCD_Changed_01_21$YearLabs<-ifelse(NLCD_Changed_01_21$Year==2, "2001-2004",
                                    ifelse(NLCD_Changed_01_21$Year==3, "2004-2006",
                                           ifelse(NLCD_Changed_01_21$Year==4, "2006-2008",
                                                  ifelse(NLCD_Changed_01_21$Year==5, "2008-2011",
                                                         ifelse(NLCD_Changed_01_21$Year==6, "2011-2013",
                                                                ifelse(NLCD_Changed_01_21$Year==7, "2013-2016",
                                                                       ifelse(NLCD_Changed_01_21$Year==8, "2016-2019",
                                                                              ifelse(NLCD_Changed_01_21$Year==9, "2019-2021", NA))))))))
NLCD_Changed_01_21$IndexLabs<-ifelse(NLCD_Changed_01_21$Index==2, "Water Change",
                                    ifelse(NLCD_Changed_01_21$Index==3, "Urban Change",
                                           ifelse(NLCD_Changed_01_21$Index==4, "Wetland (within class change)",
                                                  ifelse(NLCD_Changed_01_21$Index==5, "Herbaceous Wetland Whange",
                                                         ifelse(NLCD_Changed_01_21$Index==6, "Agriculture (within class change)",
                                                                ifelse(NLCD_Changed_01_21$Index==7, "Cultivated Crop Change",
                                                                       ifelse(NLCD_Changed_01_21$Index==8, "Hay/Pasture Change",
                                                                               ifelse(NLCD_Changed_01_21$Index==9, "Rangeland Herbaceous and Shrub Change",
                                                                                      ifelse(NLCD_Changed_01_21$Index==10, "Barren Change", 
                                                                                             ifelse(NLCD_Changed_01_21$Index==11, "Forest Change",
                                                                                                    ifelse(NLCD_Changed_01_21$Index==12, "Woody Wetland Change",
                                                                                                           ifelse(NLCD_Changed_01_21$Index==13, "Snow Change", NA))))))))))))

table(NLCD_Changed_01_21$IndexLabs)
plot(NLCD_Changed_01_21$kms~NLCD_Changed_01_21$Year)

library(ggplot2)
library(ggpubr)

Index_pallet<-c("#0000ff", "#eb82eb", "#79ffd2", "#009ede", "#ffd000", "#9f2828", "#ffff00", "#dfdfc2",	"#b3ac9f", "#79ff00", "#ff0000", "#ffffff")

png("./NLCD_Change_Year.png", width = 10, height = 10, units = "in", res = 300)
ggplot(data = subset(NLCD_Changed_01_21, !is.na(YearLabs)), aes(x=YearLabs, y=kms, fill = as.factor(Index))) +
  geom_col() +
  fill_palette(Index_pallet) +
  theme_pubr() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
        legend.position = "none") +
  xlab("Date for First Change") +
  ylab("Area Changed (square Kilometers)") +
  facet_wrap(.~IndexLabs)#, scale="free_y") 
dev.off()  

NLCD_Changed_01_21_flow<-read.csv("./NLCD_2001_2021_Changed.csv", header = TRUE)

table(NLCD_Changed_01_21_flow$LC_2001)
table(NLCD_Changed_01_21_flow$LC_2021)

links<-NLCD_Changed_01_21_flow
colnames(links)<-c("source","target","value")
links$source<-paste0("LC01_",links$source)
links$target<-paste0("LC21_",links$target)


library(networkD3)
library(dplyr)

nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE)
p

NLCD_Changed_01_21_flow<-read.csv("./NLCD_2001_2021_ChangedIndex.csv", header = TRUE)
table(NLCD_Changed_01_21_flow$LC_2001)
table(NLCD_Changed_01_21_flow$LC_2021)
NLCD_Changed_01_21_flow$IndexLabs<-ifelse(NLCD_Changed_01_21_flow$Index==2, "Water Change",
                                     ifelse(NLCD_Changed_01_21_flow$Index==3, "Urban Change",
                                            ifelse(NLCD_Changed_01_21_flow$Index==4, "Wetland (within class change)",
                                                   ifelse(NLCD_Changed_01_21_flow$Index==5, "Herbaceous Wetland Whange",
                                                          ifelse(NLCD_Changed_01_21_flow$Index==6, "Agriculture (within class change)",
                                                                 ifelse(NLCD_Changed_01_21_flow$Index==7, "Cultivated Crop Change",
                                                                        ifelse(NLCD_Changed_01_21_flow$Index==8, "Hay/Pasture Change",
                                                                               ifelse(NLCD_Changed_01_21_flow$Index==9, "Rangeland Herbaceous and Shrub Change",
                                                                                      ifelse(NLCD_Changed_01_21_flow$Index==10, "Barren Change", 
                                                                                             ifelse(NLCD_Changed_01_21_flow$Index==11, "Forest Change",
                                                                                                    ifelse(NLCD_Changed_01_21_flow$Index==12, "Woody Wetland Change",
                                                                                                           ifelse(NLCD_Changed_01_21_flow$Index==13, "Snow Change", NA))))))))))))


NLCD_Changed_01_21_flow$LC_2001_Labs<-ifelse(NLCD_Changed_01_21_flow$LC_2001==11, "Open Water",
                                          ifelse(NLCD_Changed_01_21_flow$LC_2001==12, "Snow/Ice",
                                                 ifelse(NLCD_Changed_01_21_flow$LC_2001==21, "Developed, Open",
                                                        ifelse(NLCD_Changed_01_21_flow$LC_2001==22, "Developed, Low Intensity",
                                                               ifelse(NLCD_Changed_01_21_flow$LC_2001==23, "Developed, Med Intensity",
                                                                      ifelse(NLCD_Changed_01_21_flow$LC_2001==24, "Developed, High Intensity",
                                                                             ifelse(NLCD_Changed_01_21_flow$LC_2001==31, "Barren Land",
                                                                                    ifelse(NLCD_Changed_01_21_flow$LC_2001==41, "Deciduous Forest",
                                                                                           ifelse(NLCD_Changed_01_21_flow$LC_2001==42, "Evergreen Forest", 
                                                                                                  ifelse(NLCD_Changed_01_21_flow$LC_2001==43, "Mixed Forest",
                                                                                                         ifelse(NLCD_Changed_01_21_flow$LC_2001==52, "Shrub Scrub",
                                                                                                                ifelse(NLCD_Changed_01_21_flow$LC_2001==71, "Herbaceous", 
                                                                                                                       ifelse(NLCD_Changed_01_21_flow$LC_2001==81, "Hay/Pasture",
                                                                                                                              ifelse(NLCD_Changed_01_21_flow$LC_2001==82, "Cultivated Crops",
                                                                                                                                     ifelse(NLCD_Changed_01_21_flow$LC_2001==90, "Woody Wetland",
                                                                                                                                            ifelse(NLCD_Changed_01_21_flow$LC_2001==95, "Herbaceous Wetland",NA))))))))))))))))


head(NLCD_Changed_01_21_flow)
NLCD_Changed_01_21_flow$IndexLabs

links<-NLCD_Changed_01_21_flow[,c(5,4,3)]
colnames(links)<-c("source","target","value")

library(networkD3)
library(dplyr)

nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE)
p
