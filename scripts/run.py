import configparser
import os
import random
import numpy as np
import pandas as pd
from windtexter.link_budget import LinkBudget
CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")

# Receiver coordinates
rec_x = np.random.uniform(0, 72, 2)
rec_y = np.random.uniform(0, 72, 2)

# Jammer coordinates
jam_x = np.random.uniform(0, 72, 2)
jam_y = np.random.uniform(0, 72, 2)

signal_results = []
for rec_xs in rec_x:
    for rec_ys in rec_y:
        for jam_xs in jam_x:
            for jam_ys in jam_y:
                link_budget = LinkBudget(40, 16, 1000, 2.5, 0, 0, rec_xs, rec_ys, jam_xs, jam_ys)

                inteference_distance_km = link_budget.calc_interference_path()
                inteference_path_loss_dB = link_budget.calc_interference_path_loss()
                interference_power = link_budget.calc_jammer_power()

                receiver_distance_km = link_budget.calc_signal_path()
                receiver_path_loss_dB = link_budget.calc_radio_path_loss()

                sinr_dB = link_budget.calc_sinr()

                signal_results.append({"interference_distance_km": inteference_distance_km,
                "inteference_path_loss_dB": inteference_path_loss_dB, "interference_power": 
                interference_power, "receiver_distance_km": receiver_distance_km, 
                "receiver_path_loss_dB": receiver_path_loss_dB, "sinr_dB": sinr_dB})

results = pd.DataFrame(signal_results)

path = os.path.join(RESULTS, 'signal_results.csv')
results.to_csv(path, index=False)           