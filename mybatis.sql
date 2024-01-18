----------------------------------------------------------------
---------------------- MEMBER TABLE --------------------------
----------------------------------------------------------------
CREATE TABLE MEMBER (
    USER_ID VARCHAR2(30) PRIMARY KEY,
    USER_PWD VARCHAR2(100) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    EMAIL VARCHAR2(100),
    BIRTHDAY CHAR(6),
    GENDER CHAR(1) CHECK (GENDER IN('M', 'F')),
    PHONE CHAR(13),
    ADDRESS VARCHAR2(100),
    ENROLL_DATE DATE DEFAULT SYSDATE,
    MODIFY_DATE DATE DEFAULT SYSDATE,
    STATUS CHAR(1) DEFAULT 'Y' CHECK(STATUS IN('Y', 'N'))
);

INSERT INTO MEMBER
VALUES ('admin', '1234', '관리자', 'admin@aie.or.kr', '800918', 'F', '010-1111-2222','서울시  금천구 가산디지털2로', '20231211', DEFAULT, DEFAULT);

INSERT INTO MEMBER
VALUES ('user01', '1234', '홍길동', 'user01@aie.or.kr', '900213', 'M','010-3333-4444','서울시 양천구 목동','20231128',DEFAULT, DEFAULT);

----------------------------------------------------------------
------------------------ BOARD TABLE ---------------------------
----------------------------------------------------------------
CREATE TABLE BOARD(
    BOARD_NO NUMBER PRIMARY KEY,
    BOARD_TITLE VARCHAR2(100) NOT NULL,
    BOARD_CONTENT VARCHAR2(4000) NOT NULL,
    BOARD_WRITER VARCHAR2(30),
    COUNT NUMBER DEFAULT 0,
    CREATE_DATE DATE DEFAULT SYSDATE,
    STATUS CHAR(1) DEFAULT 'Y' CHECK (STATUS IN('Y', 'N')),
    FOREIGN KEY (BOARD_WRITER) REFERENCES MEMBER
);

CREATE SEQUENCE SEQ_BNO NOCACHE;

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '첫번째 게시판 서비스를 시작하겠습니다.', '안녕하세요. 첫 게시판입니다.','admin', DEFAULT, '20230311', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '두번째 게시판 서비스를 시작하겠습니다.', '안녕하세요. 2 게시판입니다.','user01', DEFAULT, '20230315', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '하이 에브리원 게시판 서비스를 시작하겠습니다.', '안녕하세요. 3 게시판입니다','user01',DEFAULT, '20230319', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '안녕.. 마이바티스는 처음이지?', '안녕하세요. 첫 게시판입니다.', 'user01',DEFAULT, '20230320', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '안녕. 제목1', '안녕 내용1', 'admin', DEFAULT, '20230323', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '페이징 처리때문에 샘플데이터 많이 넣어놓는다...', '안녕하십니까', 'admin',DEFAULT,  '20230324', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL,'제목2' ,'내용2', 'admin', DEFAULT, '20230325',DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL,'제목3' ,'내용3' , 'admin', DEFAULT, '20230326', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL,'제목4' ,'내용4', 'user01', DEFAULT, '20230327', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '제목5' ,'내용5', 'admin', DEFAULT, '20230328', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL,'제목6' ,'내용6', 'user01', DEFAULT, '20230329', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '제목7' ,'내용7', 'admin', DEFAULT, '20230401', DEFAULT);

INSERT INTO BOARD
VALUES(SEQ_BNO.NEXTVAL, '마지막 게시판 시작하겠습니다.', '안녕하세요. 마지막 게시판입니다.', 'admin',  DEFAULT, '20230403', DEFAULT);

----------------------------------------------------------------
------------------------ REPLY TABLE ---------------------------
----------------------------------------------------------------
CREATE TABLE REPLY(
    REPLY_NO NUMBER PRIMARY KEY,
    REPLY_CONTENT VARCHAR2(400),
    REF_BNO NUMBER,
    REPLY_WRITER VARCHAR2(30),
    CREATE_DATE DATE DEFAULT SYSDATE,
    STATUS CHAR(1) DEFAULT 'Y' CHECK (STATUS IN ('Y', 'N')),
    FOREIGN KEY (REF_BNO) REFERENCES BOARD,
    FOREIGN KEY (REPLY_WRITER) REFERENCES MEMBER
);

CREATE SEQUENCE SEQ_RNO NOCACHE;

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL,'첫번째 댓글입니다', 1, 'user01', '20230325', DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '첫번째 댓글입니다', 13, 'user01', '20230412', DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '두번째 댓글입니다', 13, 'user01', '20230413', DEFAULT);

INSERT INTO REPLY
VALUES(SEQ_RNO.NEXTVAL, '마지막 댓글입니다', 13, 'user01', '20230414', DEFAULT);