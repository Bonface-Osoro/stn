library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "cost_results.csv"))

#######################
##plot1 = Total Cost ##
#######################

df = data %>%
  group_by(application, windtexter) %>%
  summarize(mean = mean(total_cost),
            sd = sd(total_cost))

df$windtexter = as.factor(df$windtexter)
df$application = factor(df$application)
df$application = factor(df$application,
                           levels = c('private', 'commercial', 'government', 'millitary'),
                           labels = c('Private', 'Commercial', 'Government', 'Millitary')
)
df$windtexter = factor(df$windtexter,
                levels = c('Baseline', 'Partial', 'Full'),
                labels = c('Baseline', 'Partial', 'Full')
)

total_cost <-
  ggplot(df, aes(x = application, y = mean, fill = windtexter)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean - sd,
        ymax = mean + sd),
    width = .2,
    position = position_dodge(.9),
    color = 'black',
    size = 0.3
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "Jamming Costs",
    subtitle = "By anti-jamming strategy (Error bars: 1SD).",
    x = NULL,
    y = "Total cost\n(US$)",
    fill = 'Anti-jamming Approach'
  ) +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme_minimal() + theme(plot.title = element_text(face = "bold")) +
  theme(
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 7),
    axis.text.y = element_text(size = 7),
    axis.title.y = element_text(size = 7),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 7),
    legend.text = element_text(size = 7),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )



#######################
##plot1 = Total Cost ##
#######################

df = data %>%
  group_by(windtexter, application) %>%
  summarize(mean = mean(total_cost),
            sd = sd(total_cost))

df$application = as.factor(df$application)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter,
                        levels = c('Baseline', 'Partial', 'Full'),
                        labels = c('Baseline', 'Partial', 'Full')
)
df$application = factor(df$application,
                       levels = c('private', 'commercial', 'government', 'millitary'),
                       labels = c('Private', 'Commercial', 'Government', 'Millitary')
)

total_costs <-
  ggplot(df, aes(x = windtexter, y = mean, fill = application)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean - sd,
        ymax = mean + sd),
    width = .2,
    position = position_dodge(.9),
    color = 'black',
    size = 0.3
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
      title = "Total Losses",
    subtitle = "Total losses incurred by different segments of the economy (Error bars: 1SD).",
    x = NULL,
    y = "Total cost\n(US$)",
    fill = 'Application Area'
  ) +
  scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme_minimal() + theme(plot.title = element_text(face = "bold")) +
  theme(
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 7),
    axis.text.y = element_text(size = 7),
    axis.title.y = element_text(size = 7),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 7),
    legend.text = element_text(size = 7),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )









