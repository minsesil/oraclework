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