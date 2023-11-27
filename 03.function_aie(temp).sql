/*
ADD_MONTHS(DATE,NUMBER):특정날짜에 해당 숫자만큼의 개월수를 더해 그 날짜 반환
*/
SELECT ADD_MONTHS(SYSDATE,1) FROM DUAL;

--사원명,입사일,입사후 정직원된 날짜(6개월후)조회
SELECT EMP_NAME,HIRE_DATE,ADD_MONTHS(HIRE_DATE,6) "정직원된 날짜" FROM EMPLOYEE;
------------------------------------------------------------------------------
/*
NEXT_DAY(DATE,요일(문자|숫자)):특정 날짜 이후에 가까운 해당 요일의 날짜를 반환
*/
SELECT SYSDATE,NEXT_DAY(SYSDATE,'월요일') FROM DUAL;
SELECT SYSDATE,NEXT_DAY(SYSDATE,'월') FROM DUAL;

--1:일요일
SELECT SYSDATE,NEXT_DAY(SYSDATE,2) FROM DUAL;
SELECT SYSDATE,NEXT_DAY(SYSDATE,'MONDAY') FROM DUAL; 에러 현재언어가 KOREA이기때문

--언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE,NEXT_DAY(SYSDATE,'MONDAY') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE=KOREAN;
-----------------------------------------------------------------------------
/*
LAST_DAY(DATE);해당 월의 마지막 일자의 날짜 반환
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

--사원명,입사일,입사한 달의 마지막 날짜 조회
SELECT EMP_NAME,HIRE_DATE,LAST_DAY(HIRE_DATE) FROM EMPLOYEE;

--사원명,입사일,입사한 달의 마지막 날짜 조회
SELECT EMP_NAME,HIRE_DATE,LAST_DAY(HIRE_DATE) FROM EMPLOYEE;

--사원명,입사일,입사한 달의 마지막 날짜, 입사한 달의 근무일수 조회
SELECT EMP_NAME,HIRE_DATE,LAST_DAY(HIRE_DATE)-HIRE_DATE+1 FROM EMPLOYEE;		--근무한 날도 포함해야 하므로 +1
----------------------------------------------------------------------------------------------------------------
/*
EXTRACT : 특정 날짜로부터 년|월|일 값을 추출하여 반환하는 함수(NUMBER:반환형)

[표현법]
EXTRACT(YEAR FROM DATE):년도만 추출
EXTRACT(MONTH FROM DATE):월만 추출
EXTRACT(DAY FROM DATE):일만 추출
*/
--사원명,입사년도,입사월,입사일 조회
SELECT EMP_NAME,EXTRACT(YEAR FROM HIRE_DATE)입사년도, EXTRACT(MONTH FROM HIRE_DATE)입사월, EXTRACT(DAY FROM HIRE_DATE)입사일 
FROM EMPLOYEE ORDER BY 입산년도,입사월,입사일 ASC;

-------------------------------------------------------------------------------------------------------------------
                                    형변화 함수
-------------------------------------------------------------------------------------------------------------------
/* 
TO_CHAR : 숫자 또는 날짜의 값을 문자타입으로 변환

[표현법]
TO_CHAR(숫자|날짜,[포맷])
- 포맷 : 반환 결과를 특정 형식에 맞게 출력하도록 함
*/
-------------------------------------숫자=>문자--------------------------------------------------------------------
/*
9 : 해당 자리의 숫자를 의미
    - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
0 : 해당 자리의 숫자를 의미
    - 값이 없을 경우 0표시, 숫자의 길이를 고정적으로 표시할때 주로사용
FM : 좌우 9로 치환된 소수점 이상의 공백 및 소수점 이하의 0을 제거
     해당 자리에 값이 없을경우 자리차지 하지 않음

*/
SELECT TO_CHAR(1234) FROM DUAL; --문자로 변환했기때문에 왼쪽정렬
SELECT TO_CHAR(1234,'999999') FROM DUAL; --6자리 공간차지,왼쪽정렬,빈칸공백
SELECT TO_CHAR(1234,'000000') FROM DUAL; --6자리 공간차지,왼쪽정렬,빈칸은 0으로 채움

SELECT TO_CHAR(1234,'L99999')자리 FROM DUAL; -- L(LOCAL)현재 설정된 나라의 화폐단위(빈칸공백)
SELECT TO_CHAR(12341234,'L999,999,999')자리 FROM DUAL; --출력)\12,341,234

--사번,이름,급여(\1,111,111),연봉(\123,234,234) 조회
SELECT EMP_ID,EMP_NAME,TO_CHAR(SALARY,'L99,999,999')급여,TO_CHAR(SALARY*12,'L999,999,999')연봉 FROM EMPLOYEE;

--FM
SELECT TO_CHAR(123.456,'FM99990.999'),TO_CHAR(1234.56,'FM9990.99'),TO_CHAR(0.1000,'FM9990.00'),TO_CHAR(0.1000,'FM9999.999') FROM DUAL;

