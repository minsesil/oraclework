/*
    - 서브쿼리(SUBQUERY)
      하나의 SQL문 안에 포함된 또다른 SELECT문
      메인 SQL문의 보조 역할을 하는 쿼리문
*/
-- 박정보 사원과 같은 부서에 속한 사원들 조회

-- 1. 박정보 사원 부서코드 조회
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '박정보'; --D9

--2. 부서코드가 'D9'인 사원의 정보 조회
    SELECT EMP_NAME
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D9';
    
--> 위의 두 쿼리문을 하나로 하면
    SELECT EMP_NAME
    FROM EMPLOYEE
    WHERE DEPT_CODE = (SELECT DEPT_CODE
                       FROM EMPLOYEE
                       WHERE EMP_NAME = '박정보');

-- 전 직원의 평균급여보다 급여를 더 많이 받는 사원의 사번,사원명,급여,직급코드 조회
    SELECT EMP_ID,EMP_NAME,SALARY,DEPT_CODE
    FROM EMPLOYEE
    WHERE SALARY >=(SELECT AVG(SALARY)
                    FROM EMPLOYEE);
---------------------------------------------------------------------------------------- 
/*
    - 서브쿼리의 구분
      서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 분류
      
      * 단일행 서브쿼리 : 서버쿼리의 조회 결과값이 오로지 1개일 때(1행 1열)
      * 다중행 서브쿼리 : 서버쿼리의 조회 결과값이 여러행 일때(여러행 1열)
      * 다중열 서브쿼리 : 서버쿼리의 조회 결과값이 여러열 일때(1행 여러열)
      * 다중행 다중열 서브쿼리 : 서버쿼리의 조회 결과값이 여러행 여러열 일때(여러행 여러열)
      
      >>서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
        서버쿼리의 조회 결과값이 오로지 1개일때(1행 1열)
        
        일반 비교연산자 사용 가능
        =, !=, >, <...
*/
-- 1) 전 직원의 평균 급여보다 급여를 적게 받는 사원의 사원명, 급여 조회
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    WHERE SALARY < (SELECT AVG(SALARY)
                    FROM EMPLOYEE)
    ORDER BY SALARY;
    
-- 2) 최저 급여를 받는 사원의 사원명, 급여 조회
    SELECT EMP_NAME,SALARY
    FROM EMPLOYEE
    WHERE SALARY = (SELECT MIN(SALARY)
                    FROM EMPLOYEE);
                    
-- 3) 박정보 사원의 급여보다 더 많이 받는 사원의 사번,사원명,급여 조회
    SELECT EMP_ID,EMP_NAME,SALARY
    FROM EMPLOYEE
    WHERE SALARY > (SELECT SALARY
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '박정보');
                    
-- ##JOIN + SUBQUERY
-- 4) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 부서이름, 급여 조회
-->> 오라클 전용 구문
    SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,SALARY
    FROM EMPLOYEE,DEPARTMENT
    WHERE SALARY > (SELECT SALARY
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '박정보');
    AND DEPT_CODE = DEPT_ID;
    
-->>ANSI 구문
   SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,SALARY
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE SALARY > (SELECT SALARY
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '박정보');
                    
-- 5)왕정보 사원과 같은 부서원들의 사번,사원명,전화번호,부서명 조회 단,왕정보는 제외
-->> 오라클 전용 구문
    SELECT EMP_ID,EMP_NAME,PHONE,DEPT_TITLE
    FROM EMPLOYEE,DEPARTMENT
    WHERE DEPT_CODE = DEPT_ID
    AND DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE EMP_NAME = '왕정보')
    AND EMP_NAME != '왕정보';
    
-->>ANSI 구문
    SELECT IMP_ID,EMP_NAME,PHONE,DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE DEPT_CODE = (SELECT DEPT_CODE
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '왕정보')
    AND EMP_AME != '왕정보';

-- GROUP + SUBQUERY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--      6.1  부서별 급여합 중 가장 큰 값 조회
/*
    SELECT DEPT_CODE, SUM(SALARY) 급여합
    FROM EMPLOYEE                       
    GROUP BY DEPT_CODE
    ORDER BY 급여합 DESC;
*/
    SELECT MAX(SUM(SALARY))      --부서별 그룹을 지어서 합계구함
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
--      6.2 부서별 급여합이 17,700,000인 부서 조회
    SELECT DEPT_CODE, SUM(SALARY) 급여합
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    HAVING SUM(SALARY) = 17700000;
    
