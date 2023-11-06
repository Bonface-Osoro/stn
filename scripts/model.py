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
<<<<<<< HEAD

=======
<<<<<<< HEAD

    for area in areas:

        for texts in text_number:

            if texts == text_number[0]:

                technique = "Baseline"
            elif texts == text_number[1]:

                technique = "Partial"
            else:

=======
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b
    for area in areas:

        for texts in text_number:

            if texts == text_number[0]:

                technique = "Baseline"
            elif texts == text_number[1]:

                technique = "Partial"
            else:
<<<<<<< HEAD

=======
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b
                technique = "Full"
            intercept_prob = Windtexter(texts)
            interception_probability = intercept_prob.intercept_message() 

            block_prob = Windtexter(texts)
            block_probability = block_prob.block_message()

            if interception_probability and block_probability <= 0.5:
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b

                status = "unsuccessful"
            else:

<<<<<<< HEAD
=======
=======
                status = "unsuccessful"
            else:
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b
                status = "sucessful"

            # calculate interception probability cost
            inter_cost = SocioEconomic(interception_probability, area)
            interception_cost = inter_cost.cost()

            # calculate interception probability cost by application area
            int_app = inter_cost.application_area()
            
            # calculate blocking probability cost
            block_cst = SocioEconomic(block_probability, area)
            block_cost = block_cst.cost()

            # calculate blocking probability cost by application area
            block_app = block_cst.application_area()

            # Include the application area cost
            int_cst = (interception_cost * int_app) / interception_probability
            blk_cost = (block_cost * block_app) / block_probability

            if technique == "Full":
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b

                final_int_cst = round((int_cst * 1), 2)
                final_blk_cost = round((blk_cost * 1), 2)
            elif technique == "3 sites":

<<<<<<< HEAD
=======
=======
                final_int_cst = round((int_cst * 1), 2)
                final_blk_cost = round((blk_cost * 1), 2)
            elif technique == "3 sites":
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b
                final_int_cst = round((int_cst * 2), 2)
                final_blk_cost = round((blk_cost * 2), 2)
                total_cost = round((final_int_cst + final_blk_cost), 3)
            else:
<<<<<<< HEAD

=======
<<<<<<< HEAD

=======
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b
                final_int_cst = round((int_cst * 3), 2)
                final_blk_cost = round((blk_cost * 3), 2)
                total_cost = round((final_int_cst + final_blk_cost), 3)

            results.append({"iteration": i, "interception": interception_probability, "interception_cost": 
                            final_int_cst, "blocking": block_probability, "message_status": status, 
                            "message_block_cost": final_blk_cost, "total_cost": total_cost, "windtexter": technique, 
                            "application": area})

results = pd.DataFrame(results)

######################################### PREPARE COST RESULTS #######################################

# Select only unsuccessful messages
econ_results = results[results['message_status'] == "unsuccessful"]

# Drop unused columns
econ_results = econ_results.drop(["interception", "blocking", "message_status"], axis=1)

# Melt columns into rows
econ_results = pd.melt(econ_results, id_vars = ["iteration", "windtexter", "application", "total_cost"], 
value_vars = ["interception_cost", "message_block_cost"], 
var_name = "probability_type", value_name = "probability_cost")

########################################### SAVE THE RESULTS #########################################
path = os.path.join(RESULTS, 'windtexter_results.csv')
results.to_csv(path, index = False) 

<<<<<<< HEAD
path = os.path.join(RESULTS, 'cost_results.csv')
=======
<<<<<<< HEAD
path = os.path.join(RESULTS, 'cost_results.csv')
=======
path = os.path.join(VIS, 'windtexter_results.csv')
results.to_csv(path, index = False)   

path = os.path.join(RESULTS, 'cost_results.csv')
econ_results.to_csv(path, index = False) 

path = os.path.join(VIS, 'cost_results.csv')
>>>>>>> e69c3a939e68002412112ec5e6656bc1c211818d
>>>>>>> cdba5dbc500e65bd2f8044d0f47d77e7967ded4b
econ_results.to_csv(path, index = False) 