SELECT TO_CHAR(123.456,'99990.999'),TO_CHAR(1234.56,'9990.99'),TO_CHAR(0.1000,'9990.00'),TO_CHAR(0.1000,'9999.999') FROM DUAL;

----------------------------------------------------------------------------------------------------------------------------------------
                                        날짜=>문자
----------------------------------------------------------------------------------------------------------------------------------------
 --시간
SELECT TO_CHAR(SYSDATE,'AM')"한국날짜",TO_CHAR(SYSDATE,'PM''nls_date_language=american')"미국날짜" FROM DUAL;

SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS') FROM DUAL;  --12시간 형식
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') FROM DUAL;   --24시간 형식

--날짜
ALTER SESSION SET NLS_LANAGUAGE=KOREAN;
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY')FROM DUAL;
SELECT TO_CHAR(SYSDATE,'MON,YYYY')FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY"년 "MM"월 "DD"일 "DAY')FROM DUAL; --2023년 11월 10일 금요일
SELECT TO_CHAR(SYSDATE,'DL')FROM DUAL;--위와같은형태

SELECT TO_CHAR(SYSDATE,'YY-MM-DD')FROM DUAL;

--사원명, 입사일(23-02-02),입사일(2023년 2월 2일 금요일)조회
SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'YYYY-MM-DD')입사일,TO_CHAR(HIRE_DATE,'DL')입사년원일 FROM EMPLOYEE;

--년도
/*
  YY : 무조건 앞에 '20'이 붙는다.
  RR : 50년을 기준으로 작으면 앞에 '20'을 붙이고, 크면 앞에 '19'를 붙인다.
*/
SELECT TO_CHAR(SYSDATE,'YYYY'),TO_CHAR(SYSDATE,'YY'),TO_CHAR(SYSDATE,'RRRR'),TO_CHAR(SYSDATE,'YEAR') FROM DUAL;

SELECT TO_CHAR(HIRE_DATE,'YYYY'),TO_CHAR(HIRE_DATE,'RRRR') FROM EMPLOYEE;

--월
SELECT TO_CHAR(SYSDATE,'MM'),TO_CHAR(SYSDATE,'MON'),TO_CHAR(SYSDATE,'MONTH'),TO_CHAR(SYSDATE,'RM') FROM DUAL; --> 11 11월 11월 XI

--일
SELECT TO_CHAR(SYSDATE,'DD'),TO_CHAR(SYSDATE,'DDD'),TO_CHAR(SYSDATE,'D')FROM DUAL;  --> 10 314 6

--요일에 대한 포맷
SELECT TO_CHAR(SYSDATE,'DAY'),TO_CHAR(SYSDATE,'DY') FROM DUAL;  --> 금요일 금
------------------------------------------------------------------------------------------------------------------------------------------
/*
    TO_DATE : 숫자 또는 문자 타입을 날짜 타입으로 변환
    
    [표현법]
    TO_DATE(숫자|문자,[포맷])
*/
SELECT TO_DATE(20231110) FROM DUAL;     --> 23/11/10
SELECT TO_DATE(231110) FROM DUAL;   --> 23/11/10

SELECT TO_DATE(011110) FROM DUAL;   --> 오류 (숫자형태로 넣을때 앞이 0일때 오류, 0이 붙으면 반드시 문자타입으로)
SELECT TO_DATE('011110') FROM DUAL; --> 01/11/10

SELECT TO_DATE('070407 020830','YYMMDD HHMISS') FROM DUAL;  -->07/04/07 (도구>환경설정>날짜형식에서 RR->RRRR로 바꿔주면 2007로)
SELECT TO_CHAR(TO_DATE('070407 020830','YYMMDD HHMISS'),'YY-MM-DD HH:MI:SS') FROM DUAL;  -->07/04/07 02:08:30

--  YY : 무조건 앞에 '20'이 붙는다.
--  RR : 50년을 기준으로 작으면 앞에 '20'을 붙이고, 크면 앞에 '19'를 붙인다.
SELECT TO_DATE('041110','YYMMDD'),TO_DATE('981110','YYMMDD') FROM DUAL; --> 2004/11/10  2098/11/10  
SELECT TO_DATE('041110','RRMMDD'),TO_DATE('981110','RRMMDD') FROM DUAL; --> 2004/11/10  1998/11/10  
-------------------------------------------------------------------------------------------------------------------------
/*
    TO_NUMBER : 문자 타입을 숫자 타입으로 변환
    
    TO_NUMBER(문자,[포맷])
*/
SELECT TO_NUMBER('0212341234')FROM DUAL;    --> 212341234 (앞에 0이 사라짐)
SELECT '1000'+'5500' FROM DUAL;     --> 6500(DB에서는 문자여도 연산기호가있으면 연산이됨-자동으로 숫자로 형변환)
SELECT TO_NUMBER('1,000','9,999,999') FROM DUAL;    --> 1   1000
SELECT TO_NUMBER('1,000,000','9,999,999')+TO_NUMBER('1,000,000','9,999,999') FROM DUAL;     -->1    2000000



