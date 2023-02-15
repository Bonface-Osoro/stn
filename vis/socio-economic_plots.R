library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "windtexter_results.csv"))

#######################
##plot1 = Total Cost ##
#######################

df = data %>%
  group_by(message_status, windtexter) %>%
  summarize(mean = mean(total_cost),
            sd = sd(total_cost))

df$windtexter = as.factor(df$windtexter)
df$message_status = factor(df$message_status)
df$message_status = factor(df$message_status,
                       levels = c('sucessful', 'unsuccessful'),
                       labels = c('Sucessful', 'Unsucessful')
)
df$windtexter = factor(df$windtexter,
                  levels = c('Baseline', 'Partial', 'Full'),
                  labels = c('Baseline', 'Partial', 'Full')
                  )

total_cost <-
  ggplot(df, aes(x = message_status, y = mean, fill = windtexter)) +
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

##############################
##plot2 = Intercepting Cost ##
##############################
df = data %>%
  group_by(message_status, windtexter) %>%
  summarize(mean = mean(interception_cost),
            sd = sd(interception_cost))

df$windtexter = as.factor(df$windtexter)
df$message_status = factor(df$message_status)
df$message_status = factor(df$message_status,
                           levels = c('sucessful', 'unsuccessful'),
                           labels = c('Sucessful', 'Unsucessful')
)
df$windtexter = factor(df$windtexter,
                       levels = c('Baseline', 'Partial', 'Full'),
                       labels = c('None', 'Partial', 'Full')
)

interception_cost <-
  ggplot(df, aes(x = message_status, y = mean, fill = windtexter)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean - sd,
        ymax = mean + sd),
    width = .2,
    position = position_dodge(.9),
    color = 'blue',
    size = 0.1
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "(A) Interception Costs",
    subtitle = "Costs due to interception of the messages by \nsecure texting strategy (Error bars: 1SD).",
    x = NULL,
    y = "Total cost\n(US$)",
    fill = 'Multi-transmission'
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
    axis.text.x = element_text(size = 4),
    axis.text.y = element_text(size = 4),
    axis.title.y = element_text(size = 4),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 4)) +
  theme(
    legend.title = element_text(size = 4),
    legend.text = element_text(size = 4),
    plot.subtitle = element_text(size = 4),
    plot.title = element_text(size = 7)
  )



##########################
##plot3 = Blocking Cost ##
##########################
df = data %>%
  group_by(message_status, windtexter) %>%
  summarize(mean = mean(message_block_cost),
            sd = sd(message_block_cost))

df$windtexter = as.factor(df$windtexter)
df$message_status = factor(df$message_status)
df$message_status = factor(df$message_status,
                           levels = c('sucessful', 'unsuccessful'),
                           labels = c('Sucessful', 'Unsucessful')
)
df$windtexter = factor(df$windtexter,
                       levels = c('Baseline', 'Partial', 'Full'),
                       labels = c('None', 'Partial', 'Full')
)

blocking_cost <-
  ggplot(df, aes(x = message_status, y = mean, fill = windtexter)) +
  geom_bar(stat = "identity",
           position = position_dodge(),
           width = 0.98) +
  geom_errorbar(
    aes(ymin = mean - sd,
        ymax = mean + sd),
    width = .2,
    position = position_dodge(.9),
    color = 'blue',
    size = 0.1
  ) +
  scale_fill_brewer(palette = "Accent") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "(B) Blocking",
    subtitle = "Costs due to blocking of the messages by \nsecure texting strategy (Error bars: 1SD).",
    x = NULL,
    y = "Total cost\n(US$)",
    fill = 'Multi-transmission'
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
    axis.text.x = element_text(size = 4),
    axis.text.y = element_text(size = 4),
    axis.title.y = element_text(size = 4),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 4)) +
  theme(
    legend.title = element_text(size = 4),
    legend.text = element_text(size = 4),
    plot.subtitle = element_text(size = 4),
    plot.title = element_text(size = 7)
  )

costs <- ggarrange(
  interception_cost, blocking_cost,
  ncol = 2,
  nrow = 1,
  common.legend = T,
  legend = "bottom"
) 

path = file.path(folder, "figures", "costs.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 3.7,
  height = 2.0,
  res = 480
)
print(costs)
dev.off()









