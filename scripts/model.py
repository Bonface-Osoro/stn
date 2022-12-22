import configparser
import math
import os
import random
import numpy as np
import pandas as pd
from windtexter.agents import SenderAgent
from windtexter.agents import InterceptorAgent

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join("results")
VIS = os.path.join("vis")

class Attack: #runner call it
    """
    This class represents the process of an interception by a malicious user in a network.
    They try to decrypt, read and block the users if the message is successfully decrypted.
    """
    def compare(self, iteration):
        """This function compares the message from the sender.

        Returns
        -------
        interception_rslt : dictionary
            Contains the message interception probability and status       
        """
        interception_results = []

        for number in range(0, iteration):
            decrypt_list = [0, 10, 20]
            for crypt in decrypt_list:
                call_sender = InterceptorAgent("091k") # Access sender class
                sender_text = call_sender.decrypt_text(crypt) # Print the sender message
                #Probability of the sender's message being intercepted between 0 and 1. 
                probability = sender_text / 100
            
                if probability >= 0.65:
                    status = "intercepted" #Indicates whether message has been read
                    scenario = "Baseline"        #Ability to block the user
                elif probability >= 0.5 and probability <= 0.65:
                    status = "susceptible"
                    scenario = "Partial"
                else:
                    status = "secure"
                    scenario = "Full"

                interception_results.append({"attempts": number, "probability": probability,
                                            "status": status, "windtexter": scenario})
        results = pd.DataFrame(interception_results)

        path = os.path.join(RESULTS, 'sim_results.csv')
        results.to_csv(path, index = False) 

        path = os.path.join(VIS, 'sim_results.csv')
        results.to_csv(path, index = False)                                          

        return None

a = Attack()
b = a.compare(100000)
print(b)