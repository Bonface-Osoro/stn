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
    def __init__(self, probability, use_case):
        """Class constructor
        Args:
            probability (float) : A probability value
            use_case (string) : Application area of the secure text (e.g private, commercial etc)
        """
        self.probability = probability
        self.use_case = use_case


    def cost(self):
        """The function quantifies the cost associated with intercepting or blocking the message.
        
        Returns
        -------
        cost : interger
            Monetary cost of intercepting or blocking messages.
        """
        if self.probability == 0.1:
            cost = 10
        elif self.probability == 0.2:
            cost = 7.2
        elif self.probability == 0.3:
            cost = 5.1
        elif self.probability == 0.4:
            cost = 2.8
        elif self.probability == 0.5:
            cost = 1.1
        elif self.probability == 0.6:
            cost = 0.3
        elif self.probability == 0.7:
            cost = 0.1
        elif self.probability == 0.8:
            cost = 0.1
        elif self.probability == 0.9:
            cost = 0.1
        else:
            cost = 0.1

        return cost
    

    def application_area(self):
        """The function returns the coefficient representing the 
           importance of the message transmitted.
        
        Returns
        -------
        beta : interger
            Coefficient representing the application area.
        """
        if self.use_case == "private":
            beta = 2
        elif self.use_case == "commercial":
            beta = 4
        elif self.use_case == "government":
            beta = 6
        else:
            beta = 8
        
        return beta

if __name__ == "__main__":  
     x = Windtexter(4) 
     y = x.intercept_message() 
     print(y)
if __name__ == "__main__":  
     x = Windtexter(4) 
     y = x.block_message() 
     print(y)
if __name__ == "__main__":  
     x = SocioEconomic(y, 'private') 
     y = x.cost() 
     print(y)