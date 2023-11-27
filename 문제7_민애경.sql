--【문항 7】 ORDER테이블에 RELEASE(CHAR 1, 기본값 ‘Y’)컬럼을 추가하고, 
--ORDER_PRODUCT 컬럼의 타입을 VARCHAR(5 0) 으로 변경하고, 
--COUNT의 컬럼명을 ORDER_NAME으로 변경하시오.

ALTER TABLE ORDERS ADD RELEASE CHAR(1) DEFAULT 'Y';
ALTER TABLE ORDERS MODIFY ORDER_PRODUCT VARCHAR(50);
ALTER TABLE ORDERS RENAME COLUMN COUNT TO ORDER_NAME;
