library(ggpubr)
library(ggplot2)
library(dplyr)
library(tidyverse)


# Set default folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

#Load the data
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
data <- read.csv(file.path(folder, "sim_results.csv"))

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




