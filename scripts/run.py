import configparser
import os
import random
import numpy as np
import pandas as pd
import time
from windtexter.link_budget import LinkBudget as lb
from windtexter.link_budget import calc_eirp, calc_noise, calc_signal_path 
from windtexter.link_budget import calc_interference_path
from windtexter.windtext import calc_cost_probability, application_area
pd.options.mode.chained_assignment = None

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))

BASE_PATH = CONFIG['file_locations']['base_path']
DATA = os.path.join(BASE_PATH)
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

def antijammer(transmitters):
    """
    This function generate 
    calculates the SINR in 
    the jamming environment

    Parameters
    ----------
    transmitters : int.
        Number of transmitters to simulate.
    power : float.
        Transmitter power in dB.
    antenna_gain : float.
        User Equipment antenna gain.
    technology : string.
        Cellular generation eg '3G' etc.
    transmitter_x : float.
        Transmitter x coordinate.
    transmitter_y : float.
        Transmitter y coordinate.
    receiver_x : float.
        Receiver x coordinate.
    receiver_y : float.
        Receiver y coordinate.
    Interceptor : float.
        Interceptor y coordinate.
    """
    start = time.time()
    print('Running antijammer simulation for {} transmitters'.format(transmitters))
    df = pd.read_csv(os.path.join(DATA, '{}_transmitters_inputs.csv'.format(
        transmitters)))
    df[['interference_distance_km', 'inteference_path_loss_dB', 
        'interference_power', 'receiver_distance_km', 'eirp_db',
        'noise_db', 'receiver_power_dB', 'receiver_path_loss_dB', 
        'snr_dB', 'sinr_dB', 'jamming']] = ''
    
    for i in range(len(df)):
             
        eirp = calc_eirp(df['transmitter_power_db'].loc[i], 
                            df['antenna_gain_db'].loc[i])
        
        noise = (calc_noise(df['technology'].loc[i])[0])
        
        inteference_distance_km = (calc_interference_path(
            df['interceptor_x'].loc[i], df['interceptor_y'].loc[i], 
            df['receiver_x'].loc[i], df['receiver_y'].loc[i]))
        
        receiver_distance_km = (calc_signal_path(df['transmitter_x'].loc[i], 
                df['transmitter_y'].loc[i], df['receiver_x'].loc[i], 
                df['receiver_y'].loc[i]))
        
        receiver_path_loss_dB = (lb.calc_radio_path_loss(
            df['technology'].loc[i], receiver_distance_km)[0])
        
        receiver_power_dB = lb.calc_receiver_power(eirp, 
                            receiver_path_loss_dB)
        
        inteference_path_loss_dB = (lb.calc_interference_path_loss(
            inteference_distance_km, df['technology'].loc[i])[0])
        
        interference_power = lb.calc_jammer_power(eirp, noise, 
                             inteference_path_loss_dB)
        
        snr_dB = lb.calc_baseline_snr(receiver_power_dB, noise) 
        sinr_dB = lb.calc_sinr(receiver_power_dB, 
                  interference_power, noise)
        
        df['eirp_db'].loc[i] = eirp
        df['noise_db'].loc[i] = noise
        df['interference_distance_km'].loc[i] = inteference_distance_km
        df['inteference_path_loss_dB'].loc[i] = inteference_path_loss_dB
        df['interference_power'].loc[i] = interference_power
        df['receiver_distance_km'].loc[i] = receiver_distance_km
        df['receiver_path_loss_dB'].loc[i] = receiver_path_loss_dB 
        df['receiver_power_dB'].loc[i] = receiver_power_dB 
        df['snr_dB'].loc[i] = snr_dB
        df['sinr_dB'].loc[i] = sinr_dB

        ### Obtain the maximum interference distance ###
    max_dist = df['interference_distance_km'].max()

    for i in range(len(df)): 

        if df["interference_distance_km"].loc[i] <= 0.25 * max_dist:

            df["jamming"].loc[i] = "High"

        ### set the high scenario to two thirds of the maximum distance ###
        elif df["interference_distance_km"].loc[i] >= 0.60 * max_dist:

            df["jamming"].loc[i] = "Low"

        else:

            df["jamming"].loc[i] = "Baseline"


    fileout = '{}_signal_results.csv'.format(transmitters)
    folder_out = os.path.join(RESULTS)

    if not os.path.exists(folder_out):
        os.makedirs(folder_out)

    path_out = os.path.join(folder_out, fileout)
    df.to_csv(path_out, index = False)

    executionTime = (time.time() - start)
    print('Execution time in minutes: ' + str(round(executionTime / 60, 2))) 


    return None


