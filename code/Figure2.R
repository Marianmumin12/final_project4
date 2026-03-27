here::i_am("code/Figure2.R")

health_data <- read.csv(file = here::here("data/health_dataset.csv"))

library(tidyverse)
library(dplyr)

# 1. Prepare and Clean the Data
plot_gen_health <- health_data %>%
  # Filter for valid Immigrant status (1, 2) and valid Health states (1-5)
  filter(Immigrant %in% c(1, 2), 
         Gen_health_state %in% 1:5) %>%
  mutate(
    # Create descriptive labels
    Immigrant_Status = factor(Immigrant, 
                              levels = c(1, 2), 
                              labels = c("Landed Immigrant", "Canadian-born")),
    Health_State = factor(Gen_health_state, 
                          levels = 1:5, 
                          labels = c("Excellent", "Very Good", "Good", "Fair", "Poor"))
  ) %>%
  # Calculate percentages within each group
  count(Immigrant_Status, Health_State) %>%
  group_by(Immigrant_Status) %>%
  mutate(percent = n / sum(n) * 100)

# 2. Create the Grouped Bar Chart
Figure2 <- ggplot(plot_gen_health, aes(x = Health_State, y = percent, fill = Immigrant_Status)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  # Using professional, high-contrast colors
  scale_fill_manual(values = c("Landed Immigrant" = "#2c7fb8", "Canadian-born" = "#feb24c")) +
  labs(
    title = "General Health State: Immigrants vs. Canadian-born",
    subtitle = "Comparison of self-reported health (Percentage of Group)",
    x = "Health Rating",
    y = "Percentage (%)",
    fill = "Population Group"
  ) +
  theme_minimal() +
  theme(
    legend.position = "top",
    panel.grid.minor = element_blank()
  ) +
  # Add percentage labels on top of bars
  geom_text(aes(label = paste0(round(percent, 1), "%")), 
            position = position_dodge(width = 0.8), 
            vjust = -0.5, 
            size = 3.5)

saveRDS(
  Figure2,
  file = here::here("output/Figure2.rds")
)