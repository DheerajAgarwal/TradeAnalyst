list.of.packages <- c("corrplot",
                      "curl",
                      "dplyr",
                      "DT",
                      "forcats",
                      "ggplot2",
                      "httr",
                      "lubridate",
                      "PerformanceAnalytics",
                      "quantmod",
                      "plotly",
                      "rvest",
                      "shiny",
                      "stringr",
                      "tidyverse",
                      "xts"
                      )
cat("Checking if all necessary packages are available..................\n")

missing.packages <-
  list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]

if (length(missing.packages)){
  cat("Installing Missing libraries..................\n")
  install.packages(missing.packages)
} else {
  cat("all needed packages are already installed..................\n")
}

# load all required libraries

for(i in 1:length(list.of.packages))
{
  eval(bquote(library(.(list.of.packages[i]))))
}

# rm(list.of.packages)
rm(missing.packages, i, list.of.packages)
