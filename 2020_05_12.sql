DROP TABLE PERSON;

CREATE TABLE PERSON(
    PNAME VARCHAR2(50),
    PAGE NUMBER(3)
);

-- DML(Data Mainpulation Language) : 데이터 조작어
--      데이터를 조회, 삭제, 수정, 추가
--      SELECT, DELETE, UPDATE, INSERT
SELECT SYSDATE FROM DUAL;

--INSERT : 추가
--	INSERT INTO 테이블명(컬럼1, 컬럼2, 컬럼3 ...)	
--	VALUES(데이터1, 데이터2, 데이터3....)
--	INSERT INTO 테이블명	
--	VALUES(데이터1, 데이터2, 데이터3....)
--	테이블 생성시 만든 모든 컬럼에 데이터를 저장
--	데이터 순서는 CREATE 작성시 만든 컬럼의 순서대로 작성 

-- PERSON 데이터 5건 추가 
INSERT INTO PERSON(PNAME, PAGE) VALUES('홍길동', 20);
INSERT INTO PERSON VALUES('이길동', 35);

INSERT ALL 
    INTO PERSON VALUES('김씨', 20)
    INTO PERSON VALUES('이씨', 30)
    INTO PERSON VALUES('박씨', 40)
    INTO PERSON VALUES('정씨', 50)
    INTO PERSON VALUES('곽씨', 60)
SELECT * FROM DUAL;

-- 데이터 조회 : SELECT
-- SELECT 조회할 컬럼1, 조회할 컬럼2, ...
-- FROM 조회할 테이블1, 조회할 테이블2, ...
-- WHERE 조건절
-- GROUP BY 그룹으로 묶을 컬럼1, 그룹으로 묶을 컬럼 2, ... [HAVING 조건절]
-- ORDER BY 정렬할 기준 컬럼1 [ASC | DESC], 정렬할 기준 컬럼2 [ASC | DESC], ... 

-- 전체 학생 데이터 조회
SELECT * FROM STUDENT;
-- 원하는 컬럼만 조회 - 이름, 학과명
SELECT SNAME, MNAME FROM STUDENT;
-- AS : 해당 컬럼에 별칭을 지정함, 함수나, 수식을 감추기 위해서
SELECT MNAME, LENGTH(MNAME) AS MNAME_LENGTH FROM STUDENT;
-- DISTINCT : 중복된 내용 제거해서 조회
-- 학과명만 조회
SELECT DISTINCT MNAME FROM STUDENT;
-- 조건절
--  관계연산자 : > < >= <= = <> !=
--  논리연산자 : AND OR NOT
-- STUDENT 테이블에서 평점이 4.0 이상인 학생만 조회
SELECT * FROM STUDENT WHERE SCORE >= 4.0;
-- STUDENT 테이블에서 학과명이 심리학과가 아닌 학생들만 조회
SELECT * FROM STUDENT WHERE NOT MNAME LIKE '심리학과';
SELECT * FROM STUDENT WHERE MNAME <> '심리학과';
-- STUDENT 테이블에서 학과명이 전자공학과, 기계공학과인 학생들만 조회
SELECT * FROM STUDENT WHERE MNAME LIKE '전자공학과' OR MNAME LIKE '기계공학과';
-- 컬럼 IN(값1, 값2, ...) 해당 컬럼 값이 IN안에 존재하면 TRUE, 없으면 FALSE
-- 비교하는 연산자는 = 으로 비교
SELECT * FROM STUDENT WHERE MNAME IN('전자공학과', '기계공학과');
-- STUDENT 테이블에서 학과명이 전자공학과, 기계공학과인 학생들을 제외하고 조회
SELECT * FROM STUDENT WHERE MNAME NOT IN('전자공학과', '기계공학과');
-- 와일드 카드 문자
-- % : 글자개수 0개 이상 올 수 있다.
-- 학생이름이 박씨인 학생을 조회
SELECT * FROM STUDENT WHERE SNAME LIKE '박%';
-- 학과명에 공학이 들어가는 학생들만 조회
SELECT * FROM STUDENT WHERE MNAME LIKE '%공학%';
-- 학생이름이 빈으로 끝나는 학생들만 조회
SELECT * FROM STUDENT WHERE SNAME LIKE '%빈';
-- _ : 글자 개수 1개인 경우
SELECT * FROM STUDENT WHERE MNAME LIKE '__공학';
-- || 양쪽의 데이터를 하나의 문자열로 합쳐주는 연산자
SELECT PNAME || PAGE FROM PERSON;
SELECT PNAME || ',' || PAGE FROM PERSON;

SELECT * FROM USER_TABLES;
-- 전체 테이블 삭제하기 위한 DROP TABLE 테이블명; <-- 으로 조회
-- DROP TABLE STUDENT;
-- DROP TABLE PERSON;
-- ...
SELECT 'DROP TABLE ' || TABLE_NAME || ';' FROM USER_TABLES;
-- BETWEEN a AND b : a부터 b까지
SELECT * FROM STUDENT WHERE SCORE BETWEEN 3.0 AND 3.25;

