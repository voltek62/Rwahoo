
if(!requireNamespace('devtools')){
  install.packages('devtools', 
                   repos = 'https://cloud.r-project.org')
}

if(!requireNamespace('rtika')){
  devtools::install_github('ropensci/rtika')
}

packages <- c("rlist", "rvest", "stringr","magrittr", "data.table", "XML") 
if (length(setdiff(packages, rownames(installed.packages()))) > 0) { 
  install.packages(setdiff(packages, rownames(installed.packages()))) 
}


source("./api/semrush.R")
source('./tools.R')
source("./getGoogleRelated.R")

##################################################
#step 1: get the max near competitor of the domain
##################################################

#semrush <- semrushGetInfoByUrl("ovh.com")
#tranform into a vector of valid URLS for Apache Tika
#if (!grepl("http",semrush$dn[1]))
#  semrush$dn <- paste0("http://", semrush$dn)
#URLs <- head(semrush,20)

# Test with Google
URLs <- getGoogleRelated("seo-camp.org")


###################################
#step 2: apache tika crawl metadata
###################################



library(rtika)
library(magrittr)
library(data.table)
library(XML)


if(is.na(tika_jar())){
  install_tika()
}


# URL checking is long ??? or Apache Tika is slow to launch : Rewrite the Rtika Package with boost mode
metadata <- tika_json(URLs$dn, 
                        threads=40, 
                        timeout=3000, 
                        max_restarts=1, 
                        cleanup=FALSE,
                        quiet=FALSE
                      )
# remove no resut
metadata <- metadata[!is.na(metadata)]
# transform into list
metadata <- lapply(metadata, jsonlite::fromJSON)
#save(metadata, file="export.JSON")

data <- lapply(metadata, extractTags)

###################################
# step 3 - making an amazing report
###################################

library(DataExplorer)
library(ggplot2)

DF <- rbindlist(data, fill=TRUE)


create_report(DF)

