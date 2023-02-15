import math 
import random
import numpy as np
import pandas as pd


class TextProbabilities:
    """
    This class represents the probability values of intercepting or blocking a windtexter message.
    """
    def __init__(self):
        """Class constructor
        Args:
            windtext_1...windtext_n (string): windtext names
        """
        self.windtext_1, self.windtext_2, self.windtext_3, self.windtext_4, \
            self.windtext_5 = "windtext_1", "windtext_2", "windtext_3", "windtext_4", "windtext_5"


    def create_windtexts(self):
        """The agent creates untruested wireless networks.
        
        Returns
        -------
        sites : list
            A list containing the created sites.
        """
        self.windtext_1 = [0.1, 0.2, 0.3, 0.4, 0.45]
        self.windtext_2 = [0.1, 0.2, 0.3, 0.45, 0.45]
        self.windtext_3 = [0.2, 0.2, 0.3, 0.45, 0.45]
        self.windtext_4 = [0.2, 0.3, 0.3, 0.45, 0.45]
        self.windtext_5 = [0.3, 0.4, 0.45, 0.45, 0.45]
        texts = [self.windtext_1, self.windtext_2, self.windtext_3, self.windtext_4, self.windtext_5]

        return texts


class Windtexter:
    """
    This class represents a windtexter application where critical messages have been hidden on plain sight
    before transmission to multiple networks.
    """
    def __init__(self, number_of_texts):
        """Class constructor
        Args:
            number_of_texts (interger): number of windtext to choose from the list
        """
        self.number_texts = number_of_texts


    def intercept_message(self):
        """The function creates probability values of intercepting the messages.
        
        Returns
        -------
        intercept_val : float
            A probability value.
        """
        texter = TextProbabilities()
        text = texter.create_windtexts()
        intercept_val = round(random.choice(text[self.number_texts]) + random.choice(text[self.number_texts]), 1)

        return intercept_val
    

    def block_message(self):
        """The function creates probability values of blocking the messages.
        
        Returns
        -------
        block_val : float
            A probability value.
        """
        texter = TextProbabilities()
        text = texter.create_windtexts()
        block_val = round(random.choice(text[self.number_texts]) + random.choice(text[self.number_texts]), 1)

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
            cost = 10000
        elif self.probability == 0.2:
            cost = 9000
        elif self.probability == 0.3:
            cost = 8000
        elif self.probability == 0.4:
            cost = 7000
        elif self.probability == 0.5:
            cost = 6000
        elif self.probability == 0.6:
            cost = 5000
        elif self.probability == 0.7:
            cost = 4000
        elif self.probability == 0.8:
            cost = 3000
        elif self.probability == 0.9:
            cost = 2000
        else:
            cost = 1000

        return cost

if __name__ == "__main__":  
     x = Windtexter(4) 
     y = x.intercept_message() 
     print(y)
if __name__ == "__main__":  
     x = Windtexter(4) 
     y = x.block_message() 
     print(y)
if __name__ == "__main__":  
     x = SocioEconomic(y) 
     y = x.cost() 
     print(y)