-->>위 2개를 합치면
    SELECT DEPT_CODE, SUM(SALARY) 급여합
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                            FROM EMPLOYEE
                            GROUP BY DEPT_CODE);

---------------------------------------------------------------------------------------- 
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
        서브쿼리의 조회 결과값이 여러행 일때(여러행 1열)
        
        - IN 서브쿼리 : 여러개의 결과값 중 "한개라도"를 경우
            (여러개의 결과값 중 가장 작은값 보다 클 경우)
            
        - > ANY 서브쿼리:여러개의 결과값 중 "한개라도" 클 경우
            (여러개의 결과값 중 가장 작은값 보다 클 경우)
            
        - < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은 경우
            (여러개의 결과값 중 가장 큰값 보다 작을 경우)
            
        비교대상 > ANY(값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/
-- 1) 조정연 또는 전지연과 같은 직급인 사원들의 사번,사원명,직급코드,급여
--  1.1 조정연 또는 전지연이 어떤 직급인지 조회
    SELECT JOB_CODE
    FROM EMPLOYEE
    --WHERE EMP_NAME = '조정연' OR EMP_NAME = '전지연';
    WHERE EMP_NAME IN ('조정연','전지연');

-- 1.2 직급 코드가 J3,J7인 사원의 사번,사원명,직급코드,급여 조회
    SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
    FROM EMPLOYEE
    WHERE JOB_CODE IN (SELECT JOB_CODE
                        FROM EMPLOYEE
                        WHERE EMP_NAME IN ('조정연','전지연'));
                        
-- 대표 => 부사장 => 부장 => 차장 => 과장 => 대리 =>사원
-- 2) 대리 직급임에도 불구하고 과장직급의 급여들 중 최소 급여보다 맣이 반는 직원의 사번,사원명,직급,급여저회
--  2.1 과장 직급인 사원들의 급여조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';  --2,200,    2,500,     3,760

--  2.2 직급이 대리이면서 급여가 위의 목록값 중에 하나라도 큰 사원
    SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME = '대리'
        AND SALARY > ANY(SELECT (SALARY)    -- = (SELECT MIN(SALARY)
                            FROM EMPLOYEE
                            JOIN JOB USING(JOB_CODE)
                            WHERE JOB_NAME ='과장');
                            
 -- 3)차장 직금임에도 과장직급의 급여보다 적게받는 사원의 사번,사원명,직급명,급여조회
 
    SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME='차장'
    
    AND SALARY < ANY(SELECT SALARY
                        FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                        WHERE JOB_NAME = '과장');   --2,200.  2,500.  3,760
    
-- 4) 과장직급임에도 불구하고 차장직급인 사원의 모든 급여보다 더 많이 받는 사원들의 사번,사원명,직급명,급여조회
-- ANY : 차장의 가장 적게받는 급여보다 많이 받는 과장
         비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
    SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME = '과장'
    AND SALARY > ANY(SELECT SALARY
                        FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                        WHERE JOB_NAME = '차장'); --280, 155, 249, 248
   
-- ALL : 차장의 가장 많이 받는 급여보다 더 많이 과장 (=and)
--       비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3 (결국 가장큰값보다 커야)

-- 차장의 가장 많이 받는 급여보다 더 많이 과장
    SELECT EMP_ID,EMP_NAME,JOB_NAME,SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME = '과장' --220, 250, 376
    AND SALARY > ALL(SELECT SALARY      --단일행:MAX
                        FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                        WHERE JOB_NAME = '차장');    --280,155,249,248
                        
/*
    3. 다중열 서브쿼리
    결과값이 한행이면서 여러 컬럼일 때   
*/
-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사번, 사원명 부서코드,직급코드 조회
SELECT DEPT_CODE FROM EMPLOYEE EMP_NAME='장정보';

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME='장정보')
AND JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME='장정보');
--다중열 서브쿼리로
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE(DEPT_CODE,JOB_CODE)=(SELECT DEPT_CODE, JOB_CODE
                            FROM EMPLOYEE
                            WHERE EMP_NAME='장정보');

