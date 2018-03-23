library(rvest)
library(httr)
library(stringr)


getGoogleRelated <- function(name) {
  
  query <- URLencode(name)
  num <- 0 
  
  page <- paste("https://www.google.fr/search?num=100&espv=2&btnG=Rechercher&q=related:",
                query,"&start=", num, sep = "")
  
  #On importe la page de requête sur Google
  webpage <- read_html(page)
  
  
  #On extrait les balises A pour chaque résultat google
  googleTitle <- html_nodes(webpage, xpath="//h3/a")
  
  googleTitleText <- html_text(googleTitle)
  
  #On extrait les liens 
  hrefgoogleTitleLink <- html_attr(googleTitle, "href")
  
  #On nettoie
  googleTitleLink <- str_replace_all(hrefgoogleTitleLink, "/url\\?q=|&sa=(.*)","")
  
  DF_competitors <- data.frame(Title=googleTitleText, Link=googleTitleLink) %>%
                      mutate(dn=sub("/$","",Link))
  
  return(DF_competitors)
}