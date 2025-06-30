

files <- list.files(path=file.path("inst","fish","andes"))
file.rename(file.path("inst","fish","andes",files),file.path("inst","fish","andes", paste0(substr(files,1,4),".png")))

#library(devtools)
#install_github("Maritimes/Mar.datawrangling")
library(Mar.datawrangling)

uid=""
pwd=""


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

RED_data.last5<-subset(rv_data,YEAR%in%2020:2024&SPEC==23 )
fishPlot(RED_data.last5, SP=23,lab="last5years")




