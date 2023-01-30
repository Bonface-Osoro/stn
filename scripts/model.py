import configparser
import math
import os
import random
import numpy as np
import pandas as pd
from windtexter.antijammer import Transmitter
from windtexter.antijammer import InterceptorAgent
from windtexter.windtext import Windtexter
from windtexter.windtext import SocioEconomic

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

results = []

site_number = [0, 2, 4]
windtext_probabilities = [0.1, 0.2, 0.3, 0.4, 0.45]
for i in range(1000):
    intercept_prob = Windtexter(windtext_probabilities)
    interception_probability = intercept_prob.intercept_message() 

    block_prob = Windtexter(windtext_probabilities)
    block_probability = block_prob.block_message()

    inter_cost = SocioEconomic(interception_probability)
    interception_cost = inter_cost.cost()

    block_cst = SocioEconomic(block_probability)
    block_cost = block_cst.cost()

    total_cost = interception_cost + block_cost

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
                        "windtexter": strategy, "interception_probability": interception_probability,
                        "interception_cost": interception_cost, "block_probability": block_probability,
                        "message_block_cost": block_cost, "total_cost": total_cost})

results = pd.DataFrame(results)

path = os.path.join(RESULTS, 'windtexter_results.csv')
results.to_csv(path, index = False) 

path = os.path.join(VIS, 'windtexter_results.csv')
results.to_csv(path, index = False)                                          
