import math
import random
import numpy as np
from agents import SenderAgent
from agents import InterceptorAgent

class Attack:
    """
    This class represents the process of an interception by a malicious user in a network.
    They try to decrypt, read and block the users if the message is successfully decrypted.
    """
    def compare(self):
        """This function compares the message from the sender.

        Returns
        -------
        interception_rslt : dictionary
            Contains the message interception probability and status       
        """
        interception_rslt = dict()
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

        interception_rslt["probability"] = probability
        interception_rslt["status"] = status
        interception_rslt["block"] = block

        return interception_rslt

a = Attack()
b = a.compare()
print(b)