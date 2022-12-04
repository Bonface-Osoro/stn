"""
Spatial Based Radio Signal Interference modelling

Written by Osoro Bonface
November 2022
Geroge Mason university, US

"""
import math
import numpy as np

class LinkBudget:
    """
    This class estimates the wireless radio link budget
    """
    def __init__(self, power, antenna_gain, bandwidth, 
                 frequency, transmitter_x, transmitter_y, 
                 receiver_x, receiver_y, jammer_x, jammer_y):
        """
        A class constructor.

        Arguments
        ----------
        power (float) : Transmitter power in watts.
        antenna_gain (float) : Antenna gain in dB.
        losses (float) : Antenna losses in dB.
        bandwidth (int) : The bandwidth of the carrier frequency (MHz).
        distance (float) : Euclidean distance between the transmitter 
                           and receiver in kilometres.
        frequency (int) : frequency of the radio wave in (GHz).
        interference (float) : Unwanted in-band interference from 
                               other radio antennas
        transmitter_x (int) : x coordinates of transmitter (km).
        transmitter_y (int) : y coordinates of transmitter (km).
        receiver_x (int) : x coordinates of receiver (km).
        receiver_y (int) : y coordinates of receiver (km).
        """
        self.power = power
        self.antenn_gain = antenna_gain
        self.bandwidth = bandwidth
        self.frequency = frequency
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
        noise : float
            Received noise at the UE receiver in dB.
        """
        k = 1.38e-23 #Boltzmann's constant k = 1.38×10−23 joules per kelvin
        t = 290 #Temperature of the receiver system T0 in kelvins

        noise = (10 * (math.log10((k * t * 1000)))) + \
                (10 * (math.log10(self.bandwidth * 10 ** 6))) + 1.5

        return noise

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
        y_term = (self.receiver_y - self.transmitter_x) ** 2
        distance = math.sqrt(x_term + y_term)

        return distance
    
    def calc_radio_path_loss(self):
        """
        Calculate path loss between transmitter and base station 
        assuming an isotropic radiating antenna.

        Returns
        -------
        rx_path_loss : float
            Receiver Path loss in dB.
        """
        rx_path_loss = 20 * math.log10(self.calc_signal_path()) + \
                    20 * math.log10(self.frequency) + 92.45

        return rx_path_loss
    
    def calc_receiver_power(self):
        """
        Calculates the received power at the user equipment.
        """
        transmitted_power = self.calc_eirp()
        power_lost = self.calc_radio_path_loss() - 4 + 4 -4
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
        x_i_term = (self.jammer_x - self.transmitter_x) ** 2
        y_i_term = (self.jammer_y - self.transmitter_y) ** 2 
        jammer_distance = math.sqrt(x_i_term + y_i_term)

        return jammer_distance
    
    def calc_interference_path_loss(self):
        """
        Calculates the path loss between the jammer 
        and the transmitter

        Returns
        -------
        jam_path_loss : float
            Jammer Path loss in dB.
        """
        jam_path_loss = 20 * math.log10(self.calc_interference_path()) + \
                    20 * math.log10(self.frequency) + 92.45

        return jam_path_loss

    def calc_jammer_power(self):
        """
        Calculates the power transmitted by jammer.
        """
        transmitted_power = self.calc_eirp()
        power_lost = self.calc_interference_path_loss() - 4 + 4 -4
        jammer_power = transmitted_power - power_lost

        return jammer_power

    def calc_jamming_sinr(self):
        """
        Calculates the snr from the jammer.

        Returns
        -------
        jammer_sinr : float
            Jammer sinr.
        """
        jammer_sinr = np.log10((10 ** self.calc_jammer_power()) / \
                      (10 ** self.calc_noise())) 
        
        return jammer_sinr

    def calc_sinr(self):
        """
        Calculates the signal to interfernce plus noise ratio

        Returns
        -------
        sinr : float
            sinr in dB.
        """
        sinr = np.log10(10 ** self.calc_receiver_power()) / \
               (10 ** self.calc_jamming_sinr() + 10 ** self.calc_noise()) 
        
        return sinr

if __name__ == "__main__":  
        
    x = LinkBudget(40, 16, 1000, 2.5, 0, 0, 2, 0, 10, 0)
    y = x.calc_sinr()
    print(y)