#' FishPlot
#' @param FishData The fish data
#' @param yr The year
#' @param ladj The length adjustment
#' @param jadj The jitter adjustment
#' @param nadj The number adjustment
#' @param SP The Species Code
#' @param yl The latitudes
#' @param xl The longitudes
#' @param lscale The length scale
#' @param type The type of plot "mean.length" or "FishPlot"TM
#' @return A Fish Plot
#' @export

fishPlot<-function(FishData, yr=1970:2024,ladj=0.001,jadj=0.2,nadj=0.01, SP=23,lab=NULL, yl= c(41, 47.85),xl= c(-68,-56.6),lscale=30, type="FishPlot",units='cm'){

  library(sf)
  library(dplyr)
  library(Mar.data)
  library(ggplot2)
  library(ggimage)

  # use Ecosystem survey data (Summer) if not provided
  if(missing(FishData))FishData<-subset(rv_data,SPEC==SP&YEAR%in%yr)

  # get a pic of the fish (pics from ANDES)
  pic=system.file("fish",paste0(substr(SP+10000,2,5),".png"), package = "FishPlot")

  # coast line
  coast2 <- st_as_sf(coast,coords=4:5,crs=st_crs(4326)) |>
    group_by(PID,SID) |>
    summarize(do_union = FALSE) |>
    st_cast("POLYGON")

  # mean length version
  if(type=="mean.length"){
    mlen<-FishData |>
      group_by(YEAR,SETNO,LONGITUDE,LATITUDE) |>
      summarize(meanLEN=weighted.mean(FLEN,CLEN_ADJ))

    FMapSurvey1 <- ggplot()+
      geom_sf(data = Strata_Mar_sf,colour="black",fill="white")+
      geom_sf(data = coast2, colour='black',fill='grey')+
      theme_bw()+ylab("Latitude")+xlab("Longitude")+
      scale_y_continuous(limits = yl)+
      scale_x_continuous(limits = xl)+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
      geom_image(data = mlen, aes(x=LONGITUDE,y=LATITUDE,image = pic), size=mlen$meanLEN*ladj  )+
      geom_image(aes(x=xl[2]-1,y=yl[1]+1,image = pic), size=lscale*ladj  )+
      geom_text(aes(x = xl[2]-1, y = yl[1]+0.7, label = paste(lscale,"cm")))


    ggsave(file.path("plots",paste0("MeanLengthMap",SP,lab,".png")), plot = FMapSurvey1, height = 8, width = 11, units = "in", dpi = 300)
  }

  # fishPlot version
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
      geom_sf(data = coast2, colour='black',fill='grey')+
      theme_bw()+ylab("Latitude")+xlab("Longitude")+
      scale_y_continuous(limits =yl)+
      scale_x_continuous(limits =xl)+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
      geom_image(data = fdat, aes(x=LONGITUDE,y=LATITUDE,image = pic), size=fdat$FLEN*ladj  ) +
      geom_image(aes(x=xl[2]-1,y=yl[1]+1,image = pic), size=lscale*ladj  )+
      geom_text(aes(x = xl[2]-1, y = yl[1]+0.7, label = paste(lscale,units)))

    ggsave(file.path("plots",paste0("FishMap",SP,lab,".png")), plot = FMapSurvey2, height = 8, width = 11, units = "in", dpi = 300)
    return(FMapSurvey2)
  }
}

