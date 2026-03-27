here::i_am("code/Figure1.R")

health_data <- read.csv(file = here::here("data/health_dataset.csv"))

library(ggplot2)
library(dplyr)

Figure1 <- health_data |>
  # 1. Same cleaning as your table
  filter(Immigrant %in% 1:2, Sense_belonging %in% 1:4) |>
  mutate(
    Immigrant = factor(Immigrant, labels = c("Landed Immigrant", "Canadian-born")),
    Sense_belonging = factor(Sense_belonging, 
                             labels = c("Very strong", "Somewhat strong", "Somewhat weak", "Very weak"))
  ) |>
  
  # 2. Create the plot
  ggplot(aes(x = Sense_belonging, fill = Immigrant)) +
  geom_bar(position = "dodge", stat = "count") +
  labs(
    title = "Sense of Belonging: Immigrants vs. Canadian-born",
    x = "Level of Belonging",
    y = "Number of Respondents",
    fill = "Status"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") # Professional color scheme

saveRDS(
  Figure1,
  file = here::here("output/Figure1.rds")
)