-- 데이터 삭제 : DELETE 
--      DELETE FROM 테이블명 WHERE 조건절;
DELETE FROM PERSON;
ROLLBACK;
SELECT * FROM PERSON;

DELETE FROM PERSON WHERE PAGE >= 40;
-- 학생 데이터 중 평점이 0.5 이하인 학생 삭제
DELETE FROM STUDENT WHERE SCORE <= 0.5;
SELECT * FROM STUDENT WHERE SCORE <= 0.5;

-- 데이터 수정 : UPDATE
-- UPDATE 테이블명 SET 수정할컬럼명 = 수정할값, ...  WHERE 조건절
UPDATE PERSON SET PAGE = 99;
UPDATE PERSON SET PAGE = 99 WHERE PAGE = 30;
SELECT * FROM PERSON;
ROLLBACK;
-- PERSON 테이블에있는 모든 데이터의 나이값을 1씩 증가
UPDATE PERSON SET PAGE = PAGE + 1;
-- STUDENT 테이블에서 평점이 1.0 미만인 데이터의 이름을 제적으로 수정
UPDATE STUDENT SET SNAME = '제적' WHERE SCORE < 1.0;
SELECT * FROM STUDENT;

-- CAR
-- 차량번호, 차량명, 제조사, 제조년도, 금액
-- 차량번호 --> A000000000
CREATE TABLE CAR(
    ID CHAR(10) PRIMARY KEY,
    CNAME VARCHAR(50),
    MAKER VARCHAR(50),
    MYEAR NUMBER(4),
    PRICE NUMBER(5)
);

select * from car;

-- 자동차 테이블에서 제조사가 BMW인 자동차를 조회
-- ROWNUM --> 행번호
SELECT ROWNUM, C.* FROM CAR C
WHERE C.MAKER LIKE 'BMW';
-- 자동차 테이블에서 위에서 데이터 10건만 출력
SELECT ROWNUM, C.* FROM CAR C
WHERE ROWNUM <= 10;
-- 자동차 테이블에서 금액이 큰 순서대로 전체 데이터 조회
SELECT * FROM CAR ORDER BY PRICE ASC; -- 오름차순 생략해도 가능
SELECT * FROM CAR ORDER BY PRICE DESC; -- 내림차순 생략해도 가능

-- FROM : 데이터 소스
-- WHERE : 데이터를 필터링
-- GROUP BY : 그룹 수행
-- SELECT : 출력할 컬럼 선택
-- ORDER BY : 출력할 데이터 정렬
-- 자동차 테이블에서 금액이 큰 순서대로 전체 데이터 조회, 행번호도 포함
SELECT ROWNUM, C.* FROM CAR C ORDER BY C.PRICE DESC;

--자동차 테이블에서 자동차번호가 3번째 자리가 8, 4번째 자리가 9인 자동차를 조회
SELECT * FROM CAR WHERE ID LIKE '__89______';
SELECT * FROM CAR WHERE ID LIKE '__89%';
-- 자동차 테이블에서 금액이 10000넘는 자동차의 금액을 3000씩 금액을 낮추세요
UPDATE CAR SET PRICE = PRICE - 3000
WHERE PRICE > 10000;
-- 자동차 테이블에서 제조사가 Jeep인 데이터를 삭제하세요
DELETE FROM CAR WHERE MAKER = 'Jeep';
-- NULL 값 비교
INSERT INTO PERSON VALUES(NULL, 30);
SELECT * FROM PERSON;
-- PERSON 테이블에 이름이 NULL 값인 데이터를 출력
SELECT * FROM PERSON WHERE PNAME IS NULL;
-- PERSON 테이블에 이름이 NULL 값이 아닌 데이터를 출력
SELECT * FROM PERSON WHERE PNAME IS NOT NULL;
--------------------------------------------------------
-- 날짜 함수
SELECT SYSDATE FROM DUAL;
-- 오라클에서 지정된 현재 날짜 시간의 출력 포멧을 변경 - 현재 연결된 세션에서만 가능
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YY';
--TO_CHAR(데이터, '형식') : 데이터를 지정한 문자 포멧 형식으로 문자열 변환
-- YYYY - 연도 4자리, YY - 연도 2자리, RRRR - 연도 4자리, RR - 연도 2자리
SELECT TO_CHAR(SYSDATE, 'YYYY RRRR') FROM DUAL;
-- M MM MON MONTH - 월
SELECT TO_CHAR(SYSDATE, 'MM MON MONTH') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON MONTH','NLS_DATE_LANGUAGE=KOREAN') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON MONTH','NLS_DATE_LANGUAGE=ENGLISH') FROM DUAL;
-- DD DY DAY - 일 단축 요일 전체 요일
SELECT TO_CHAR(SYSDATE, 'DD DY DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DD DY DAY','NLS_DATE_LANGUAGE=KOREAN') FROM DUAL;
-- 시분초 - HH MI SS , 24시기준 HH24, AM - AM/PM
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS HH24:MI:SS','NLS_DATE_LANGUAGE=KOREAN') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'Q YYYY-MM-DD HH24:MI:SS') FROM DUAL;

