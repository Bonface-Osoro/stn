import configparser
import os
import numpy as np
import pandas as pd
from windtexter.link_budget import LinkBudget
pd.options.mode.chained_assignment = None

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

signal_results = []

# transmitter coordinates
trans_a, trans_b, trans_c, trans_d, trans_e = [4, 4], [4, 14], [8, 8], [14, 4], [14,14]
trans = [trans_a, trans_b, trans_c, trans_d, trans_e]

# Jammer coordinates
int_a, int_b, int_c, int_d, int_e = [4.1, 4.1], [4.1, 14.1], [8.1, 8.1], [14.1, 4.1], [14.1, 14.1]
interferences = [int_a, int_b, int_c, int_d, int_e]

# Receiver coordinates
receiver_x = np.arange(start = 1, stop = 16, step = 1)
receiver_y = np.arange(start = 1, stop = 16, step = 1)

technologies = ["2G", "3G", "4G", "5G"]

#for iterations in range(10):
for technology in technologies:

    for rx in receiver_x:

        for ry in receiver_y:

            for interference in interferences:

                for t in trans:

                    if t[0] == rx or t[1] == ry or t[0] == interference[0] or t[1] == interference[1]:
                        break
                    else:

                        link_budget = LinkBudget(40, 16, technology, t[0], t[1], rx, ry, interference[0], interference[1])

                        inteference_distance_km = link_budget.calc_interference_path()
                        inteference_path_loss_dB = link_budget.calc_interference_path_loss()[0]
                        interference_power = link_budget.calc_jammer_power()

                        receiver_distance_km = link_budget.calc_signal_path()
                        receiver_path_loss_dB = link_budget.calc_radio_path_loss()[0]
                        receiver_power_dB = link_budget.calc_receiver_power()
                        snr_dB = link_budget.calc_baseline_snr()
                        sinr_dB = link_budget.calc_sinr()

                        signal_results.append({"receiver_x": rx, "receiver_y": ry, "interference_x": interference[0], 
                        "interference_y": interference[1], "transmitter_x": t[0], "transmitter_y": t[1], "interference_distance_km": 
                        inteference_distance_km, "inteference_path_loss_dB": inteference_path_loss_dB, 
                        "interference_power": interference_power, "receiver_distance_km": receiver_distance_km, 
                        "receiver_power_dB": receiver_power_dB, "receiver_path_loss_dB": receiver_path_loss_dB,
                        "snr_dB": snr_dB, "sinr_dB": sinr_dB, "technology": technology})

df = pd.DataFrame(signal_results)
df["jamming"] = ""

### Obtain the maximum interference distance ###
max_dist = df['interference_distance_km'].max()
print(max_dist)
for i in df.index: 

    ### set the low scenario to a third of the maximum distance ###
    if df["interference_distance_km"].loc[i] <= 0.25 * max_dist:
<<<<<<< HEAD

=======
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
        df["jamming"].loc[i] = "Low"

    ### set the high scenario to two thirds of the maximum distance ###
    elif df["interference_distance_km"].loc[i] >= 0.75 * max_dist:
<<<<<<< HEAD

        df["jamming"].loc[i] = "High"

    else:

=======
        df["jamming"].loc[i] = "High"

    else:
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
        df["jamming"].loc[i] = "Baseline"

path = os.path.join(RESULTS, "signal_results.csv")
df.to_csv(path, index = False) 