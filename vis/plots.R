library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

####################
##JAMMING RESULTS ##
####################
data <- read.csv(file.path(folder, '..', 'results', 'full_jamming_results.csv'))
data$no_transmitters = factor(
  data$no_transmitters,
  levels = c(1, 3, 5),
  labels = c('1 Transmitter', '3 Transmitters', '5 Transmitters')
)
data$discrete <- cut(data$interference_distance_km, seq(0,40,5))
data$continuous = ""
data$continuous[data$discrete == '(0,5]'] <- 2.5
data$continuous[data$discrete == '(5,10]'] <- 7.5
data$continuous[data$discrete == '(10,15]'] <- 12.5
data$continuous[data$discrete == '(15,20]'] <- 17.5
data$continuous[data$discrete == '(20,25]'] <- 22.5
data$continuous[data$discrete == '(25,30]'] <- 27.5
data$continuous[data$discrete == '(30,35]'] <- 32.5
data$continuous[data$discrete == '(35,40]'] <- 37.5

data = select(data, interference_power, technology, 
              no_transmitters, continuous)

data$continuous = as.numeric(data$continuous)
data = data %>%
  group_by(no_transmitters, technology, continuous) %>%
  summarise(
    mean = mean(interference_power),
    sd = sd(interference_power))

#########################################
##plot1 = Interference power line plot ##
#########################################

int_power <- ggplot(data, aes(continuous, mean, color = technology)) + 
  geom_line(position = position_dodge(width = 0.5), size = 0.2) + 
  geom_point(size = 1.2) +
  geom_errorbar(aes(ymin = mean - sd, ymax= mean + sd), width = 0.2,
    position=position_dodge(0.05)) + 
  labs( colour = NULL,
    title = "Interference Power.",
    subtitle = "Simulated for different transmitter, jammer and receiver x-y positions in the spatial grid and number of transmitters.",
    x = "Jammer-Receiver Distance (km)",
    y = "Interference Power (dB)",
    fill = "Technology"
  ) + scale_fill_brewer(palette = "Accent") + 
  theme(plot.title = element_text(size = 12),
        legend.position = 'bottom',
        axis.text.x = element_text(size = 6),
        panel.spacing = unit(0.6, "lines"),
        plot.subtitle = element_text(size = 9),
        axis.text.y = element_text(size = 6),
        axis.title = element_text(size = 7),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 9)) +
  facet_wrap( ~ no_transmitters, ncol = 3)

################################
##plot2 = Receiver power plot ##
################################
data <- read.csv(file.path(folder, '..', 'results', 'full_jamming_results.csv'))
data$no_transmitters = factor(
  data$no_transmitters,
  levels = c(1, 3, 5),
  labels = c('1 Transmitter', '3 Transmitters', '5 Transmitters')
)
data$discrete <- cut(data$receiver_distance_km, seq(0,40,5))
data$continuous = ""
data$continuous[data$discrete == '(0,5]'] <- 2.5
data$continuous[data$discrete == '(5,10]'] <- 7.5
data$continuous[data$discrete == '(10,15]'] <- 12.5
data$continuous[data$discrete == '(15,20]'] <- 17.5
data$continuous[data$discrete == '(20,25]'] <- 22.5
data$continuous[data$discrete == '(25,30]'] <- 27.5
data$continuous[data$discrete == '(30,35]'] <- 32.5
data$continuous[data$discrete == '(35,40]'] <- 37.5

data = select(data, receiver_power_dB, technology, 
              no_transmitters, continuous)

data$continuous = as.numeric(data$continuous)
data = data %>%
  group_by(no_transmitters, technology, continuous) %>%
  summarise(
    mean = mean(receiver_power_dB),
    sd = sd(receiver_power_dB))

