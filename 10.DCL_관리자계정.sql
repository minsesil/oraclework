/*
 < DCL : DATA CONTROL LANGUAGE >
   데이타 제어어
   계정에게 시스템권한 또는 객체에 접근권한 부여(GRANT)하거나 회수(REVOKE)하는 구문
   
   > 시스템 권한 : DB에 접근하는 권한, 객체를 생성할수 있는 권한
   > 객체접근 권한 : 특정 객체들을 조작할수 있는 권한
*/
--------------------------------------------------------------------------------------------------------------------
/*
 1.시스템 권한의 종류
   - CREATE SESSION : 접속할수있는 권한
   - CREATE TABLE : 테이블을 생성할수 있는 권한
   - CREATE VIEW : 뷰를 생성할수있는 권한
   - CREATE SEQUENCE : 시퀀스를 생성할수있는 권한
   ...
*/
--1.1. SAMPLE(사용자이름) / sample(비번) 계정생성
     ALTER SESSION set "_oracle_script" = true;
     create user sample identified by sample;
     --접속권한이 없어서 접속할수 없음

--1.2. 접속을 위해 CREATE SESSION 권한부여
    GRANT CREATE SESSION TO SAMPLE;
   
/*
-- SAMPLE계정에서 테이블생성 불가 : 권한부여를 안해서
CREATE TABLE TEST (
       ID VARCHAR2(30),
       NAME VARCHAR2(20)
);
*/
-- 1.3 테이블을 생성할 수 있는 CREATE TABLE 권한 부여(테이블생성 못함)
GRANT CREATE TABLE TO SAMPLE;

-- 1.4 TABLESPACE 할당(데이터 삽입 안됨)
ALTER USER SAMPLE QUOTA 2M ON USERS;


----------------------------------------------------------------------------------------
/*
    2. 객체 접근 권한
        특정 객체에 접근하여 조작할 수 있는 권한
        
        권한 종류
        SELECT      TABLE, VIEW, SEQUENCE
        INSERT      TABLE, VIEW
        UPDATE      TABLE, VIEW
        DELETE      TABLE, VIEW
        .....
        
        [표현식]
        GRANT 권한종류 ON 특정객체 TO 계정명;
        - GRANT 권한 종류 ON 권한을 가지고 있는 USER.특정객체 TO 권한을줄USER;
*/
-- 2.1 SMAPLE계정에게 AIE계정 EMPLOYEE테이블을 SELECT할 수 있는 권한부여
GRANT SELECT ON AIE.EMPLOYEE TO SAMPLE;

-- 2.2 SMAPLE계정에게 AIE계정의 DEPARTMENT테이블에 INSERT할 수 있는 권한부여
GRANT INSERT ON AIE.DEPARTMENT TO SAMPLE;
GRANT SELECT ON AIE.DEPARTMENT TO SAMPLE;

--권한 회수(권한 박탈)
--REVOKE 회수할 권한 FROM 계정명;
REVOKE SELECT ON AIE.EMPLOYEE FROM SAMPLE;
REVOKE INSERT ON AIE.DEPARTMENT FROM SAMPLE;
REVOKE SELECT ON AIE.EMPLOYEE FROM SAMPLE;

----------------------------------------------------------------------------------------
/*
  <ROLE 롤>
  - 특정 권한들을 하나의 집합으로 모아놓은 것
  
  CONNECT : CREATE, SESSION
  RESOURCE : CREATE 객체, INSERT, UPDATE...
  DBA : 시스템 및 객체 관리에 대한 모든 권한을 갖고 있는 롤
*/

--기존 했던 예
ALTER SESSION set "_oracle_script" = true;
create user SAMPLE2 identified by SAMPLE2; -- 아이디, 패스워드
--grant RESOURCE, CONNECT to SAMPLE2;  --권한
grant DBA to SAMPLE2;
alter user SAMPLE2 default TABLESPACE users quota UNLIMITED on users;

