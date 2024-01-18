--실행순서 : from->where->select->order
select * 
from (select * from board order by ref desc, pos)
where ROWNUM >= 11 AND ROWNUM <= 20;
--ROWNUM은 기준 1에서 데이터를 상대적인 번호로 검색해 온다
--기준1번이 없어서 검색안됨

--오류
select ROWNUM,* 
from (select * from board order by ref desc, pos)
where ROWNUM >= 1 AND ROWNUM <= 10;

--오류로 인해 별칭부여(ROWNUM을 출력하면서 서브쿼리 테이블의 모든 컬럼을 가져오려면 반드시 서브쿼리에 별칭부여)
select ROWNUM,BT1.* 
from (select * from board order by ref desc, pos)BT1
where ROWNUM >= 1 AND ROWNUM <= 10;
--or 
select ROWNUM,BT1.* 
from (select * from board order by ref desc, pos)BT1
where ROWNUM between 1 and 10;

select *
from (select ROWNUM as RNUM, BT1.* from (select * from board order by ref desc, pos)BT1)
where RNUM between ? and ?;
--서브쿼리에 ROWNUM이 1부터 모두 들어있어야 됨 (BoardDao인용)

select *
from (select ROWNUM as RNUM, BT1.* from (select * from board order by ref desc, pos)BT1)
where RNUM >=1 and RNUM <=10;


select * 
from (select ROWNUM as RNUM, BT1.* from (select * from board order by ref desc,pos) BT1 where name like '%동%')
where ROWNUM between 6 and 9;
--구현
select * 
from (select ROWNUM as RNUM, BT1.* from (select * from board order by ref desc,pos) BT1 where" + keyField + "like?)
where ROWNUM between ? and ?;