rec_power <- ggplot(data, aes(continuous, mean, color = technology)) +
  geom_line(position = position_dodge(width = 0.5), size = 0.2) +
  geom_point(size = 1.2) +
  geom_errorbar(aes(ymin = mean - sd, ymax= mean + sd), width = 0.01,
    position=position_dodge()) +
  labs(
    colour = NULL,
    title = "Receiver Power.",
    subtitle = "Simulated receiver power recorded due to jamming and grouped by number of transmitters.",
    x = "Receiver-Transmitter Distance (km)",
    y = "Receiver Power (dB)",
    fill = "Technology"
  ) + scale_fill_brewer(palette = "Accent") +  
  theme(plot.title = element_text(size = 12),
        legend.position = 'bottom',
        axis.text.x = element_text(size = 6),
        panel.spacing = unit(0.6, "lines"),
        plot.subtitle = element_text(size = 9),
        axis.text.y = element_text(size = 6),
        axis.title = element_text(size = 7),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 9)) + 
  facet_wrap( ~ no_transmitters, ncol = 3)

#######################
## Panel Power Plots ##
#######################
losses <- ggarrange(
  int_power,
  rec_power,
  ncol = 1,
  nrow = 2,
  common.legend = T,
  labels = c('A', 'B', 'C'),
  legend = "bottom")

path = file.path(folder, "figures", "loss_profile.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 7,
  height = 6,
  res = 480
)
print(losses)
dev.off()

###########################
## SIGNAL TO NOISE RATIO ##
###########################
data <- read.csv(file.path(folder, '..', 'results', 'full_jamming_results.csv'))

df = data %>%
  group_by(technology, power_scenario, no_transmitters) %>%
  summarize(mean = mean(snr_dB),
            sd = sd(snr_dB))

df$power_scenario = factor(
  df$power_scenario,
  levels = c('low', 'baseline', 'high'),
  labels = c('Low EIRP', 'Baseline EIRP', 'High EIRP')
)

df$no_transmitters = factor(
  df$no_transmitters,
  levels = c(1, 3, 5),
  labels = c('1 Transmitter', '3 Transmitters', '5 Transmitters')
)

snr_db <- ggplot(df, aes(x = technology, y = mean, fill = power_scenario)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd/5, ymax = mean + sd/5),
    width = .2, position = position_dodge(.98), color = 'red', size = 0.2) + 
  geom_text(aes(label = formatC(signif(after_stat(y), 3), 
    digits = 3, format = "fg", flag = "#")),
    size = 1.5, position = position_dodge(0.98),
    vjust = 0.5, hjust = -0.6, angle = 90) + 
  scale_y_continuous(limits = c(0, 38), labels = function(y)
    format(y, scientific = FALSE), expand = c(0, 0)) + 
  labs(colour = NULL, 
    title = "Signal-to-Noise Ratio (SNR).",
    subtitle = "SNR at User Equipment (UE) based on different Equivalent Isotropic Radiated Power (EIRP) and path loss scenario.",
    x = NULL, y = "Signal-to-Noise Ratio (dB)",
    fill = 'EIRP Scenario'
  ) + 
  scale_fill_brewer(palette = "Paired") +  
  theme(plot.title = element_text(size = 12),
        legend.position = 'bottom',
        axis.text.x = element_text(size = 6),
        panel.spacing = unit(0.6, "lines"),
        plot.subtitle = element_text(size = 9),
        axis.text.y = element_text(size = 6),
        axis.title = element_text(size = 7),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 9)) +
  facet_wrap( ~ no_transmitters, ncol = 3)


#############################################
## SIGNAL TO NOISE PLUS INTERFERENCE RATIO ##
#############################################
data <- read.csv(file.path(folder, '..', 'results', 'full_jamming_results.csv'))

df = data %>%
  group_by(jamming, technology, no_transmitters) %>%
  summarize(mean = mean(sinr_dB),
            sd = sd(sinr_dB))

df$no_transmitters = factor(
  df$no_transmitters,
  levels = c(1, 3, 5),
  labels = c('1 Transmitter', '3 Transmitters', '5 Transmitters')
)

df$jamming = factor(
  df$jamming,
  levels = c('Low', 'Baseline', 'High'),
  labels = c('Low', 'Baseline', 'High')
)

