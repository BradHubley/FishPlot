#library(devtools)
#install_github("Maritimes/Mar.datawrangling")
library(Mar.datawrangling)

uid="hubleyb"
pwd="R4#vmxtas"


# 1. Establish Oracle connection first (NEW REQUIREMENT)
cxn <- ROracle::dbConnect(DBI::dbDriver("Oracle"), uid, pwd, "PTRAN")

# 2. Extract data (first time will prompt for extraction)
RV <- new.env()
get_data(db = 'rv', cxn = cxn, env=RV)

# 3. filter the data (optional)
#RV$GSSPECIES <- RV$GSSPECIES[RV$GSSPECIES$CODE == 10,]  # Cod only
#RV$GSMISSIONS <- RV$GSMISSIONS[RV$GSMISSIONS$YEAR == 2024,]  # Recent year
RV$GSINF <- RV$GSINF[RV$GSINF$TYPE==1,]
RV$GSMISSIONS <- RV$GSMISSIONS[RV$GSMISSIONS$SEASON=="SUMMER",]
self_filter(env=RV)  # Apply filters to all related tables

# 4. Create analysis-ready dataset
my_data <- summarize_catches(morph_dets = TRUE, env=RV)

columns<-c("YEAR","SETNO","LONGITUDE","LATITUDE","TOTNO","FLEN","CLEN_ADJ")


# redfish
RED_data.24<-subset(my_data,YEAR==2024&SPEC==23,columns )
fishPlot(RED_data.24, Species="Redfish",lab=2024)
fishPlot(RED_data.24, Species="Redfish",lab=2024,type='mean.length')

RED_data.last5<-subset(my_data,YEAR%in%2020:2024&SPEC==23,columns )
fishPlot(RED_data.last5, Species="Redfish",lab="last5years")

# haddock
HAD_data.24<-subset(my_data,YEAR==2024&SPEC==11,columns )
fishPlot(HAD_data.24,Species="Haddock",lab=2024,ladj=0.002)

# Cod
COD_data.24<-subset(my_data,YEAR==2024&SPEC==10,columns )
fishPlot(COD_data.24,Species="Cod",lab=2024,nadj=1)

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

# Yellowtail
YEL_data.24<-subset(my_data,YEAR==2024&SPEC==42,columns )
fishPlot(YEL_data.24,Species="Yellowtail",lab=2024)

# Barndoor skate
BDS_data.24<-subset(my_data,YEAR==2024&SPEC==200,columns )
fishPlot(BDS_data.24,Species="Barndoor skate",lab=2024,nadj = 1,lscale=100)

