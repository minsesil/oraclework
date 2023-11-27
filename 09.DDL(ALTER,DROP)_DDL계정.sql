/*
 <ALTER>
 객체를 변경하는 구문
 
 [표현식]
 ALTER TABLE 테이블명 변경할내용;
 
 *변경할 내용
  1)컬럼 추가/수정/삭제
  2)제약조건 추가/삭제 -> 수정불가(수정하고자하면 삭제후 새로추가)
  3)컬럼명/제약조건명/테이블명 변경
*/

--==1)컬럼 추가/수정/삭제
--1. 컬럼 추가(ADD) : ADD 컬럼명 데이타타입[DEFAULT기본값]

--DEPT_COPY테이블에 CNAME컬럼추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
-->새로운 컬럼이 만들어지고 기본적으로 NULL로 채워짐

--DEPT_COPY테이블에 LNAME컬럼추가,기본값은 한국으로 추가
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT'한국';
-->새로운 컬럼이 만들어지고 내가 지정한 기본값으로 채워짐

--2. 컬럼수정(MODIFY):
 --> 데이타타입 수정 : MODIFY 컬럼명 바꾸고자하는 데이타타입
 --> DEFAULT값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는 기본값
 
--DEPT_COPY 테이블의 DEPT_ID의 데이타 타입을 CHAR(3)으로 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

--DEPT_COPY 테이블의 DEPT_ID의 데이타 타입을 NUMBER로 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;  
--오류발생 : 컬럼값에 영문이 있음,또한 컬럼의 데이타 타입을 변경하기 위해선 해당 컬럼의 값을 지워야한다.(출력:데이터 유형을 변경할 열은 비어 있어야 합니다)

--DEPT_COPY테이블의 DEPT_TITLE의 데이타 타입을 VARCHAR2(10) 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10); 
--오류발생:컬럼의 값이 10BYTE가 넘는 데이타가 들어있어음

--* DEPT_TITLE : VARCHAR2(40)
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40);
--* LOCATION_ID : VARCHAR2(2)
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR2(2);
--* LNAME : '미국'으로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';

--*위3개를 다중변경
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40)
                      MODIFY LOCATION_ID VARCHAR2(2)
                      MODIFY LNAME DEFAULT '미국'

--3. 컬럼삭제(DROP COLUMN)
/*
 [표현법]
 ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
*/
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

--DEPT COPY2 테이블에서 LNAME 컬럼삭제
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;

--컬럼 삭제는 다중 안됨(하나씩 해줘야함)
ALTER TABLE DEPT_COPY2
   DROP COLUMN DEPT_TITLE
   DROP COLUMN LNAME;
   
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;   
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME; 
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID; 

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID; 
-->오류발생:최소 한개의 컬럼은 존재해야함

-------------------------------------------------------------------------------------------------------------------------------------
/*
 2)컬럼 추가/수정/삭제
*/
--=====제약조건 추가
/*
  ## 테이블을 다 생성한 후에 제약조건 추가  
     ALTER TABLE 테이블명 변경할내용;
  
  - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
  - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)];
  - UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
  - CHECK       : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식);
  - NOT NULL    : ALTER TABLE 테이블명 MODIFY UNIQUE 컬럼명 NOT NULL;
*/

--=====제약조건 삭제
/*
 [표현법]
 ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건;
 ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;          NULL일때는 수정
*/
ALTER TABLE DEPT_COPY DROP CONSTRAINT F_JOB;

ALTER TABLE EMP_DEPT MODIFY EMP_NAME NULL;

-------------------------------------------------------------------------------------------------------------------------------------
--3)컬럼명/제약조건명/테이블명 변경(RENAME)
--====1.컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
--DEPT_COPY테이블의 DEPT_TITLE을 DEPT_NAME으로 컬럼명 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

--====2.제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
--EMPLOYEE_COPY테이블의 기본키의 제약조건의 이름 변경
ALTER TABLE EMPLOYEE_COPY RENAME CONSTRAINT SYS_C007695 TO EC_PK;

--====2.테이블명 변경 : RENAME 기존테이블명[RENAME] TO 바꿀테이블명
--DEPT_COPY => DEPT_TEST
ALTER TABLE DEPT_COPY2 RENAME TO DEPT_TEST2;

-------------------------------------------------------------------------------------------------------------------------------------
--테이블 삭제
--DROP TABLE 테이블명;
/*
  조건
  어딘가에서 참조되고 있는 부모테이블은 함부로 삭제안됨
  만약 삭제를 하고싶다면
  방법1. 자식테이블을 먼저 삭제하고 부모테이블을 삭제
  방법2. 그냥 부모테이블만 삭제하는데 제약조건까지 같이삭제
        DROP TABLE 테이블명 CASCADE CONSTRAINT;
*/        
  DROP TABLE DEPT_TEST;