sinr_db <- ggplot(df, aes(x = technology, y = mean, fill = jamming)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd/10, ymax = mean + sd/10),
                width = .2, position = position_dodge(.98), 
                color = 'red', size = 0.2) + 
  geom_text(aes(label = formatC(signif(after_stat(y), 3), 
     digits = 3, format = "fg", flag = "#")),
     size = 1.5, position = position_dodge(0.98),
     vjust = 3, hjust = 0.5) +
  labs(colour = NULL, 
       title = "Signal-to-Noise plus Interference Ratio (SNIR).",
       subtitle = "SNIR at User Equipment (UE) based on different jamming and Equivalent Isotropic Radiated Power (EIRP) scenario.",
       x = NULL, y = "Signal-to-Noise Ratio (dB)",
       fill = 'Jamming Power Scenario'
  ) + 
  scale_fill_brewer(palette = "Paired") +  
  theme(plot.title = element_text(size = 12),
        legend.position = 'bottom',
        axis.text.x = element_text(size = 6),
        panel.spacing = unit(0.6, "lines"),
        plot.subtitle = element_text(size = 9),
        axis.text.y = element_text(size = 6),
        axis.title = element_text(size = 7),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 9)) + 
  facet_wrap( ~ no_transmitters, ncol = 3)

#######################
## Panel Power Plots ##
#######################
snrs <- ggarrange(
  snr_db,
  sinr_db,
  ncol = 1,
  nrow = 2,
  common.legend = F,
  labels = c('A', 'B'),
  legend = "bottom")

path = file.path(folder, "figures", "snrs.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 7,
  height = 6,
  res = 480
)
print(snrs)
dev.off()

############################
## SECURE TEXTING RESULTS ##
############################
data <- read.csv(file.path(folder, '..', 'results', 'windtexter_results.csv'))

####################################
##    Density plot Interception   ##
####################################
data$windtexter = as.factor(data$windtexter)
data$windtexter = factor(data$windtexter,
  levels = c('Baseline', 'Partial', 'Full'),
  labels = c('Baseline', 'Partial', 'Full'))

dp_strat <- ggplot(data, aes(x = interception, color = windtexter)) +
  geom_density(size = 0.2) + 
  geom_vline(xintercept= 0.5, colour="#666666", 
             linetype = "dashed", size = 0.3) + 
  geom_text(aes(x = 0.5, label="Successful", y = 3), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 3), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_fill_viridis_d(direction = 1) +
  labs(colour = NULL,
    title = "Interception.",
    subtitle = "Density plot of the probability outcome by different \nstrategies.",
    x = "Probability",
    y = "Density",
    fill = "Strategy"
  )  +
  theme(
    plot.title = element_text(size = 8),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line = element_line(colour = "black"),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", axis.title = element_text(size = 6)
  ) + 
  scale_y_continuous(labels = function(y)
    format(y, scientific = FALSE), expand = c(0, 0))

################################
##    Density plot Blocking   ##
################################
block_strat <- ggplot(data, aes(x = blocking, color = windtexter)) +
  geom_density(size = 0.2) + 
  geom_vline(xintercept= 0.5, colour="#666666", 
             linetype = "dashed", size = 0.3) + 
  geom_text(aes(x = 0.5, label="Successful", y = 3), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 3), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_fill_viridis_d(direction = 1) +
  labs(colour = NULL,
    title = "Blocking.",
    subtitle = "Density plot of the probability outcome by different \nstrategies.",
    x = "Probability",
    y = "Density",
    fill = "Strategy"
  ) + 
  theme(
    plot.title = element_text(size = 8),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line = element_line(colour = "black"),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", 
    axis.title = element_text(size = 6)
  ) + 
  scale_y_continuous(labels = function(y) format(y, 
     scientific = FALSE), expand = c(0, 0)) 

##########################################################
##    Density plot by message success - Interception    ##
##########################################################
data$message_status = as.factor(data$message_status)
data$message_status = factor(data$message_status,
  levels = c('sucessful', 'unsuccessful'),
  labels = c('Success', 'Fail'))

