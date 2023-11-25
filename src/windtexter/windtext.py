import math 
import random
import numpy as np
import pandas as pd

def application_area(use_case):
    """
    The function returns the 
    coefficient representing 
    the importance of the 
    message transmitted.

    Parameters
    ==========
    use_case : string
        The sector affected by 
        jamming.
    
    Returns
    -------
    beta : interger
        Coefficient representing 
        the application area.
    """
    beta = []
    if use_case == 'private':

        beta_list = [1, 2, 3]
        min_cost = min(beta_list)
        max_cost = max(beta_list)
        mean_cost = sum(beta_list) / len(beta_list)
        beta.append([min_cost, mean_cost, max_cost])

    elif use_case == 'commercial':

        beta_list = [4, 5, 6]
        min_cost = min(beta_list)
        max_cost = max(beta_list)
        mean_cost = sum(beta_list) / len(beta_list)
        beta.append([min_cost, mean_cost, max_cost])


    elif use_case == 'government':

        beta_list = [7, 8, 9]
        min_cost = min(beta_list)
        max_cost = max(beta_list)
        mean_cost = sum(beta_list) / len(beta_list)
        beta.append([min_cost, mean_cost, max_cost])

    else:

        beta_list = [10, 11, 12]
        min_cost = min(beta_list)
        max_cost = max(beta_list)
        mean_cost = sum(beta_list) / len(beta_list)
        beta.append([min_cost, mean_cost, max_cost])


    return beta


def calc_cost_probability(probability):
    """
    This function calculates the cost 
    based on probability.

    Parameters
    ==========
    probability : float
        Probability value

    Return
    ======
    costs : list
        The low, baseline and cost due 
        to message failure
    """
    costs = []

    if probability < 0.1:

        cost_list = [random.uniform(90, 100) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.11 and probability < 0.2:

        cost_list = [random.uniform(72, 89) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.21 and probability < 0.3:

        cost_list = [random.uniform(51, 71) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.31 and probability < 0.4:

        cost_list = [random.uniform(28, 50) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.41 and probability < 0.55:

        cost_list = [random.uniform(11, 27.9) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.56 and probability < 0.6:

        cost_list = [random.uniform(3, 10.9) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.61 and probability < 0.75:

        cost_list = [random.uniform(0.1, 2.9) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    elif probability > 0.76 and probability < 0.85:

        cost_list = [random.uniform(0.1, 2.9) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    else:

        cost_list = [random.uniform(0.1, 2.9) for _ in range(3)]
        min_cost = min(cost_list)
        max_cost = max(cost_list)
        mean_cost = sum(cost_list) / len(cost_list)
        costs.append([min_cost, mean_cost, max_cost])

    return costs