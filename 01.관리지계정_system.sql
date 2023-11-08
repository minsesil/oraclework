-- 한줄주석(ctrl + /)
/*
여러줄 주석 (alt+shift+c)
*/
-- 실행(ctrl+enter)

--나의계정보기
show user;

--사용자 계정조회
select * from DBA_USERS;

--계정 만들기
--create user 사용자명 identified by 비밀번호;
--오라클 12버전부터 일반사용자는 c##을 붙여 이름을 작명한다.
--create user user1 IDENTITIED BY 1234;
create user c##user1 IDENTITIED by user1234;
create user c##user6 IDENTITIED by "1234";

--사용자 이름에 c## 붙이는 것을 회피하는 방법
ALTER SESSION set "_oracle_script" = true;
create user user7 identified by user7;

--사용자 이름은 대소문자를 가리지 않는다
--실제 사용할 계정 생성
create user aie identified by aie;
-- 실행

--권한생성
--[표현범]grant 권한1,권한2,...to 계정명;
grant RESOURCE, CONNECT to aie;
-- 실행

--테이블 스페이스에 얼마만큼의 영역을 할당할 것인지를 부여
alter user aie default TABLESPACE users quota UNLIMITED on users;

--테이블 스페이스의 영역을 특정 용량만큼 할당하려면


--user 삭제
--[표현법] drop user 사용자명; => 테이블이 없는 상태
--[표현범] drop user 사용자명 cascade; => 테이블이 있을때