dp_msg <- ggplot(data, aes(x = interception, color = message_status)) +
  geom_density(size = 0.2) +
  geom_vline(xintercept = 0.5, colour="#666666", 
             linetype = "dashed", size = 0.3) + 
  geom_text(aes(x=0.5, label="Successful", y = 2), colour = "#666666", 
            angle = 90, vjust = 2, size = 2) +
  geom_text(aes(x=0.5, label="Unsuccessful", y = 2), colour = "#666666", 
            angle = 90, vjust = -2, size = 2) +
  scale_fill_viridis_d(direction = 1) +
  labs(colour = NULL,
    title = "Total Interceptions.",
    subtitle = "Density plot of the probability outcome by message \ndelivery status.",
    x = "Probability",
    y = "Density",
    fill = "Message Delivery"
  ) + 
  theme(
    plot.title = element_text(size = 8),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line = element_line(colour = "black"),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", 
    axis.title = element_text(size = 6)
  ) + 
  scale_y_continuous(labels = function(y) format(y, 
  scientific = FALSE), expand = c(0, 0)) 


##################################
##    Aggregate Interceptions   ##
##################################
df = data %>%
  group_by(windtexter, message_status) %>%
  summarize(total = floor(sum(interception)))

df$message_status = as.factor(df$message_status)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter, levels = c('Baseline', 'Partial', 'Full'),
   labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)'))

interception_agg <-
  ggplot(df, aes(x = windtexter, y = total, fill = message_status)) +
  geom_bar(stat = "identity", position = position_dodge(0.9)) +   
  geom_text(aes(windtexter, label = total), size = 1.5, 
    vjust = -0.5, position = position_dodge(1),
    hjust = 0.5, data = df) +
  labs(colour = NULL,
    title = "Aggregate Interceptions.",
    subtitle = "Total amount of messages interception attempts by \ndelivery status.",
    x = NULL,
    y = "Number of Messages",
    fill = "Message Delivery"
  ) + scale_fill_brewer(palette = "Accent") +
  theme(
    plot.title = element_text(size = 8),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line = element_line(colour = "black"),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", 
    axis.title = element_text(size = 6)
  ) + 
  scale_y_continuous(labels = function(y) format(y, 
  scientific = FALSE), limits = c(0, 2000), expand = c(0, 0))


##############################
##    Aggregate blockings   ##
###############################
df = data %>%
  group_by(windtexter, message_status) %>%
  summarize(total = floor(sum(blocking)))

df$message_status = as.factor(df$message_status)
df$windtexter = factor(df$windtexter)
df$windtexter = factor(df$windtexter, levels = c('Baseline', 'Partial', 'Full'),
  labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)

blocking_agg <-
  ggplot(df, aes(x = windtexter, y = total, fill = message_status)) +
  geom_bar(stat = "identity", position = position_dodge(0.9)) +   
  geom_text(aes(windtexter, label = total), size = 1.5, 
  vjust = -0.5, position = position_dodge(1),
  hjust = 0.5, data = df) +
  labs(
    colour = NULL,
    title = "Aggregate Blockings.",
    subtitle = "Total amount of message blocking attempts by \ndelivery status.",
    x = NULL,
    y = "Number of Messages",
    fill = "Message Delivery"
  ) + scale_fill_brewer(palette = "Accent") +
  theme(
    plot.title = element_text(size = 8),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.line = element_line(colour = "black"),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.position = "bottom", 
    axis.title = element_text(size = 6)
  ) + 
  scale_y_continuous(labels = function(y) format(y, 
  scientific = FALSE), limits = c(0, 2500), expand = c(0, 0))

################################
## Panel Secure Texting plots ##
################################
row_1 <- ggarrange(dp_strat, block_strat,
         ncol = 2, common.legend = T, 
         legend = "bottom", labels = c('A', 'B'))

row_2 <- ggarrange(interception_agg, blocking_agg,
         ncol = 2, common.legend = T, 
         legend = "bottom", labels = c('C', 'D'))

