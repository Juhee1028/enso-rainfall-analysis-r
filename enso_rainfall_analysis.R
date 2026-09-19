# ENSO and Summer Rainfall Analysis in Brisbane
# Investigates relationships between SOI, ENSO phase, and seasonal rainfall.

library(tidyverse)
library(broom)

dir.create("figures", showWarnings = FALSE)

# 1. Load and prepare data
rainfall <- read_csv("data/total_seasonal_rainfall.csv", show_col_types = FALSE)
soi <- read_csv("data/seasonal_soi_data.csv", show_col_types = FALSE)

joined_data <- inner_join(rainfall, soi, by = c("Year", "Season"))

rainfall_data <- joined_data %>%
  transmute(
    station_id = id,
    station_name = name,
    season = factor(
      Season,
      levels = c("Summer", "Autumn", "Winter", "Spring"),
      ordered = TRUE
    ),
    year = Year,
    rainfall_mm = total_seas_prcp,
    seasonal_soi = SeasonalSOI,
    enso_phase = factor(
      Phase,
      levels = c("Neutral", "ElNino", "LaNina")
    )
  ) %>%
  drop_na(season, year, rainfall_mm, seasonal_soi, enso_phase)

message("Rows retained for analysis: ", nrow(rainfall_data))

# 2. Explore the SOI-rainfall relationship across seasons
season_plot <- ggplot(
  rainfall_data,
  aes(x = seasonal_soi, y = rainfall_mm)
) +
  geom_point(alpha = 0.65) +
  geom_smooth(method = "lm", formula = y ~ x, colour = "#1565C0") +
  facet_wrap(~ season) +
  labs(
    title = "Seasonal SOI and Rainfall at Brisbane Airport",
    x = "Mean seasonal SOI",
    y = "Total seasonal rainfall (mm)"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/seasonal_soi_rainfall.png", season_plot,
       width = 9, height = 6, dpi = 300)

# Compare the seasonal regression slopes without repeating four models
season_results <- rainfall_data %>%
  group_by(season) %>%
  group_modify(~ tidy(
    lm(rainfall_mm ~ seasonal_soi, data = .x),
    conf.int = TRUE
  )) %>%
  filter(term == "seasonal_soi")

print(season_results)

# 3. Compare linear and quadratic summer models
summer_data <- rainfall_data %>%
  filter(season == "Summer") %>%
  droplevels()

linear_model <- lm(rainfall_mm ~ seasonal_soi, data = summer_data)
quadratic_model <- lm(
  rainfall_mm ~ seasonal_soi + I(seasonal_soi^2),
  data = summer_data
)

print(tidy(linear_model, conf.int = TRUE))
print(glance(linear_model))
print(tidy(quadratic_model, conf.int = TRUE))
print(glance(quadratic_model))
print(anova(linear_model, quadratic_model))

prediction_values <- tibble(seasonal_soi = c(-25, 25))
print(predict(
  quadratic_model,
  newdata = prediction_values,
  interval = "prediction",
  level = 0.95
))

# 4. Check linear-model assumptions
diagnostics <- augment(linear_model)

residual_plot <- ggplot(diagnostics, aes(.fitted, .resid)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "#C62828") +
  geom_point(alpha = 0.7) +
  geom_smooth(se = FALSE, colour = "#1565C0") +
  labs(
    title = "Residuals and Fitted Values",
    x = "Fitted rainfall (mm)",
    y = "Residuals (mm)"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/linear_model_residuals.png", residual_plot,
       width = 7, height = 5, dpi = 300)

# 5. Compare rainfall across ENSO phases
phase_anova <- aov(rainfall_mm ~ enso_phase, data = summer_data)
print(summary(phase_anova))
print(TukeyHSD(phase_anova))
print(bartlett.test(rainfall_mm ~ enso_phase, data = summer_data))

# Robust alternative when group variances are unequal
print(oneway.test(
  rainfall_mm ~ enso_phase,
  data = summer_data,
  var.equal = FALSE
))

phase_model <- lm(rainfall_mm ~ enso_phase, data = summer_data)
print(tidy(phase_model, conf.int = TRUE))
print(glance(phase_model))

phase_plot <- ggplot(summer_data, aes(enso_phase, rainfall_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.08, alpha = 0.65, colour = "#1565C0") +
  labs(
    title = "Summer Rainfall by ENSO Phase",
    x = "ENSO phase",
    y = "Total summer rainfall (mm)"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/rainfall_by_enso_phase.png", phase_plot,
       width = 7, height = 5, dpi = 300)

# 6. Test whether ENSO phases occur equally often
phase_counts <- table(summer_data$enso_phase)
print(phase_counts)
print(chisq.test(phase_counts))
