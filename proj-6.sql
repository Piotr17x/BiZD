/*6a 
Dodawanie, usuwanie, aktualizacja rekordów
*/
CREATE OR REPLACE PROCEDURE add_algorithm(
    alg_id algorithms.algorithm_id%TYPE,
    alg_name algorithms.algorithm_name%TYPE
) as
BEGIN
    INSERT INTO algorithms VALUES(alg_id, alg_name);
    DBMS_OUTPUT.PUT_LINE('Dodano algorytm z id: '||alg_id||' o nazwie: '|| alg_name);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Algorytm z id: '||alg_id||' ju¿ istnieje.');
END;

CREATE OR REPLACE PROCEDURE change_algorithm_name(
    alg_id algorithms.algorithm_id%TYPE,
    alg_name algorithms.algorithm_name%TYPE
) as
no_rows_affected exception;
BEGIN
    UPDATE algorithms SET algorithm_name = alg_name WHERE algorithm_id=alg_id;
    IF SQL%NOTFOUND THEN
        RAISE no_rows_affected;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Zmieniono nazwê algorytmu z id: '||alg_id||' na: '|| alg_name);
    EXCEPTION
        WHEN no_rows_affected THEN
            DBMS_OUTPUT.PUT_LINE('Algorytm z id: '||alg_id||' nie istnieje.');
END;

CREATE OR REPLACE PROCEDURE delete_algorithm(
    alg_id algorithms.algorithm_id%TYPE
) as
no_rows_affected exception;
BEGIN
    DELETE FROM algorithms where algorithm_id=alg_id;
    IF SQL%NOTFOUND THEN
        RAISE no_rows_affected;
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuniêto algorytm z id: '||alg_id);
    EXCEPTION
        WHEN no_rows_affected THEN
            DBMS_OUTPUT.PUT_LINE('Algorytm z id: '||alg_id||' nie istnieje.');
END delete_algorithm;

begin
    add_algorithm('MCTSA', 'monterce');
    change_algorithm_name('MCTSA', 'monterce11');
    delete_algorithm('MCTSA');
end;

/*6b 
Archiwizacja usuniętych danych
*/
CREATE TABLE simulations_archive (
sim_id NUMBER PRIMARY KEY,
outcome VARCHAR2(50),
red_player VARCHAR2(50),
blue_player VARCHAR2(50),
turn_cnt NUMBER
);

CREATE or replace TRIGGER sim_archive
  BEFORE delete ON simulations
  FOR EACH ROW
BEGIN
  INSERT INTO simulations_archive values(
  :OLD.sim_id,
  :OLD.outcome,
  :OLD.red_player,
  :OLD.blue_player,
  :OLD.turn_cnt);
END;

INSERT INTO simulations (outcome, red_player, blue_player, turn_cnt) values ('MCTS_BB_3_0_50_1', 'AAS_L', 'MCTS_BB_3_0_50_1', 20);
commit;
delete from simulations where sim_id in (75);
commit;
/*6c 
Logowanie informacji do tabeli
*/
CREATE TABLE parameters_logs (ids number GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), user_ varchar(50), parameter_name varchar(50), czas_zmiany timestamp);
Create or replace TRIGGER parameters_logger
    after insert
    on parameters
    for each row
begin
    insert into parameters_logs (user_, parameter_name, czas_zmiany) values ((select user from dual), :new.parameter_id, current_timestamp);
end;
/*6e 
Procedury, funkcje z parametrami, możliwe parametry domyślne
*/

