/*7*/

CREATE TABLE simulation_vs_stats(
ids NUMBER GENERATED by default on null as IDENTITY,
primary_parameter VARCHAR2(50),
secondary_parameter VARCHAR2(50),
wins number,
loses number,
draws number,
winrate number,
e_greedy number,
c number,
sim_depth number,
playout number
);

CREATE TABLE simulation_turn_stats(
ids NUMBER GENERATED by default on null as IDENTITY,
parameter VARCHAR2(50),
turn_cnt number,
wins number,
loses number,
draws number,
winrate number
);


INSERT INTO simulation_vs_stats (primary_parameter) values ('draw');
INSERT INTO simulation_turn_stats (parameter) values ('draw');


CREATE OR REPLACE PROCEDURE insert_vs_stats(
player parameters.parameter_id%TYPE
) as
TYPE var_array IS VARRAY (50) OF simulation_vs_stats.primary_parameter%type;
opponents var_array;
player_data parameters%rowtype;
parameter_not_found exception;
player_exists number;
BEGIN
    select count(parameter_id) into player_exists from parameters where parameter_id=player;
    if player_exists != 1 then
        raise parameter_not_found;
    end if;
    
    delete from simulation_vs_stats where primary_parameter = player;
    commit;
    
    select distinct(outcome) BULK COLLECT into opponents from simulations where red_player=player and outcome != 'draw' or blue_player=player and outcome != 'draw';
    
    FOR i IN 1..opponents.COUNT LOOP
        if opponents(i) = player then
            continue;
        end if;
        select * into player_data from parameters where parameter_id = opponents(i);
        insert into simulation_vs_stats (primary_parameter, secondary_parameter, wins, loses, draws, winrate, e_greedy, c, sim_depth, playout)
        values (
        player,
        opponents(i),
        (SELECT count(sim_id) from simulations
        where 
        red_player=opponents(i) and blue_player=player
        and outcome=player
        or blue_player=opponents(i) and red_player=player
        and outcome=player),
        (SELECT count(sim_id) from simulations
        where 
        red_player=opponents(i) and blue_player=player
        and outcome=opponents(i)
        or blue_player=opponents(i) and red_player=player
        and outcome=opponents(i)),
        (SELECT count(sim_id) from simulations
        where 
        red_player=opponents(i) and blue_player=player
        and outcome='draw'
        or blue_player=opponents(i) and red_player=player
        and outcome='draw'),
        get_winrate(player,opponents(i)),
        player_data.e_greedy,
        player_data.c,
        player_data.sim_depth,
        player_data.playout_number
        );
    END LOOP;
EXCEPTION
    WHEN parameter_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Podana nazwa parametru nie istnieje.');
END;

begin
    insert_vs_stats('MCTS_BB_2_0_n_0,1');
end;

SELECT min(turn_cnt) from simulations;


CREATE OR REPLACE PROCEDURE insert_turn_stats(
player parameters.parameter_id%TYPE
) as
parameter_not_found exception;
player_exists number;
player_data parameters%rowtype;
total Number;
wins NUMBER;
draws NUMBER;
winratio Number;
BEGIN
    select count(parameter_id) into player_exists from parameters where parameter_id=player;
    if player_exists != 1 then
        raise parameter_not_found;
    end if;
    
    delete from simulation_turn_stats where parameter = player;
    commit;
    select * into player_data from parameters where parameter_id = player;
    DBMS_OUTPUT.PUT_LINE(player_data.c);
    
    FOR i IN 1..29 LOOP
        select count(sim_id) into total from simulations where 
        (red_player=player or blue_player=player)
        and turn_cnt=i;
        if total = 0 then
            continue;
        end if;
        select count(sim_id) into wins from simulations where 
        (red_player=player or blue_player=player)
        and turn_cnt=i and outcome=player;
        select count(sim_id) into draws from simulations where 
        (red_player=player or blue_player=player)
        and turn_cnt=i and outcome='draw';
        winratio:=ROUND((wins+draws*0.5)/total,2);
        insert into simulation_turn_stats (parameter, turn_cnt, wins, loses, draws, winrate)
        values (
        player,
        i,
        wins,
        (SELECT count(sim_id) from simulations
        where 
        (red_player=player or blue_player=player)
        and outcome!=player and outcome!='draw' and turn_cnt=i),
        draws,
        winratio
        );
    END LOOP;
EXCEPTION
    WHEN parameter_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Podana nazwa parametru nie istnieje.');
END;

begin
    insert_turn_stats('MCTS_BB_2_0_n_0,1');
end;
