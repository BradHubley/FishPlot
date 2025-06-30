

files <- list.files(path=file.path("inst","fish","andes"))
file.rename(file.path("inst","fish","andes",files),file.path("inst","fish","andes", paste0(substr(files,1,4),".png")))

#library(devtools)
#install_github("Maritimes/Mar.datawrangling")
library(Mar.datawrangling)

uid="hubleyb"
pwd="R4#vmxtas"


# 1. Establish Oracle connection first (NEW REQUIREMENT)
cxn <- ROracle::dbConnect(DBI::dbDriver("Oracle"), uid, pwd, "PTRAN")

# 2. Extract data (first time will prompt for extraction)
get_data(db = 'rv', cxn = cxn)

# 3. filter the data (optional)
#GSSPECIES <- GSSPECIES[GSSPECIES$CODE == 10,]  # Cod only
#GSMISSIONS <- GSMISSIONS[GSMISSIONS$YEAR == 2024,]  # Recent year
GSINF <- GSINF[GSINF$TYPE==1,]
GSMISSIONS <- GSMISSIONS[GSMISSIONS$SEASON=="SUMMER",]
self_filter()  # Apply filters to all related tables

species<-GSSPECIES[,1:4]
save(species,file="data/species.rda")

# 4. Create analysis-ready dataset
my_data <- summarize_catches(morph_dets = TRUE)

columns<-c("YEAR","SETNO","LONGITUDE","LATITUDE","TOTNO","FLEN","CLEN_ADJ","SPEC")
rv_data <- subset(my_data,select=columns)
save(rv_data,file="data/rv_data.rda")



# redfish
RED_data.24<-subset(rv_data,YEAR==2024&SPEC==23 )
fishPlot(RED_data.24, SP=23,lab=2024)
fishPlot(RED_data.24, SP=23,lab=2024,type='mean.length')

RED_data.last5<-subset(rv_data,YEAR%in%2020:2024&SPEC==23,columns )
fishPlot(RED_data.last5, SP=23,lab="last5years")

# haddock
HAD_data.24<-subset(my_data,YEAR==2024&SPEC==11,columns )
fishPlot(HAD_data.24,Species="Haddock",lab=2024,ladj=0.002)

# Cod
COD_data.24<-subset(my_data,YEAR==2024&SPEC==10,columns )
fishPlot(COD_data.24,Species="Cod",lab=2024)

# Silver hake
SLH_data.24<-subset(my_data,YEAR==2024&SPEC==14,columns )
fishPlot(SLH_data.24,Species="Silver hake",lab=2024)

# Pollock
POL_data.24<-subset(my_data,YEAR==2024&SPEC==16,columns )
fishPlot(POL_data.24,Species="Pollock",lab=2024)

# Halibut
HAL_data.24<-subset(my_data,YEAR==2024&SPEC==30,columns )
fishPlot(HAL_data.24,Species="Halibut",lab=2024,lscale=81,nadj = 1,ladj=0.001,jadj=0.3)

# Dogfish
DOG_data.24<-subset(my_data,YEAR==2024&SPEC==220,columns )
fishPlot(DOG_data.24,Species="Dogfish",lab=2024)

# Plaice
PLA_data.24<-subset(my_data,YEAR==2024&SPEC==40,columns )
fishPlot(PLA_data.24,Species="Plaice",lab=2024)

PLA_data<-subset(my_data,SPEC==40,columns )
fishPlot(PLA_data,Species="Plaice",lab='all')

# Yellowtail
YEL_data.24<-subset(my_data,YEAR==2024&SPEC==42,columns )
fishPlot(YEL_data.24,Species="Yellowtail",lab=2024)

# Barndoor skate
BDS_data.24<-subset(my_data,YEAR==2024&SPEC==200,columns )
fishPlot(BDS_data.24,Species="Barndoor skate",lab=2024,nadj = 1,lscale=100)


# Alewife
GAS_data.24<-subset(my_data,YEAR==2024&SPEC==62 )
fishPlot(GAS_data.24,Species="Alewife",nadj = 1,lab="2024",lscale=30)


# Alewife
GAS_data<-subset(my_data,SPEC==62 )
fishPlot(GAS_data,Species="Alewife",lab="summer",lscale=30,nadj=0.1)


# Blueback
BBH_data<-subset(my_data,SPEC==165 )
fishPlot(BBH_data,Species="Alewife",lab="blueback",lscale=30,nadj=0.1)




