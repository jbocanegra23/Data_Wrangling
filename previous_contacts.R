
## Let’s say a marketing campaign connected with a member of a household and did not 
## want to re-contact with the same household even though member #2 of the household 
## is labeled as no contact. Further, let’s assume the parent database can only handle
## individual level data rather than household, thus we need to purposeful tag ALL members
## of a household as a “no-contact”. So here is how one can do it and essentially automate
## assuming that the process of loading back to parent database cannot be supported by
## some form of API:

library(readr)
library(readxl)
library(WriteXLS)
library(tidyr)
library(dplyr)

## Underlying
data <- read_csv(“full_data.csv”)

data$Addressid <- paste(data$`Address -MyData`, 
                        data$`Address Line 2 -MyData`, 
                        data$`City -MyData`, 
                        data$`Zip -MyData`, sep = "_")

## Previous Contacts Algorithm

previous_contacts <- function (file, final_file) {
  ## setwd for source file here
  survey_data <- read_excel(file)
  survey_data <- survey_data %>% select(UID) %>% 
      mutate(helper = 1)
  households.touched <- data %>% left_join(survey_data, by = "UID") %>% 
      select(UID, Addressid, helper) %>%
      group_by(Addressid) %>%
      summarise(helper1 = sum(helper, na.rm = TRUE)) %>%
      filter(helper1 > 0)
  data.complete <- data %>% left_join(households.touched, by = "Addressid") %>%
      filter(helper1 > 0)
  final.data <- data.complete %>% select(UID, `State -MyData.`)
  ## setwd for destination file here
  WriteXLS(final.data, final_file)
}

## Test of previous contacts algorithm
previous_contacts(file = "survey_results_test.xlsx", 
                  final_file = "previous_contacts_test.xlsx")

## Success!


