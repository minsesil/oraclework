--【문항 6】 member테이블에서 주문수량이 3개 이상인 고객의 고객아이디, 제품, 수량, 일자로 구성된 뷰를 ‘great_order’이라는 이름으로 생성하시오. 
--단, 뷰에 삽입이나 수정 연산을 할 때 SELECT 문에서 제시한 뷰의 정의 조건을 위반하면 수행되지 않도록 하는 제약조건을 지정 하시오.

-- VIEW 생성
 CREATE VIEW great_order
 AS SELECT ORDER_ID, ORDER_PRODUCT, ORDER_DATE
    FROM MEMBER
      JOIN ORDERS ON(ID = ORDER_ID)
      WHERE COUNT >= 3
 WITH CHECK OPTION;