--지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번,사원명,직급코드,사수번호조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE,MANAGER_ID) = (SELECT JOB_CODE,MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME='지정보');

/*
    4. 다중행 다중열 서브쿼리
       서브쿼리 결과 여러행, 여러열일 경우
*/
-- 1) 각 직급별 최소급여를 받는 사원의 사번,이름,직급코드, 급여 조회
-- 1.1 각 직급별로 최소급여를 받는 사원의 직급코드, 최소급여 조회
    SELECT JOB_CODE,MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE;
/*    
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    GROUP BY JOB_CODE = 'J5' AND SALARY = 2200000
        OR JOB_CODE = 'J6' AND SALARY = 2000000
 */       
    --다중행,다중열 서브쿼리
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE(JOB_CODE,SALARY) IN (SELECT JOB_CODE,MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);

-- 2) 각 부서별 최고급여를 받는 사원의 사번, 사원명, 부서코드, 급여 조회(EMPLOYEE,JOB)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
    FROM EMPLOYEE
    WHERE(DEPT_CODE,SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE);
                                
---------------------------------------------------------------------------------------- 
/*
    5. 인라인 뷰(INLINE VIEW)
       FROM절에 서브쿼리를 작성
    
       서브쿼리를 수행한 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스 포함 연봉, 부서코드 조회
    -- 조건1. 보너스포함 연봉이 NULL이 나오지 않도록
    -- 조건2. 보너스포함 연봉이 3000만원 이상인 사원들만 조회
    -- <순서> 1.FROM 2.WHERE 3.SELECT
    --         SELECT 연봉
    --         FROM 내가만든 테이블(보너스포함연봉)
    --         WHERE 조건2
    SELECT EMP_ID, EMP_NAME, SALARY*NVL((1+BONUS),1)*12 연봉, DEPT_CODE --널값처리 NVL: 널이면1
    FROM EMPLOYEE
    WHERE SALARY*NVL((1+BONUS),1)*12 >= 30000000;
    
        --인라인 뷰에 없는 컬럼은 가져올수 없다
        --SELECT EMP_ID, EMP_NAME, JOB_CODE --FROM절 컬럼과 동일하게 맞춰야함
        SELECT EMP_ID, EMP_NAME
        FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL((1+BONUS),1)*12 연봉, DEPT_CODE 
              FROM EMPLOYEE)
        WHERE 연봉 >= 30000000;
 -- 인라인 뷰를 주로 사용하는 곳 => TOP-N 분석(상위 몇이만 가져오기)
 
 -- 전 직원중 급여가 가장 높은 상위 5명만 조회
 -- * ROWNUM : 오라클에서 제공해주는 커럼, 조회된 순서대로 1부터 부여해줌
 --             WHERE절에 기술
 
    SELECT ROWNUM, EMP_NAME, SALARY --가지고온 순서대로 ROWNUM이 붙는다
    FROM EMPLOYEE;
    
    SELECT ROWNUM, EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY;
    
    SELECT ROWNUM, EMP_NAME, SALARY
    FROM EMPLOYEE
    WHERE ROWNUM <= 5
    ORDER BY SALARY;   
    
-- 순서때문에 내가 원하는 결과 나오지 않음
-- 먼저 정렬(ORDER BY)한 테이블을 만들고
-- 그 테이블에서 ROWNUM을 부여
-- 전 직원중 급여가 가장 높은 상위 5명만 조회
    SELECT *
    FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
          FROM EMPLOYEE
          ORDER BY SALARY DESC);
    
    SELECT ROWNUM, EMP_NAME, SALARY, DEPT_CODE
    FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
          FROM EMPLOYEE
          ORDER BY SALARY DESC)  
    WHERE ROWNUM <= 5;
    
-- 인라인 뷰의 모든 컬럼과 다른 컬럼(오라클에서 제공해주는 컬럼)을 가져올때는 테이블에 별칭 부여
    SELECT ROWNUM, T.*
    FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
          FROM EMPLOYEE
          ORDER BY SALARY DESC)T
    WHERE ROWNUM <= 5;   
    
--EX) 가장 최근에 입사한 사원 5명의 ROWNUM, 사번, 사원명, 입사일 조회
      SELECT ROWNUM, DEPT_CODE, EMP_NAME, HIRE_DATE
      FROM (SELECT DEPT_CODE, EMP_NAME, HIRE_DATE
             FROM EMPLOYEE
             ORDER BY HIRE_DATE DESC)
      WHERE ROWNUM <=5;

--EX) 각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회 (~별:ORDER BY)
      SELECT * FROM (SELECT DEPT_CODE, CEIL(AVG(SALARY))평균급여 
                        FROM EMPLOYEE 
                        GROUP BY DEPT_CODE 
                        ORDER BY 평균급여 DESC)
      WHERE ROWNUM <= 3; 

---------------------------------------------------------------------------------------- 
/* #별로 쓸일이 많지않다
    6. WITH
       서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
        
     - 장점
       1. 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할수 있다.
       2. 실행속도도 빨라짐
*/
    -- WITH 테이블명 AS
    --부서별 
    WITH TOPN_SAL1 AS(SELECT DEPT_CODE,CEIL(AVG(SALARY))평균급여
                      FROM EMPLOYEE 
                      GROUP BY DEPT_CODE
                      ORDER BY 평균급여 DESC);  --ER?
    SELECT * 
    FROM TOPN_SAL1
    WHERE ROWNUM <= 5;

