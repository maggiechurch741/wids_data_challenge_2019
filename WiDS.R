library(tidyverse)
library(choroplethr)
library(choroplethrMaps)

# Data comes from the 2013 5-year American Community Survey (ACS).
data(df_county_demographics)

demog_choro <- df_county_demographics %>%
  select(region, percent_black) %>%
  rename("value" = percent_black)

# Breast Cancer Data from CDC 
cdc <- read.delim("/fsr/home/m1mgc02/Personal/wids_data_challenge_2019-master/Compressed Mortality, 1999-2016.txt") 

# crude rate = death/population * 100,000. Age adjustment is a technique for "removing" the effects of age from crude rates.
# Rates are marked as "unreliable" when the death count is less than 20.


# Clean data
cdc_clean <- cdc %>% 
  mutate(unreliable = str_detect(`Crude.Rate`, "Unreliable")) %>%
  mutate(Crude.Rate = str_replace(`Crude.Rate`, "\\(Unreliable\\)", "")) %>%
  mutate(Crude.Rate = as.numeric(`Crude.Rate`)) %>%
  mutate(Age.Adjusted.Rate = str_replace(`Age.Adjusted.Rate`, "\\(Unreliable\\)", "")) %>%
  mutate(Age.Adjusted.Rate = as.numeric(`Age.Adjusted.Rate`))

# Format data for Choroplethr
cdc_choro <- cdc_clean %>% 
  filter(!is.na(Age.Adjusted.Rate)) %>%
  rename("value" = Age.Adjusted.Rate) %>%
  rename("region" = County.Code) %>%
  select(value, region)

county_choropleth(demog_choro)
county_choropleth(cdc_choro)


