library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "cost_results.csv"))

###############################
## plot1 = Interception Cost ##
###############################
df = data %>%
  filter(probability_type == "interception_cost")
df = data %>%
  group_by(windtexter, application) %>%
  summarize(mean = mean(probability_cost),
            sd = sd(probability_cost))

df$application = as.factor(df$application)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter,
                       levels = c('Baseline', 'Partial', 'Full'),
                       labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)
df$application = factor(df$application,
                        levels = c('private', 'commercial', 'government', 'millitary'),
                        labels = c('Private', 'Commercial', 'Government', 'Millitary')
)

interception_costs <-
  ggplot(df, aes(x = windtexter, y = mean, fill = application)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean - sd*0.15,
        ymax = mean + sd*0.15),
    width = .2,
    position = position_dodge(.9),
    color = 'black',
    size = 0.05
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "(A) Interception Losses",
    subtitle = "Losses incurred by different segments \nof the economy due to interception of \nthe messages (Error bars: 1SD).",
    x = NULL,
    y = "Interception Losses\n(US$)",
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
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 7)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    plot.title = element_text(size = 8)
  )

###########################
## plot2 = Blocking Cost ##
###########################
df = data %>%
  filter(probability_type == "message_block_cost")
df = data %>%
  group_by(windtexter, application) %>%
  summarize(mean = mean(probability_cost),
            sd = sd(probability_cost))

df$application = as.factor(df$application)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter,
                       levels = c('Baseline', 'Partial', 'Full'),
                       labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)
df$application = factor(df$application,
                        levels = c('private', 'commercial', 'government', 'millitary'),
                        labels = c('Private', 'Commercial', 'Government', 'Millitary')
)

blocking_costs <-
  ggplot(df, aes(x = windtexter, y = mean, fill = application)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean - sd*0.15,
        ymax = mean + sd*0.15),
    width = .2,
    position = position_dodge(.9),
    color = 'black',
    size = 0.05
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "(B) Blocking Losses",
    subtitle = "Losses incurred by different segments \nof the economy due to interception of \nthe messages (Error bars: 1SD).",
    x = NULL,
    y = "Blocking Losses\n(US$)",
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
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 7)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    plot.title = element_text(size = 8)
  )


#######################
##plot3 = Total Cost ##
#######################

df = data %>%
  group_by(windtexter, application) %>%
  summarize(mean = mean(total_cost),
            sd = sd(total_cost))

df$application = as.factor(df$application)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter,
                        levels = c('Baseline', 'Partial', 'Full'),
                        labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
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
    aes(ymin = mean - sd*0.15,
        ymax = mean + sd*0.15),
    width = .2,
    position = position_dodge(.9),
    color = 'black',
    size = 0.05
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
      title = "(C) Total Losses",
    subtitle = "Total losses incurred by \ndifferent segments of the \neconomy (Error bars: 1SD).",
    x = NULL,
    y = "Total Losses\n(US$)",
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
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 7)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    plot.title = element_text(size = 8)
  )


costs <- ggarrange(
  interception_costs, blocking_costs, total_costs,
  ncol = 3,
  common.legend = T,
  legend = "bottom"
) 

path = file.path(folder, "figures", "socio_costs.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 6,
  height = 2.5,
  res = 480
)
print(costs)
dev.off()






