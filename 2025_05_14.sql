-- 지정된 날짜까지 남은 개월 수
SELECT ABS(MONTHS_BETWEEN(SYSDATE, 
            TO_DATE('2025-12-31','YYYY-MM-DD'))) FROM DUAL;
-- 지정된 날짜부터 몇 개월 후 날짜
SELECT ADD_MONTHS(SYSDATE, 2) FROM DUAL;
-- 지정된 날짜 기준으로 돌아오는 날짜(원하는 요일)
SELECT NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL;
-- 지정된 날짜 기준으로 날짜가 속한 월의 마지막 날
SELECT LAST_DAY(SYSDATE) FROM DUAL;
-- 내일 날짜 조회
SELECT SYSDATE + 1 FROM DUAL;
-- D-DAY 올해 수능까지 D-DAY 조회
SELECT CEIL(TO_DATE('13/11/25') - SYSDATE) FROM DUAL;
-- 값이 NULL일때 처리하는 함수
-- 첫번쨰 값이 NULL일때 두번째 값을 리턴, NULL이 아니면 그냥 현재값을 리턴
SELECT NVL(NULL, '널값'), NVL('100', '널값') FROM DUAL;
--첫번째 값이 NULL일때 3번째 값을 리턴, NULL이 아닐때 2번째 값을 리턴
SELECT NVL2(NULL, 'A','B'), NVL2('100','A','B') FROM DUAL;
-- 첫번째 값을 가지고 매칭 되는 값의 오른쪽에 있는 데이터를 리턴
-- 매칭 되는 값이 없으면 마지막 값을 리턴
SELECT DECODE(1,1,'A',2,'B','C') FROM DUAL; 
SELECT DECODE(2,1,'A',2,'B','C') FROM DUAL; 
SELECT DECODE(4,1,'A',2,'B','C') FROM DUAL; 
SELECT DECODE(4,1,'A',2,'B',3,'C',4,'D','F') FROM DUAL; 
-- 윈도우 함수
-- 각 행에 대한 집계(순위, 행번호...)를 하는 함수
-- 그룹과는 달리 각 행의 데이터나 구조는 그대로 유지됨
-- 순위 : RANK, DENSE_RANK
-- 동일한 순위가 나오면, 그 다음 순위 번호는 건너뜀
SELECT RANK() OVER(ORDER BY PRICE DESC) AS PRICE_RANK, C.*
FROM CAR C;
-- 동일한 순위가 나오면, 그 다음 순위 번호는 건너뛰지 않는다.
SELECT DENSE_RANK() OVER(ORDER BY PRICE ASC), C.*
FROM CAR C;
-- 행번호 : ROW_NUMBER
SELECT ROWNUM, C.* FROM CAR C ORDER BY C.PRICE DESC;
SELECT ROW_NUMBER() OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- LEAD : 현재 행을 기준으로 다음 위치에 해당하는 값을 읽어오는 함수
SELECT LEAD(ID) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
SELECT LEAD(ID,3) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
SELECT LEAD(ID,3,'데이터 없음') OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- LAG : 현재 행을 기준으로 이전 위치에 해당하는 값을 읽어오는 함수
SELECT LAG(ID) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
SELECT LAG(ID,3) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
SELECT LAG(ID,3,'데이터 없음') OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- NTILE : n 분위 그룹 분할
SELECT NTILE(5) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- SUM : 누적합
SELECT SUM(PRICE) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- AVG : 누적 평균
SELECT AVG(PRICE) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- MAX : 최대값, MIN : 최소값 --> 현재행까지를 기준
SELECT 
    MAX(PRICE) OVER(ORDER BY C.PRICE DESC) as max, 
    MIN(PRICE) OVER(ORDER BY C.PRICE DESC) as min, C.* 
FROM CAR C;
-- COUNT : 누적 개수
SELECT COUNT(*) OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- PERCENT_RANK : 퍼센트 순위
SELECT PERCENT_RANK() OVER(ORDER BY C.PRICE DESC), C.* FROM CAR C;
-- PARTITION BY : 윈도우 함수와 함께 사용할 데이터 그룹 단위로 계산
--                행의 숫자가 줄어들지 않음.
SELECT 
    RANK() OVER(PARTITION BY C.MAKER ORDER BY C.PRICE DESC), 
    C.* 
FROM CAR C;

-- 📌 자주 쓰는 ROWS BETWEEN 구문 요약
-- 처음부터 현재 행까지
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- 현재 행부터 마지막 행까지
-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
-- 양쪽의 N개까지
-- ROWS BETWEEN N PRECEDING AND N FOLLOWING
-- 현재 행부터 몇 행(현재행 다음부터)까지 
-- ROWS BETWEEN CURRENT ROW AND N FOLLOWING
-- 현재 행 포함, 이전 N개 행까지
-- ROWS BETWEEN N PRECEDING AND CURRENT ROW
SELECT 
    MAX(PRICE) OVER(PARTITION BY C.MAKER ORDER BY C.PRICE DESC) as max, 
    MIN(PRICE) OVER(PARTITION BY C.MAKER ORDER BY C.PRICE DESC) as min, C.* 
