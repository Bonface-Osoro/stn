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
##    Density plot Interception   ##
####################################
data$windtexter = as.factor(data$windtexter)
data$windtexter = factor(data$windtexter,
  levels = c('Baseline', 'Partial', 'Full'),
  labels = c('Baseline', 'Partial', 'Full')
)

dp_strat <- ggplot(data,
                    aes(x = interception_probability, 
                        color = windtexter)) +
  geom_density() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = NULL,
    subtitle = "Density plot of the interception probability \noutcome by different strategies",
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


################################
##    Density plot Blocking   ##
################################
block_strat <- ggplot(data,
                   aes(x = block_probability, 
                       color = windtexter)) +
  geom_density() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = NULL,
    subtitle = "Density plot of the blocking probability \noutcome by different strategies",
    x = "Blocking Probability",
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


##########################################################
##    Density plot by message success - Interception    ##
##########################################################
data$message_status = as.factor(data$message_status)
data$message_status = factor(data$message_status,
   levels = c('sucessful', 'unsuccessful'),
   labels = c('Success', 'Fail')
)
dp_msg <- ggplot(data,
                   aes(x = interception_probability, 
                       color = message_status)) +
  geom_density() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = NULL,
    subtitle = "Density plot of the probability of intercepting \nthe message by delivery status",
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

######################################################
##    Density plot by message success - Blocking    ##
######################################################

block_msg <- ggplot(data,
                 aes(x = block_probability, 
                     color = message_status)) +
  geom_density() +
  scale_fill_brewer(palette = "Paired") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = NULL,
    subtitle = "Density plot of the probability the blocking \na message by delivery status",
    x = "Block Probability",
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
  dp_strat, 
  block_strat, 
  dp_msg, 
  block_msg,
  ncol = 2,
  nrow = 2,
  common.legend = F,
  legend = "bottom",
  labels = c("a", "b", "c", "d")
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