def windtext(transmitters):
    """
    This function calculate 
    SINR based on jamming 
    scenario.

    Parameters
    ----------
    transmitters : int.
        Number of transmitters to simulate.
    power : float.
        Transmitter power in dB.
    antenna_gain : float.
        User Equipment antenna gain.
    technology : string.
        Cellular generation eg '3G' etc.
    transmitter_x : float.
        Transmitter x coordinate.
    transmitter_y : float.
        Transmitter y coordinate.
    receiver_x : float.
        Receiver x coordinate.
    receiver_y : float.
        Receiver y coordinate.
    Interceptor : float.
        Interceptor y coordinate.
    """
    start = time.time()
    print('Running secure texting simulation for {} transmitters'.format(transmitters))
    df = pd.read_csv(os.path.join(DATA, '{}_secure_data.csv'.format(
        transmitters)))
    df[['interference_distance_km', 'inteference_path_loss_dB', 
        'interference_power', 'receiver_distance_km', 'eirp_db',
        'noise_db', 'receiver_power_dB', 'receiver_path_loss_dB', 
        'snr_dB', 'sinr_dB', 'jamming']] = ''
    
    for i in range(len(df)):
             
        eirp = calc_eirp(df['transmitter_power_db'].loc[i], 
                            df['antenna_gain_db'].loc[i])
        
        noise = (calc_noise(df['technology'].loc[i])[0])
        
        inteference_distance_km = (calc_interference_path(
            df['interceptor_x'].loc[i], df['interceptor_y'].loc[i], 
            df['receiver_x'].loc[i], df['receiver_y'].loc[i]))
        
        receiver_distance_km = (calc_signal_path(df['transmitter_x'].loc[i], 
                df['transmitter_y'].loc[i], df['receiver_x'].loc[i], 
                df['receiver_y'].loc[i]))
        
        receiver_path_loss_dB = (lb.calc_radio_path_loss(
            df['technology'].loc[i], receiver_distance_km)[0])
        
        receiver_power_dB = lb.calc_receiver_power(eirp, 
                            receiver_path_loss_dB)
        
        inteference_path_loss_dB = (lb.calc_interference_path_loss(
            inteference_distance_km, df['technology'].loc[i])[0])
        
        interference_power = lb.calc_jammer_power(eirp, noise, 
                             inteference_path_loss_dB)
        
        snr_dB = lb.calc_baseline_snr(receiver_power_dB, noise) 
        sinr_dB = lb.calc_sinr(receiver_power_dB, 
                  interference_power, noise)
        
        df['eirp_db'].loc[i] = eirp
        df['noise_db'].loc[i] = noise
        df['interference_distance_km'].loc[i] = inteference_distance_km
        df['inteference_path_loss_dB'].loc[i] = inteference_path_loss_dB
        df['interference_power'].loc[i] = interference_power
        df['receiver_distance_km'].loc[i] = receiver_distance_km
        df['receiver_path_loss_dB'].loc[i] = receiver_path_loss_dB 
        df['receiver_power_dB'].loc[i] = receiver_power_dB 
        df['snr_dB'].loc[i] = snr_dB
        df['sinr_dB'].loc[i] = sinr_dB

        ### Obtain the maximum interference distance ###
    max_dist = df['interference_distance_km'].max()

    for i in range(len(df)): 

        if df["interference_distance_km"].loc[i] <= 0.25 * max_dist:

            df["jamming"].loc[i] = "High"

        ### set the high scenario to two thirds of the maximum distance ###
        elif df["interference_distance_km"].loc[i] >= 0.60 * max_dist:

            df["jamming"].loc[i] = "Low"

        else:

            df["jamming"].loc[i] = "Baseline"


    path = os.path.join(RESULTS, "{}_texting_results.csv".format(transmitters))
    df.to_csv(path, index = False)

    executionTime = (time.time() - start)
    print('Execution time in minutes: ' + str(round(executionTime / 60, 2))) 

    return None


def merge_files():
    merged_data = pd.DataFrame()

    base_directory = os.path.join(RESULTS) 

    for root, _, files in os.walk(base_directory):

        for file in files:

            if file.endswith('_signal_results.csv'):
                
                file_path = os.path.join(base_directory, file)
                df = pd.read_csv(file_path)

                merged_data = pd.concat([merged_data, df], ignore_index = True)

                fileout = 'full_jamming_results.csv'
                folder_out = os.path.join(RESULTS)

                if not os.path.exists(folder_out):

                    os.makedirs(folder_out)

                path_out = os.path.join(folder_out, fileout)
                merged_data.to_csv(path_out, index = False)


    return None


