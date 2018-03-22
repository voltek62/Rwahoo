library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)

source("./api/conf.R")

### API SEMRUSH

# be careful with duplicate

semrushGetInfoByUrl <- function(myDomain) {
  
  url <- paste("https://api.semrush.com/?type=domain_organic_organic&key=[YOUR SEMRUSH API KEY]&display_limit=100&export_columns=Dn&domain=",myDomain,"&database=fr", sep = "")
  
  print(url)
  
  filename <- tempfile()
  
  f <- CFILE(filename, "wb")
  curlPerform(url = url
              , writedata = f@ref
              , encoding = "ISO-8859-1"
              #, verbose = TRUE
  )
  close(f)
  
  result <- read.csv2( filename, header = TRUE
                       , sep=";"
                       , encoding = "UTF-8"
                       , stringsAsFactors = FALSE) 
  
  colnames(result) <- c("dn")
  

  
 
  
  return(result)
}

#semrush <- semrushGetInfoByUrl("ovh.com","fr", 2)