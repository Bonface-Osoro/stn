library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "signal_results.csv"))

######################################
##plot1 = Interference power line plot
######################################
int_power <- ggplot(data,
       aes(interference_distance_km, interference_power, color = technology)) +
  geom_line() +   scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Interference Power",
    subtitle = "Inteference power as the \nposition of the jammer changes",
    x = "Interference Distance (km)",
    y = "Interference Power (dB)",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(
    axis.text.x = element_text(size = 8),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size =8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

######################################
##plot2 = Interference path loss line plot
######################################
int_power_loss <- ggplot(data,
       aes(interference_distance_km, inteference_path_loss_dB, color = technology)) +
  geom_line() +  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Interference Path Loss",
    subtitle = "Inteference path loss as the \nposition of the jammer changes",
    x = "Interference Distance (km)",
    y = "Interference Path Loss (dB)",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(
    axis.text.x = element_text(size = 8),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size =8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )
######################################
##plot3 = Receiver path loss line plot
######################################
rec_power_loss <- ggplot(data,
       aes(receiver_distance_km, receiver_path_loss_dB, color = technology)) +
  geom_line() + scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Receiver Path Loss",
    subtitle = "Receiver path loss as the \nposition of the jammer changes",
    x = "Receiver Distance (km)",
    y = "Receiver Path Loss (dB)",
    fill = "Technology"
  ) + scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(
    axis.text.x = element_text(size = 8),
    axis.line = element_line(colour = "black")
  ) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size =8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

losses <- ggarrange(
  int_power,
  int_power_loss,
  rec_power_loss,
  ncol = 3,
  common.legend = T,
  legend = "bottom",
  labels = c("a", "b", "c")
)

path = file.path(folder, "figures", "loss_profile.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 8,
  height = 4,
  res = 480
)
print(losses)
dev.off()







