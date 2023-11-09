import random
import numpy as np

class Transmitter:
    """
    This class represents a radio access point that handles the transmisssion and reception of the data.
    It represents the cell/Wi-fi base stations and also satellite.
    """
    def __init__(self):
        """Class constructor
        Args:
            site_1...site_n (string): tranmistter names
        """
        self.site_1, self.site_2, self.site_3, self.site_4, self.site_5 = "site_1", "site_2", "site_3", "site_4", "site_5"

    def create_transmitters(self):
        """The agent creates untruested wireless networks.
        
        Returns
        -------
        sites : list
            A list containing the created sites.
        """
        self.site_1 = [0.5, 0.6, 0.7, 0.8, 0.9]
        self.site_2 = [0.5, 0.6, 0.8, 0.8, 0.9]
        self.site_3 = [0.5, 0.7, 0.7, 0.9, 0.9]
        self.site_4 = [0.5, 0.5, 0.7, 0.9, 0.9]
        self.site_5 = [0.5, 0.6, 0.6, 0.8, 0.9]
        sites = [self.site_1, self.site_2, self.site_3, self.site_4, self.site_5]

        return sites


class InterceptorAgent:
    """
    This class represents a malcious user in the network who tries to decrypt, read and block 
    data transmission and reception.
    """
    def __init__(self, number_of_transmitters):
        """Class constructor
        Args:
            number_of_transmitters (interger): number of transmitters to choose from the list.
        """
        self.number_of_transmitters = number_of_transmitters
        
    def decrypt_message(self):
        """Intercepts the message by a ceratin random probability.
        
        Returns
        -------
        message_success : float
            Probability of message interception.
        """
        interception_probability = [0.1, 0.2, 0.3, 0.4]
        transmitter = Transmitter()
        target_transmitter = transmitter.create_transmitters()
        probability = random.choice(target_transmitter[self.number_of_transmitters])
        interception_code = random.choice(interception_probability)
        message_success = round(probability - interception_code, 1)

        return message_success
        
# Test the classes
if __name__ == "__main__":  
     x = InterceptorAgent(4) 
     y = x.decrypt_message() 
     print(y)