---------------------------------------------------------------------------------------- 
/*
    7. 순위 매기는 함수(WINDOW FUNCTION)
       RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
       - RANK() OVER(정렬기준): 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰고 순위계산
                               EX)공동 1순위가 3명이면 그 다음 순위는 4위
                
       - DENSE_RANK() OVER(정렬기준):동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
                                    EX)공동 1순위가 3명이면 그 다음 순위는 2위
        >>두 함수는 무조건 SELECT절에서만 사용가능
    */   
 -- 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE;
 
    SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE;
  
 -- 급여가 상위 5위인 사원의 사원명, 급여, 순위 조회

    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE;
    WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;  오류
    
    -->인라인뷰를 쓸수밖에 없다
    SELECT *
    FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
         FROM EMPLOYEE)
    WHERE 순위 <= 5;
    
    --ROWNUM사용(나)
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE
    WHERE ROWNUM <= 5;  --이렇게도 가능

 -- WITH로 사용
    WITH TOPN_SAL5 AS (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
                        FROM EMPLOYEE)
    SELECT 순위, EMP_NAME, SALARY
    FROM TOPN_SAL5
    WHERE 순위 <= 5;
 
-------------------<연습문제>-------------------------------------------------------------
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회 
-- EMPLOYEE:EMP_NAME,EMP_NO/DEPARTMENT:DEPT_TITLE/JOB:JOB_NAME
    SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE E, DEPARTMENT, JOB J
    WHERE E.DEPT_CODE = DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79
    AND SUBSTR(EMP_NO,8,1)IN('2','4')
    AND EMP_NAME LIKE '전%';

    --ANSI형
     SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
     FROM EMPLOYEE
     JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
     JOIN JOB USING(JOB_CODE)
     WHERE SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79
     AND SUBSTR(EMP_NO,8,1)IN('2','4')
     AND EMP_NAME LIKE '전%';

-- 2. 나이가 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
-- EMPLOYEE:EMP_ID,EMP_NAME,EMP_NO/DEPARTMENT:DEPT_TITLE/JOB:JOB_NAME
--나이계산) : 올해연도 - 주민번호 연도
--올해연도추출
    EXTRACT(YEAR FROM SYSDATE)
-- 주민번호 연도추출
   EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
   
    SELECT EMP_ID
            ,EMP_NAME
            ,EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
            ,DEPT_TITLE
            ,JOB_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
    JOIN JOB USING(JOB_CODE)
    WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
    (SELECT EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))));


-- 3. 이름에 ‘하’가 들어가는 사원의 사원 코드, 사원 명, 직급 조회
    SELECT EMP_ID 사원코드, EMP_NAME 사원명, JOB_NAME 직급
    FROM EMPLOYEE E, JOB J
    WHERE E.JOB_CODE = J.JOB_CODE
    AND EMP_NAME LIKE '%하%';
    
