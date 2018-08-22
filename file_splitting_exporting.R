
library(readr)
library(WriteXLS)
library(dplyr)

data1 <- read_csv(“All_Data.csv”)

districts <- unique(sort(data$District))
districts.1 <- paste(“Geo”, districts, sep = "_")
file_names <- paste(districts.1, ".xlsx", sep = "")

sep_function <- function(data, a, name) {
  data %>% filter(District == a) %>%
  WriteXLS(name)
}
  
## setwd to destination files. 

for(i in 1:14) {
  sep_function(districts[i], file_names[i])
}

## This simple and efficient algorithm allows the user to 
## export full data from a parent source in mass and then
## separate the data file as a deliverable to set destination.