density_plots <- ggarrange(
  row_1, 
  row_2, 
  nrow = 2,
  common.legend = F,
  legend = "bottom"
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

###########
## COSTS ##
###########

data <- read.csv(file.path(folder, '..', 'results', 'cost_results.csv'))
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
df$windtexter = factor(df$windtexter, levels = c('Baseline', 'Partial', 'Full'),
   labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)
df$application = factor(df$application,
   levels = c('private', 'commercial', 'government', 'millitary'),
   labels = c('Private', 'Commercial', 'Government', 'Millitary')
)

interception_costs <-
  ggplot(df, aes(x = windtexter, y = mean, fill = application)) +
  geom_bar(stat = "identity", position = position_dodge(.9), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd*0.15, ymax = mean + sd*0.15),
    width = .2, position = position_dodge(.9), color = 'red', size = 0.05) +
  scale_fill_viridis_d(direction = 1) +
  labs(
    colour = NULL,
    title = "Interception Losses.",
    subtitle = "Losses incurred by different segments \nof the economy due to interception of \nthe messages (Error bars: 1SD).",
    x = NULL,
    y = "Interception Losses\n(US$)",
    fill = 'Application Area'
  ) +
  scale_y_continuous(labels = function(y) format(y, scientific = FALSE), expand = c(0, 0)
  ) + theme_minimal() +
  theme(
    plot.title = element_text(size = 8),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    legend.position = 'bottom', 
    axis.title = element_text(size = 7))

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
df$windtexter = factor(df$windtexter,levels = c('Baseline', 'Partial', 'Full'),
  labels = c('Baseline \n(1 site)', 'Partial \n(3 sites)', 'Full \n(5 sites)')
)
df$application = factor(df$application,
  levels = c('private', 'commercial', 'government', 'millitary'),
  labels = c('Private', 'Commercial', 'Government', 'Millitary')
)

blocking_costs <-
  ggplot(df, aes(x = windtexter, y = mean, fill = application)) +
  geom_bar(stat = "identity", position = position_dodge(.9), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd*0.15, ymax = mean + sd*0.15),
  width = .2, position = position_dodge(.9), color = 'red', size = 0.05
  ) +
  scale_fill_viridis_d(direction = 1) + 
  labs(
    colour = NULL,
    title = "Blocking Losses.",
    subtitle = "Losses incurred by different segments \nof the economy due to interception of \nthe messages (Error bars: 1SD).",
    x = NULL,
    y = "Blocking Losses\n(US$)",
    fill = 'Application Area'
  ) +
  scale_y_continuous(labels = function(y) format(y, scientific = FALSE), expand = c(0, 0)
  ) + theme_minimal() +
  theme(
    plot.title = element_text(size = 8),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    legend.position = 'bottom', 
    axis.title = element_text(size = 7))  


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
  geom_bar(stat = "identity", position = position_dodge(.9), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd*0.15, ymax = mean + sd*0.15), width = .2,
    position = position_dodge(.9), color = 'red', size = 0.05
  ) + scale_fill_viridis_d(direction = 1) +
  labs(
    colour = NULL,
      title = "Total Losses.",
    subtitle = "Total losses incurred by \ndifferent segments of the \neconomy (Error bars: 1SD).",
    x = NULL,
    y = "Total Losses\n(US$)",
    fill = 'Application Area'
  ) +
  scale_y_continuous(labels = function(y) format(y, scientific = FALSE),
    expand = c(0, 0)
  ) + theme_minimal() +
  theme(
    plot.title = element_text(size = 8),
    strip.text.x = element_blank(),
    panel.border = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(size = 6),
    axis.text.y = element_text(size = 6),
    axis.title.y = element_text(size = 6),
    axis.line.x  = element_line(size = 0.15),
    axis.line.y  = element_line(size = 0.15),
    legend.title = element_text(size = 6),
    legend.text = element_text(size = 6),
    plot.subtitle = element_text(size = 6),
    legend.position = 'bottom', 
    axis.title = element_text(size = 7))

costs <- ggarrange(
  interception_costs, blocking_costs, total_costs,
  ncol = 3,
  common.legend = T,
  legend = "bottom",
  labels = c('A', 'B', 'C')
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

