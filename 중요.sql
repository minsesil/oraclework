--올해년도추출
    EXTRACT(YEAR FROM SYSDATE)
-- 주민번호 년도추출
   EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
   
   --그룹별 서브쿼리예
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
                            
  --부서별 많이받는사람
  SELECT DEPT_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE;
                                
 --ROWNUM
 --전 직원중 급여가 가장 높은 상위 5명
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
----------------------------------------------------------------------------------                            
 -- 급여가 상위 5위인 사원의 사원명, 급여, 순위 조회

    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE;
    WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;  오류
    
    -->인라인뷰를 쓸수밖에 없다
    SELECT *
    FROM(SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
         FROM EMPLOYEE)
    WHERE 순위 <= 5;   
    
 ------------------------------------------------------------------------   
--CREAT
--주석달기
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMENT ON COLUMN MEMBER.MEM_NO IS '회원번호'


--테이블을 다 생성한 후에 제약조건 추가
  ALTER TABLE 테이블명 변경할내용;
  - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);

## 테이블을 다 생성한 후에 제약조건 추가  
     ALTER TABLE 테이블명 변경할내용;
  
  - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
  - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)];
  - UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
  - CHECK       : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식);
  - NOT NULL    : ALTER TABLE 테이블명 MODIFY UNIQUE 컬럼명 NOT NULL;
  

-- NVL(컬럼, 해당 컬럼이 NULL일 경우 반환될 값)
SELECT EMP_NAME,NVL(BONUS,0) FROM EMPLOYEE;

--평균
CEIL(AVG(SALARY)) 평균