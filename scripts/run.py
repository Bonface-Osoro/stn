import configparser
import os
import random
import numpy as np
import pandas as pd
import tqdm
from windtexter.link_budget import LinkBudget as lb
from windtexter.link_budget import calc_eirp, calc_noise, calc_signal_path 
from windtexter.link_budget import calc_interference_path

pd.options.mode.chained_assignment = None

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))

BASE_PATH = CONFIG['file_locations']['base_path']
DATA = os.path.join(BASE_PATH)
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

def antijammer():
    """
    This function generate 
    calculates the SINR in 
    the jamming environment

    Parameters
    ----------
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
    print('Running simulation')
    df = pd.read_csv(os.path.join(DATA, 'sim_inputs.csv'))
    df[['interference_distance_km', 'inteference_path_loss_dB', 
        'interference_power', 'receiver_distance_km', 
        'receiver_power_dB', 'receiver_path_loss_dB', 
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

        df['interference_distance_km'].loc[i] = inteference_distance_km
        df['inteference_path_loss_dB'].loc[i] = inteference_path_loss_dB
        df['interference_power'].loc[i] = interference_power
        df['receiver_distance_km'].loc[i] = receiver_distance_km
        df['receiver_power_dB'].loc[i] = receiver_path_loss_dB
        df['receiver_path_loss_dB'].loc[i] = receiver_power_dB
        df['snr_dB'].loc[i] = snr_dB
        df['sinr_dB'].loc[i] = sinr_dB

        ### Obtain the maximum interference distance ###
    max_dist = df['interference_distance_km'].max()

    for i in range(len(df)): 

        ### set the low scenario to a third of the maximum distance ###
        if df["interference_distance_km"].loc[i] <= 0.25 * max_dist:

            df["jamming"].loc[i] = "Low"

        ### set the high scenario to two thirds of the maximum distance ###
        elif df["interference_distance_km"].loc[i] >= 0.75 * max_dist:

            df["jamming"].loc[i] = "High"

        else:

            df["jamming"].loc[i] = "Baseline"


    path = os.path.join(RESULTS, "signal_results.csv")
    df.to_csv(path, index = False)


    return None

if __name__ == "__main__": 
    
    antijammer()