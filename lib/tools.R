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

library(rlist)
library(tidyr)


extractTags <- function(list) {
  
   drops <- c("generator","og:site_name","X-Parsed-By","X-TIKA:content","X-TIKA:digest:MD5", "X-TIKA:parse_time_millis", "tika:file_ext", "tika_batch_fs:relative_path", "X-TIKA:content")
   
  
  tryCatch({
    
    parsedHTML <- htmlParse(list$`X-TIKA:content`, encoding="UTF-8")
    
    #listAhref <- xpathSApply(parsedHTML, "//a", xmlGetAttr, 'href')
    #list <- list.append(list, "aHref"=listAhref)
    #listAhrefSameHost <- tika_listAhref[which(grepl(url, tika_listAhref))]
    #listAhrefOtherHost <- tika_listAhref[which(!grepl(url, tika_listAhref))]    
    #listImgSrc <- xpathSApply(parsedHTML, "//img", xmlGetAttr, 'src')

    
    ################## H1 ####################
    H1 <- xpathSApply(parsedHTML, "//h1", xmlValue)
    
    listH1 <- ""
    list['h1-1 Length'] <- 0
    if (length(H1)>0) {
      listH1 <- H1[H1 != ""]
      # List transformation
      listH1 <- strsplit(listH1, "\n")
    }
    
    list <- list.append(list, "h1-"=head(listH1,3))
    ######################################
    
    ################## H2 ####################
    H2 <- xpathSApply(parsedHTML, "//h2", xmlValue)
    
    listH2 <- ""
    list['h2-1 Length'] <- 0
    if (length(H2)>0) {
      listH2 <- H2[H2 != ""]
      # List transformation
      listH2 <- strsplit(listH2, "\n")
    }
    
    list <- list.append(list, "h2-"=head(listH2,3))
    ######################################
    
    

    # Drop certain columns
    list <- list[-which(names(list) %in% drops)]
    
    # We keep only one level with flatten method
    list <- lapply(list, na.exclude) 
    list <- list.flatten(list)
    
    # encoding error with some tags because of <b><br/>.
    list <- lapply(list, toString)    
    
    # Fix dynamic names after flatten method
    names(list)[names(list)=="h1-"] <- "h1-1"
    list['h1-1 Length'] <- nchar(list['h1-1'])
    
    return(list)
    
  })
  
}


#TODO : get last url
# detectExpire %<-% function(x) {
#   
#   #print(x)
#   
#   l <- list()
#   
#   l['Url'] <- x
#   l['res'] <- ""
#   
#   tryCatch({
#     
#     # timeout si le header ne repond pas
#     options(timeout = 1)
#     result <- curlGetHeaders(x)
#     status_code <- attr(result,"status")
#     
#     #TODO: get last URL
#     
#     if ( status_code == 200 )
#       l['res'] <- "200"
#     else 
#       l['res'] <- "No OK"
#     
#     
#   }
#   ,error = function(e) {
#     l['res'] <- "Expired"
#   }
#   )
#   
#   return(l)
# }
