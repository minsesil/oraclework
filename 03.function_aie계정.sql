/*
<함수>
전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환

- 단일행 함수 : N개의 값을 읽어들여 N개의 결과값을 반환(매 행마다 함수 실행)
- 그룹 함수 : N개의 값을 읽어들여 1개의 결과값을 반환(그룹별로 함수 실행)

>> SELECT 절에 단일행 함수와 그룹함수를 함께 사용할수 없음

>> 함수식을 기술할수 있는 위치:SELECT절, WHERE절, ORDER BY절, HAVING절
*/
----------------------------단일행 함수--------------------------------------
--=========================================================================
--                        <문자처리 함수>
--=========================================================================
/*
    LEGNTH / LENGTHB => NUMBER로 반환
    
    LENGTH(컬럼 | '문자열') : 해당 문자열의 글자수 반환
    LENGTHB(컬럼 | '문자열') : 해당 문자열의 BYTE수 반환
        - 한글 : XE 버전일때 => 1글자당 3byte(김, ㄱ ㄷ ㅏ 등도 1글자에 해당)
                EE 버전일때 => 1글자당 2byte
        - 그외 : 1글자당 1byte
 */
 SELECT LENGTH('오라클'),LENGTH('오라클') 
 FROM DUAL;     --오라클에서 제공하는 가상 테이블
 
 SELECT LENGTH('ORACLE'),LENGTH('ORACLE') FROM DUAL;
 
 SELECT LENGTH('ㅇㅗㄹㅏ')||'글자',LENGTHB('ㅇㅗㄹㅏ')||'BYTE' FROM DUAL;
 
 SELECT EMP_NAME,LENGTH(EMP_NAME)||'글자',LENGTHB(EMP_NAME)||'byte',EMAIL,LENGTH(EMAIL)||'글자',LENGTHB(EMAIL)||'byte' 
 FROM EMPLOYEE;
-------------------------------------------------------------------------------------------------------------------------------------
 /*
 INSTR : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(반환형:NUMBER)
        - ORACLE에서 INDEX번호는 1부터 시작. 찾는 문자가 없으면 0 반환 (중요)
        
        INSTR(컬럼|'문자열','찾을문자열',[찾을위치의시작,[순번])
        
        찾을위치의 시작값
        1 : 앞에서부터 찾기
        -1 : 뒤에서부터 찾기
*/
SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL;  --결과:2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1) FROM DUAL;  --결과:2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1) FROM DUAL;  --결과:17
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1,3) FROM DUAL;  --결과:12 (순번넣을때 앞에서부터(1) 생략하면 안됨)
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',-1,2) FROM DUAL;  --결과:14 (순번넣을때 앞에서부터(1) 생략하면 안됨)

--이메일에서 맨처음에 나오는 _의 위치
SELECT EMAIL,INSTR(EMAIL,'_')"_위치", INSTR(EMAIL,'@')"@위치" FROM EMPLOYEE;

--------------------------------------------------------------------------------------------------
/*
    SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(CHARACTER)
    
    SUBSTR(컬럼 | '문자열', POSITION, [LENGTH])
     - POSITION : 문자열을 추출할 시작위치 INDEX
     - LENGTH : 추출할 문자 개수(생략시 맨마지막까지 추출)
*/
SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;        -- 결과 : HTMLCSS
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;       -- 결과 : HTML
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;       -- 결과 : ORACLE
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;    -- 결과 : HTML(INDEX가 음수이면 뒤에서부터 INDEX번호를 센다)

-- 주민번호에서 성별만 추출하여 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

-- 여자사원들만 사번, 사원명, 성별을 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

-- 남자사원들만 사번, 사원명, 성별을 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN (1,3);

-- 사원명, 이메일, 아이디(@표시 앞까지만) 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL,1, INSTR(EMAIL,'@')-1)  아이디
FROM EMPLOYEE;

