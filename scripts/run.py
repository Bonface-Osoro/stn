import configparser
import os
import random
import numpy as np
import pandas as pd
from windtexter.link_budget import LinkBudget
pd.options.mode.chained_assignment = None

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")

signal_results = []
technologies = ["2G", "3G", "4G", "5G"]
for technology in technologies:
    for iterations in range(1000):

        # Jammer coordinates
        interference_x = random.randrange(1, 70)
        interference_y = random.randrange(1, 70)

        # Receiver coordinates
        receiver_x = random.randrange(1, 70)
        receiver_y = random.randrange(1, 70)

        link_budget = LinkBudget(40, 16, technology, 0, 0, receiver_x, receiver_y, interference_x, interference_y)
        
        inteference_distance_km = link_budget.calc_interference_path()
        inteference_path_loss_dB = link_budget.calc_interference_path_loss()[0]
        interference_power = link_budget.calc_jammer_power()

        receiver_distance_km = link_budget.calc_signal_path()
        receiver_path_loss_dB = link_budget.calc_radio_path_loss()[0]

        sinr_dB = link_budget.calc_sinr()

        signal_results.append({"iterations": iterations, "interference_distance_km": 
        inteference_distance_km, "inteference_path_loss_dB": inteference_path_loss_dB, 
        "interference_power": interference_power, "receiver_distance_km": receiver_distance_km, 
        "receiver_path_loss_dB": receiver_path_loss_dB, "sinr_dB": sinr_dB, "technology": technology})

df = pd.DataFrame(signal_results)
df["jamming_power"] = ""
max_power = df['interference_power'].max()
min_power = df['interference_power'].min()

for i in df.index: 

    if df["interference_power"].loc[i] <= -27:
        df["jamming_power"].loc[i] = "Low"

    elif df["interference_power"].loc[i] >= 21:
        df["jamming_power"].loc[i] = "High"

    else:
        df["jamming_power"].loc[i] = "Baseline"

path = os.path.join(RESULTS, "signal_results.csv")
df.to_csv(path, index=False)           