here::i_am("code/table1.R")

health_data <- read.csv(
  file = here::here("data/health_dataset.csv")
)


library(tidyverse)
library(gtsummary)
library(dplyr)
library(here)

table1 <- health_data |>
  # 1. Removes 7, 8, 9 for Belonging and 97-99 for Satisfaction)
  filter(Immigrant %in% 1:2, 
         Sense_belonging %in% 1:4, 
         Life_satisfaction <= 10) |>
  
  # 2. Add Labels 
  mutate(
    Immigrant = factor(Immigrant, labels = c("Landed Immigrant", "Canadian-born")),
    Sense_belonging = factor(Sense_belonging, 
                             labels = c("Very strong", "Somewhat strong", "Somewhat weak", "Very weak"))
  ) |>
  select(Immigrant, Sense_belonging, Life_satisfaction) |>
  
  # 3. Generate Table
tbl_summary(
    by = Immigrant,
    label = list(
      Sense_belonging ~ "Community Belonging",
      Life_satisfaction ~ "Life Satisfaction (0-10)"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ({sd}) [{min} - {max}]",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = all_continuous() ~ 2
  ) |>
  add_p() |>
  bold_labels() |>
  modify_spanning_header(all_stat_cols() ~ "**Immigration Status**")

 
saveRDS(
  table1,
  file = here::here("output/table1.rds")
)