--------------------------------------------------------------------------------------------------
/*
    LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때(CHARACTER: 반환형)
    
    LPAD / RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
    문자열에 덧붙이고자하는 문자를 왼쪽 혹은 오른쪽에 덧붙여서 최종 길이만큼의 문자열 반환
*/
-- EMAIL을 20길이로 오른쪽정렬로 출력(왼쪽으로 공백으로 채워서 출력)
SELECT EMP_NAME, LPAD(EMAIL, 20)-->공백8칸kim@kh.or.kr
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '#')-->########kim@kh.or.kr
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#')-->kim@kh.or.kr########
FROM EMPLOYEE;

-- 사번, 사원명, 주민번호 출력(123456-1****** 의 형식)
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8),14,'*')-->651102-1******
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,1,8) || '******'
FROM EMPLOYEE;

--------------------------------------------------------------------------------------------------
/*
    LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 나머지 문자 반환(CHARACTER: 반환형)
    TRIM : 문자열의 앞/뒤 양쪽에 있는 지정한 문자를 제거한 나머지 문자 반환
    
    [표현법]
    LTRIM / RTRIM('문자열', [제거하고자하는 문자열])
    TRIM( [LEADING | TRAILING | BOTH]제거하고자하는 문자열 FROM '문자열')
*/
SELECT LTRIM('     A I   E     ') || '애드인에듀' FROM DUAL;        -- 제거하고자하는 문자열 생략시 기본값 공백
SELECT LTRIM('JAVAJAVASCRIPTSPRING', 'JAVA') FROM DUAL;
SELECT LTRIM('BCABACBDFGIABC','ABC') FROM DUAL;
SELECT LTRIM('738473KLIK28373','0123456789') FROM DUAL;

SELECT RTRIM('BCABACBDFGIBACABAB','ABC') FROM DUAL;
SELECT RTRIM('738473KLIK28373','0123456789') FROM DUAL;

-- TRIM은 기본적으로 양쪽모두 문자(기본값: 공백) 제거
SELECT TRIM('     A I   E     ') || '애드인에듀' FROM DUAL;   -->A I   E애드인에듀
SELECT TRIM('A' FROM 'AAABDKD342AAAA') FROM DUAL;   -->BDKD342

-- LEADING : 앞의 문자 제거
SELECT TRIM(LEADING 'A' FROM 'AAAAKDJDIAAAA') FROM DUAL;    -->KDJDAAAA

-- TRAILING : 뒤의 문자 제거
SELECT TRIM(TRAILING 'A' FROM 'AAAAKDJDIAAAA') FROM DUAL;   -->AAAAKDJDI

-- BOTH : 앞과 뒤의 문자 제거 => 기본값:생략가능
SELECT TRIM(BOTH 'A' FROM 'AAAAKDJDIAAAA') FROM DUAL;   -->KDJDI

--------------------------------------------------------------------------------------------------
/*
    LOWER / UPPER / INITCAP : 문자열을 대문자 혹은 소문자 혹은 단어의 앞글자만 대문자로 변환
    
    [표현법]
    LOWER / UPPER / INITCAP('영문자열')
*/
SELECT LOWER('Java JavaScript Oracle') FROM DUAL;
SELECT UPPER('Java JavaScript Oracle') FROM DUAL;
SELECT INITCAP('java javascript oracle') FROM DUAL;
--------------------------------------------------------------------------------------------------
/*
    CONCAT : 문자열 두개를 하나로 합친 결과 반환
    
    [표현법]
    CONCAT('문자열', '문자열')
*/
SELECT CONCAT('oracle','(오라클)') from dual;
SELECT 'oracle' || '(오라클)' from dual;

-- SELECT CONCAT('oracle','(오라클)','02-313-0470') from dual;    인수는 2개만 가능
SELECT 'oracle' || '(오라클)' || ' 02-313-0470' from dual;
--------------------------------------------------------------------------------------------------
/*
    REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr', 'aie.or.kr') -->kim@kh.or.kr   kim@aie.or.kr
FROM EMPLOYEE;

--===================================================================================
--                              <숫자 처리 함수>
--===================================================================================

/*
    ABS : 절대값을 구하는 함수
    
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-10) FROM DUAL;  --> 10      
SELECT ABS(-3.1415) FROM DUAL;  -->3.1415

--------------------------------------------------------------------------------------------------
/*
    MOD : 두 수를 나눈 나머지값 반환
    
    [표현법]
    MOD(NUMBER, NUMBER)
*/
SELECT MOD(10, 3) FROM DUAL;    -->1
SELECT MOD(10.9, 2) FROM DUAL;  -->0.9    -- 잘 사용하지 않음    

