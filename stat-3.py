import scipy.stats as scs
import pandas as pd


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


def zad_3():
    df = pd.read_csv('napoje.csv', sep=';')
    test_results = scs.normaltest(df)
    new_df = pd.DataFrame([[round(x, 3) for x in test_results.pvalue]], columns=df.columns)
    print(new_df)


zad_3()
print('=+=+=+=+=+=+=')


def zad_4():
    df = pd.read_csv('napoje.csv', sep=';')
    print('rowność średnich')
    results = scs.ttest_ind(df['okocim'], df['lech'])
    print(f'okocim - lech: {results.pvalue:.3f}')
    results = scs.ttest_ind(df['fanta '], df['regionalne'])
    print(f'fanta - regionalne: {results.pvalue:.3f}')
    results = scs.ttest_ind(df['cola'], df['pepsi'])
    print(f'cola - pepsi: {results.pvalue:.3f}')


zad_4()
print('=+=+=+=+=+=+=')


def zad_5():
    df = pd.read_csv('napoje.csv', sep=';')
    print('rowność wariancji')
    results = scs.levene(df['okocim'], df['lech'])
    print(f'okocim - lech: {results.pvalue:.3f}')
    results = scs.levene(df['żywiec'], df['fanta '])
    print(f'żywiec - fanta: {results.pvalue:.3f}')
    results = scs.levene(df['regionalne'], df['cola'])
    print(f'regionalne - cola: {results.pvalue:.3f}')


zad_5()
print('=+=+=+=+=+=+=')


def zad_6():
    df = pd.read_csv('napoje.csv', sep=';')
    print('równość średnich pomiędzy latami 2001 i 2015 dla piw regionalnych')
    print(f"{scs.ttest_ind(df[df['rok'] == 2001]['regionalne'], df[df['rok'] == 2015]['regionalne']).pvalue:.5f}")


zad_6()
print('=+=+=+=+=+=+=')


def zad_7():
    df = pd.read_csv('napoje.csv', sep=';')
    df2 = pd.read_csv('napoje_po_reklamie.csv', sep=';')
    print('cola')
    print(f"{scs.ttest_rel(df[df['rok'] == 2016]['cola'], df2['cola']).pvalue:.5f}")
    print('fanta')
    print(f"{scs.ttest_rel(df[df['rok'] == 2016]['fanta '], df2['fanta ']).pvalue:.5f}")
    print('pepsi')
    print(f"{scs.ttest_rel(df[df['rok'] == 2016]['pepsi'], df2['pepsi']).pvalue:.5f}")


zad_7()
print('=+=+=+=+=+=+=')
