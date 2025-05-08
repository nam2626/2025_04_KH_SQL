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




