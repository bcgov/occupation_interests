library(tidyverse)
library(here)
library(readxl)
library(janitor)

original_interests <- read_excel(here("data","Occupational interest by NOC2021 occupation.xlsx"))

five_more <- read_csv(here("data","five_more.csv"))|>
  mutate(`NOC 2021`=str_pad(`NOC 2021`, width=5, side = "left", pad = "0"))|>
  pivot_longer(cols = 3:5, names_to = "Options", values_to = "Occupational Interest")

full_join(original_interests, five_more)|>
  arrange(`NOC 2021`)|>
  openxlsx::write.xlsx(here("out", "Occupational interest by NOC2021 occupation_plus_5.xlsx"))
