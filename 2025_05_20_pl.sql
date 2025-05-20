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
BEGIN
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
END;    
/
SELECT GET_SCORE_GRADE(0.2) FROM DUAL;