-- 4. 부서 코드가 D5이거나 D6인 사원의 사원 명, 직급, 부서 코드, 부서 명 조회
    SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
    FROM EMPLOYEE E, DEPARTMENT D, JOB J
    WHERE DEPT_CODE = DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND DEPT_CODE IN ('D5','D6');
    
-- 5. 보너스를 받는 사원의 사원 명, 보너스, 부서 명, 지역 명 조회
    SELECT EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서명, LOCAL_NAME 지역명
    FROM EMPLOYEE, DEPARTMENT, LOCATION
    WHERE DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE
    AND BONUS IS NOT NULL;

-- 6. 사원 명, 직급, 부서 명, 지역 명 조회
    SELECT EMP_NAME, JOB_NAME, LOCAL_NAME
    FROM EMPLOYEE E, DEPARTMENT, JOB J, LOCATION 
    WHERE DEPT_CODE = DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND LOCATION_ID = LOCAL_CODE;

-- 7. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회 
    SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE)
    WHERE NATIONAL_NAME IN('한국','일본');

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 이름 조회
    SELECT EMP_NAME ,DEPT_TITLE
    FROM EMPLOYEE, DEPARTMENT
    WHERE DEPT_CODE = (SELECT DEPT_CODE 
                       FROM EMPLOYEE 
                       WHERE EMP_NAME='하정연');
    
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
    SELECT EMP_NAME, JOB_NAME, SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE NVL(BONUS,0)=0
        AND JOB_CODE IN ('J4','J7');
        
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회   
    SELECT COUNT(*)
    FROM EMPLOYEE
    GROUP BY ENT_YN;

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서 명, 직급, 입사일, 순위 조회
    --결과 이상하니 체크
    SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, SALARY*NVL((1+BONUS),1)*12 연봉, RANK() OVER(ORDER BY SALARY DESC) 랭크
    FROM EMPLOYEE E,DEPARTMENT,JOB J
    WHERE DEPT_CODE = DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND ROWNUM <= 5;
    
 --선생님
     SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 순위
       FROM (SELECT EMP_ID
                    , EMP_NAME
                    , DEPT_TITLE
                    , JOB_NAME
                    , HIRE_DATE
                    , RANK() OVER(ORDER BY (SALARY*NVL(1+BONUS,1)*12) DESC) 순위
             FROM EMPLOYEE
             JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
             JOIN JOB USING(JOB_CODE))
     WHERE 순위 <= 5;

-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회

--	    12-1. JOIN과 HAVING 사용        
        SELECT DEPT_TITLE, SUM(SALARY)
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
        GROUP BY DEPT_TITLE
        HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);
        
--	    12-2. 인라인 뷰 사용  (FROM절에 넣어줌) 
        SELECT *
        FROM(SELECT DEPT_TITLE, SUM(SALARY) 부서급여합
             FROM EMPLOYEE
             JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
             GROUP BY DEPT_TITLE)
        WHERE 부서급여합 > (SELECT SUM(SALARY*12)*0.2 FROM EMPLOYEE);

--	    12-3. WITH 사용 (결과이상 체크)
        WITH DEPTSUM AS (SELECT DEPT_TITLE, SUM(SALARY) 부서급여합
                         FROM EMPLOYEE
                         JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
                         GROUP BY DEPT_TITLE)
        SELECT *
        FROM DEPTSUM
        WHERE 부서급여합 > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);
      
-- 13. 부서 명과 부서 별 급여 합계 조회(NULL도 조회되도록)
   --LEFT JOIN
    SELECT DEPT_TITLE, SUM(SALARY)
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
    GROUP BY DEPT_TITLE;

    SELECT DEPT_TITLE, SUM(SALARY)
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
    GROUP BY DEPT_TITLE;
   
-- 14. WITH를 이용하여 급여 합과 급여 평균 조회 (WITH는 테이블을 만들란 얘기) 
    --  1)
    WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
              AVG_SAL AS (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE)
              
    SELECT *
    FROM SUM_SAL,  AVG_SAL;
    
    --   2)
    WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
              AVG_SAL AS (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE)
    
    SELECT * FROM SUM_SAL
    UNION
    SELECT * FROM AVG_SAL;


