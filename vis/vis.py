import os
import sys
import configparser
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
pd.options.mode.chained_assignment = None

CONFIG = configparser.ConfigParser()
CONFIG.read(os.path.join(os.path.dirname(__file__), '..', 'scripts', 'script_config.ini'))
BASE_PATH = CONFIG['file_locations']['base_path']


DATA_INTERMEDIATE = os.path.join(BASE_PATH, "results")
RESULTS = os.path.join(BASE_PATH, '..', 'results')
VIS = os.path.join(BASE_PATH, '..', 'vis', 'figures')
print(DATA_INTERMEDIATE)

ROOT_DIR = os.path.normpath(os.path.join(os.path.abspath(__file__), '..', '..', 'scripts'))
sys.path.insert(0, ROOT_DIR)

path = os.path.join(RESULTS, "interception_results.csv")
df = pd.read_csv(path)

df = df[["attempts", "probability", "status"]]
df = pd.melt(df, id_vars = ["attempts", "status"], value_vars = ["probability"])
df.columns = ["attempts", "status", "Metric", "Value"]

df[["intercepted", "susceptible", "secure"]] = " "

for i in df.index:
    if df["status"].loc[i] == "secure":
        df["secure"].loc[i] = df["Value"].loc[i]
        df["intercepted"].loc[i] = 0
        df["susceptible"].loc[i] = 0
    elif df["status"].loc[i] == "intercepted":
        df["intercepted"].loc[i] = df["Value"].loc[i]
        df["secure"].loc[i] = 0
        df["susceptible"].loc[i] = 0
    else:
        df["susceptible"].loc[i] = df["Value"].loc[i]
        df["secure"].loc[i] = 0
        df["intercepted"].loc[i] = 0
df = df[["Value", "attempts", "intercepted", "susceptible", "secure"]]

path = os.path.join(RESULTS, "processed_results.csv")
df.to_csv(path, index=False)   

cdfs = []
count, bins_count = np.histogram(df["secure"], bins = 10)
pdf = count / sum(count)
cdf = np.cumsum(pdf)
print (len(cdf), len(count))

list_1 = cdf.tolist()
list_2 = count.tolist()
print(list_1)
df = pd.DataFrame({'cdf':list_1,'count':list_2})
#cdfs.append({"cdf", list_1})
path = os.path.join(RESULTS, "cdf_results.csv")
df.to_csv(path, index=False) 

#plt.plot(bins_count[1:], pdf, color="red", label="PDF")
plt.plot(bins_count[1:], cdf, label = "CDF")
plt.legend()
plt.show()