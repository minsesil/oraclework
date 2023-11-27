--【문항 4】 테이블로부터 name 컬럼에 ‘신’자가 포함된 문자열을 검색하고 기본키 내림차순으로 정렬하여 출력하는 SQL문을 작성하시오.
SELECT NAME
FROM MEMBER
JOIN ORDERS ON(ID = ORDER_ID)
WHERE NAME LIKE '%신%'
ORDER BY NAME ASC;