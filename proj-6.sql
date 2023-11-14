/*6a*/
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

/*6b*/
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
/*6c*/