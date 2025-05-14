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

