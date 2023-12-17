// Funkcje ze skryptu zapisującego dane do pliku .csv i prosto do bazy.

public static void saveCombatLog(string fileName, string outcome, string red_team, string blue_team, int turnOfGameEnd,
    int attackCnt_0To5_R, int attackCnt_0To5_B, int attackCnt_5To10_R, int attackCnt_5To10_B, int attackCnt_Red, int attackCnt_Blue, int moveCnt_Red, int moveCnt_Blue, int BlueUnit, int RedUnit
    )
{

    bool writeTitleFlag = false;
    if (!System.IO.File.Exists(fileName))
    {
        writeTitleFlag = true;
    }

    using (StreamWriter w = new StreamWriter(fileName, true))
    {
        if (writeTitleFlag)
        {
            w.WriteLine("outcome,red_team,blue_team,EndTurn,AttackCntRed_0_5,AttackCntBlue_0_5,attackCntRed_6_11,attackCntBlue_6_11,attackCnt_Red,attackCnt_Blue,moveCnt_Red,moveCnt_Blue,AllUnitHP_Red,AllUnitHP_Blue"
            );
        }
        w.WriteLine(
            outcome + "," + red_team + "," + blue_team + "," + turnOfGameEnd + "," + attackCnt_0To5_R + "," + attackCnt_0To5_B + "," + attackCnt_5To10_R + "," + attackCnt_5To10_B + "," + attackCnt_Red + "," + attackCnt_Blue + "," + moveCnt_Red + "," + moveCnt_Blue + "," + RedUnit + "," + BlueUnit
        );
    }

    string sql_command = "INSERT INTO simulations (outcome, red_player, blue_player, turn_cnt) VALUES (:1, :2, :3, :4)";
    string sql_command_perf = "INSERT INTO performances (sim_id, parameter_id, atk_cnt_first5, atk_cnt_second5, atk_cnt, move_cnt, rem_hp) VALUES (:1, :2, :3, :4, :5, :6, :7)";


    OracleConnection connection = new OracleConnection(connectionString);
    OracleCommand command = new OracleCommand(sql_command, connection);

    // sim
    command.Parameters.Add(new OracleParameter("1", OracleDbType.Varchar2)).Value = outcome;
    command.Parameters.Add(new OracleParameter("2", OracleDbType.Varchar2)).Value = red_team;
    command.Parameters.Add(new OracleParameter("3", OracleDbType.Varchar2)).Value = blue_team;
    command.Parameters.Add(new OracleParameter("4", OracleDbType.Varchar2)).Value = turnOfGameEnd;

    try
    {
        connection.Open();
        command.ExecuteNonQuery();
        Logger.addLogMessage("\r\n" + "sim inserted", 1);

        // get sim_id
        int sim_id = -1;
        sql_command = "SELECT max(sim_id) FROM simulations";
        command = new OracleCommand(sql_command, connection);
        OracleDataReader reader = command.ExecuteReader();
        reader.Read();
        sim_id = int.Parse(reader["max(sim_id)"].ToString());
        Logger.addLogMessage("\r\n" + "max id = "+sim_id, 1);

        //insert 1st perf
        command = new OracleCommand(sql_command_perf, connection);
        command.Parameters.Add(new OracleParameter("1", OracleDbType.Varchar2)).Value = sim_id;
        command.Parameters.Add(new OracleParameter("2", OracleDbType.Varchar2)).Value = red_team;
        command.Parameters.Add(new OracleParameter("3", OracleDbType.Varchar2)).Value = attackCnt_0To5_R;
        command.Parameters.Add(new OracleParameter("4", OracleDbType.Varchar2)).Value = attackCnt_5To10_R;
        command.Parameters.Add(new OracleParameter("5", OracleDbType.Varchar2)).Value = attackCnt_Red;
        command.Parameters.Add(new OracleParameter("6", OracleDbType.Varchar2)).Value = moveCnt_Red;
        command.Parameters.Add(new OracleParameter("7", OracleDbType.Varchar2)).Value = RedUnit;
        command.ExecuteNonQuery();
        Logger.addLogMessage("\r\n" + "perf red inserted", 1);

        //insert 2nd perf
        command = new OracleCommand(sql_command_perf, connection);
        command.Parameters.Add(new OracleParameter("1", OracleDbType.Varchar2)).Value = sim_id;
        command.Parameters.Add(new OracleParameter("2", OracleDbType.Varchar2)).Value = blue_team;
        command.Parameters.Add(new OracleParameter("3", OracleDbType.Varchar2)).Value = attackCnt_0To5_B;
        command.Parameters.Add(new OracleParameter("4", OracleDbType.Varchar2)).Value = attackCnt_5To10_B;
        command.Parameters.Add(new OracleParameter("5", OracleDbType.Varchar2)).Value = attackCnt_Blue;
        command.Parameters.Add(new OracleParameter("6", OracleDbType.Varchar2)).Value = moveCnt_Blue;
        command.Parameters.Add(new OracleParameter("7", OracleDbType.Varchar2)).Value = BlueUnit;
        command.ExecuteNonQuery();
        Logger.addLogMessage("\r\n" + "perf blue inserted", 1);
    }
    catch (Exception ex)
    {
        Logger.addLogMessage("\r\n" + ex.Message, 1);
    }

}
public static void saveAISettings(string fileName, string short_name, string long_name, int? sec_per_turn, double? e_greedy, double? c, int? depth, int? playout)
{
    bool writeTitleFlag = false;
    if (!System.IO.File.Exists(fileName))
    {
        writeTitleFlag = true;
    }
    string line = short_name + "," + long_name + "," + sec_per_turn + "," + e_greedy + "," + c + "," + depth + "," + playout;
    // 外に出力したいとき使用する
    using (StreamWriter w = new StreamWriter(fileName, true))
    {
        if (writeTitleFlag)
        {
            w.WriteLine("short_name,long_name,sec_per_turn,e_greedy,c,depth,playout"
            );
        }
        w.WriteLine(line);
    }

    // SQL query with a parameter
    string sqlQuery = "INSERT INTO parameters (parameter_id, algorithm_id, turn_time, e_greedy, c, sim_depth, playout_number) VALUES (:1, :2, :3, :4, :5, :6, :7)";

    OracleConnection connection = new OracleConnection(connectionString);

    OracleCommand command = new OracleCommand(sqlQuery, connection);

    // Bind parameter
    command.Parameters.Add(new OracleParameter("1", OracleDbType.Varchar2)).Value = long_name;
    command.Parameters.Add(new OracleParameter("2", OracleDbType.Varchar2)).Value = short_name;
    command.Parameters.Add(new OracleParameter("3", OracleDbType.Varchar2)).Value = sec_per_turn;
    command.Parameters.Add(new OracleParameter("4", OracleDbType.Varchar2)).Value = e_greedy;
    command.Parameters.Add(new OracleParameter("5", OracleDbType.Varchar2)).Value = c;
    command.Parameters.Add(new OracleParameter("6", OracleDbType.Varchar2)).Value = depth;
    command.Parameters.Add(new OracleParameter("7", OracleDbType.Varchar2)).Value = playout;

    try
    {
        connection.Open();
        command.ExecuteNonQuery();
        Logger.addLogMessage("\r\n" + long_name + "inserted", 1);
    }
    catch (Exception ex)
    {
        Logger.addLogMessage("\r\n" + ex.Message, 1);
    }
}
