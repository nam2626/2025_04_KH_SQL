-- 뷰(VIEW)
-- SQL에 하나 이상의 테이블의 조회 결과를 저장한 가상한 테이블, 스토리지 용량 X
-- 실제 데이터를 저장하지 않고, 쿼리의 결과를 미리 정의해 두어서 필요할때 재사용

-- 뷰 생성 권한
GRANT CREATE VIEW TO C##JANG;
-- 관리자 권한
GRANT DBA TO C##SCOTT;

-- CREATE OR REPLACE VIEW 뷰이름
-- AS
-- 조회할 SQL문(SELECT문)

--학생 정보 조회, 학번, 이름, 학과명, 평점, 성별 조회하는 조회문 작성
SELECT S.SNO, S.SNAME, S.SCORE, S.GENDER, M.MNAME
FROM STUDENT S INNER JOIN MAJOR M ON S.MNO = M.MNO;

CREATE OR REPLACE VIEW STUDENT_VIEW
AS
SELECT S.SNO, S.SNAME, S.SCORE, S.GENDER, M.MNAME
FROM STUDENT S INNER JOIN MAJOR M ON S.MNO = M.MNO;

SELECT * FROM STUDENT_VIEW;

-- 위에 만든 뷰를 성별을 제거하고 다시 STUDENT_VIEW로 생성
