import os
import sys
import configparser
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
pd.options.mode.chained_assignment = None

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), '..', 'scripts', 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']


DATA_INTERMEDIATE = os.path.join(BASE_PATH, "results")
RESULTS = os.path.join(BASE_PATH, '..', 'results')
VIS = os.path.join(BASE_PATH, '..', 'vis', 'figures')

ROOT_DIR = os.path.normpath(os.path.join(os.path.abspath(__file__), '..', '..', 'scripts'))
sys.path.insert(0, ROOT_DIR)

path = os.path.join(RESULTS, "signal_results.csv")

df = pd.read_csv(path)
df = df[["technology", "iterations", "interference_distance_km", "inteference_path_loss_dB", 
         "interference_power", "receiver_distance_km", "receiver_path_loss_dB", 
         "sinr_dB"]] 

df.columns = ["Technology", "Iterations", "Interference distance (km)", "Inteference path loss (dB)", 
              "Interference power (dB)", "Receiver distance (km)", "Receiver path loss (dB)", 
              "SINR (dB)"]

long_df = pd.melt(df, id_vars = ["Interference distance (km)", "Technology"], 
          value_vars = ["Interference power (dB)",
          "Receiver distance (km)", "Receiver path loss (dB)", 
          "Inteference path loss (dB)", "SINR (dB)"])

long_df.columns = ["Interference distance (km)", "Technology", "Metric", "Value"]

sns.set(font_scale = 1)

plot = sns.ecdfplot(df, x = "Interference power (dB)", hue = "Technology")

# plot = sns.relplot(x = "Interference distance (km)", y = "Value", linewidth = 0.5,
#        hue = "Technology", col = "Metric", kind = "line", col_wrap = 3,
#        data = long_df, facet_kws = dict(sharex = False, sharey = False), legend = "full")

# plt.subplots_adjust(hspace = 0.25, wspace = 0.25, bottom = 0.07)
# plt.tight_layout()

# plt.savefig(os.path.join(VIS, "simulation plots.png"))
plt.show()