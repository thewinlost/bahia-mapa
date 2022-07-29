
install.packages ("rgdal")
install.packages ("ggplot2")
install.packages("rgeos")
install.packages("gpclib")
install.packages("maptools")
install.packages ("readr")

library (readr)
library (ggplot2)
library(gpclib)
library(maptools)
library(rgeos)
library (rgdal)


bh <- readOGR("C:/", "29MUE250GC_SIR")

bh$CD_GEOCODM  <- substr(bh$CD_GEOCODM,1,6)   
nascimentos <- read.csv2(file.choose(), header = T, sep = ",")     #o header é f, porque o csv não twm cabeçalho


nascimentos$CD_GEOCODM <- substr(nascimentos$municipio,1,6)


nascimentos <- nascimentos[order(nascimentos$CD_GEOCODM),] 
malhaBH <- bh@data[order(bh@data$CD_GEOCODM),]


bh2 <- merge (malhaBH,nascimentos)


library (ggplot2)
bh.bhf <- fortify (bh, region = "CD_GEOCODM")
bh.bhf <- merge(bh.bhf, bh2, by.x = "id", by.y = "CD_GEOCODM")
bh.bhf <- bh.bhf[,-c(8,10,11, 12)]


bh.bhf$nascimentosCat <- cut(bh.bhf$nascimentos, breaks = c(0,500,1000,1500,2000,2500,32000),
                             labels = c('0-500',
                                        '500-1000',
                                        '1000-1500',
                                        '1500-2000',
                                        '2000-2500',
                                        '+320000'),
                             include.lowest = T)






install.packages("RColorBrewer",dependencies = T)
library(RColorBrewer)

mapa_ggplot <-ggplot(bh.bhf, aes(long, lat, group=group, fill= nascimentosCat))+
  geom_polygon(colour='black')+ coord_equal() + ggtitle("Nascidos vivos na Bahia em 2020") +
  labs(x = "Longitude", y = "Latitude", fill=" ") + 
  scale_fill_manual(values=brewer.pal(9, 'PuRd')[4:9])+
  theme(plot.title=element_text(hjust = 0.5) )


mapa_ggplot

