library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "signal_results.csv"))

#########################################
##plot1 = Interference power line plot ##
#########################################
int_power <- ggplot(data,
                    aes(interference_distance_km,
                        interference_power,
                        color = technology)) +
  geom_line(position = position_dodge(width = 0.5), size = 0.2) +
  scale_color_brewer(palette = "Spectral") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Interference Power",
    subtitle = "Simulated for different jammer x-y positions in the spatial \ngrid",
    x = "Jammer-Receiver Distance (km)",
    y = "Interference Power (dB)",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 4),
        legend.title = element_text(size = 4),
        legend.text = element_text(size = 4),
        plot.subtitle = element_text(size = 5),
        plot.title = element_text(size = 7),
        strip.text.x = element_blank(),
        axis.text.x = element_text(size = 4),
        axis.text.y = element_text(size = 4),
        axis.title.y = element_text(size = 4),
        axis.line = element_line(colour = "black")
  ) 

################################
##plot2 = Receiver power plot ##
################################
rec_power <- ggplot(data,
                    aes(receiver_distance_km,
                        receiver_power_dB,
                        color = technology)) +
  geom_line(position = position_dodge(width = 0.5), size = 0.2) +
  labs(
    colour = NULL,
    title = "Receiver Power",
    subtitle = "Receiver power recorded due to jamming by cellular \ngenerations",
    x = "Receiver-Transmitter Distance (km)",
    y = "Receiver Power (dB)",
    fill = "Technology"
  ) + scale_color_brewer(palette = "Spectral") +
  theme(legend.position = "right") + scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(legend.position = 'bottom', axis.title = element_text(size = 4),
    legend.title = element_text(size = 4),
    legend.text = element_text(size = 4),
    plot.subtitle = element_text(size = 5),
    plot.title = element_text(size = 7),
    strip.text.x = element_blank(),
    axis.text.x = element_text(size = 4),
    axis.text.y = element_text(size = 4),
    axis.title.y = element_text(size = 4),
    axis.line = element_line(colour = "black")
  ) 

losses <- ggarrange(
  int_power,
  rec_power,
  ncol = 2,
  nrow = 1,
  common.legend = T,
  legend = "bottom",
  labels = c("a", "b")
)

path = file.path(folder, "figures", "loss_profile.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 4.5,
  height = 3,
  res = 480
)
print(losses)
dev.off()

###########################
##ECDF 1 = Receiver Power##
###########################
ecdf_rec_power <- ggplot(data,
                         aes(x = receiver_power_dB,
                             color = jamming)) +
  stat_ecdf(size = 0.1) +
  scale_color_brewer(palette = "Spectral") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "Empirical cumulative distribution",
    subtitle = "Distribution of the received power based on the \ncellular technology",
    x = "Receiver power (dB)",
    y = "Proportions",
    fill = 'Jamming Scenario'
  ) +
  scale_y_continuous(labels = function(y)
                       format(y, scientific = FALSE),
                     expand = c(0, 0)
  ) + 
  theme(legend.position = 'bottom', axis.title = element_text(size = 4),
        legend.title = element_text(size = 4),
        legend.text = element_text(size = 4),
        plot.subtitle = element_text(size = 5),
        plot.title = element_text(size = 7),
        strip.text.x = element_blank(),
        axis.text.x = element_text(size = 4),
        axis.text.y = element_text(size = 4),
        axis.title.y = element_text(size = 4),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        axis.line = element_line(colour = "black")
  ) 

######################
##plot 4 - Bar Plot ##
######################
##### bar plot #
df = data %>%
  group_by(technology, jamming) %>%
  summarize(mean = mean(receiver_power_dB),
            sd = sd(receiver_power_dB))

df$jamming = as.factor(df$jamming)
df$technology = factor(df$technology)

df$jamming = factor(df$jamming,
                       levels = c('Low', 'Baseline', 'High'),
                       labels = c('Baseline', 'Low', 'High')
)

receiver_power <-
  ggplot(df, aes(x = technology, y = mean, fill = jamming)) +
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
  scale_fill_brewer(palette = "Spectral") + theme_minimal() +
  theme(legend.position = 'right') +
  labs(
    colour = NULL,
    title = "Receiver Power",
    subtitle = "Power received by different jamming \nscenario (Error bars: 1SD).",
    x = "Cellular Generation",
    y = "Receiver Power \n(dB)",
    fill = 'Jamming Scenario'
  ) +
  scale_y_continuous(trans = "reverse",
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + 
  theme(legend.position = 'bottom', axis.title = element_text(size = 4),
        legend.title = element_text(size = 4),
        legend.text = element_text(size = 4),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.subtitle = element_text(size = 5),
        plot.title = element_text(size = 7),
        strip.text.x = element_blank(),
        axis.text.x = element_text(size = 4),
        axis.text.y = element_text(size = 4),
        axis.title.y = element_text(size = 4),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        axis.line = element_line(colour = "black")
  ) 


ant_jamming <- ggarrange(
  receiver_power, ecdf_rec_power,
  ncol = 2,
  nrow = 1,
  common.legend = T,
  legend = "bottom",
  labels = c("a", "b")
)

path = file.path(folder, "figures", "ant_jamming.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 3.7,
  height = 2.5,
  res = 480
)
print(ant_jamming)
dev.off()









