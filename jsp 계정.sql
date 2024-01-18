create table member (
    id varchar2(20) primary key,
    pwd varchar2(20) not null,
    name varchar2(20) not null,
    gender char(1),
    birthday char(6),
    email varchar2(30),
    zipcode char(5),
    address varchar2(100),
    detailAddress varchar2(50),
    hobby char(5),
    job varchar2(30)
);

INSERT INTO MEMBER VALUES('kim', '1234', '홍길동', '1', '231205', 'kim@naver.com', '12345', '서울특별시 영등포구 당산동 이레빌딩', '19층','11001','학생');
INSERT INTO MEMBER VALUES('lee', '1234', '이길동', '2', '231115', 'lee@naver.com', '23456', '인천광역시 남동구 구월동', '17층','10001','교수');
INSERT INTO MEMBER VALUES('park', '1234', '박길동', '1', '231021', 'park@naver.com', '34567', '경기도 성남시 수정구', '수정아파트','01010','공무원');

commit;
---2023.12.22--------------------------------------------------------------------------------------------------------------------------------------------------
--SEQUENCE:SEQ_VOTE
--votelist 테이블
create table votelist (
    num number primary key,
    question varchar2(200) not null,
    sdate date,
    edate date,
    wdate date,
    type number default 1 not null,
    active number default 1
);

-- voteitem 테이블
create table voteitem (
    listnum number ,
    itemnum number default 0,
    item varchar2(50),
    count number default 0,
    primary key(listnum, itemnum)
);

--시퀀스 생성
CREATE SEQUENCE SEQ_VOTE;


--2023.12-06 (게시판 만들기)--------------------------------------------------------------------------------------------------------------------------------------------------
CREATE SEQUENCE SEQ_BOARD nocache;

CREATE TABLE board (
	num	number PRIMARY KEY,
	name varchar2(20) NOT NULL,
	subject varchar2(50) NOT NULL,
	content	varchar2(4000) NOT NULL,
	pos	number,
	ref	number,
	depth number,
	regdate	date,
	pass varchar2(15) NOT NULL,
	ip varchar2(15),
	count number default 0
);

insert into board values(SEQ_BOARD.NEXTVAL, '박길동', '제목1', '내용1', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-01', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '김길동', '제목2', '내용2', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-05', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '송길동', '제목3', '내용3', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-12', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '한길동', '제목4', '내용4', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-14', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '곽길동', '제목5', '내용5', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-25', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '원길동', '제목6', '내용6', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-04', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '임길동', '제목7', '내용7', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-07', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '신길동', '제목8', '내용8', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-11', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '박길동', '제목9', '내용9', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-22', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '정길동', '제목10', '내용10', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-29', '1234', '0:0:0:0:0:0:0:1', default);

commit;

--2024-01-03
create table reply(
	no number primary key,
	content varchar2(400),
	ref number,
	name varchar2(20),
	redate date
)

create sequence SEQ_REPLY;

insert into reply values(SEQ_REPLY.NEXTVAL,'와우! 첫 댓글', 1, '김처음','2023/12/02');
insert into reply values(SEQ_REPLY.NEXTVAL,'멋지군요', 1, '박멋짐','2023/12/12');
insert into reply values(SEQ_REPLY.NEXTVAL,'굉장하군요', 1, '이굉장','2023/12/15');
insert into reply values(SEQ_REPLY.NEXTVAL,'아름다워요', 1, '황아름','2024/01/03');

commit;



    