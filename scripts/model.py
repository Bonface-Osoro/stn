import configparser
import math
import os
import random
import numpy as np
import pandas as pd
from windtexter.antijammer import Transmitter
from windtexter.antijammer import InterceptorAgent

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

results = []

site_number = [0, 2, 4]
for i in range(1000):
    for sites in site_number:
        if sites == site_number[0]:
            strategy = "baseline"
        elif sites == site_number[1]:
            strategy = "partial"
        else:
            strategy = "Full"
        interception = InterceptorAgent(sites)
        probability = interception.decrypt_message() 
        if probability <= 0.5:
            status = "unsuccessful"
        else:
            status = "successful"

        results.append({"iteration": i, "probability": probability, "message_status": status, 
                        "windtexter": strategy})

results = pd.DataFrame(results)

path = os.path.join(RESULTS, 'windtexter_results.csv')
results.to_csv(path, index = False) 

path = os.path.join(VIS, 'windtexter_results.csv')
results.to_csv(path, index = False)                                          