-- 문자열을 날짜로 바꿈
SELECT TO_DATE('2025-09-23','YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('2025-09-23','YYYY-MM-DD') - SYSDATE FROM DUAL;
SELECT TO_CHAR(TO_DATE('2025-09-23','YYYY-MM-DD'),'Q YYYY-MM-DD') FROM DUAL;

-- EMPLOYEE 테이블에서 2024년 6월달에 입사한 사원만 조회
SELECT * FROM EMPLOYEE WHERE TO_CHAR(HIREDATE,'YYYY-MM') = '2024-06';
-- EMPLOYEE 테이블에서 2024년 3분기에 입사한 사원만 조회
SELECT * FROM EMPLOYEE WHERE TO_CHAR(HIREDATE,'Q-YYYY') = '3-2024';
-- EMPLOYEE 테이블에서 2024년 1월 1일부터 1월 31일까지 입사한 사원만 조회
SELECT * FROM EMPLOYEE WHERE HIREDATE >= '2024-01-01';
SELECT * FROM EMPLOYEE WHERE HIREDATE >= TO_DATE('2024-01-01','YYYY-MM-DD');
-- EMPLOYEE 테이블에서 2024년 1월 1일부터 1월 31일까지 입사한 사원만 조회
SELECT * FROM EMPLOYEE 
WHERE HIREDATE 
    BETWEEN 
        TO_DATE('2024-01-01','YYYY-MM-DD') 
        AND 
        TO_DATE('2024-01-31','YYYY-MM-DD');

-- DUAL : 임시 테이블, 값을 확인하는 용도(함수 결과값, 계산 결과값)
-- sysdate : 현재 날짜 시간값
SELECT 'HELLO', 10 + 2, 10 - 3, 10 / 4, 2 * 6 FROM DUAL;
-- 문자열 함수
-- INITCAP : 각 단어별 첫글자는 대문자로, 나머지는 소문자로 변환
SELECT INITCAP('HELLO WORLD') FROM DUAL;
SELECT INITCAP('hello world') FROM DUAL;

-- LOWER : 알파벳 전부 소문자로 변경
-- UPPER : 알파벳 전부 대문자로 변경
SELECT LOWER('Hello World'), UPPER('Hello World') FROM DUAL;

-- LENGTH : 글자 개수
-- LENGTHB : 글자 개수에 해당하는 바이트 수
SELECT LENGTH('안녕하세요'), LENGTHB('안녕하세요') FROM DUAL;

-- 학생 테이블의 학과명의 글자 개수와 글자 개수의 바이트수를 출력
SELECT DISTINCT MNAME, LENGTH(MNAME), LENGTHB(MNAME) 
FROM STUDENT;
-- INSTR : 문자열 검색, 검색결과가 있으면 0보다 큰값, 검색 결과가 없으면 0
SELECT INSTR('ABCDEFG', 'CD') FROM DUAL;
SELECT INSTR('ABCDEFG', 'CDF') FROM DUAL;
-- 문자열 공백 체크
SELECT INSTR('HELLO WORLD', ' ') FROM DUAL;

DROP TABLE PERSON;
-- PERSON 테이블 생성시 PNAME에 공백이 없는 조건
-- 나이는 1 ~ 999
CREATE TABLE PERSON(
    PNAME VARCHAR2(50),
    PAGE NUMBER(3),
    CONSTRAINT CHK_NAME CHECK(INSTR(PNAME, ' ') = 0),
    CONSTRAINT CHK_AGE CHECK(PAGE BETWEEN 1 AND 999)    
);
ALTER TABLE PERSON ADD CONSTRAINT 
CHK_AGE CHECK(PAGE BETWEEN 1 AND 999) ;

INSERT INTO PERSON VALUES('김철수',10);
INSERT INTO PERSON VALUES('김 철수',10); -- 공백 오류
INSERT INTO PERSON VALUES('김철수',0); -- 나이값 오류

-- REPLACE : 문자열 바꾸기
SELECT REPLACE('AAAAAAABBBBBCCCCBB','B','F') FROM DUAL;

-- 학생 테이블에 학과명을 '공학'을 '학'으로 변경하는 UPDATE문 작성
-- 학과명에 공학이 있을때만 동작하게끔 처리
UPDATE STUDENT SET MNAME = REPLACE(MNAME, '공학', '학')
WHERE MNAME LIKE '%공학%';

SELECT * FROM STUDENT;