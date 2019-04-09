library(tidyverse)
library(choroplethr)
library(choroplethrMaps)

# Breast Cancer Data from CDC 
cdc <- read.delim("/fsr/home/m1mgc02/Personal/wids_data_challenge_2019-master/Compressed Mortality, 1999-2016.txt") 

# Crude rate = death/population * 100,000. Age adjustment is a technique 
# for "removing" the effects of age from crude rates.


# Create a new variable for "Unreliable" data (when the death count is less than 20)
cdc_clean <- cdc %>% 
  mutate(unreliable = str_detect(`Crude.Rate`, "Unreliable")) %>%
  mutate(Crude.Rate = str_replace(`Crude.Rate`, "\\(Unreliable\\)", "")) %>%
  mutate(Crude.Rate = as.numeric(`Crude.Rate`)) %>%
  mutate(Age.Adjusted.Rate = str_replace(`Age.Adjusted.Rate`, "\\(Unreliable\\)", "")) %>%
  mutate(Age.Adjusted.Rate = as.numeric(`Age.Adjusted.Rate`)) %>%

  # Rename region for ease of the merge and plotting
  rename(region = "County.Code")

# Data comes from the 2013 5-year American Community Survey (ACS).
data(df_county_demographics)

# Merge CDC with demographic data
cdc_full <- inner_join(cdc_clean, df_county_demographics, by = "region")

# Map Choroplethr
choro <- function(df, var){
  var.enquo <- enquo(var)
  
  df %>% 
    filter(!is.na(!!var.enquo)) %>%
    rename("value" = !!var.enquo) %>%
    select(value, region) %>%
    county_choropleth() 
}

cdc_full %>% choro(Age.Adjusted.Rate) 



