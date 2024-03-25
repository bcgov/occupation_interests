library(tidyverse)
library(here)
library(readxl)
library(janitor)


desired_nocs <- read_excel(
  here("data", "Occupational Characteristics w skills interests wages.xlsx"),
  skip = 0,
  na = "x"
  )|>
  select(NOC)

interests <- read_excel(here("data","Interests.xlsx"))
mapping <- read_excel(here('data',"onet2019_soc2018_noc2016_noc2021_crosswalk.xlsx"))|>
  mutate(noc2021=str_pad(noc2021, width=5, "left","0"),
         noc2021=paste0("#",noc2021)
  )

full_join(interests, mapping,
                    by=join_by("O*NET-SOC Code"=="onetsoc2019"),
                    relationship = "many-to-many")|>
  filter(`Scale Name`=="Occupational Interests")|>
  group_by(noc2021, `Element Name`)|>
  summarise(`Data Value`=mean(`Data Value`, na.rm = TRUE))|>
  group_by(noc2021, .add = FALSE)|>
  slice_max(`Data Value`, n=3, with_ties = FALSE)|>
  write_csv(here("out","top3_interests_by_noc.csv"))
