library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(RColorBrewer)

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
  geom_line(position = position_dodge(width = 0.5), size = 0.3) + 
  geom_point(size = 1, position=position_dodge(0.5)) +
  geom_errorbar(aes(ymin = mean - sd, ymax= mean + sd), width = 3.5, size = 0.2,
    position=position_dodge(0.5)) + 
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
  geom_line(position = position_dodge(width = 0.5), size = 0.3) +
  geom_point(size = 1.2, position=position_dodge(0.5)) +
  geom_errorbar(aes(ymin = mean - sd, ymax= mean + sd), width = 3.5,size=0.2,
    position=position_dodge(0.5)) +
  labs(
    colour = NULL,
    title = "Receiver Power.",
    subtitle = "Simulated receiver power recorded due to jamming and grouped by number of transmitters.",
    x = "Receiver-Transmitter Distance (km)",
    y = "Receiver Power (dB)",
    fill = "Technology"
  ) + scale_fill_brewer(palette = "Set1") +  
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
  geom_bar(stat = "identity", position = position_dodge(), width = 0.97) +
  geom_errorbar(aes(ymin = mean - sd/5, ymax = mean + sd/5),
    width = .2, position = position_dodge(.98), color = 'red', size = 0.2) + 
  geom_text(aes(label = formatC(signif(after_stat(y), 3), 
    digits = 3, format = "fg", flag = "#")),
    size = 1.5, position = position_dodge(0.98),
    vjust = 0.5, hjust = -0.6, angle = 90) + 
  scale_y_continuous(limits = c(0, 40), labels = function(y)
    format(y, scientific = FALSE), expand = c(0, 0)) + 
  labs(colour = NULL, 
    title = "Signal-to-Noise plus Interference Ratio (SNIR) Pre-jamming.",
    subtitle = "SNR at User Equipment (UE) based on different Equivalent Isotropic Radiated Power (EIRP) and path loss scenario.",
    x = NULL, y = "SNIR (dB)",
    fill = 'EIRP Scenario'
  ) + 
  scale_fill_brewer(palette = "YlGnBu") +  
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
  geom_bar(stat = "identity", position = position_dodge(), width = 0.97) +
  geom_errorbar(aes(ymin = mean - sd/10, ymax = mean + sd/10),
                width = .2, position = position_dodge(.98), 
                color = 'red', size = 0.2) + 
  geom_text(aes(label = formatC(signif(after_stat(y), 3), 
     digits = 3, format = "fg", flag = "#")),
     size = 1.5, position = position_dodge(0.98),
     vjust = 3, hjust = 0.5) +
  
  labs(colour = NULL, 
       title = "Signal-to-Noise plus Interference Ratio (SNIR) Post-jamming.",
       subtitle = "SNIR at User Equipment (UE) based on different jamming and Equivalent Isotropic Radiated Power (EIRP) scenario.",
       x = NULL, y = "SNIR (dB)",
       fill = 'Jamming Power Scenario'
  ) + 
  scale_fill_brewer(palette = "YlGnBu") +  
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

########################
## Number of Messages ##
########################
data <- read.csv(file.path(folder, '..', 'results', 'full_windtexter_results.csv'))

df = data %>%
  group_by(text_scenario, message, technology) %>%
  summarize(total = (floor(sum(probability))/1000))

df$text_scenario = factor(df$text_scenario)
df$text_scenario = factor(df$text_scenario, levels = c('baseline', 'partial', 'full'),
  labels = c('Baseline (1 Transmitter)', 'Partial (3 Transmitters)', 
             '(5 Transmitters)'))

df$message = factor(
  df$message,
  levels = c('fail', 'success'),
  labels = c('Fail', 'Success')
)

total_texts <-
  ggplot(df, aes(x = technology, y = total, fill = message)) +
  geom_bar(stat = "identity", position = position_dodge(0.98)) +   
  geom_text(aes(label = formatC(signif(after_stat(y), 3), 
    digits = 3, format = "fg", flag = "#")),
    size = 2, position = position_dodge(0.98),
    vjust = 0.1, hjust = 0.5) +
  scale_y_continuous(limits = c(0, 200), labels = function(y)
    format(y, scientific = FALSE), expand = c(0, 0)) +
  labs(colour = NULL, 
    title = "Secure Texting Results.",
    subtitle = "Based on antenna multi-transmission strategy and success rate of messages.",
    x = NULL, 
    y = "Total Messages ('000')",
    fill = 'Message Success'
  ) + 
  scale_fill_brewer(palette = "YlGnBu") +  
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
  facet_wrap( ~ text_scenario, ncol = 3)

################################
## Panel Secure Texting plots ##
################################
secure_plots <- ggarrange(
  total_texts, 
  nrow = 1,
  common.legend = T,
  labels = c('A'),
  legend = "bottom"
)

