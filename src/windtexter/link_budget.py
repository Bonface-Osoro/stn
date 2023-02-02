"""
Spatial Based Radio Signal Interference modelling

Written by Osoro Bonface
November 2022
George Mason university, USA

"""
import math
import numpy as np
import pandas as pd

class LinkBudget:
    """
    This class estimates the wireless radio link budget
    """
    def __init__(self, power, antenna_gain, technology, 
                 transmitter_x, transmitter_y, receiver_x, 
                 receiver_y, jammer_x, jammer_y):
        """
        A class constructor.

        Arguments
        ----------
        power (float) : Transmitter power in watts.
        antenna_gain (float) : Antenna gain in dB.
        technology (str) : Cellular technology (2G, 3G, 4G or 5G)
        transmitter_x (float) : x coordinates of transmitter (km).
        transmitter_y (float) : y coordinates of transmitter (km).
        receiver_x (float) : x coordinates of receiver (km).
        receiver_y (float) : y coordinates of receiver (km).
        jammer_x (float) : x coordinates of jammer (km).
        jammer_y (float) : y coordinates of jammer (km).
        """
        self.power = power
        self.antenn_gain = antenna_gain
        self.technology = technology
        self.transmitter_x = transmitter_x
        self.transmitter_y = transmitter_y
        self.receiver_x = receiver_x
        self.receiver_y = receiver_y
        self.jammer_x = jammer_x
        self.jammer_y = jammer_y


    def calc_eirp(self):
        """
        Calculate the Equivalent Isotropically Radiated Power.
        Equivalent Isotropically Radiated Power (EIRP) = (
            Power + Gain)

        Returns
        -------
        eirp : float
            eirp in dB.
        """
        eirp = self.power  + self.antenn_gain - 1

        return eirp


    def calc_noise(self):
        """
        Estimates unwanted electromagnetic noise.

        Returns
        -------
        noise_dict : list
            Received noise at the UE receiver in dB.
        """
        k = 1.38e-23 #Boltzmann's constant k = 1.38×10−23 joules per kelvin
        t = 290 #Temperature of the receiver system T0 in kelvins

        noise_list = []
        if self.technology == "2G":
            bandwidth = 6.8        # In MHz
            noise = (10 * (math.log10((k * t * 1000)))) + \
                    (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
            noise_list.append(noise)

        elif self.technology == "3G":
            bandwidth = 25
            noise = (10 * (math.log10((k * t * 1000)))) + \
                    (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
            noise_list.append(noise)
        
        elif self.technology == "4G":
            bandwidth = 100
            noise = (10 * (math.log10((k * t * 1000)))) + \
                    (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
            noise_list.append(noise)
        
        elif self.technology == "5G":
            bandwidth = 30000
            noise = (10 * (math.log10((k * t * 1000)))) + \
            (10 * (math.log10(bandwidth * 10 ** 6))) + 1.5
            noise_list.append(noise)

        else:
            print("Invalid Technology Input")

        return noise_list


    def calc_signal_path(self):
        """
        Calculate the Euclidean distance between the transmitter
        and receiver.

        Returns
        -------
        distance : float
            Distance in km.
        """
        x_term = (self.receiver_x - self.transmitter_x) ** 2
        y_term = (self.receiver_y - self.transmitter_y) ** 2
        distance = math.sqrt(x_term + y_term)

        return distance
    

    def calc_radio_path_loss(self):
        """
        Calculate path loss between transmitter and base station 
        assuming an isotropic radiating antenna.

        Returns
        -------
        rx_path_loss : list
            Receiver Path loss in dB.
        """
        rx_path_loss = []

        if self.technology == "2G":
            frequency = 0.85       # In GHz
            rx_path = 20 * math.log10(self.calc_signal_path()) + \
                        20 * math.log10(frequency) + 92.45
            rx_path_loss.append(rx_path)

        elif self.technology == "3G":
            frequency = 1.9
            rx_path = 20 * math.log10(self.calc_signal_path()) + \
                        20 * math.log10(frequency) + 92.45
            rx_path_loss.append(rx_path)

        elif self.technology == "4G":
            frequency = 3.5
            rx_path = 20 * math.log10(self.calc_signal_path()) + \
            20 * math.log10(frequency) + 92.45 
            rx_path_loss.append(rx_path)

        elif self.technology == "5G":
            frequency = 26
            rx_path = 20 * math.log10(self.calc_signal_path()) + \
            20 * math.log10(frequency) + 92.45 
            rx_path_loss.append(rx_path)

        else:
            print("Invalid Technology Input")   

        return rx_path_loss
    

    def calc_receiver_power(self):
        """
        Calculates the received power at the user equipment.
        """
        transmitted_power = self.calc_eirp()
        power_lost = self.calc_radio_path_loss()[0] - 4 + 4 -4
        received_power = transmitted_power - power_lost

        return received_power


    def calc_interference_path(self):
        """
        Calculates the Euclidean distance between the transmitter
        and the jammer.

        Returns
        -------
        jammer_distance : float
            Jammer's distance from the base station in km.
        """  
        x_i_term = (self.jammer_x - self.receiver_x) ** 2
        y_i_term = (self.jammer_y - self.receiver_y) ** 2 
        jammer_distance = math.sqrt(x_i_term + y_i_term)

        return jammer_distance
    

    def calc_interference_path_loss(self):
        """
        Calculates the path loss between the jammer 
        and the transmitter

        Returns
        -------
        jam_path_loss : list
            Jammer Path loss in dB.
        """
        jam_path_loss = []
        if self.technology == "2G":
            frequency = 0.85
            jam_path = 20 * math.log10(self.calc_interference_path()) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        elif self.technology == "3G":
            frequency = 1.9
            jam_path = 20 * math.log10(self.calc_interference_path()) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        elif self.technology == "4G":
            frequency = 3.5
            jam_path = 20 * math.log10(self.calc_interference_path()) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        elif self.technology == "5G":
            frequency = 26
            jam_path = 20 * math.log10(self.calc_interference_path()) + \
                        20 * math.log10(frequency) + 92.45
            jam_path_loss.append(jam_path)

        else:
            print("Invalid Technology Input")

        return jam_path_loss


    def calc_jammer_power(self):
        """
        Calculates the power transmitted by jammer.
        """
        transmitted_power = self.calc_eirp()
        power_lost = self.calc_interference_path_loss()[0] - 4 + 4 -4
        jam_power = transmitted_power - power_lost
        jammer_power = np.log10((10 ** jam_power) / (10 ** self.calc_noise()[0]))

        return jammer_power


    def calc_baseline_snr(self):
        """
        Calculates the baseline signal to noise ratio in the absence of a jammer

        Returns
        -------
        snr : float
            sinr in dB.
        """
        snr = np.log10(10 ** self.calc_receiver_power()) / \
               (10 ** self.calc_noise()[0]) 
        
        return snr


    def calc_sinr(self):
        """
        Calculates the signal to interfernce plus noise ratio

        Returns
        -------
        sinr : float
            sinr in dB.
        """
        sinr = np.log10(10 ** self.calc_receiver_power()) / \
               (10 ** self.calc_jammer_power() + 10 ** self.calc_noise()[0]) 
        
        return sinr

## Test the Code ##
if __name__ == "__main__":  
        
    x = LinkBudget(40, 16, "3G", 0, 0, 10, 10, 15, 15)
    y = x.calc_sinr()
    print(y)