--------------------------------------------------------------------------------------------------
/*
    ROUND : 반올림한 결과 반환
    
    [표현법]
    ROUND(NUMBER, [위치])
*/
SELECT ROUND(1234.56) FROM DUAL;        -->1235        -- 위치 생략시 0    
SELECT ROUND(12.34) FROM DUAL;          -->12
SELECT ROUND(1234.5678, 2) FROM DUAL;   -->1234.57
SELECT ROUND(1234.56, 4) FROM DUAL;     -->1234.56
SELECT ROUND(1234.56, -2) FROM DUAL;    -->1200

--------------------------------------------------------------------------------------------------
/*
    CEIL : 올림한 결과 반환
    
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(-123.456) FROM DUAL;
--------------------------------------------------------------------------------------------------
/*
    FLOOR : 내림한 결과 반환
    
    [표현법]
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(-123.456) FROM DUAL;
--------------------------------------------------------------------------------------------------
/*
    TRUNC : 위치 지정 가능한 버림처리 함수
    
    [표현법]
    TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.78) FROM DUAL;         -->123
SELECT TRUNC(123.7867, 2) FROM DUAL;    -->123.78
SELECT TRUNC(123.7867, -2) FROM DUAL;   -->100

SELECT TRUNC(-123.78) FROM DUAL;        -->-123
SELECT TRUNC(-123.78, -2) FROM DUAL;    -->-100

--===================================================================================
--                          <날짜 처리 함수>
--===================================================================================
/*
    SYSDATE : 시스템 날짜와 시간 반환
*/
SELECT SYSDATE FROM DUAL;

