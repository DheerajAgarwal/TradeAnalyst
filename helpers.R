cleandf <- function(df=NULL, source = NA, ...){
  col_names <- c("Date", "Open", "High", "Low", "Close", "Adjusted", "Volume", "Dividend", "SplitCoeff", "Ticker")
  colnames(df) <- col_names
  df$Date <- as.Date(df$Date)
  rownames(df) <- df$Date
  col_order <- c("Date", "Ticker", "Open", "High", "Low", "Close", "Adjusted", "Volume", "Dividend", "SplitCoeff")
  df <- df[, col_order]
  df <- data.frame(df,
                   "LastFetched" = Sys.Date(),
                   "Source" = source,
                   "LastSourceRefresh" = meta_lastrefresh,
                   "SourceTimeZone" = meta_refreshtz,
                   "Comments" = meta_comment
  )
  
  df <- df[, c("Open", "High", "Low", "Close", "Volume", "Adjusted") ]
  # df <- data.frame(df, "Source" = source)
  return(df)
}