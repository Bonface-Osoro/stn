"""
Spatial Based Radio Signal Interference modelling

Written by Osoro Bonface
November 2022
George Mason university, USA

"""
import math
import numpy as np
import pandas as pd

def calc_eirp(power, antenn_gain):
    """
    Calculate the Equivalent Isotropically Radiated Power.
    Equivalent Isotropically Radiated Power (EIRP) = (
        Power + Gain)

    Parameters
    ----------
    power (float) : 
        Transmitter power in watts.
    antenna_gain (float) : 
        Antenna gain in dB.

    Returns
    -------
    eirp : float
        eirp in dB.
    """
    eirp = power  + antenn_gain

    return eirp


def calc_noise(technology):
    """
    Estimates unwanted electromagnetic noise.

    Parameters
    ----------
    technology : string.
        technology (str) : Cellular technology 
        (2G, 3G, 4G or 5G)

    Returns
    -------
    noise_dict : list
        Received noise at the UE receiver in dB.
    """
    k = 1.38e-23 #Boltzmann's constant k = 1.38×10−23 joules per kelvin
    t = 290 #Temperature of the receiver system T0 in kelvins

    noise_list = []
    if technology == "2G":

        bandwidth = 6.8        # In MHz
        noise = (10 * (math.log10((k * t * 1000)))) + \
                (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
        noise_list.append(noise)

    elif technology == "3G":

        bandwidth = 25
        noise = (10 * (math.log10((k * t * 1000)))) + \
                (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
        noise_list.append(noise)
    
    elif technology == "4G":

        bandwidth = 100
        noise = (10 * (math.log10((k * t * 1000)))) + \
                (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
        noise_list.append(noise)
    
    elif technology == "5G":

        bandwidth = 30000
        noise = (10 * (math.log10((k * t * 1000)))) + \
        (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
        noise_list.append(noise)

    else:

        print("Invalid Technology Input")

    return noise_list


def calc_signal_path(transmitter_x, transmitter_y, 
                        receiver_x, receiver_y):
    """
    Calculate the Euclidean distance between the transmitter
    and receiver.

    Parameters
    ----------
    transmitter_x (float) : 
        x coordinates of transmitter (km).
    transmitter_y (float) : 
        y coordinates of transmitter (km).
    receiver_x (float) : 
        x coordinates of receiver (km).
    receiver_y (float) : 
        y coordinates of receiver (km).

    Returns
    -------
    distance : float
        Distance in km.
    """
    x_term = (receiver_x - transmitter_x) ** 2
    y_term = (receiver_y - transmitter_y) ** 2
    distance = math.sqrt(x_term + y_term)

    return distance


def calc_interference_path(jammer_x, jammer_y, 
                            receiver_x, receiver_y):
    """
    Calculates the Euclidean distance between the transmitter
    and the jammer.

    Parameters
    ----------
    jammer_x (float) : 
        x coordinates of jammer (km).
    jammer_y (float) : 
        y coordinates of jammer (km).
    receiver_x (float) : 
        x coordinates of receiver (km).
    receiver_y (float) : 
        y coordinates of receiver (km).

    Returns
    -------
    jammer_distance : float
        Jammer's distance from the base station in km.
    """  
    x_i_term = (jammer_x - receiver_x) ** 2
    y_i_term = (jammer_y - receiver_y) ** 2 
    jammer_distance = math.sqrt(x_i_term + y_i_term)

    return jammer_distance


class LinkBudget:
    """
    This class estimates the wireless radio link budget
    """
    '''def __init__(self, power, antenna_gain, technology, 
                 transmitter_x, transmitter_y, receiver_x, 
                 receiver_y, jammer_x, jammer_y):'''
    def __init__(self):
        """
        A class constructor.

        """
   

    def calc_radio_path_loss(technology, signal_path):
        """
        Calculate path loss between transmitter and base station 
        assuming an isotropic radiating antenna.

        Parameters
        ----------
        technology : string.
            Cellular technology 
            (2G, 3G, 4G or 5G)
        signal_path : float.
            signal path in km

        Returns
        -------
        rx_path_loss : list
            Receiver Path loss in dB.
        """
        rx_path_loss = []

        if technology == "2G":

            frequency = 0.85       # In GHz
            rx_path = 20 * math.log10(signal_path) + \
                        20 * math.log10(frequency) + 92.45
            rx_path_loss.append(rx_path)

        elif technology == "3G":

            frequency = 1.9
            rx_path = 20 * math.log10(signal_path) + \
                        20 * math.log10(frequency) + 92.45
            rx_path_loss.append(rx_path)

        elif technology == "4G":

            frequency = 3.5
            rx_path = 20 * math.log10(signal_path) + \
            20 * math.log10(frequency) + 92.45 
            rx_path_loss.append(rx_path)

        elif technology == "5G":

            frequency = 26
            rx_path = 20 * math.log10(signal_path) + \
            20 * math.log10(frequency) + 92.45 
            rx_path_loss.append(rx_path)

        else:

            print("Invalid Technology Input")   

        return rx_path_loss
    

    def calc_receiver_power(eirp, path_loss_db):
        """
        Calculates the received power at the user equipment.

        Parameters
        ----------
        eirp_db (float) : 
            EIRP power.
        path_loss_db (float) : 
            Free space path loss in dB.

        Returns
        ----------
        power : float.
        """
        transmitted_power = eirp
        power_lost = path_loss_db - 4 + 4 -4
        received_power = transmitted_power - power_lost

        return received_power


    def calc_interference_path_loss(jammer_path, technology):
        """
        Calculates the path loss between the jammer 
        and the transmitter

        Parameters
        ----------
        jammer_path : float
            Distance between the jammer 
            and the user equipment
        technology : string.
            technology (str) : Cellular technology 
            (2G, 3G, 4G or 5G)

        Returns
        -------
        jam_path_loss : list
            Jammer Path loss in dB.
        """
        jam_path_loss = []
        if technology == "2G":

            frequency = 0.85
            jam_path = 20 * math.log10(jammer_path) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        elif technology == "3G":

            frequency = 1.9
            jam_path = 20 * math.log10(jammer_path) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        elif technology == "4G":

            frequency = 3.5
            jam_path = 20 * math.log10(jammer_path) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        elif technology == "5G":

            frequency = 26
            jam_path = 20 * math.log10(jammer_path) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        else:
            
            print("Invalid Technology Input")

        return jam_path_loss


    def calc_jammer_power(eirp_db, noise_db, 
                          jammer_path_loss_db):
        """
        Calculates the power 
        transmitted by jammer.

        Parameters
        ==========
        eirp_db : float
            Transmitted power in dB
        noise_db : float
            Jammer noise power  
        jammer_path_loss_db : float
            Distance between the jammer 
            and the user equipment

        Returns
        =======
        jammer_power : float
            The power transmitted by 
            the jammer
        """
        transmitted_power = eirp_db
        power_lost = jammer_path_loss_db - 4 + 4 -4
        jam_power = transmitted_power - power_lost
        jammer_power = np.log10((10 ** jam_power) / (10 ** noise_db))

        return jammer_power


    def calc_baseline_snr(received_power, noise_db):
        """
        Calculates the baseline 
        signal to noise ratio in 
        the absence of a jammer

        Parameters
        ==========
        received_power : float
            Power received by UE in dB
        noise_db : float
            Jammer noise power  

        Returns
        -------
        snr : float
            sinr in dB.
        """
        snr = (10 * np.log10(10 ** received_power
               ) / (10 ** noise_db)) 
        
        return snr


    def calc_sinr(received_power, 
                  jammer_power, 
                  noise_db):
        """
        Calculates the signal to 
        interfernce plus noise ratio

        Parameters
        ==========
        received_power : float
            Power received by UE in dB
        jammer_power : float
            Power transmitted by the jammer
        noise_db : float
            Jammer noise power 

        Returns
        -------
        sinr : float
            sinr in dB.
        """
        sinr = (np.log10(10 ** received_power) / 
                (10 ** jammer_power 
                 + 10 ** noise_db)) 
        
        return sinr