--------------------------------------------------------------------------------------------------
/*
    MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수 반환
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월  차' 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') 근무개월수
FROM EMPLOYEE;

--------------------------------------------------------------------------------------------------
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
SELECT SYSDATE,NEXT_DAY(SYSDATE,'월요일') FROM DUAL;   -->2023/11/13  2023/11/20
SELECT SYSDATE,NEXT_DAY(SYSDATE,'월') FROM DUAL;       -->상동

--1:일요일
SELECT SYSDATE,NEXT_DAY(SYSDATE,2) FROM DUAL;          -->상동
SELECT SYSDATE,NEXT_DAY(SYSDATE,'MONDAY') FROM DUAL; 에러 현재언어가 KOREA이기때문

--언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE,NEXT_DAY(SYSDATE,'MONDAY') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE=KOREAN;
-----------------------------------------------------------------------------
/*
LAST_DAY(DATE);해당 월의 마지막 일자의 날짜 반환
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL; -->2023/11/30

--사원명,입사일,입사한 달의 마지막 날짜 조회
SELECT EMP_NAME,HIRE_DATE,LAST_DAY(HIRE_DATE) FROM EMPLOYEE;    -->1990/02/06  1990/02/28

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
                                    형변화 함수(많이사용)
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
SELECT TO_CHAR(1234,'999999') FROM DUAL; --6자리 공간차지,왼쪽정렬,빈칸공백            -->공백2개1234
SELECT TO_CHAR(1234,'000000') FROM DUAL; --6자리 공간차지,왼쪽정렬,빈칸은 0으로 채움    -->001234

SELECT TO_CHAR(1234,'L99999')자리 FROM DUAL; -- L(LOCAL)현재 설정된 나라의 화폐단위(빈칸공백)     -->공백\1234
SELECT TO_CHAR(12341234,'L999,999,999')자리 FROM DUAL; --출력)\12,341,234                   -->공백\12,341,234

--사번,이름,급여(\1,111,111),연봉(\123,234,234) 조회 (**시험자주나옴)
SELECT EMP_ID,EMP_NAME,TO_CHAR(SALARY,'L99,999,999')급여,TO_CHAR(SALARY*12,'L999,999,999')연봉 FROM EMPLOYEE;

--FM
SELECT TO_CHAR(123.456,'FM99990.999'),  -->123.456
       TO_CHAR(1234.56,'FM9990.99'),    -->1234.56
       TO_CHAR(0.1000,'FM9990.999'),    -->0.1
       TO_CHAR(0.1000,'FM9990.00'),     -->0.10      **중요
       TO_CHAR(0.1000,'FM9999.999')     -->.1
FROM DUAL;

SELECT TO_CHAR(123.456,'99990.999'),TO_CHAR(1234.56,'9990.99'),TO_CHAR(0.1000,'9990.00'),TO_CHAR(0.1000,'9999.999') FROM DUAL;

----------------------------------------------------------------------------------------------------------------------------------------
                                        날짜=>문자
----------------------------------------------------------------------------------------------------------------------------------------
 --시간
SELECT TO_CHAR(SYSDATE,'AM')"한국날짜",TO_CHAR(SYSDATE,'PM''nls_date_language=american')"미국날짜" FROM DUAL;   -->ER?

SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS') FROM DUAL;  --12시간 형식     -->오전 10:12:56
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') FROM DUAL;   --24시간 형식     -->10:13:14

--날짜
ALTER SESSION SET NLS_LANAGUAGE=KOREAN;
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY')FROM DUAL;               -->2023-11-10 금요일
SELECT TO_CHAR(SYSDATE,'MON,YYYY')FROM DUAL;                     -->11월,2023
SELECT TO_CHAR(SYSDATE,'YYYY"년 "MM"월 "DD"일 "DAY')FROM DUAL;    --> 2023년 11월 10일 금요일
SELECT TO_CHAR(SYSDATE,'DL')FROM DUAL;                           --> 위와같은형태

SELECT TO_CHAR(SYSDATE,'YY-MM-DD')FROM DUAL;                     --> 23-11-12

--사원명, 입사일(23-02-02),입사일(2023년 2월 2일 금요일)조회
SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'YYYY-MM-DD')입사일,TO_CHAR(HIRE_DATE,'DL')입사년원일 FROM EMPLOYEE;

--년도
/*
  YY : 무조건 앞에 '20'이 붙는다.
  RR : 50년을 기준으로 작으면 앞에 '20'을 붙이고, 크면 앞에 '19'를 붙인다.
*/
SELECT TO_CHAR(SYSDATE,'YYYY'),TO_CHAR(SYSDATE,'YY'),TO_CHAR(SYSDATE,'RRRR'),TO_CHAR(SYSDATE,'YEAR') FROM DUAL;

SELECT TO_CHAR(HIRE_DATE,'YYYY'),TO_CHAR(HIRE_DATE,'RRRR') FROM EMPLOYEE;   --**

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
SELECT TO_DATE(231110) FROM DUAL;       --> 23/11/10

SELECT TO_DATE(011110) FROM DUAL;       --> 오류 (숫자형태로 넣을때 앞이 0일때 오류, 0이 붙으면 반드시 문자타입으로)
SELECT TO_DATE('011110') FROM DUAL;     --> 01/11/10

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
SELECT TO_NUMBER('0212341234')FROM DUAL;             --> 212341234 (앞에 0이 사라짐)
SELECT '1000'+'5500' FROM DUAL;                     --> 6500(DB에서는 문자여도 연산기호가있으면 연산이됨-자동으로 숫자로 형변환)
SELECT TO_NUMBER('1,000','9,999,999') FROM DUAL;    --> 1   1000
SELECT TO_NUMBER('1,000,000','9,999,999')+TO_NUMBER('1,000,000','9,999,999') FROM DUAL;     -->1    2000000

----------------------------------------------------------------------------------------------------------------
                                       < NULL 처리 함수 > 굉장히중요 *****
----------------------------------------------------------------------------------------------------------------
/*
    NVL(컬럼, 해당 컬럼이 NULL일 경우 반환될 값)
*/
SELECT EMP_NAME,NVL(BONUS,0) FROM EMPLOYEE;

