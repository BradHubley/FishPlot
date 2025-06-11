#' FishPlot
#' @param FishData The fish data
#' @param yr The year
#' @param ladj The length adjustment
#' @param jadj The jitter adjustment
#' @param nadj The number adjustment
#' @param Species The Species Name
#' @param yl The latitudes
#' @param xl The longitudes
#' @param lscale The length scale
#' @param type The type of plot "mean.length" or "FishPlot"TM
#' @return A Fish Plot
#' @export

fishPlot<-function(FishData,ladj=0.001,jadj=0.2,nadj=0.01, Species="Redfish",lab=NULL, yl= c(41, 47.85),xl= c(-68,-56.6),lscale=30, type="FishPlot"){

  library(sf)
  library(tidyverse)
  library(Mar.data)
  library(ggimage)

  if(Species=="Redfish")pic=system.file("fish","Sebastes_fasciatus.png", package = "FishPlot")
  if(Species=="Haddock")pic=system.file("fish","Melanogrammus_aeglefinus.png", package = "FishPlot")
  if(Species=="Cod")pic=system.file("fish","Gadus_morhua.png", package = "FishPlot")
  if(Species=="Silver hake")pic=system.file("fish","Merluccius_bilinearis.png", package = "FishPlot")
  if(Species=="Pollock")pic=system.file("fish","Pollachius_virens.png", package = "FishPlot")
  if(Species=="Halibut")pic=system.file("fish","Hippoglossus_hippoglossus.png", package = "FishPlot")
  if(Species=="Dogfish")pic=system.file("fish","Squalus_acanthias.png", package = "FishPlot")
  if(Species=="Plaice")pic=system.file("fish","Hippoglossoides_platessoides.png", package = "FishPlot")
  if(Species=="Yellowtail")pic=system.file("fish","Limanda_ferruginea.png", package = "FishPlot")
  if(Species=="Barndoor skate")pic=system.file("fish","dipturus_laevis.png", package = "FishPlot")

  #coast<-readRDS("data/coast.rds")

  if(type=="mean.length"){
    mlen<-FishData |>
      group_by(YEAR,SETNO,LONGITUDE,LATITUDE) |>
      summarize(meanLEN=weighted.mean(FLEN,CLEN_ADJ))

    FMapSurvey1 <- ggplot()+
      geom_sf(data = Strata_Mar_sf,colour="black",fill="white")+
      geom_sf(data = coast, colour='black',fill='grey')+
      theme_bw()+ylab("Latitude")+xlab("Longitude")+
      scale_y_continuous(limits = yl)+
      scale_x_continuous(limits = xl)+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
      geom_image(data = mlen, aes(x=LONGITUDE,y=LATITUDE,image = pic), size=mlen$meanLEN*ladj  )+
      geom_image(aes(x=xl[2]-1,y=yl[1]+1,image = pic), size=lscale*ladj  )+
      geom_text(aes(x = xl[2]-1, y = yl[1]+0.7, label = paste(lscale,"cm")))


    ggsave(file.path("plots",paste0("MeanLengthMap",Species,lab,".png")), plot = FMapSurvey1, height = 8, width = 11, units = "in", dpi = 300)
  }

  if(type=="FishPlot"){

    sets<-unique(FishData$SETNO)
    slist<-list()
    for(i in 1:length(sets)){
      tmp<-subset(FishData,SETNO==sets[i])
      tmp<-tmp[sample(1:nrow(tmp),size=ceiling(tmp$TOTNO[1]*nadj),replace = T),c("LATITUDE","LONGITUDE","FLEN")]
      tmp$LATITUDE<-jitter(tmp$LATITUDE,jadj)
      tmp$LONGITUDE<-jitter(tmp$LONGITUDE,jadj)
      slist[[i]]<-tmp
    }
    fdat<-do.call("rbind",slist)

    FMapSurvey2 <- ggplot()+
      geom_sf(data = Strata_Mar_sf,colour="black",fill="white")+
      geom_sf(data = coast, colour='black',fill='grey')+
      theme_bw()+ylab("Latitude")+xlab("Longitude")+
      scale_y_continuous(limits =yl)+
      scale_x_continuous(limits =xl)+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
      geom_image(data = fdat, aes(x=LONGITUDE,y=LATITUDE,image = pic), size=fdat$FLEN*ladj  ) +
      geom_image(aes(x=xl[2]-1,y=yl[1]+1,image = pic), size=lscale*ladj  )+
      geom_text(aes(x = xl[2]-1, y = yl[1]+0.7, label = paste(lscale,"cm")))

    ggsave(file.path("plots",paste0("FishMap",Species,lab,".png")), plot = FMapSurvey2, height = 8, width = 11, units = "in", dpi = 300)
  }
}

