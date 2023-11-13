import configparser
import os
import random
import numpy as np
import pandas as pd
from windtexter.inputs import parameters

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
DATA = os.path.join(BASE_PATH)
RESULTS = os.path.join("results")

def covert(transmitters):
    
    df1 = pd.read_csv(os.path.join(
        DATA, '{}_transmitters_inputs.csv'.format(
        transmitters)))
 

    return print(df1.shape)


if __name__ == "__main__": 
    
    transmitters = [1, 2, 3, 4, 5]
    for transmitter in transmitters:

        covert(transmitter)