FROM CAR C;

SELECT 
    SUM(C.PRICE) OVER(
        PARTITION BY C.MAKER 
        ORDER BY C.PRICE DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
    ), 
    C.* 
FROM CAR C;

SELECT 
    SUM(C.PRICE) OVER(
        PARTITION BY C.MAKER 
        ORDER BY C.PRICE DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ), 
    C.* 
FROM CAR C;

SELECT 
    SUM(C.PRICE) OVER(
        PARTITION BY C.MAKER 
        ORDER BY C.PRICE DESC
        ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING
    ), 
    C.* 
FROM CAR C;

-- 학생 테이블 윈도우 함수 실습
-- 전공별 성적 순위를 출력, 순위를 건너뛰지 않음.
SELECT 
    DENSE_RANK() OVER(PARTITION BY MNAME ORDER BY SCORE DESC) AS SCORE_RANK,
    S.*
FROM STUDENT S;

-- 학과별 평균 점수와 개인 점수의 차이값을 조회
-- 학번 이름 학과명 점수 평균점수 점수 - 평균점수 
SELECT
    S.*,
    AVG(SCORE) OVER(PARTITION BY MNAME) AS SCORE_AVG,
    SCORE - AVG(SCORE) OVER(PARTITION BY MNAME) AS SCORE_DIFF
FROM STUDENT S;

-- 전체 학생 조회시 성적을 내림차순으로 정렬, 해당 순서대로 누적 점수를 조회
SELECT
    S.*,
    SUM(SCORE) OVER(ORDER BY SCORE DESC) AS SCORE_SUM
FROM STUDENT S;

SELECT
    S.*,
    SUM(SCORE) OVER(ORDER BY SCORE DESC) AS SCORE_SUM
FROM STUDENT S
WHERE S.SCORE >= 3.0;

-- 각 학생의 점수와 동일한 점수를 받은 사람이 몇 명인지 조회
SELECT
    S.*,
    COUNT(*) OVER(PARTITION BY SCORE) AS SCORE_COUNT
FROM STUDENT S;

-- 각 학생의 전공 내에 최고 점수와 본인의 점수를 차이를 조회
SELECT
    S.*,
    MAX(S.SCORE) OVER(PARTITION BY S.MNAME) AS SCORE_MAX,
    S.SCORE - MAX(S.SCORE) OVER(PARTITION BY S.MNAME) AS SCORE_DIFF
FROM STUDENT S;
-- 성적 순서대로 정렬 했을때 다음 학생의 이름을 조회
SELECT
    LEAD(S.SNAME) OVER(ORDER BY S.SCORE DESC) AS NEXT_STUDENT,
    S.*
FROM STUDENT S;

-- 그룹함수
--  테이블에 있는 데이터를 특정 컬럼을 기준으로 묶어서 통계값을 구하는 함수
--  SUM, AVG, COUNT, MAX, MIN, STDDEV, VARIANCE
--  윈도우 함수의 PARTITION 처럼 특정 컬럼에 동일한 데이터를 묶어서 통계값을 구함
--  단, 다른점은 그룹함수는 PARTITION과는 다르게 행을 축소 시킴
-- CAR 테이블의 제조사별 금액의 총합을 조회
SELECT MAKER, SUM(PRICE)
FROM CAR
GROUP BY MAKER
ORDER BY SUM(PRICE) DESC;

-- 실행 순서 FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY
-- WHERE 입장에서는 별칭 M에 대한 정보를 모름.
SELECT MAKER AS M, SUM(PRICE) AS MAKER_TOTAL_PRICE
FROM CAR
WHERE INSTR(M,'B') > 0
GROUP BY MAKER
ORDER BY MAKER_TOTAL_PRICE DESC;

-- 학과별 평점의 평균을 조회, 소수점은 2자리까지만 조회
SELECT MNAME, TRUNC(AVG(SCORE),2) AS AVG_SCORE,
TO_CHAR(AVG(SCORE),'0.00') AS AVG_SCORE_CHAR
FROM STUDENT
GROUP BY MNAME;

-- 학과별 평점의 최대값, 최소값 조회
SELECT MNAME,MAX(SCORE), MIN(SCORE)
FROM STUDENT
GROUP BY MNAME;

-- 학과별 인원수를 조회, 단 평점이 3.0이상인 학생들의 인원수를 조회
SELECT MNAME, COUNT(*) AS MAJOR_STUDENT_COUNT
FROM STUDENT
WHERE SCORE >= 3.0
GROUP BY MNAME;

-- 학과별 인원수를 조회, 단 학과 평균점수가 2.5 이하인 학과만 조회
SELECT MNAME, COUNT(*) AS MAJOR_STUDENT_COUNT
FROM STUDENT
GROUP BY MNAME HAVING AVG(SCORE) <= 2.5;

