import scipy.stats as scs
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde


def zad_1():
    norm = scs.norm.rvs(2, 30, 200)
    results = scs.ttest_1samp(norm, 2.5)
    print(results)


zad_1()
print('=+=+=+=+=+=+=')


def zad_2():
    df = pd.read_csv('napoje.csv', sep=';')
    print(f'lech: {scs.ttest_1samp(df.lech, 60500).pvalue:.3f}')
    print(f'cola: {scs.ttest_1samp(df.cola, 222000).pvalue:.3f}')
    print(f'regionalne: {scs.ttest_1samp(df.regionalne, 435400).pvalue:.3f}')


zad_2()
print('=+=+=+=+=+=+=')
