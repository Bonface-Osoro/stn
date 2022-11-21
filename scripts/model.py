import configparser
import math
import os
import random
import numpy as np
import pandas as pd
from windtexter import SenderAgent
from windtexter import InterceptorAgent

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']
RESULTS = os.path.join(BASE_PATH)

class Attack: #runner call it
    """
    This class represents the process of an interception by a malicious user in a network.
    They try to decrypt, read and block the users if the message is successfully decrypted.
    """
    def compare(self, number_of_attempts):
        """This function compares the message from the sender.

        Returns
        -------
        interception_rslt : dictionary
            Contains the message interception probability and status       
        """
        interception_results = []
        for number in range(0, number_of_attempts):
            call_sender = SenderAgent(22, 44, "091k") # Access sender class
            sender_text = call_sender.send_text() # Print the sender message
            #Probability of the sender's message being intercepted between 0 and 1. 
            probability = sum(sender_text) / 10

            if probability >= 0.75:
                status = "intercepted" #Indicates whether message has been read
                block = "block"        #Ability to block the user
            elif probability >=0.5 and probability <= 0.75:
                status = "susceptible"
                block = "attempt"
            else:
                status = "secure"
                block = "unable"

            interception_results.append({"attempts": number, "probability": probability,
                                        "status": status, "block": block})
        all_results = pd.DataFrame(interception_results)

        if not os.path.exists(RESULTS):
            os.makedirs(RESULTS) 
            path = os.path.join(RESULTS, 'interception_results.csv')
            all_results.to_csv(path, index=False)                                          

        return interception_results

a = Attack()
b = a.compare(10)
print(b)