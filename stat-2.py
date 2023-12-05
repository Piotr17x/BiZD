import scipy.stats as scs
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde


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


def zad_2_3_4():
    p = 0.5
    data_b = scs.bernoulli.rvs(p, size=100)
    mean, var, skew, kurt = scs.bernoulli.stats(p, moments='mvsk')
    print(mean, var, skew, kurt)
    data_d = [scs.binom.rvs(1, p) for x in range(100)]
    mean, var, skew, kurt = scs.binom.stats(1, p, moments='mvsk')
    print(mean, var, skew, kurt)
    data_p = [scs.poisson.rvs(p) for x in range(100)]
    mean, var, skew, kurt = scs.poisson.stats(p, moments='mvsk')
    print(mean, var, skew, kurt)
    fig, ax = plt.subplots(3, 1)
    kde = gaussian_kde(data_b)
    dist_space = np.linspace(min(data_b), max(data_b), 100)
    ax[0].plot(dist_space, kde(dist_space))
    ax[0].set_title('bernoulli')
    kde = gaussian_kde(data_d)
    dist_space = np.linspace(min(data_d), max(data_d), 100)
    ax[1].plot(dist_space, kde(dist_space))
    ax[1].set_title('binom')
    kde = gaussian_kde(data_p)
    dist_space = np.linspace(min(data_p), max(data_p), 100)
    ax[2].plot(dist_space, kde(dist_space))
    ax[2].set_title('poisson')
    plt.show()


# zad_2_3_4()
print('=+=+=+=+=+=+=')

def zad_5():
    suma = sum([scs.binom.pmf(x, 20, 0.4) for x in range(20)])
    print(suma)


zad_5()
print('=+=+=+=+=+=+=')


def zad_6():
    print('100:=')
    norm = scs.norm.rvs(0, 2, 100)
    print('mean ',norm.mean())
    print('svd ',np.std(norm))
    print('10000:=')
    norm = scs.norm.rvs(0, 2, 10000)
    print('mean ',norm.mean())
    print('svd ',np.std(norm))
    print('Zwiększenie liczby prób zwiększa dokładność statystyk')


zad_6()
print('=+=+=+=+=+=+=')


def zad_7():
    x = np.linspace(scs.norm.ppf(0.01), scs.norm.ppf(0.99), 100)
    norm = scs.norm.rvs(1, 2, 100)
    dens = scs.norm(-1, 0.5)
    fig, ax = plt.subplots(3, 1)
    ax[0].hist(norm, label='normal')
    ax[0].set_title('norm')
    kde = gaussian_kde(norm)
    dist_space = np.linspace(min(norm), max(norm), 100)
    ax[1].plot(dist_space,kde(dist_space), label='stnd')
    ax[1].set_title('stnd')
    ax[2].plot(dist_space, dens.pdf(dist_space), 'k-', lw=3, label='Normalny – z próby')
    ax[2].set_title('dens')
    plt.show()


zad_7()
print('=+=+=+=+=+=+=')
