--1.job테이블에 직급몀만 조회
select job_name from job;

--2.DEPARTMENT 테이블의 모든 컬럼 조회
select *from department;

--3. DEPARTMENT 테이블의 부서코드, 부서명만 조회
select dept_title,location_id from department;

--4. EMPLOYEE테이블에 사원명,이메일,전화번호,입사일,급여조회
select emp_name,email,phone,hire_date,l from employee;