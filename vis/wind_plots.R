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
                    aes(x = interception, 
                        color = windtexter)) +
  geom_density(size = 0.2) + 
  geom_vline(xintercept= 0.5, colour="#666666", linetype = "dashed", size = 0.3) + 
  geom_text(aes(x=0.5, label="Successful", y = 3), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 3), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_color_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "(a) Interception",
    subtitle = "Density plot of the probability outcome by different \nstrategies",
    x = "Probability",
    y = "Density",
    fill = "Strategy"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme(plot.title = element_text(face = "bold")) +
  theme(axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 6)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    plot.title = element_text(size = 8)
  )

################################
##    Density plot Blocking   ##
################################
block_strat <- ggplot(data,
                   aes(x = blocking, 
                       color = windtexter)) +
  geom_density(size = 0.2) + 
  geom_vline(xintercept= 0.5, colour="#666666", linetype = "dashed", size = 0.3) + 
  geom_text(aes(x=0.5, label="Successful", y = 3), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 3), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_color_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "(b) Blocking",
    subtitle = "Density plot of the probability outcome by different \nstrategies",
    x = "Probability",
    y = "Density",
    fill = "Strategy"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme(plot.title = element_text(face = "bold")) +
  theme(axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 6)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    plot.title = element_text(size = 8)
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
                   aes(x = interception, 
                       color = message_status)) +
  geom_density(size = 0.2) +
  geom_vline(xintercept= 0.5, colour="#666666", linetype = "dashed", size = 0.3) + 
  geom_text(aes(x=0.5, label="Successful", y = 2), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 2), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_color_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "(c) Total Interceptions",
    subtitle = "Density plot of the probability outcome by message \ndelivery status",
    x = "Probability",
    y = "Density",
    fill = "Message Delivery"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme(plot.title = element_text(face = "bold")) +
  theme(axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 6)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    plot.title = element_text(size = 8)
  )

######################################################
##    Density plot by message success - Blocking    ##
######################################################

block_msg <- ggplot(data,
                 aes(x = blocking, 
                     color = message_status)) +
  geom_density(size = 0.2) +
  geom_vline(xintercept= 0.5, colour="#666666", linetype = "dashed", size = 0.3) + 
  geom_text(aes(x=0.5, label="Successful", y = 7.5), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 7.5), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_color_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "(d) Total Blockings",
    subtitle = "Density plot of the probability outcome by message \ndelivery status",
    x = "Probability",
    y = "Density",
    fill = "Message Delivery"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme(plot.title = element_text(face = "bold")) + 
  theme(axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 6)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    plot.title = element_text(size = 8)
  )


##################################
##    Aggregate Interceptions   ##
##################################

df = data %>%
  group_by(windtexter, message_status) %>%
  summarize(total = floor(sum(interception)))

df$message_status = as.factor(df$message_status)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter,
                       levels = c('Baseline', 'Partial', 'Full'),
                       labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)

interception_agg <-
  ggplot(df, aes(x = windtexter, y = total, fill = message_status)) +
  geom_bar(stat = "identity",
           position = position_dodge(), width = 0.98) +   
  geom_text(aes(windtexter, label = total), size = 1.5, vjust = -1,
            hjust = 0.005, data = df) + 
  scale_fill_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "(d) Aggregate Interceptions",
    subtitle = "Total amount of messages interception attempts by \ndelivery status",
    x = NULL,
    y = "Number of Messages",
    fill = "Message Delivery"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE), limits = c(0, 2000),
    expand = c(0, 0)
  ) + theme(plot.title = element_text(face = "bold")) + 
  theme(axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 6)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    plot.title = element_text(size = 8)
  )

##############################
##    Aggregate blockings   ##
###############################

df = data %>%
  group_by(windtexter, message_status) %>%
  summarize(total = floor(sum(blocking)))

df$message_status = as.factor(df$message_status)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter,
                       levels = c('Baseline', 'Partial', 'Full'),
                       labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)

blocking_agg <-
  ggplot(df, aes(x = windtexter, y = total, fill = message_status)) +
  geom_bar(stat = "identity",
           position = position_dodge(), width = 0.98) +   
  geom_text(aes(windtexter, label = total), size = 1.5, vjust = -0.5,
            hjust = 0.005, data = df) + 
  scale_fill_brewer(palette = "Accent") +
  theme(legend.position = "right") +
  labs(
    colour = NULL,
    title = "(e) Aggregate Blockings",
    subtitle = "Total amount of message blocking attempts by \ndelivery status",
    x = NULL,
    y = "Number of Messages",
    fill = "Message Delivery"
  ) +   scale_y_continuous(
    labels = function(y)
      format(y, scientific = FALSE), limits = c(0, 2500),
    expand = c(0, 0)
  ) + theme(plot.title = element_text(face = "bold")) + 
  theme(axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line = element_line(colour = "black")) +
  theme(legend.position = "bottom", axis.title = element_text(size = 6)) +
  theme(
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    plot.title = element_text(size = 8)
  )


row_1 <- ggarrange(dp_strat, block_strat,
  ncol = 2, common.legend = T, legend = "bottom"
)

row_2 <- ggarrange(interception_agg, blocking_agg,
    ncol = 2, common.legend = T, legend = "bottom"
)


density_plots <- ggarrange(
  row_1, 
  row_2, 
  nrow = 2,
  common.legend = F,
  legend = "bottom",
  labels = c()
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

