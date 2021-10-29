# 1.load library 
library(sf)
library(sp)
library(tidyverse)
library(janitor)
library(here)
library(ggplot2)
library(here)
library(rgdal)
library(tmap)
library(RSQLite)
library(countrycode)

# 2.load gender inequality csv 
gender <- read_csv(here::here('data',
                        'Gender Inequality Index (GII).csv'),
                   locale = locale(encoding = 'latin1'), skip=5,na='..')

# 3.load world spatial data 
world <- st_read(here("Data", 
                      "World_Countries_(Generalized)", 
                      "World_Countries__Generalized_.shp"))

# 4.data manipulation 
genderDiffer <- gender %>% 
  clean_names() %>% 
  select(country,x2019,x2010) %>% 
  mutate(differ=x2019-x2010) %>% 
  slice(1:189,) %>% 
  mutate(iso_code=countrycode(country,
                              origin ='country.name', destination = 'iso2c' ))

# join spatial data 
genderJoin <- world %>% 
  clean_names() %>% 
  left_join(.,
            genderDiffer, 
            by=c('aff_iso'='iso_code'))

# 5.plot map
tmap_mode('plot')
qtm(genderJoin,
    fill='x2010')
qtm(genderJoin,
    fill='x2019')
qtm(genderJoin,
    fill='differ')




