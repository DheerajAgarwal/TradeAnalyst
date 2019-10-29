# installing & sourcing libraries

source("./setup.R")
# source('./helpers.R')

# Source parameters ----

# baseurl <- "https://www.alphavantage.co"
# 
# ticker <- "WOW.AX"
# func <- "TIME_SERIES_DAILY_ADJUSTED"
# API_KEY <- "EUDLB81402IK8SIA"

today = Sys.Date()
great_depression = "2008-01-01"

#Loads the company stock using ticker

#getSymbols("GOOGL",from=great_depression ,to=today)
getSymbols("WOW.AX",from=great_depression ,to=today)
getSymbols("ETHI.AX",from=great_depression ,to=today)

# # Australian Stocks
# source_url <- paste0(baseurl, "/query?function=",func, "&symbol=",ticker,"&outputsize=full&apikey=",API_KEY)
# 
# # Fetch data ----
# 
# temp <- httr::GET(source_url) %>%
#   content()
# 
# meta_lastrefresh <- temp$`Meta Data`$`3. Last Refreshed`
# meta_comment <- temp$`Meta Data`$`1. Information`
# meta_refreshtz <- temp$`Meta Data`$`5. Time Zone`
# 
# # Transform ----
# 
# df <- do.call(rbind.data.frame, temp[[2]])
# df <- tibble::rownames_to_column(df, var = "Date")
# 
# df["Ticker"] <- ticker
# 
# df <- cleandf(df=df, source = baseurl, meta_lastrefresh, meta_refreshtz, meta_comment)
# WOW <- as.xts(df)
# storage.mode(WOW) <- "numeric"
