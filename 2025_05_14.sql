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

SELECT 
    MAX(PRICE) OVER(PARTITION BY C.MAKER ORDER BY C.PRICE DESC) as max, 
    MIN(PRICE) OVER(PARTITION BY C.MAKER ORDER BY C.PRICE DESC) as min, C.* 
FROM CAR C;

SELECT 
    RANK() OVER(PARTITION BY C.MAKER ORDER BY C.PRICE DESC), 
    C.* 
FROM CAR C;