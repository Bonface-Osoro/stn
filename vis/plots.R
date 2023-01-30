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
  geom_line(position = position_dodge(width = 0.5)) +
  scale_fill_brewer(palette = "Paired") +
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
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

#############################################
##plot2 = Interference path loss line plot ##
#############################################
int_power_loss <- ggplot(data,
                         aes(interference_distance_km, 
                             inteference_path_loss_dB, 
                             color = technology)) +
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
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )
#########################################
##plot3 = Receiver path loss line plot ##
#########################################
rec_power_loss <- ggplot(data,
                         aes(receiver_distance_km,
                             receiver_path_loss_dB,
                             color = technology)) +
  geom_line() +
  labs(
    colour = NULL,
    title = "Receiver Path Loss",
    subtitle = "Receiver path loss as the \nposition of the jammer changes",
    x = "Receiver Distance (km)",
    y = "Receiver Path Loss (dB)",
    fill = "Technology"
  ) + scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") + scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )


################################
##plot3 = Receiver power plot ##
################################
rec_power <- ggplot(data,
                         aes(receiver_distance_km,
                             receiver_power_dB,
                             color = technology)) +
  geom_line() +
  labs(
    colour = NULL,
    title = "Receiver Power",
    subtitle = "Receiver power recorded for \nvarious jammer position changes",
    x = "Receiver Distance (km)",
    y = "Receiver Power (dB)",
    fill = "Technology"
  ) + scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") + scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )


########################################
##plot5 = SINR Scenario bar line plot ##
########################################
df = data %>%
  group_by(jamming_power, technology) %>%
  summarize(mean = mean(interference_power),
            sd = sd(interference_power))

df$technology = as.factor(df$technology)
df$jamming_power = factor(df$jamming_power)
df$Technology = factor(
  df$technology,
  levels = c('2G', '3G', '4G', "5G"),
  labels = c('2G', '3G', '4G', "5G")
)

int_pwr <-
  ggplot(df, aes(x = jamming_power, y = mean, fill = Technology)) +
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
  ) + scale_fill_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Inteference Path Loss",
    subtitle = "Interference path loss \nfor various jamming power scenario",
    x = "Cellular Technology",
    y = "Pathloss",
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
  rec_power,
  ncol = 2,
  nrow = 2,
  common.legend = T,
  legend = "bottom",
  labels = c("a", "b", "c", "d")
)

path = file.path(folder, "figures", "loss_profile.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 6,
  height = 6,
  res = 480
)
print(losses)
dev.off()

###########################
##ECDF 1 = Receiver Power##
###########################
ecdf_rec_power <- ggplot(data,
  aes(x = receiver_power_dB, 
  color = technology)) +
  stat_ecdf() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Receiver Power",
    subtitle = "Empirical cumulative distribution of different \nreceiver power",
    x = "Receiver power (dB)",
    y = "Proportions",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

#######################################
##ECDF2 = Interference path loss plot##
#######################################

ecdf_int_pathloss <- ggplot(data,
                         aes(x = inteference_path_loss_dB, 
                             color = technology)) +
  stat_ecdf() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Interference Path Loss",
    subtitle = "Empirical cumulative distribution for inteference path loss \nfor different jammer positions",
    x = "Interference Path Loss (dB)",
    y = "Proportions",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

####################################
##ECDF3 = Interference power plot ##
####################################
ecdf_int_power <- ggplot(data,
          aes(x = interference_power, 
          color = technology)) +
  stat_ecdf() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Interference Power",
    subtitle = "Empirical cumulative distribution for inteference power \nfor different jammer positions",
    x = "Interference Power (dB)",
    y = "Proportions",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

####################################
##ECDF4 = Receiver path loss plot ##
####################################
ecdf_rec_pathloss <- ggplot(data,
  aes(x = receiver_path_loss_dB, 
  color = technology)) +
  stat_ecdf() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Receiver Path Loss",
    subtitle = "Empirical cumulative distribution for receiver path loss \nfor different positions",
    x = "Receiver Path Loss (dB)",
    y = "Proportions",
    fill = "Technology"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) +
  theme(axis.text.x = element_text(size = 8),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 8)) +
  theme(
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 8),
    plot.subtitle = element_text(size = 8),
    plot.title = element_text(size = 10)
  )

ecdfs <- ggarrange(
  ecdf_int_pathloss,
  ecdf_int_power,
  ecdf_rec_pathloss,
  ecdf_rec_power,
  ncol = 2,
  nrow = 2,
  common.legend = T,
  legend = "bottom",
  labels = c("a", "b", "c", "d")
)

path = file.path(folder, "figures", "ecdfs.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 6.7,
  height = 6.5,
  res = 480
)
print(ecdfs)
dev.off()