def assign_probabilities():

    start = time.time()
    df1 = pd.DataFrame()
    base_directory = os.path.join(RESULTS) 

    print('Generating probabilities and calculating costs')
    for root, _, files in os.walk(base_directory):

        for file in files:

            if file.endswith('_texting_results.csv'):
                
                file_path = os.path.join(base_directory, file)
                df = pd.read_csv(file_path)

                df1 = pd.concat([df1, df], ignore_index = True)
                min_value = df1['sinr_dB'].min()
                max_value = df1['sinr_dB'].max()
                normalized_values = (df1['sinr_dB'] - min_value) / (max_value - min_value)
                probabilities = normalized_values * 0.98 + 0.1
                df1['probability'] = round(probabilities, 2)
                df1[['message', 'low_cost', 'baseline_cost', 'high_cost']] = ''

                for i in range(len(df1)):

                    if df1['probability'].loc[i] >= 0.53:

                        df1['message'].loc[i] = 'success'

                    else:

                        df1['message'].loc[i] = 'fail'

                    if df1['text_scenario'].loc[i] == 'baseline':

                        coefficient = 6
                        beta = application_area(df1['application_area'].loc[i])
                        costs = calc_cost_probability(df1['probability'].loc[i])
                        df1['low_cost'].loc[i] = (((costs[0][0]) * (coefficient) 
                                                * (beta[0][0])) / 
                                                (df1['probability'].loc[i]))
                        df1['baseline_cost'].loc[i] = (((costs[0][1]) * (coefficient) 
                                                * (beta[0][1])) / 
                                                (df1['probability'].loc[i]))
                        df1['high_cost'].loc[i] = (((costs[0][2]) * (coefficient) 
                                                * (beta[0][2])) / 
                                                (df1['probability'].loc[i]))
                        
                    elif df1['text_scenario'].loc[i] == 'partial':

                        coefficient = 4
                        beta = application_area(df1['application_area'].loc[i])
                        costs = calc_cost_probability(df1['probability'].loc[i])
                        df1['low_cost'].loc[i] = (((costs[0][0]) * (coefficient) 
                                                * (beta[0][0])) / 
                                                (df1['probability'].loc[i]))
                        df1['baseline_cost'].loc[i] = (((costs[0][1]) * (coefficient) 
                                                * (beta[0][1])) / 
                                                (df1['probability'].loc[i]))
                        df1['high_cost'].loc[i] = (((costs[0][2]) * (coefficient) 
                                                * (beta[0][2])) / 
                                                (df1['probability'].loc[i]))
                    else:
                        
                        coefficient = 2
                        beta = application_area(df1['application_area'].loc[i])
                        costs = calc_cost_probability(df1['probability'].loc[i])
                        df1['low_cost'].loc[i] = (((costs[0][0]) * (coefficient) 
                                                * (beta[0][0])) / 
                                                (df1['probability'].loc[i]))
                        df1['baseline_cost'].loc[i] = (((costs[0][1]) * (coefficient) 
                                                * (beta[0][1])) / 
                                                (df1['probability'].loc[i]))
                        df1['high_cost'].loc[i] = (((costs[0][2]) * (coefficient) 
                                                * (beta[0][2])) / 
                                                (df1['probability'].loc[i]))
                        
    df1 = pd.melt(df1, id_vars = ['text_scenario', 'probability', 
         'jamming', 'technology', 'message', 'application_area'], 
         value_vars = ['low_cost', 'baseline_cost', 'high_cost'], 
         var_name = 'cost_scenario', value_name = 'cost') 
                          
    df1 = df1[['text_scenario', 'jamming', 'technology', 
               'probability', 'message', 'cost_scenario', 
               'cost', 'application_area']]
    
    fileout = 'full_windtexter_results.csv'
    folder_out = os.path.join(RESULTS)

    if not os.path.exists(folder_out):

        os.makedirs(folder_out)

    path_out = os.path.join(folder_out, fileout)
    df1.to_csv(path_out, index = False)
    executionTime = (time.time() - start)
    print('Execution time in minutes: ' + str(round(executionTime / 60, 2))) 


    return None


if __name__ == "__main__": 
     
    transmitters = [1, 3, 5]
    for transmitter in transmitters:

        #antijammer(transmitter)
        #windtext(transmitter)
        pass

    #merge_files()
    assign_probabilities()