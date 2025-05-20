-- PL/SQL
--  데이터베이스에서 사용되는 절차적 언어
--  프로시저, 함수, 트리거 등의 형태로 작성을 할 수 있음
--  데이터 조작 및 비지니스 로직을 데이터베이스 내에서 직접 처리할 수 있음
--------------------------------------------------------------------
-- 함수
CREATE OR REPLACE FUNCTION GET_ODD_EVEN(NUM IN NUMBER)
RETURN VARCHAR2
IS
    -- 함수에서 사용할 변수 선언
    MSG VARCHAR2(100);
BEGIN
    -- 실행 영역
    IF NUM = 0 THEN
        MSG := '0 입니다.';
    ELSIF MOD(NUM,2) = 0 THEN
        MSG := '짝수 입니다.';
    ELSE
        MSG := '홀수 입니다.';
    END IF;
    RETURN MSG;
END;
/
SELECT
	GET_ODD_EVEN(10),
	GET_ODD_EVEN(11),
	GET_ODD_EVEN(0)
FROM
	DUAL;

-- 성적 등급 구하는 함수 작성
/
CREATE OR REPLACE FUNCTION GET_SCORE_GRADE(SCORE IN NUMBER)
RETURN VARCHAR2
IS
    MSG VARCHAR2(100);
    USER_EXCEPTION EXCEPTION;
BEGIN
    IF SCORE < 0 THEN
        RAISE USER_EXCEPTION;
    END IF;

    IF SCORE = 4.5 THEN
        MSG := 'A+';
    ELSIF SCORE >= 4.0 THEN
        MSG := 'A';
    ELSIF SCORE >= 3.5 THEN
        MSG := 'B+';
    ELSIF SCORE >= 3.0 THEN
        MSG := 'B';
    ELSIF SCORE >= 2.5 THEN
        MSG := 'C+';
    ELSIF SCORE >= 2.0 THEN
        MSG := 'C';
    ELSIF SCORE >= 1.5 THEN
        MSG := 'D+';
    ELSIF SCORE >= 1.0 THEN
        MSG := 'D';
    ELSE
        MSG := 'F';
    END IF;
    RETURN MSG;
EXCEPTION
    WHEN USER_EXCEPTION THEN
        RETURN '점수는 0이상 입력해야합니다.';
    WHEN OTHERS THEN
        RETURN '알수 없는 에러 발생';    
END;    
/
SELECT GET_SCORE_GRADE(0.2), GET_SCORE_GRADE(-5) FROM DUAL;
-------------------------------------
-- 학과번호를 받아서 학과명 리턴하는 함수
-------------------------------------
SELECT MNAME FROM MAJOR WHERE MNO LIKE 'M01';
/
CREATE OR REPLACE FUNCTION GET_MAJOR_NAME(V_MAJOR_NO IN VARCHAR2)
RETURN VARCHAR2
IS
    MSG VARCHAR2(100);
BEGIN
    SELECT MNAME INTO MSG FROM MAJOR WHERE MNO LIKE V_MAJOR_NO;
    RETURN MSG;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '해당 데이터 없음';
END;
/
SELECT GET_MAJOR_NAME('M01'), GET_MAJOR_NAME('M99') FROM DUAL;
------------------------------------------------------------------------
/
CREATE OR REPLACE FUNCTION GET_TOTAL(N1 IN NUMBER, N2 IN NUMBER)
RETURN NUMBER
IS
    TOTAL NUMBER;
    I NUMBER;
BEGIN
    TOTAL := 0;
    I := N1;

    -- LOOP
    --     TOTAL := TOTAL + I;
    --     I := I + 1;
    --     EXIT WHEN I > N2;
    -- END LOOP;

    -- WHILE(I <= N2)
    -- LOOP
    --     TOTAL := TOTAL + I;
    --     I := I + 1;
    -- END LOOP;

    FOR I IN N1 .. N2
    LOOP
        TOTAL := TOTAL + I;
    END LOOP;

    RETURN TOTAL;
