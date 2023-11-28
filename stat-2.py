import scipy.stats as scs
import pandas as pd


def zad_1():
    df = pd.DataFrame([
        [1, 1/6],
        [2, 1/6],
        [3, 1/6],
        [4, 1/6],
        [5, 1/6],
        [6, 1/6],
    ], columns=['wartość', 'prawdopodobieństwo'])
    print(df.wartość.describe())
    print(df.prawdopodobieństwo.describe())


zad_1()
print('=+=+=+=+=+=+=')


def zad_2():
    p = 0.3
    data_b = scs.bernoulli.rvs(p, size=100)
    data_d = scs.binom.rvs(p)
    print(data_d)



zad_2()
print('=+=+=+=+=+=+=')
