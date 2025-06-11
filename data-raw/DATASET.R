## code to prepare `DATASET` dataset goes here
#library(devtools)
#install_github("Maritimes/Mar.datawrangling")
library(Mar.datawrangling)
library(SpatialHub)
library(sf)

#uid=""
#pwd=""

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

columns<-c("YEAR","SETNO","LONGITUDE","LATITUDE","TOTNO","FLEN","CLEN_ADJ","SPEC")
rv_data <- subset(my_data,select=columns)

usethis::use_data(rv_data, overwrite = TRUE)


coast<-SpatialHub::coastMR

usethis::use_data(coast, overwrite = TRUE)