--사원명,보너스포함연봉 조회
SELECT EMP_NAME,(SALARY*BONUS+SALARY)*12 FROM EMPLOYEE;   --NULL이 있는경우가 있음

SELECT EMP_NAME,(SALARY*(1+BONUS))*12 FROM EMPLOYEE;      --결과는 위와같다

SELECT EMP_NAME,SALARY*(1+NVL(BONUS,0))*12 FROM EMPLOYEE;

SELECT EMP_NAME,NVL(DEPT_CODE,'부서없음') FROM EMPLOYEE;    --널이면 '부서없음'이란 대체값 넣어줌
---------------------------------------------------------------------------------------------------------------------------------
/*
    NVL2(컬럼,반환값1,반환값2)
    -컬럼값이 존재할경우 반환값1
    -컬럼값이 NULL일때 반환값2
*/
--보너스를 받는사람은 50%의 성과급을, 보너스를 받지않는 사람은 0.1
SELECT EMP_NAME,SALARY,BONUS,SALARY*NVL2(BONUS,0.5,0.1)성과금 FROM EMPLOYEE;

--부서가 있으면 부서있음, 없으면 부서없음
SELECT DEPT_CODE,NVL2(DEPT_CODE,'부서있음','부서없음')부서여부 FROM EMPLOYEE;
---------------------------------------------------------------------------------------------------------------------------------
/*
    NULLIF(비교대상1,비교대상2)
    - 두개의 값이 일치하면 NULL반환
    - 두개의 값이 일치하지 않으면 비교대상 1을 반환
*/
SELECT NULLIF('1234','1234') FROM DUAL;     -->NULL
SELECT NULLIF('1234','5678') FROM DUAL;     -->1234
---------------------------------------------------------------------------------------------------------------------------------
                                <선택 함수>
---------------------------------------------------------------------------------------------------------------------------------
/*
    DECODE(비교하고자 하는 대상(컬럼|산술연산|함수식),비교값1,비교값2,결과값2,...
    
    SWITCH(비교대상){
     CASE 비교값1;
      결과값1;
     CASE 비교값2;
      결과값2;
      ...
    }
*/
--사원명,성별
SELECT EMP_NAME,DECODE(SUBSTR(EMP_NO,8,1),'1','남자','2','여자','3','남자','4','여자')FROM EMPLOYEE;

--<EX>
--직원의 급여를 직급별로 인상해서 조회
--J7이면 급여의 10% 인상
--J6이면 급여의 15% 인상
--J5이면 급여의 20% 인상
--그외이면 급여의 5% 인상

--사원명,직급코드,기존급여,인상된급여
SELECT EMP_NAME,JOB_CODE,SALARY 기존급여,
DECODE(JOB_CODE,'J7',SALARY*1.1,'J6',SALARY*1.15,'J5',SALARY*1.2,SALARY*1.05)"인상된급여" FROM EMPLOYEE;

------------------------------------------------------------------------------------------------------------
/*
    CASE WHEN THEN
    END
    
    CASE WHEM 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N
    END
*/
--사원명,급여,급여가 500만원 이상이면 '고급', 350만운 이상이면 '중급',나버지는 '초급'
SELECT EMP_NAME,SALARY,
CASE WHEN SALARY>=5000000 THEN '고급'
     WHEN SALARY>=3500000 THEN '중급'
     ELSE '초급'
END 급수
FROM EMPLOYEE;
*/

-========================================================================================================================
--                                              <그룹 함수>
-========================================================================================================================
/*
    SUM(숫자타입의 컬럼) : 해당컬럼값들의 함계를 구해서 반환
*/
-- 전 사원의 총 급여액 조회
SELECT SUM(SALARY)"총 급여액" FROM EMPLOYEE;    -->70096240

--남자사월의 총급여액 조회
SELECT SUM(SALARY)"남자사원의 총 급여액"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN('1','3');            -->50170000

--부서코드가 'D5'인 사원의 총 급여액 조회
SELECT SUM(SALARY)"D5사원 총급여액"
FROM EMPLOYEE
WHERE DEPT_CODE='D5';                           -->15760000