CREATE OR REPLACE PROCEDURE get_vs_stats(
player_one parameters.parameter_id%TYPE,
player_two parameters.parameter_id%TYPE
) as
no_parameters_found exception;
player_one_wins number;
player_two_wins number;
draws number;
p1_exists number;
p2_exists number;
BEGIN
    select count(parameter_id) into p1_exists from parameters where parameter_id=player_one;
    select count(parameter_id) into p2_exists from parameters where parameter_id=player_two;
    if p1_exists != p2_exists and p1_exists != 1 then
        raise no_parameters_found;
    end if;
    SELECT count(sim_id) into player_one_wins from simulations
    where 
    red_player=player_one and blue_player=player_two
    and outcome=player_one
    or blue_player=player_one and red_player=player_two
    and outcome=player_one;
    
    SELECT count(sim_id) into player_two_wins from simulations
    where 
    red_player=player_one and blue_player=player_two
    and outcome=player_two
    or blue_player=player_one and red_player=player_two
    and outcome=player_two;
    
    SELECT count(sim_id) into draws from simulations
    where 
    red_player=player_one and blue_player=player_two
    and outcome='draw'
    or blue_player=player_one and red_player=player_two
    and outcome='draw';
    DBMS_OUTPUT.PUT_LINE('Statystyki gier '|| player_one ||' vs '|| player_two);
    DBMS_OUTPUT.PUT_LINE(player_one||': '|| player_one_wins);
    DBMS_OUTPUT.PUT_LINE(player_two||': '|| player_two_wins);
    DBMS_OUTPUT.PUT_LINE('remisów: '|| draws);
EXCEPTION
    WHEN no_parameters_found THEN
        DBMS_OUTPUT.PUT_LINE('Podana nazwa jednego z parametrów nie istnieje.');
END;

begin
    get_vs_stats('MCTS_BB_1_0_n_2', 'MCTS_BB_1_0_n_1');
end;


CREATE OR REPLACE FUNCTION get_winrate(
player_one parameters.parameter_id%TYPE,
player_two parameters.parameter_id%TYPE
)
return number
is
    no_parameters_found exception;
    no_simulations exception;
    winrate number;
    all_matches number:=1;
    draws number;
    p1_exists number;
    p2_exists number;
BEGIN
    select count(parameter_id) into p1_exists from parameters where parameter_id=player_one;
    select count(parameter_id) into p2_exists from parameters where parameter_id=player_two;
    if p1_exists != p2_exists and p1_exists != 1 then
        raise no_parameters_found;
    end if;
    SELECT count(sim_id) into winrate from simulations
    where 
    red_player=player_one and blue_player=player_two
    and outcome=player_one
    or blue_player=player_one and red_player=player_two
    and outcome=player_one;
    
    SELECT count(sim_id) into all_matches from simulations
    where 
    red_player=player_one and blue_player=player_two
    or blue_player=player_one and red_player=player_two;
    
    SELECT count(sim_id) into draws from simulations
    where 
    red_player=player_one and blue_player=player_two
    and outcome='draw'
    or blue_player=player_one and red_player=player_two
    and outcome='draw';
    if all_matches < 1 then
        raise no_simulations;
    end if;
    winrate:=(winrate + draws/2)/all_matches*100;
    return winrate;
EXCEPTION
    WHEN no_parameters_found THEN
        DBMS_OUTPUT.PUT_LINE('Podana nazwa jednego z parametrów nie istnieje.');
    WHEN no_simulations THEN
        DBMS_OUTPUT.PUT_LINE('Brak wykonanych symulacji algorytmów z tymi parametrami.');
END;


begin
    DBMS_OUTPUT.PUT_LINE('Gracz MCTS_BB_1_0_n_2 ma winrate vs MCTS_BB_1_0_n_1 wynoszący ' || get_winrate('MCTS_BB_1_0_n_2', 'MCTS_BB_1_0_n_1') ||'%');
end;

/*6f Sprawdzanie poprawności dodawanych danych
wyzwalacz blokujący dodawanie symulacji gdzie liczba tur > 29
*/

CREATE or replace TRIGGER sim_turn_checker
  BEFORE insert ON simulations
  FOR EACH ROW
BEGIN
  if :new.turn_cnt > 29 or :new.turn_cnt < 1 then
    raise_application_error(-20000, 'niepoprawna liczba tur');
  end if;
END;

Begin
    INSERT INTO simulations (outcome, red_player, blue_player, turn_cnt) values ('draw', 'asdas2da2w', 'asdas2da2w', 30);
end;
