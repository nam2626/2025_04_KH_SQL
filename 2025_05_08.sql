-- 사용자 생성
--          C##사용자명             암호
CREATE USER C##SCOTT IDENTIFIED BY 123456;
-- 권한 부여
GRANT RESOURCE, CONNECT TO C##SCOTT;
-- 저장소 사용량 부여
ALTER USER C##SCOTT DEFAULT TABLESPACE 
USERS QUOTA UNLIMITED ON USERS;

-- 학생 테이블
-- 학번, 이름, 학과명, 평점
CREATE TABLE STUDENT(
    SNO CHAR(8),
    SNAME VARCHAR2(50),
    MNAME VARCHAR2(50),
    SCORE NUMBER(3,2)
);
-- 데이터 추가 - INSERT
INSERT INTO 
STUDENT(SNO,SNAME,MNAME,SCORE) 
VALUES('20203333','김철수','컴퓨터공학과',3.24);
INSERT INTO 
STUDENT(SNO,SNAME,MNAME,SCORE) 
VALUES('20204444','박철수','컴퓨터공학과',3.24);
INSERT INTO 
STUDENT(SNAME,MNAME) 
VALUES('박철수','컴퓨터공학과');
INSERT INTO 
STUDENT
VALUES('20206666','이철수','컴퓨터공학과',3.24);
-- 전체 데이터 조회
SELECT * FROM STUDENT;

-- 수정한 데이터를 적용하는 명령어
COMMIT;

-- 마지막 COMMIT 상태로 되돌리는 명령어
ROLLBACK;

-- DDL : Data Definition Language, 데이터 정의어
-- 	데이터베이스 구성요소를 정의, 변경, 삭제하는 사용됨
--	CREATE : 데이터베이스 구성 요소를 생성(테이블, 인덱스, 시퀸스, 사용자....) 
--	ALTER : 생성된 데이터베이스 구성 요소를 변경할 때 사용
--	DROP : 생성된 데이터베이스 구성 요소를 삭제할 때 사용
--	TRUNCATE : 테이블의 모든 데이터를 빠르게 삭제하고, 공간을 해제, 구조는 유지함

-- 테이블 생성
-- CREATE TABLE 테이블_이름(
--     컬럼명1 데이터타입 [PRIMARY KEY],
--     컬럼명2 데이터타입 [NULL | NOT NULL],
--     컬럼명3 데이터타입 DEFAULT 기본값,
--     컬럼명4 데이터타입,
--     ....
-- );

-- CREATE TABLE 테이블_이름(
--     컬럼명1 데이터타입,
--     컬럼명2 데이터타입 [NULL | NOT NULL],
--     컬럼명3 데이터타입 DEFAULT 기본값,
--     ....
--     CONSTRAINT 제약조건이름 PRIMARY KEY(컬럼명)
-- );

-- 데이터 타입
-- 문자열 : CHAR(2000까지 지원), VARCHAR2(4000), CLOB(128TB)
-- 숫자 : NUMBER(자리수, 소수점개수) -> 최대 38, FLOAT(128)
-- 날짜 시간 : DATE(날짜/시간), TIMESTAMP(소수점까지 저장 가능 최대 9자리)
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/datatype-limits.html

-- 복습문제
-- COURSE 테이블 생성
-- 과목코드, 과목명, 학점
CREATE TABLE COURSE(
    CNO CHAR(6 BYTE),
    CNAME VARCHAR2(10 CHAR),
    CREDIT NUMBER(1)
);
DROP TABLE COURSE;
INSERT INTO COURSE VALUES('C00001','C Language',3);
INSERT INTO COURSE VALUES('C00002','프로그래밍 기초',3);
INSERT INTO COURSE VALUES('C00003','프로그래밍 응용','4');

-- 사원 테이블 생성
-- 사번, 사원명, 부서명, 월급, 입사일
CREATE TABLE EMPLOYEE(
    ENO CHAR(6),
    ENAME VARCHAR2(50),
    DNAME VARCHAR2(50),
    SALARY NUMBER(7,2),
    HIREDATE DATE
);
-- 사원정보 추가
INSERT INTO EMPLOYEE
VALUES('E00001','이철수','회계부',30000.00,'21/01/01');
 
COMMIT;
------------------------------------------------------------------
-- PERSON 테이블
--  이름 -> 문자열 
--  나이 -> 숫자
CREATE TABLE PERSON(
    PNAME VARCHAR2(50),
    PAGE NUMBER(3)
);

INSERT INTO PERSON VALUES('김철수',22);
INSERT INTO PERSON VALUES('이철수',33);
INSERT INTO PERSON VALUES('박철수',24);
INSERT INTO PERSON VALUES('강철수',43);
INSERT INTO PERSON VALUES('곽철수',56);

COMMIT;

-- 테이블 삭제 --> 테이블 삭제시 모든 데이터가 날아감.
--      DROP TABLE 삭제할_테이블_명;
DROP TABLE PERSON;

-- 컬럼에 기본값 설정
CREATE TABLE PERSON(
    PNAME VARCHAR2(50),
    PAGE NUMBER(3) DEFAULT 100
);
-- 이름만 저장하는 INSERT문 실행
INSERT INTO PERSON(PNAME)
VALUES('김영수');
-- PERSON 테이블 전체 조회문 실행
SELECT PNAME, PAGE FROM PERSON;

-- 테이블에 저장된 데이터를 삭제
TRUNCATE TABLE PERSON;

-- NOT NULL
--  반드시 저장되어야 하는 항목에 적용
CREATE TABLE PERSON(
    PNAME VARCHAR2(50) NOT NULL,
    PAGE NUMBER(3) DEFAULT 100
);

INSERT INTO PERSON(PAGE) VALUES(34);

CREATE TABLE PERSON(
    PNAME VARCHAR2(50),
    PAGE NUMBER(3) DEFAULT 100 NOT NULL 
);

INSERT INTO PERSON(PNAME) VALUES('박철수');
INSERT INTO PERSON(PNAME,PAGE) VALUES('박철수',NULL);
SELECT * FROM PERSON;