END; 
/
SELECT GET_TOTAL(1,100) FROM DUAL;
--------------------------------------------------------------
-- 트리거
--  데이터베이스에서 발생하는 이벤트에 대한 반응으로
--  자동 실행되는 절차적 SQL
--  INSERT, UPDATE, DELETE 등의 이벤트에 대한 반응으로 실행
--  테이블에 대한 이벤트가 발생하면 자동으로 실행되는 PL/SQL 블록
--------------------------------------------------------------
CREATE TABLE DATA_LOG(
	LOG_DATE DATE DEFAULT SYSDATE,
	LOG_DETAIL VARCHAR2(1000)	
);
-- 학과(MAJOR) 테이블에 내용이 수정(UPDATE)되면 해당 기록을 저장하는 트리거
/
CREATE OR REPLACE TRIGGER UPDATE_MAJOR_LOG
BEFORE 
    UPDATE ON MAJOR
FOR EACH ROW
BEGIN
    INSERT INTO DATA_LOG(LOG_DETAIL) VALUES(
        :OLD.MNO || ' - ' || :NEW.MNO || ',' || 
        :OLD.MNAME || ' - ' || :NEW.MNAME);
END;
/
UPDATE MAJOR SET MNAME = '디지털콘텐츠학과' WHERE MNO = 'M02';
SELECT * FROM DATA_LOG;

-- 학과 정보 추가시 발동되는 트리거
CREATE OR REPLACE TRIGGER INSERT_MAJOR_CHK_TRIGGER
BEFORE INSERT ON MAJOR
FOR EACH ROW
BEGIN 
    IF :NEW.MNAME IN('비속어','123',NULL) THEN
        RAISE_APPLICATION_ERROR(-20000, '학과명으로 쓸수 없는 텍스트 입니다.');
    END IF;
    -- 학과번호를 변경할려는 시도가 있으면 정지

END;
/
CREATE OR REPLACE TRIGGER INSERT_MAJOR_TRIGGER
AFTER INSERT ON MAJOR
FOR EACH ROW
BEGIN 
    INSERT INTO DATA_LOG(LOG_DETAIL) 
    VALUES(:NEW.MNO || ' - ' || :NEW.MNAME);
END;
/
INSERT INTO MAJOR VALUES('S01','1234');
SELECT * FROM DATA_LOG;
SELECT * FROM MAJOR;
/
-- FOR EACH ROW : 행마다 1번씩 실행
-- FOR EACH ROW 없으면 SQL 1회당 1번
CREATE OR REPLACE TRIGGER DELETE_MAJOR
AFTER DELETE ON MAJOR
BEGIN
    INSERT INTO DATA_LOG(LOG_DETAIL) 
    VALUES('FOR EACH ROW X - MAJOR 데이터 삭제');
END;
/
CREATE OR REPLACE TRIGGER DELETE_MAJOR
AFTER DELETE ON MAJOR
FOR EACH ROW
BEGIN
    INSERT INTO DATA_LOG(LOG_DETAIL) 
    VALUES('FOR EACH ROW O - MAJOR 데이터 삭제');
END;
/
DELETE FROM MAJOR WHERE MNO = 'S02';
SELECT * FROM DATA_LOG;
--------------------------------------------------------
-- 트리거 INSERT, UPDATE, DELETE 합쳐서 처리
--------------------------------------------------------
DROP TRIGGER DELETE_MAJOR;
DROP TRIGGER INSERT_MAJOR_TRIGGER;
DROP TRIGGER UPDATE_MAJOR_LOG;
/
CREATE OR REPLACE TRIGGER MAJOR_TRIGGER
AFTER
    INSERT OR UPDATE OR DELETE ON MAJOR
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO DATA_LOG(LOG_DETAIL, CMD) 
        VALUES(:NEW.MNO || ' - ' || :NEW.MNAME || 
        ' / ' || SYS_CONTEXT('USERENV','SESSION_USER'), 'INSERT');
    ELSIF UPDATING THEN
        INSERT INTO DATA_LOG(LOG_DETAIL, CMD) VALUES(
        :OLD.MNO || ' - ' || :NEW.MNO || ',' || 
        :OLD.MNAME || ' - ' || :NEW.MNAME || 
        ' / ' || SYS_CONTEXT('USERENV','SESSION_USER'), 'UPDATE');
    ELSIF DELETING THEN
        INSERT INTO DATA_LOG(LOG_DETAIL, CMD) 
        VALUES(:OLD.MNO || ' - ' || :OLD.MNAME || 
        ' / ' || SYS_CONTEXT('USERENV','SESSION_USER'),'DELETE');
    END IF;
