library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "windtexter_results.csv"))

####################################
##ECDF 1 = Interference power plot##
####################################
ecdf_intc <- ggplot(data,
                        aes(x = probability, 
                            color = windtexter)) +
  stat_ecdf() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "Windtexter Implementation",
    subtitle = "Empirical cumulative distribution of different interception probability",
    x = "Interception Probability",
    y = "Proportions",
    fill = "WindTexter Implementation"
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
  ecdf_intc,
  ncol = 1,
  nrow = 1,
  common.legend = T,
  legend = "bottom",
  labels = c("a")
)

path = file.path(folder, "figures", "wind_ecdfs.png")
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


data <- read.csv(file.path(folder, "windtexter_results.csv"))

####################################
##    Density plot by strategy    ##
####################################
data$windtexter = as.factor(data$windtexter)
data$windtexter = factor(data$windtexter,
  levels = c('baseline', 'partial', 'Full'),
  labels = c('1 Site', '3 Sites', '5 Sites')
)

dp_strat <- ggplot(data,
                    aes(x = probability, 
                        color = windtexter)) +
  geom_density() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = NULL,
    subtitle = "Density plot of the interception probability outcome by different strategies",
    x = "Interception Probability",
    y = "Density",
    fill = "WindTexter Implementation"
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

###########################################
##    Density plot by message success    ##
###########################################
data$message_status = as.factor(data$message_status)
data$message_status = factor(data$message_status,
   levels = c('successful', 'unsuccessful'),
   labels = c('Success', 'Fail')
)
dp_msg <- ggplot(data,
                   aes(x = probability, 
                       color = message_status)) +
  geom_density() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = NULL,
    subtitle = "Density plot of the interception probability outcome by message success",
    x = "Interception Probability",
    y = "Density",
    fill = "WindTexter Implementation"
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

density_plots <- ggarrange(
  dp_strat, dp_msg,
  ncol = 1,
  nrow = 2,
  common.legend = F,
  legend = "bottom",
  labels = c("a", "b")
)

path = file.path(folder, "figures", "density_plots.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 5,
  height = 5.5,
  res = 480
)
print(density_plots)
dev.off()