-- 학과별 평점의 평균을 조회, 단 학과 인원수가 30명을 넘어가는 학과만 대상
SELECT MNAME, AVG(SCORE) AS AVG_SCORE
FROM STUDENT
GROUP BY MNAME HAVING COUNT(*) > 30;

-- 학생 테이블에 성별 컬럼을 추가 M, F
ALTER TABLE STUDENT ADD GENDER CHAR(1);
-- UPDATE 문을 이용해서 성별을 다양하게 수정
SELECT * FROM STUDENT;

UPDATE STUDENT SET GENDER = DECODE(MOD(SUBSTR(SNO,8,1),2),0,'M',1,'F');
SELECT DECODE(MOD(SUBSTR(SNO,8,1),2),0,'M',1,'F') FROM STUDENT;

--입학한 년도별, 학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
    SUBSTR(SNO,1,4), MNAME, GENDER, COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY SUBSTR(SNO,1,4), MNAME, GENDER;
--입학한 년도별, 학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
    SUBSTR(SNO,1,4), MNAME, COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY SUBSTR(SNO,1,4), MNAME;
--학과별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
    MNAME, COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY MNAME;
--학과별, 성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
    MNAME, GENDER, COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY MNAME, GENDER;
--성별로 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
    GENDER, COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY GENDER;
--전체 인원수, 평점 평균, 평점 총합를 조회하세요.
SELECT 
    COUNT(*), AVG(SCORE), SUM(SCORE), MAX(SCORE), 
    MIN(SCORE), STDDEV(SCORE), VARIANCE(SCORE)
FROM STUDENT;

-- CUBE 함수
-- 제공된 컬럼의 모든 조합에 대한 집계 결과를 생성하는 함수
-- CUBE(A,B)
-- A, B 그룹에 대한 집계
-- A에 대한 집계
-- B에 대한 집계
-- 전체 집계
SELECT 
    MNAME, GENDER, COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY CUBE(MNAME, GENDER);
-- CUBE(A,B,C)
-- A B C 집계
-- A B 집계
-- A C 집계
-- B C 집계
-- A 집계
-- B 집계
-- C 집계
-- 전체 집계
-- 입학년도, 학과, 성별 
SELECT 
    SUBSTR(SNO, 1, 4) AS YEAR, MNAME, GENDER, 
    COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY CUBE(SUBSTR(SNO, 1, 4), MNAME, GENDER);
-- ROLLUP
-- 계층적인 데이터 집계 생성
-- 상위 수준 요약 정보를 점점 상세한 수준으로 내려가면서 데이터 집계
-- ROLLUP(A,B)
-- A, B에 대한 집계 결과
-- A에 대한 집계 결과
-- 전체 집계 결과
-- ROLLUP(A,B,C)
-- A, B, C에 대한 집계 결과
-- A, B에 대한 집계 결과
-- A에 대한 집계 결과
-- 전체 집계 결과
SELECT 
    SUBSTR(SNO, 1, 4) AS YEAR, MNAME, GENDER, 
    COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY ROLLUP(SUBSTR(SNO, 1, 4), MNAME, GENDER);
--GROUPING SETS
--특정 항목에 대한 집계하는 함수
--GROUPING SETS(A,B)
--A 그룹
--B 그룹
--GROUPING SETS(A,B,())
--A 그룹
--B 그룹
--전체 집계(총계)
--GROUPING SETS(A,ROLLUP(B,C))
--A 그룹
--B 그룹, C그룹
--B 그룹
--전체 집계
SELECT 
    SUBSTR(SNO, 1, 4) AS YEAR, MNAME, GENDER, 
    COUNT(*), AVG(SCORE), SUM(SCORE)
FROM STUDENT
GROUP BY
    GROUPING SETS(SUBSTR(SNO, 1, 4),(MNAME, GENDER),());

---------------------
-- 1. 전체 사원의 평균 급여를 소수점 2자리까지 출력하세요.
SELECT TRUNC(AVG(SALARY),2) AS AVG_SALARY FROM EMPLOYEE;
SELECT DISTINCT AVG(SALARY) OVER() AS AVG_SALARY FROM EMPLOYEE;
-- 2. 부서별 사원 수를 조회하세요.
SELECT DNAME, COUNT(*) AS EMP_DEPT_COUNT FROM EMPLOYEE GROUP BY DNAME;
-- 3. 직급별 평균 급여를 조회하세요.

-- 4. 부서별 최대 급여와 최소 급여를 조회하세요.
-- 5. 부서별 사원의 총 급여 합계를 조회하세요.
-- 6. 직급별 사원 수를 조회하되, 2명 이상인 직급만 조회하세요.
-- 7. 부서별 평균 급여가 3,000,000 이상인 부서만 조회하세요.
-- 8. 직급별 평균 급여를 내림차순으로 정렬해서 출력하세요.
-- 9. 부서별 급여 평균과 급여 총합을 함께 출력하세요.
-- 10. 입사 연도별 사원 수를 조회하세요. (SUBSTR(HIREDATE, 1, 4) 사용)