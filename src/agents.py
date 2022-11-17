import math
import mesa
import networkx as nx
import random
from enum import Enum


class Site:
    """
    This class represents a radio access point that handles the transmisssion and reception of the data.
    It represents the cell/Wi-fi base stations and also satellite.
    """
    def __init__(self, pos_x, pos_y, unique_id, site_type, attack_status):
        """Class constructor

        Args:
            pos_x (float): Agent's x axis position
            pos_y (float): Agent's x axis position
            unique_id (interger): Agent's unique identification information
            site_type (string): Types of the site (cellular, wi-fi or satellite)
            attack_status (interger): Whether the agent is attacked or not (0, 1 and 2 - normal, 
            attacked, compromised)
        """

        self.pos_x = pos_x
        self.pos_y = pos_y
        self.unique_id = unique_id
        self.site_type = site_type
        self.attack_status = attack_status
    
    def broadcast_details(self):
        """Provide basic details
        """
        print([self.unique_id, self.pos_x, self.pos_y, self.site_type, self.attack_status])

class Sender_agent:
    """
    This class represents a user sending and receiving data to and from the network.
    """
    def __init__(self, pos_x, pos_y, unique_id):
        """Class constructor

        Args:
            pos_x (float): Agent's x axis position
            pos_y (float): Agent's x axis position
            unique_id (interger): Agent's unique identification information
        """

        self.pos_x = pos_x
        self.pos_y = pos_y
        self.unique_id = unique_id

class Interceptor_agent:
    """
    This class represents a malcious user in the network who tries to decrypt, read and block 
    data transmission and reception.
    """
    def __init__(self, pos_x, pos_y, unique_id):
        """Class constructor

        Args:
            pos_x (float): Agent's x axis position
            pos_y (float): Agent's x axis position
            unique_id (interger): Agent's unique identification information
        """

        self.pos_x = pos_x
        self.pos_y = pos_y
        self.unique_id = unique_id
a = Site(10.1, 5.1, "001", "4G", 0)
a.broadcast_details()