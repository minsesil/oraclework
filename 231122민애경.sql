--【문항 2】 2개의 테이블을 생성한다. 외래키는 member테이블의 id와 order테이블의 order_id를 외래키로 한다.

--MEMBER 테이블 생성
CREATE TABLE  MEMBER (
     ID	            VARCHAR2(10)		PRIMARY KEY,
     NAME	        VARCHAR2(10)		NOT NULL,
     AGE	        NUMBER		        NULL,
     ADDRESS	    VARCHAR2(60)		NOT NULL
);

--ORDERS 테이블 생성
CREATE TABLE ORDERS (
	ORDER_NO	    VARCHAR2(10)	     PRIMARY KEY,
	ORDER_ID	    VARCHAR2(10)	     NOT NULL,
	ORDER_PRODUCT	VARCHAR2(20)         NOT NULL,
	COUNT           NUMBER  	         NOT NULL,
    ORDER_DATE      DATE	             DEFAULT SYSDATE NULL,
    FOREIGN KEY(ORDER_ID) REFERENCES MEMBER(ID)
);



--【문항 3】 2개의 생성된 테이블에 데이터를 저장한다.

--MEMBER 테이블
INSERT INTO MEMBER VALUES('dragon', '박문수', 20, '서울시');
INSERT INTO MEMBER VALUES('sky', '김유신', 30, '부산시');
INSERT INTO MEMBER VALUES('blue', '이순신', 25, '인천시');

--ORDERS 테이블
INSERT INTO ORDERS VALUES('o01', 'sky', '케잌', 1, '2023-11-05');
INSERT INTO ORDERS VALUES('o02', 'blue', '고로케', 3, '2023-11-10');
INSERT INTO ORDERS VALUES('o03', 'sky', '단팥빵', 5, '2023-11-22');
INSERT INTO ORDERS VALUES('o04', 'blue', '찹쌀도넛', 2, '2023-11-30');
INSERT INTO ORDERS VALUES('o05', 'dragon', '단팥빵', 4, '2023-11-02');
INSERT INTO ORDERS VALUES('o06', 'sky', '마틀바게트', 2, '2023-11-10');
INSERT INTO ORDERS VALUES('o07', 'dragon', '라이스번', 7, '2023-11-25');


SELECT * FROM MEMBER;
SELECT * FROM ORDERS;



--【문항 4】 테이블로부터 name 컬럼에 ‘신’자가 포함된 문자열을 검색하고 기본키 내림차순으로 정렬하여 출력하는 SQL문을 작성하시오.
SELECT NAME
FROM MEMBER
JOIN ORDERS ON(ID = ORDER_ID)
WHERE NAME LIKE '%신%'
ORDER BY NAME ASC;


--【문항 5】 김유신 고객이 주문한 주문제품과 수량을 검색하시오.
--          - ANSI 구문과 ORACLE 구문 모두 작성하시오.

--ANSI
SELECT ORDER_PRODUCT, COUNT
FROM MEMBER
JOIN ORDERS ON(ID = ORDER_ID)
WHERE NAME = '김유신';
--ORACLE
SELECT ORDER_PRODUCT, COUNT
FROM MEMBER, ORDERS
WHERE MEMBER.ID = ORDERS.ORDER_ID AND NAME = '김유신';


--【문항 6】 member테이블에서 주문수량이 3개 이상인 고객의 고객아이디, 제품, 수량, 일자로 구성된 뷰를 ‘great_order’이라는 이름으로 생성하시오. 
--단, 뷰에 삽입이나 수정 연산을 할 때 SELECT 문에서 제시한 뷰의 정의 조건을 위반하면 수행되지 않도록 하는 제약조건을 지정 하시오.
SELECT ORDER_ID, ORDER_PRODUCT, ORDER_DATE
FROM MEMBER
JOIN ORDERS ON(ID = ORDER_ID)
WHERE COUNT >= 3;

-- VIEW 생성
 CREATE VIEW great_order
 AS SELECT ORDER_ID, ORDER_PRODUCT, ORDER_DATE
    FROM MEMBER
      JOIN ORDERS ON(ID = ORDER_ID)
      WHERE COUNT >= 3
 WITH CHECK OPTION;
 
 SELECT * FROM great_order;


--【문항 7】 ORDER테이블에 RELEASE(CHAR 1, 기본값 ‘Y’)컬럼을 추가하고, 
--ORDER_PRODUCT 컬럼의 타입을 VARCHAR(5 0) 으로 변경하고, 
--COUNT의 컬럼명을 ORDER_NAME으로 변경하시오.

ALTER TABLE ORDERS ADD RELEASE CHAR(1) DEFAULT 'Y';
ALTER TABLE ORDERS MODIFY ORDER_PRODUCT VARCHAR(50);
ALTER TABLE ORDERS RENAME COLUMN COUNT TO ORDER_NAME;


