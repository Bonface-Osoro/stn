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

# transmitter coordinates
trans_a, trans_b, trans_c, trans_d, trans_e = [10, 10], [10, 60], [35, 35], [60, 10], [60,60]
trans = [trans_a, trans_b, trans_c, trans_d, trans_e]

# Jammer coordinates
interference_x = [10, 25, 25, 35, 35, 55, 55, 60]
interference_y = [10, 25, 25, 35, 35, 55, 55, 60]

# Receiver coordinates
receiver_x = random.randrange(1, 70)
receiver_y = random.randrange(1, 70)

technologies = ["2G", "3G", "4G", "5G"]

for technology in technologies:
    for rx in range(receiver_x):
        for ry in range(receiver_y):
            for ix in interference_x:
                for iy in interference_y:
                    for t in trans:
                        if t[0] == rx or t[1] == ry or t[0] == ix or t[1] == iy:
                            break
                        else:
                            link_budget = LinkBudget(40, 16, technology, t[0], t[1], rx, ry, ix, iy)

                            inteference_distance_km = link_budget.calc_interference_path()
                            inteference_path_loss_dB = link_budget.calc_interference_path_loss()[0]
                            interference_power = link_budget.calc_jammer_power()

                            receiver_distance_km = link_budget.calc_signal_path()
                            receiver_path_loss_dB = link_budget.calc_radio_path_loss()[0]
                            sinr_dB = link_budget.calc_sinr()

                            signal_results.append({"interference_distance_km": inteference_distance_km,
                            "inteference_path_loss_dB": inteference_path_loss_dB, "interference_power": 
                            interference_power, "receiver_distance_km": receiver_distance_km, 
                            "receiver_path_loss_dB": receiver_path_loss_dB, "sinr_dB": sinr_dB,
                            "technology": technology})

df = pd.DataFrame(signal_results)
df["jamming_power"] = ""

### Obtain the maximum interference distance ###
max_dist = df['interference_distance_km'].max()

for i in df.index: 

    ### set the low scenario to a third of the maximum distance ###
    if df["interference_distance_km"].loc[i] <= 0.33 * max_dist:
        df["jamming_power"].loc[i] = "Low"

    ### set the high scenario to two thirds of the maximum distance ###
    elif df["interference_distance_km"].loc[i] >= 0.66 * max_dist:
        df["jamming_power"].loc[i] = "High"

    else:
        df["jamming_power"].loc[i] = "Baseline"

path = os.path.join(RESULTS, "signal_results.csv")

df.to_csv(path, index = False)           