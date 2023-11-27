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
--선생님
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE
                                          FROM EMPLOYEE
                                       WHERE EMP_NAME = '하정연');
    
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
    SELECT EMP_NAME, JOB_NAME, SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE NVL(BONUS,0)=0
        AND JOB_CODE IN ('J4','J7');
        
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회   
    SELECT ENT_YN, COUNT(*)
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


