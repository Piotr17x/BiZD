import oracledb
import pandas as pd
import numpy as np
import warnings
import config
warnings.filterwarnings("ignore", category=UserWarning)

connection = oracledb.connect(user=config.user, password=config.password,
                              dsn=config.dsn)
cursor = connection.cursor()


# ładowanie do bazy z plików .csv


def insert_parameters(csv_file):
    sql_command = "INSERT INTO parameters (parameter_id, algorithm_id, turn_time, e_greedy, c, sim_depth, playout_number) VALUES (:1, :2, :3, :4, :5, :6, :7)"
    df = pd.read_csv(csv_file)
    df = df.replace(np.nan, None)
    for i, row in df.iterrows():
        data = (row[1], row[0], row[2], row[3], row[4], row[5], row[6])
        cursor.execute(sql_command, data)


def insert_simulations(csv_file):
    sql_command = "INSERT INTO simulations (outcome, red_player, blue_player, turn_cnt) VALUES (:1, :2, :3, :4)"
    sql_command_perf = "INSERT INTO performances (sim_id, parameter_id, atk_cnt_first5, atk_cnt_second5, atk_cnt, move_cnt, rem_hp) VALUES (:1, :2, :3, :4, :5, :6, :7)"
    df = pd.read_csv(csv_file)
    df = df.replace(np.nan, None)
    for i, row in df.iterrows():
        data = (row[0], row[1], row[2], row[3])
        cursor.execute(sql_command, data)
        x = int(pd.read_sql('select max(sim_id) from simulations', connection).iloc[0][0])
        # red
        data = (x, row[1], row[4], row[6], row[8], row[10], row[12])
        cursor.execute(sql_command_perf, data)
        # blue
        data = (x, row[2], row[5], row[7], row[9], row[11], row[13])
        cursor.execute(sql_command_perf, data)


# insert_parameters("algPARAMS.csv")
# insert_simulations("AutoBattleCombatLog20231109214116_1.csv")

connection.commit()
