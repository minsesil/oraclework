--15. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
    SELECT EMP_NAME,SUBSTR(EMP_NO,1,2)||'년'"생년",SUBSTR(EMP_NO,3,2)||'월'"생월",SUBSTR(EMP_NO,5,2)||'일'"생일"FROM EMPLOYEE;
    
--16. EMPLOYEE테이블에서 사원명, 주민번호 조회
--	(단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
    SELECT EMP_NAME"사원명", RPAD(SUBSTR(EMP_NO,1,7),14,'*')"주민번호" FROM EMPLOYEE;
    
--17. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
    SELECT EMP_NAME"사원명",FLOOR(ABS(HIRE_DATE-SYSDATE))"근무일수1" ,FLOOR(ABS(SYSDATE-HIRE_DATE))"근무일수2" FROM EMPLOYEE; 
    
--18. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
    SELECT * FROM EMPLOYEE WHERE SUBSTR(EMP_ID,3,1)IN(1,3,5,7,9);

--19. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
    SELECT * FROM EMPLOYEE WHERE ADD_MONTHS(HIRE_DATE,240);  --왜 에러?

--20. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
    SELECT EMP_NAME"사원명",TO_CHAR(SALARY,'L999,999,999')"급여" FROM EMPLOYEE;

--21. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
   SELECT EMP_NAME"직원명",DEPT_CODE"부서코드"
   ,SUBSTR(EMP_NO,1,2)||'년' || SUBSTR(EMP_NO,3,2)||'월' || SUBSTR(EMP_NO,5,2)||'일' "생년원일"
   ,TO_NUMBER(TO_CHAR(SYSDATE,'RRRR'))-(1900+TO_NUMBER(SUBSTR(EMP_NO,1,2)))"나이" FROM EMPLOYEE;
   
    SELECT EMP_NAME"직원명",DEPT_CODE"부서코드"
   ,SUBSTR(EMP_NO,1,2)||'년' || SUBSTR(EMP_NO,3,2)||'월' || SUBSTR(EMP_NO,5,2)||'일' "생년원일"
   ,EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RRRR'))"나이" FROM EMPLOYEE;

   
--23. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
    SELECT EMP_NAME"사원명",SUBSTR(EMP_NO,1,6)"주민번호앞자리"
    ,SUBSTR(EMP_NO,8,14)"주민번호뒷자리"
    ,SUBSTR(EMP_NO,1,6)+SUBSTR(EMP_NO,8,14)"주민번호앞자리+뒷자리" FROM EMPLOYEE;
    
--24. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
    SELECT SUM(SALARY*NVL(BONUS,0)+SALARY) "D5사원 보너스포함한 연봉합계" FROM EMPLOYEE WHERE DEPT_CODE='D5';
    
--25. 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--전체 직원수 ,2001년, 2002년, 2003년, 2004년
 SELECT COUNT(*)"전체직원수"
    .COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2001',1))"2001년"
    .COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2002',1))"2001년"
    .COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2003',1))"2003년"
    .COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),'2004',1))"2004년"
 FROM EMPLOYEE;   
 
 SELECT COUNT(*)"전체직원수"
                ,COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE)='2001' THEN 1 END)"2001년"
                ,COUNT(CASE WHEN TO_CHAR(HIRE_DATE,'YYYY')='2002' THEN 1 END)"2002년"  --방법2
                ,COUNT(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),'2003',1))"2003년"  --방법2
                ,COUNT(DECODE(EXTRACT(YEAR FROMM HIRE_DATE),'2004',1))"2004년"
 FROM EMPLOYEE;
 
 ---------------------------------------------------------------------------------------------------------------
 --9. 학번이 A517178인 한아름 학생의 학점 총 평점 (화면 헤더는 "평점", 점수는 반올림하여 소수점 이하 한자리만 표시)
    SELECT POINT FROM TB_GRADE WHERE STUDENT_NO='A517178';
    SELECT ROUND(SUM(POINT))"평점" FROM TB_GRADE WHERE STUDENT_NO='A517178';
    
 --13. 학과별 휴학생 수를 파악 학과번호와 휴학생 수를 표시
    SELECT DEPARTMENT_NO"학과번호",COUNT(ABSENCE_YN)"휴학생수"
    FROM TB_STUDENT
    GROUP BY DEPARTMENT_NO;
    
 --14. 춘 대학교에 다니는 동명이인 학생들의 이름찾기
    SELECT STUDENT_NAME "동명이인"
    FROM TB_STUDENT
    GROUP BY STUDENT_NAME
    HAVING COUNT(STUDENT_NAME) > 2;
    
    
 --15. 학번이 A112113인 김고운 학생의 년도,학기별 평점과 년도별 누적평점, 총평점   
    SELECT * FROM TB_GRADE WHERE STUDENT_NO='A112113';
    
    SELECT TERM_NO,COUNT(TERM_NO)"학기별평점",COUNT(POINT)"평점"
    FROM TB_GRADE 
    GROUP BY TERM_NO,POINT;
    HAVING STUDENT_NO = 'A112113';
    