path = file.path(folder, "figures", "secure_plots.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 8,
  height = 4.5,
  res = 480
)
print(secure_plots)
dev.off()

###########
## COSTS ##
###########

data <- read.csv(file.path(folder, '..', 'results', 'full_windtexter_results.csv'))
#######################
## Costs by strategy ##
#######################
df = data %>%
  group_by(text_scenario, cost_scenario, 
           application_area) %>%
  summarize(mean = mean(cost),
            sd = sd(cost))

df$text_scenario = factor(df$text_scenario)
df$text_scenario = factor(df$text_scenario, levels = c('baseline', 'partial', 'full'),
   labels = c('Baseline (1 Transmitter)', 'Partial (3 Transmitters)', 
              'Full (5 Transmitters)'))

df$application_area = as.factor(df$application_area)
df$application_area = factor(df$application_area,
   levels = c('private', 'commercial', 'government', 'millitary'),
   labels = c('Private', 'Commercial', 'Government', 'Millitary'))

df$cost_scenario = factor(
  df$cost_scenario,
  levels = c('low_cost', 'baseline_cost', 'high_cost'),
  labels = c('Low', 'Baseline', 'High'))

strategy_cost <-
  ggplot(df, aes(x = application_area, y = mean, fill = cost_scenario)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd*0.05, ymax = mean + sd*0.05),
    width = .2, position = position_dodge(.98), color = 'red', size = 0.15) +
  scale_fill_brewer(palette = "YlGnBu") +
  labs(
    colour = NULL,
    title = "Economic Sector Costs.",
    subtitle = "By different antenna multi-transmission modes based on different costs per message (Error bars: 1SD).",
    x = NULL,
    y = "Losses (US$)",
    fill = 'Cost per Message Scenario'
  ) +
  scale_y_continuous(limits = c(0, 1000), labels = function(y)
    format(y, scientific = FALSE), expand = c(0, 0)) + 
  theme(plot.title = element_text(size = 12),
        legend.position = 'bottom',
        axis.text.x = element_text(size = 6),
        panel.spacing = unit(0.6, "lines"),
        plot.subtitle = element_text(size = 8),
        axis.text.y = element_text(size = 6),
        axis.title = element_text(size = 7),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 9))  + 
  facet_wrap( ~ text_scenario, ncol = 3)

#########################
## Costs by Technology ##
#########################
data <- read.csv(file.path(folder, '..', 'results', 'full_windtexter_results.csv'))

df = data %>%
  group_by(text_scenario, technology, 
           cost_scenario) %>%
  summarize(mean = mean(cost),
            sd = sd(cost))

df$text_scenario = factor(df$text_scenario)
df$text_scenario = factor(df$text_scenario, levels = c('baseline', 'partial', 'full'),
  labels = c('Baseline (1 Transmitter)', 'Partial (3 Transmitters)', 
  'Full (5 Transmitters)'))

df$cost_scenario = factor(df$cost_scenario,
  levels = c('low_cost', 'baseline_cost', 'high_cost'),
  labels = c('Low', 'Baseline', 'High'))

technology_cost <-
  ggplot(df, aes(x = technology, y = mean, fill = cost_scenario)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.98) +
  geom_errorbar(aes(ymin = mean - sd*0.05, ymax = mean + sd*0.05),
    width = .2, position = position_dodge(.98), color = 'red', size = 0.15) +
  scale_fill_brewer(palette = "YlGnBu") +
  labs(
    colour = NULL,
    title = "Cellular Technology Costs.",
    subtitle = "By different antenna multi-transmission modes based on different costs per message (Error bars: 1SD).",
    x = NULL,
    y = "Losses (US$)",
    fill = 'Cost per Message Scenario'
  ) +
  scale_y_continuous(limits = c(0, 750), labels = function(y)
    format(y, scientific = FALSE), expand = c(0, 0)) + 
  theme(plot.title = element_text(size = 12),
        legend.position = 'bottom',
        axis.text.x = element_text(size = 6),
        panel.spacing = unit(0.6, "lines"),
        plot.subtitle = element_text(size = 8),
        axis.text.y = element_text(size = 6),
        axis.title = element_text(size = 7),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 8),
        axis.title.x = element_text(size = 9))  + 
  facet_wrap( ~ text_scenario, ncol = 3)

######################
## Cost Panel Plots ##
######################
costs <- ggarrange(
  strategy_cost,
  technology_cost,
  ncol = 1,
  nrow = 2,
  common.legend = T,
  labels = c('A', 'B'),
  legend = "bottom")

path = file.path(folder, "figures", "socio-economic.png")
dir.create(file.path(folder, "figures"), showWarnings = FALSE)
png(
  path,
  units = "in",
  width = 7,
  height = 6,
  res = 480
)
print(costs)
dev.off()

