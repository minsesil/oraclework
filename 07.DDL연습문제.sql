07.DDL 실습문제
도서관리 프로그램을 만들기 위한 테이블들 만들기
이때, 제약조건에 이름을 부여할 것.
       각 컬럼에 주석달기

1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
   컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음
    
--테이블생성
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    PUB_NAME VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(20)
);

--데이타입력
   - 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_PUBLISHER VALUES(1,'id1','name1','010-1111-2222');
INSERT INTO TB_PUBLISHER VALUES(2,'id2','name2','010-1111-2222');

-------------------------------------------------------------------------------------------------------------
2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
   컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
	BK_PRICE(가격) NUMBER
	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
                     
--테이블생성
CREATE TABLE TB_BOOK(
     BK_NO NUMBER PRIMARY KEY,  
     BK_TITLE VARCHAR2(20) NOT NULL,
     BK_AUTHOR VARCHAR2(20) NOT NULL,
     BK_PRICE NUMBER,
     BK_PUB_NO NUMBER, 
     FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER(PUB_NO)
 );
 
--데이타입력               
   - 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_BOOK VALUES(1,'tit1','aut1',1000,10);
INSERT INTO TB_BOOK VALUES(2,'tit2','aut2',2000,20);
INSERT INTO TB_BOOK VALUES(3,'tit3','aut3',3000,30);
INSERT INTO TB_BOOK VALUES(4,'tit4','aut4',4000,40);
INSERT INTO TB_BOOK VALUES(5,'tit5','aut5',5000,50);

-------------------------------------------------------------------------------------------------
3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
   ADDRESS(주소) VARCHAR2(70)
   PHONE(연락처) VARCHAR2(13)
   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)
   
--테이블생성   
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR2(30) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(30) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(1) CHECK(GENDER IN('M','F')),
    ADDRESS VARCHAR2(70),
    PHONE VARCHAR2(13),
    STATUS CHAR(1) DEFAULT 'N' CHECK(STATUS IN('Y','N')),
    ENROLL_DATE DATE
);

--데이타입력
   - 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_MEMBER VALUES(1,'mem1','pw1','name1','M','서울시 금천구 가산동1','010-1111-2222','Y','23/11/16');
INSERT INTO TB_MEMBER VALUES(2,'mem2','pw2','name2','F','서울시 금천구 가산동2','010-1111-2222','N','23/11/16');
INSERT INTO TB_MEMBER VALUES(3,'mem3','pw3','name3','M','서울시 금천구 가산동3','010-1111-2222','Y','23/11/16');
INSERT INTO TB_MEMBER VALUES(4,'mem4','pw4','name4','F','서울시 금천구 가산동4','010-1111-2222','N','23/11/16');
INSERT INTO TB_MEMBER VALUES(5,'mem5','pw5','name5','M','서울시 금천구 가산동5','010-1111-2222','Y','23/11/16');

-----------------------------------------------------------------------------------------------------------------
4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
	RENT_DATE(대여일) DATE -- 기본값 SYSDATE
    
--테이블생성
--REFERENCES 참조할 테이블명(참조할 컬럼명)
--ON DELETE SET NULL
CREATE TABLE TB_RENT(
   RENT_NO NUMBER PRIMARY KEY,
   RENT_MEM_NO NUMBER REFERENCES TB_MEMBER(MEMBER_NO) ON DELETE SET NULL, 
   RENT_BOOK_NO NUMBER REFERENCES TB_BOOK(BK_NO) ON DELETE SET NULL,
   RENT_DATE DATE
);

--데이타입력
   - 3개 정도 샘플데이터 추가하기
INSERT INTO TB_RENT VALUES(1,1,1,'23/11/16');
INSERT INTO TB_RENT VALUES(2,2,2,'23/11/16');
INSERT INTO TB_RENT VALUES(3,3,3,'23/11/16');
  
   
   
   