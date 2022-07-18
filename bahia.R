install.packages ("rgdal")
install.packages ("ggplot2")
install.packages("rgeos")
install.packages("gpclib")
install.packages("maptools")
install.packages ("readr")

library(gpclib)
library(maptools)
library(rgeos)
library (ggplot2)
library (rgdal)
library (readr)

bh <- readOGR("C:/", "29MUE250GC_SIR")

bh$CD_GEOCODM  <- substr(bh$CD_GEOCODM,1,6)   
nascimentos <- read.csv2(file.choose(), header = T, sep = ",")     #o header é f, porque o csv não twm cabeçalho


nascimentos$CD_GEOCODM <- substr(nascimentos$municipio,1,6)
##########################################################


nascimentos <- nascimentos[order(nascimentos$CD_GEOCODM),] 
malhaBH <- bh@data[order(bh@data$CD_GEOCODM),]
head(malhaBH)
head(nascimentos)


dim (nascimentos)
dim (malhaBH)
bh2 <- merge (malhaBH,nascimentos)

head(bh)

###################################

library (ggplot2)
bh.bhf <- fortify (bh, region = "CD_GEOCODM")


head (bh)
bh.bhf <- merge(bh.bhf, bh@data, by.x = "id", by.y = "CD_GEOCODM")
############até aqui ok

bh.bhf$nascimentosCat <- cut(bh.bhf$nascimentos, breaks = c(0,50,100,200,300,400,1000),
                        labels = c('0-50',
                                   '50-100',
                                   '200-300',
                                   '300-400',
                                   '400-1000',
                                   '+1000'),
                        include.lowest = T)

head(bh2)


bh.bhf <- merge(bh.bhf, bh2, by.x = "id", by.y = "CD_GEOCODM")


install.packages("RColorBrewer",dependencies = T)
library(RColorBrewer)

mapa_ggplot <-ggplot(bh.bhf, aes(long, lat, group=group, fill= nascimentos))+
  geom_polygon(colour='black')+ coord_equal() + ggtitle("Nascimentos na Bahia em 2020") +
  labs(x = "Longitude", y = "Latitude", fill="nascimentos") + 
  theme(plot.title=element_text(hjust = 0.5) );

  mapa_ggplot  
    