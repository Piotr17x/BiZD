import pandas as pd
import statistics
from scipy import stats
import matplotlib.pyplot as plt


def zad_1():
    df = pd.read_csv('MDR_RR_TB_burden_estimates_2023-11-28.csv')
    print(df.e_rr_pct_new.describe())


zad_1()
print('=+=+=+=+=+=+=')


def zad_2():
    df = pd.read_csv('Wzrost.csv', header=None)
    df = df.transpose()
    df.columns = ['height']
    print('średnia ', statistics.mean(df.height))
    print('mediana ', statistics.median(df.height))
    print('wariancja ', statistics.variance(df.height))
    print('odchylenie std ', statistics.stdev(df.height))
    print('Odchylenie standardowe to pierwiastek wariancji.')


zad_2()
print('=+=+=+=+=+=+=')


def zad_3():
    df = pd.read_csv('Wzrost.csv', header=None)
    df = df.transpose()
    df.columns = ['height']
    print(stats.describe(df.height))
    print('geometric mean ', stats.gmean(df.height))
    print('harmonic mean ', stats.hmean(df.height))
    print('most common value ', stats.mode(df.height))
    print('powtórzenia ', stats.find_repeats(df.height))
    print('standard error mean ', stats.sem(df.height))


zad_3()
print('=+=+=+=+=+=+=')


def zad_4():
    df = pd.read_csv('brain_size.csv', sep=';')
    print('średnia VIQ', df.VIQ.mean())
    print('male =', len(df[df.Gender == 'Male']))
    print('female =', len(df[df.Gender == 'Female']))
    plt.title('VIQ')
    plt.hist(df.VIQ)
    plt.show()
    plt.title('PIQ')
    plt.hist(df.PIQ)
    plt.show()
    plt.title('FSIQ')
    plt.hist(df.FSIQ)
    plt.show()
    plt.title('VIQ female')
    plt.hist(df[df.Gender == 'Female'].VIQ)
    plt.show()
    plt.title('PIQ female')
    plt.hist(df[df.Gender == 'Female'].PIQ)
    plt.show()
    plt.title('FSIQ female')
    plt.hist(df[df.Gender == 'Female'].FSIQ)
    plt.show()


zad_4()
print('=+=+=+=+=+=+=')
