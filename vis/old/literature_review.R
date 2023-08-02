library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "lit_review.csv"))

#############################
## Time Series Publication ##
#############################

totals <- data %>%
  group_by(Year) %>%
  summarize(total = sum(Amount))

timeseries <- ggplot(data) + 
  geom_bar(aes(x = Year, fill = factor(Application))) + 
  scale_fill_brewer(palette = "Set1") +
  geom_text(aes(Year, total, label = total), size = 2, vjust = -1,
            hjust = 0.5, data = totals) +
  labs(
    colour = NULL,
    title = "(A) Time Series of Published Radio Network Papers",
    subtitle = "Results broken down by radio network application area",
    x = NULL,
    y = "Quantity of Radio Network Papers",
    fill = 'Application Area'
  )

##############################
## Contribution Publication ##
##############################

totals <- data %>%
  group_by(Focus) %>%
  summarize(total = sum(Amount))

contribution <- ggplot(data) + 
  geom_bar(aes(x = Focus, fill = factor(Application))) + 
  scale_fill_brewer(palette = "Set1") +
  geom_text(aes(Focus, total, label = total), size = 2, vjust = -1,
            hjust = 0.5, data = totals) +
  labs(
    colour = NULL,
    title = "(B) Contribution of the Cited Radio Network Papers",
    subtitle = "Results broken down by Application Area",
    x = NULL,
    y = "Quantity of Radio Network Papers",
    fill = 'Application Area'
  )

ggplot(data) + 
  geom_bar(aes(x = Focus, fill = factor(Approach))) + 
  scale_fill_brewer(palette = "Set1") +
  geom_text(aes(Focus, total, label = total), size = 2, vjust = -1,
            hjust = 0.5, data = totals) +
  labs(
    colour = NULL,
    title = "(B) Contribution of the Cited Radio Network Papers",
    subtitle = "Results broken down by Application Area",
    x = NULL,
    y = "Quantity of Radio Network Papers",
    fill = 'Application Area'
  )












