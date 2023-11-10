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

def generate_coordinates():
    """
    This function generate 
    coordinates for the transmitter, 
    interceptor and receiver
    """

    print('Generating transmitter, receiver and interceptor random coordinates')
    transmitter_number = [1, 2, 3]
    df_merge = pd.DataFrame()
    for key, item in parameters.items():

        transmitter_powers = ([random.uniform((item['power_db'] - 5), 
                             (item['power_db'] + 5)) for _ in range(10)])
        
        low_power = np.percentile(transmitter_powers, 25)
        high_power = np.percentile(transmitter_powers, 65)
        
        antenna_gains = ([random.uniform((item['antenna_gain_db'] - 3), 
                        (item['antenna_gain_db'] + 3)) for _ in range(10)])
        
        low_gain = np.percentile(antenna_gains, 25)
        high_gain = np.percentile(antenna_gains, 65)
        
        technologies = item['technologies']
        
        for technology in technologies:

            for trans_power in transmitter_powers:

                for antenna_gain in antenna_gains:

                    if trans_power < low_power or antenna_gain < low_gain:
                        
                        power_scenario = 'low'

                    elif trans_power < high_power or antenna_gain > high_gain:

                        power_scenario = 'high'

                    else:

                        power_scenario = 'baseline'

                    for tran in transmitter_number:

                        if tran == 1:

                            range_number = 50

                        elif tran == 2:

                            range_number = 100

                        else:

                            range_number = 150

                        transmitter_x = ([random.uniform(0, item['grid_length']) 
                                        for _ in range(range_number)])
                        transmitter_y = ([random.uniform(0, item['grid_length']) 
                                        for _ in range(range_number)])
                        receiver_x = ([random.uniform(0, item['grid_length']) 
                                    for _ in range(range_number)])
                        receiver_y = ([random.uniform(0, item['grid_length']) 
                                    for _ in range(range_number)])
                        interceptor_x = ([random.uniform(0, item['grid_length']) 
                                        for _ in range(range_number)]) 
                        interceptor_y = ([random.uniform(0, item['grid_length']) 
                                        for _ in range(range_number)])
                        
                        df = pd.DataFrame({'transmitter_x': transmitter_x, 
                                        'transmitter_y': transmitter_y,
                                        'receiver_x': receiver_x,
                                        'receiver_y': receiver_y,
                                        'interceptor_x': interceptor_x,
                                        'interceptor_y': interceptor_y,
                                        'no_transmitters': tran,
                                        'transmitter_power_db': trans_power,
                                        'antenna_gain_db': antenna_gain,
                                        'technology': technology,
                                        'power_scenario': power_scenario})
                        df_merge = pd.concat([df_merge, df], ignore_index = True)

    fileout = 'sim_inputs.csv' 
    folder_out = os.path.join(DATA)    
    if not os.path.exists(folder_out):

        os.makedirs(folder_out)

    path_out = os.path.join(folder_out, fileout) 
    df_merge.to_csv(path_out, index = False)


    return None


if __name__ == "__main__": 

    generate_coordinates()