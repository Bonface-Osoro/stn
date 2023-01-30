import math 
import random
import numpy as np
import pandas as pd

class Windtexter:
    """
    This class represents a windtexter application where critical messages have been hidden on plain sight
    before transmission to multiple networks.
    """
    def __init__(self, probability):
        """Class constructor
        Args:
            probability : A list of probability value
        """
        self.probability = probability


    def intercept_message(self):
        """The function creates probability values of intercepting the messages.
        
        Returns
        -------
        intercept_val : float
            A probability value.
        """
        intercept_val = round(random.choice(self.probability) + random.choice(self.probability), 1)

        return intercept_val
    

    def block_message(self):
        """The function creates probability values of blocking the messages.
        
        Returns
        -------
        block_val : float
            A probability value.
        """
        block_val = round(random.choice(self.probability) + random.choice(self.probability), 1)

        return block_val

class SocioEconomic:
    """
    This class seek to quantify the economic impacts of message interception or blocking.
    """   
    def __init__(self, probability):
        """Class constructor
        Args:
            probability : A list of probability value
        """
        self.probability = probability

    def cost(self):
        """The function quantifies the cost associated with intercepting or blocking the message.
        
        Returns
        -------
        cost : interger
            Monetary cost of intercepting or blocking messages.
        """
        if self.probability == 0.1:
            cost = 1000
        elif self.probability == 0.2:
            cost = 2000
        elif self.probability == 0.3:
            cost = 3000
        elif self.probability == 0.4:
            cost = 4000
        elif self.probability == 0.5:
            cost = 5000
        elif self.probability == 0.6:
            cost = 6000
        elif self.probability == 0.7:
            cost = 7000
        elif self.probability == 0.8:
            cost = 8000
        elif self.probability == 0.9:
            cost = 9000
        else:
            cost = 10000

        return cost

if __name__ == "__main__":  
     x = Windtexter([0.1, 0.2, 0.3, 0.4, 0.45]) 
     y = x.block_message() 
     print(y)
if __name__ == "__main__":  
     x = SocioEconomic(y) 
     y = x.cost() 
     print(y)