END;
/
ALTER TABLE DATA_LOG ADD CMD VARCHAR2(10);
INSERT INTO MAJOR VALUES('S01','1234');
DELETE FROM MAJOR WHERE MNO = 'S01';
UPDATE MAJOR SET MNAME = '디지털콘텐츠학과' WHERE MNO = 'M02';
SELECT * FROM DATA_LOG;
---------------------------------------------------------------------
-- 프로시저
--  SQL 쿼리문으로 로직을 조합해서 사용하는 데이터베이스 코드
--  SQL문과 제어문을 이용해서, 데이터를 검색, 삽입, 수정, 삭제를 할 수 있음.
--  결과를 외부로 전달할 수도 있음.
--  하나의 트랜잭션 구성시 사용함.
---------------------------------------------------------------------
-- 매개변수가 없는 프로시저
CREATE OR REPLACE PROCEDURE PROCEDURE_EX1
IS
    -- 변수 선언
    TEST_VAR VARCHAR2(100);
BEGIN
    -- 실행부
    TEST_VAR := 'Hello World';
    DBMS_OUTPUT.PUT_LINE(TEST_VAR);
END;
/
DECLARE
    -- 사용할 변수
BEGIN
    -- 실행 영역
    PROCEDURE_EX1();
END;
/
-- 매개변수가 있는 프로시저
CREATE OR REPLACE PROCEDURE PROCEDURE_EX2(
    V_PID IN VARCHAR2,
    V_PNAME IN VARCHAR2,
    V_PAGE IN NUMBER)
IS
    TEST_VAR VARCHAR2(100);
BEGIN
    -- PERSON 테이블에 프로시저로 받아온 데이터 INSERT 문 실행
    DBMS_OUTPUT.PUT_LINE(V_PID || ' ' || V_PNAME || ' ' || V_PAGE );
    INSERT INTO PERSON VALUES(V_PID,V_PNAME,V_PAGE);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR 발생');
        ROLLBACK;
END;
/
BEGIN
    PROCEDURE_EX2('00011','김아두',33);
END;
/
SELECT * FROM PERSON;
/
--값을 외부로 전달하는 프로시저
CREATE OR REPLACE PROCEDURE PROCEDURE_EX3(
	NUM IN NUMBER,
	RESULT OUT NUMBER)
IS
	I NUMBER;
	USER_EXCEPTION EXCEPTION;
BEGIN
	IF NUM <= 0 THEN
		RAISE USER_EXCEPTION;
	END IF;
	--반복문 이용해서 1~NUM까지 곱하는 팩토리얼 계산
	--결과 값을 RESULT에 저장
	RESULT := 1;
	FOR I IN 1 .. NUM
	LOOP
		RESULT := RESULT * I;
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('숫자는 0보다 커야합니다.');
		RESULT := -1;
END;
/
DECLARE
    FAC NUMBER;
BEGIN
    PROCEDURE_EX3(-5, FAC);
    DBMS_OUTPUT.PUT_LINE(FAC);
END;
/
-- 접속한 사용자 확인
SELECT SYS_CONTEXT('USERENV','SESSION_USER') FROM DUAL;

-- 사용자 생성
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
CREATE USER C##USER IDENTIFIED BY 123456;
-- 권한 부여
GRANT CONNECT, RESOURCE TO C##USER;
-- 권한 회수
REVOKE CONNECT FROM C##USER;
-- 테이블 스페이스 사용 권한
ALTER USER C##USER DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
-- C##USER에 C##SCOTT에 있는 MAJOR 테이블에 대한 권한을 부여
GRANT INSERT, UPDATE, DELETE, SELECT ON C##SCOTT.MAJOR TO C##USER;

SELECT * FROM C##SCOTT.MAJOR;






