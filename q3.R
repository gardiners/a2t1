# Q3 R script

# Required packages
# -----------------
library(tidyverse)

# Data acquisition
# ----------------
# Read the World Bank population dataset:
pop <- read_csv("https://raw.githubusercontent.com/datasets/population/master/data/population.csv")

# Read the JHU COVID-19 deaths dataset.
covid_wide <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")

# Data cleaning
# -------------
covid_latest <- covid_wide %>%
  select(Country = `Country/Region`,  # Rename variables to meet R conventions.
         Region = `Province/State`,
         Deaths = `4/25/20`) %>%      # Select only today's totals column.
  group_by(Country) %>%               # Aggregate over entire countries.
  summarise(n = sum(Deaths))

glimpse(covid_latest)                 # Examine.

pop_latest <- pop %>%               
  group_by(`Country Code`) %>%        # Retain only the latest year's data
  top_n(1, Year)                      # for each country in the dataset.

glimpse(pop_latest)                   # Examine.

# Join the datasets
# -----------------
deaths <- covid_latest %>%
  # Join on country name:
  left_join(pop_latest, by = c("Country" = "Country Name")) %>% 
  # Rename variables for easy plotting, and compute death rate
  transmute(Country = Country,
            Deaths = n,
            Population = Value,
            Deaths_per_100k = Deaths / Population * 1e5)

glimpse(deaths) # Examine

# Select countries of interest
# ----------------------------

countries <- c( "Australia", "Belgium", "Spain", "Italy", "France",
                "Netherlands", "Sweden", "Ireland", "Switzerland",
                "Portugal", "Denmark", "Germany", "Austria")

deaths_subset <- deaths %>%
  filter(Country %in% countries) %>%
  mutate(Country = factor(Country,
                          levels = arrange(., Deaths_per_100k)$Country))

# Plot
# ----

ggplot(deaths_subset, aes(Deaths_per_100k, Country)) +
  geom_bar(stat = "identity", width = 0.6, fill = "deepskyblue4") +
  labs(x = NULL, y = NULL,
       title = "German efficiency\nCovid-19 deaths per 100,000 population",
       subtitle = "Selected European countries and Australia, to April 25th 2020",
       caption = "Sources: Johns Hopkins University; World Bank") +
  theme_minimal() +
  theme(axis.text.y = element_text(hjust = 0),
        axis.line.y.left = element_line(colour = "black"),
        panel.grid.major.y = element_blank(),
        plot.caption = element_text(hjust = 0, colour = "slategrey"),
        plot.caption.position = "plot",
        plot.title.position = "plot") +
  scale_x_continuous(breaks = seq(0, 60, 10),
                     minor_breaks = NULL,
                     position = "top",
                     expand = c(0, 0))