--D5인사원 연봉합계
SELECT SUM(SALARY*NVL(BONUS,0)+SALARY) "D5사원 보너스포함한 연봉합계" 
FROM EMPLOYEE WHERE DEPT_CODE='D5';             -->1605000

--전 사원의 총 급여액 조회
SELECT TO_CHAR(SUM(SALARY),'L999,999,999')"총급여액" FROM EMPLOYEE; --\70,096,240

--전 사원의 평균 급여액 조회
SELECT ROUND(AVG(SALARY))"평균급여액" FROM EMPLOYEE;     -->3047663
-------------------------------------------------------------------------------------------------------
/*
    MIN(모든타입컬럼):해당 컬럼값들 중에 가장 작은값 반환
    MAX(모든타입컬럼):해당 컬럼값들 중에 가장 큰값 반환
*/
--이름중 가장 작은값(사전순),급여중 가장 적게받는값,입사일중 가장먼저 입사한 날짜
SELECT MIN(EMP_NAME),MIN(SALARY),MIN(HIRE_DATE) FROM EMPLOYEE;

--이름중 가장 큰값(사전순),급여중 가장 많이받는값,입사일중 가장나중에 입사한 날짜
SELECT MAX(EMP_NAME),MAX(SALARY),MAX(HIRE_DATE) FROM EMPLOYEE;

-------------------------------------------------------------------------------------------------------
/*
    COUNT(*|컬럼|DISTINCT 컬럼):행의 갯수 반환
    COUNT(*) : 조회된 결과의 모든 행의 갯수 반환
    COUNT(컬럼):제시한 컬럼의 NULL갓을 제외한 행의 갯수 반환
    COUNT(DISTINCT 컬럼):해당 컬럼값 중복을 제거한 후의 행의 갯수 반환
*/
--전체 사원수 조회
SELECT COUNT(*) 
FROM EMPLOYEE WHERE SUBSTR(EMP_NO,8,1)IN('2','4');      -->8

--보너스를 받는 사원수 조회
SELECT COUNT(BONUS) FROM EMPLOYEE;                      -->9

--부서배치를 받은 사원 수
SELECT COUNT(DEPT_CODE) FROM EMPLOYEE;                  -->21
select dept_code from employee; --확인

--현재 사원들이 총 몇개의 부서에 배치되었는지
SELECT COUNT(DISTINCT DEPT_CODE) FROM EMPLOYEE;   -->6
select distinct dept_code from employee;    --확인

-----BASIC----------------------------------------------------------------------------------------------------------
--WORKBOOK-FUNCTION 문제풀이
--3.교수이름 나이(나이의 오름차순 정렬)조회
SELECT EXTRACT(YEAR FROM SYSDATE) FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME,
        EXTRACT(YEAR FROM SYSDATE)-(19||SUBSTR(PROFESSOR_SSN,1,2))나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1)IN('1','3')
ORDER BY 나이;

--13. 학과별 휴학생 수 학과 번호와 휴학생 수 표시
SELECT DEPARTMENT_NO 학과번호, COUNT(DECODE(ABSENCE_YN,'Y',1))"휴학생"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 학과번호;

 
 -----FUNCTION----------------------------------------------------------------------------------------------------------
 --9. 학번이 A517178인 한아름 학생의 학점 총 평점 (화면 헤더는 "평점", 점수는 반올림하여 소수점 이하 한자리만 표시)
    SELECT POINT FROM TB_GRADE WHERE STUDENT_NO='A517178';
    SELECT ROUND(SUM(POINT))"평점" FROM TB_GRADE WHERE STUDENT_NO='A517178';

--10. 학과별 학생수를 구하여 "학과번호","학생수(명)'의 형태로 헤더를 만들어 결과값이 출력되도록 하시오

SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_STUDENT;

    SELECT TB_DEPARTMENT.DEPARTMENT_NO, TB_STUDENT.DEPARTMENT_NO 
    FROM TB_DEPARTMENT, TB_STUDENT
    WHERE TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO;
     
    
    
    
    