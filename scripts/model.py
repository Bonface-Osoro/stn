import configparser
import math
import os
import random
import numpy as np
import pandas as pd
from windtexter.windtext import Windtexter
from windtexter.windtext import SocioEconomic

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

results = []

site_number = [0, 2, 4]
text_number = [0, 2, 4]

for i in range(10):
    for texts in text_number:
        if texts == text_number[0]:
            technique = "None"
        elif texts == text_number[1]:
            technique = "3 sites"
        else:
            technique = "Full"
        intercept_prob = Windtexter(texts)
        interception_probability = intercept_prob.intercept_message() 

        block_prob = Windtexter(texts)
        block_probability = block_prob.block_message()

        if interception_probability and block_probability <= 0.5:
            status = "unsuccessful"
        else:
            status = "sucessful"

        inter_cost = SocioEconomic(interception_probability)
        interception_cost = inter_cost.cost()

        block_cst = SocioEconomic(block_probability)
        block_cost = block_cst.cost()
        
        total_cost = interception_cost + block_cost

        if technique == "Full":
            total_cost = 0.5 * total_cost
        elif technique == "3 sites":
            total_cost = 0.25 * total_cost
        else:
            total_cost = total_cost

        results.append({"iteration": i, "interception_probability": interception_probability, "interception_cost": 
                        interception_cost, "block_probability": block_probability, "message_status": status, 
                        "message_block_cost": block_cost, "total_cost": total_cost, "anti-jamming": technique})

results = pd.DataFrame(results)

path = os.path.join(RESULTS, 'windtexter_results.csv')
results.to_csv(path, index = False) 

path = os.path.join(VIS, 'windtexter_results.csv')
results.to_csv(path, index = False)                                          
