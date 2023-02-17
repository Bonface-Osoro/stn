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
areas = ["private", "commercial", "government", "millitary"]

for i in range(1000):
    for area in areas:
        for texts in text_number:
            if texts == text_number[0]:
                technique = "Baseline"
            elif texts == text_number[1]:
                technique = "Partial"
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

            inter_cost = SocioEconomic(interception_probability, area)
            interception_cost = inter_cost.cost()
            
            block_cst = SocioEconomic(block_probability, area)
            block_cost = block_cst.cost()

            int_cst = interception_cost / interception_probability
            blk_cost = block_cost / block_probability

            total_cost = interception_cost + block_cost

            if technique == "Full":
                total_cost = round((total_cost * 1), 3)
            elif technique == "3 sites":
                total_cost = round((total_cost * 2), 3)
            else:
                total_cost = round((total_cost * 3), 3)

            results.append({"iteration": i, "interception": interception_probability, "interception_cost": 
                            interception_cost, "blocking": block_probability, "message_status": status, 
                            "message_block_cost": block_cost, "total_cost": total_cost, "windtexter": technique, 
                            "application": area})

results = pd.DataFrame(results)

######################################### PREPARE COST RESULTS #######################################

# Select only unsuccessful messages
econ_results = results[results['message_status'] == "unsuccessful"]

# Drop unused columns
econ_results = econ_results.drop(["interception_cost", "message_block_cost", "message_status"], axis=1)

# Melt columns into rows
econ_results = pd.melt(econ_results, id_vars =["iteration", "windtexter", "application", "total_cost"], 
value_vars =["interception", "blocking"], var_name = "probability_type", value_name = "probability")

# Save the results
path = os.path.join(RESULTS, 'windtexter_results.csv')
results.to_csv(path, index = False) 

path = os.path.join(VIS, 'windtexter_results.csv')
results.to_csv(path, index = False)   

path = os.path.join(RESULTS, 'cost_results.csv')
econ_results.to_csv(path, index = False) 

path = os.path.join(VIS, 'cost_results.csv')
econ_results.to_csv(path, index = False) 