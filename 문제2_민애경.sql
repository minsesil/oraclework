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
    --FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조할컬럼명)
);
