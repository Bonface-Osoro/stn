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

path = os.path.join(RESULTS, "results.csv")
df = pd.read_csv(path)

df = df[["iteration", "strategy", "probability", "message_status"]]
df = pd.melt(df, id_vars = ["iteration", "message_status", "strategy"], value_vars = ["probability"])
df.columns = ["iteration", "message_status", "strategy", "Metric", "Value"]

cdfs = []
count, bins_count = np.histogram(df["Value"], bins = 10)
pdf = count / sum(count)
cdf = np.cumsum(pdf)
print (bins_count[1:])

list_1 = cdf.tolist()
list_2 = bins_count[1:].tolist()
df1 = pd.DataFrame({'cdf':list_1,'count':list_2})

path = os.path.join(RESULTS, "cdf_results.csv")
df1.to_csv(path, index=False) 

plt.plot(bins_count[1:], pdf, color="red", label="PDF")
plt.plot(bins_count[1:], cdf, label = "CDF")
plt.legend()
plt.show()