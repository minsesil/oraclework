--1.학생이름과 주소지를 표시하시오. 단,출력 헤더는 "학생이름","주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
SELECT STUDENT_NAME 학생이름, STUDENT_ADDRESS 주소지 FROM TB_STUDENT;
-----------------------------------------------------------------------------------------------
--2.휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT STUDENT_NAME, STUDENT_SSN FROM TB_STUDENT WHERE ABSENCE_YN='Y' ORDER BY STUDENT_SSN DESC;
-----------------------------------------------------------------------------------------------
--3.주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 
--이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번","거주지주소"가 출력되도록 한다.
SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS 거주지주소, STUDENT_SSN
FROM TB_STUDENT
WHERE (STUDENT_ADDRESS LIKE '강원%' OR STUDENT_ADDRESS LIKE '경기%')
AND SUBSTR(STUDENT_NO,1,2) BETWEEN '90' AND '99'
ORDER BY STUDENT_NAME ASC;
-----------------------------------------------------------------------------------------------
--4.현재 법학과 교수중 가장 나이가 많은 사람부터 이름을 확인할수 있는 SQL문장을 작성하시요.
--(법학과의 '학과코드'는 학과테이블(TB_DEPARTMENT)을 조회해서 찾아내도록 하자)
SELECT PROFESSOR_NAME, PROFESSOR_SSN 
FROM TB_DEPARTMENT JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY PROFESSOR_SSN ASC;
-----------------------------------------------------------------------------------------------
--5.2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
--학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
SELECT STUDENT_NO, TO_CHAR(POINT,99.99) POINT
FROM TB_STUDENT JOIN TB_GRADE USING(STUDENT_NO)
WHERE CLASS_NO = 'C3118100' AND SUBSTR(TERM_NO,1,6) LIKE '200402%'
ORDER BY POINT DESC, STUDENT_NO DESC;
-----------------------------------------------------------------------------------------------
--6.학생번호,학생이름,학과이름을 학생이름으로 오름차순 정렬하여 출력하는 SQL문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME ASC;
-----------------------------------------------------------------------------------------------
--7.춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);
-----------------------------------------------------------------------------------------------
--8.과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL문을 작성하시오.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS JOIN TB_CLASS_PROFESSOR USING(CLASS_NO) JOIN TB_PROFESSOR USING(PROFESSOR_NO);
-->화면과 출력다름? 로우갯수는맞음
-----------------------------------------------------------------------------------------------
--9.8번의 결과중 '인문사회'계열에 속한 교수이름을 찾으려고한다.이에 해당하는 과목이름과 교수이름을 출력하는 SQL문을 작성하시오.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO) 
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO=D.DEPARTMENT_NO)
WHERE CATEGORY = '인문사회';
-->화면과 출력다름? 로우갯수는맞음
-----------------------------------------------------------------------------------------------
--10.음악학과 학생들의 평균을 구하려고 한다.음악학과 학생들의 "학번","학생이름","전체평점"을 출력하는 SQL문을 작성하시오.
--(단 평점은 소수점 1자리까지만 반올림하여 표시한다.) 
SELECT STUDENT_NO, STUDENT_NAME, ROUND(AVG(POINT), 1)"전체평점"
FROM TB_DEPARTMENT 
JOIN TB_STUDENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;
-----------------------------------------------------------------------------------------------
--11.학번이 A313047인 학생이 학교에 나오고 있지 않다.지도 교수에게 내용을 전달하기 위한
--학과이름,학생이름과 지도교수 이름이 필요하다. 이때 사용할 SQL문을 작성하시오.
--단,출력헤더는 "학과이름","학생이름","지도교수이름"으로 출력되도록 한다.
SELECT DEPARTMENT_NAME 학과이름, STUDENT_NAME 학생이름, PROFESSOR_NAME 지도교수이름
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';
-----------------------------------------------------------------------------------------------
--12.2007년도에 '인간관계론'과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL문장을 작성하시오.
SELECT STUDENT_NAME, TERM_NO, CLASS_NAME
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE CLASS_NAME = '인간관계론' AND SUBSTR(TERM_NO,1,4) LIKE '2007%'
ORDER BY STUDENT_NAME;
-----------------------------------------------------------------------------------------------
--13.
--선생님
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)                              --널값도 가져오게
WHERE CATEGORY = '예체능' 
AND PROFESSOR_NO IS NULL;
-----------------------------------------------------------------------------------------------
--14.춘기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과 지도교수 이름을 찾고 만일 지도교수가 없는 학생일 경우
--"지도교수미지정"으로 표시하도록 하는 SQL문을 작성하시오.단,출력헤더는 "학생이름","지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME,'지도교수미지정')"지도교수", ENTRANCE_DATE
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY ENTRANCE_DATE ASC;
-->널값 안나옴
----차이?-------------------------------------------------------------------------------------------
SELECT
        STUDENT_NAME 학생이름
    ,   NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
    FROM TB_STUDENT S
    LEFT JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO = PROFESSOR_NO)
    JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '서반아어학과'
    ORDER BY S.ENTRANCE_DATE;
-----------------------------------------------------------------------------------------------
--15.휴학생이 아닌 학생중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번,이름,학과이름,평점을 출력하는 SQL 문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME, ROUND(AVG(POINT),8)
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN='N'                    --?
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING ROUND(AVG(POINT),8) >= 4.0       --?
ORDER BY STUDENT_NO;
-----------------------------------------------------------------------------------------------
--16.환경조경학과 전공과목들의 과목별 평점을 파악할수 있는 SQL문을 작성하시오.
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO) 
WHERE DEPARTMENT_NAME = '환경조경학과' AND CLASS_TYPE='전공선택'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY CLASS_NO;

-----------------------------------------------------------------------------------------------
--17.춘기술대학교에 다니고있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL문을 작성하시오.
SELECT STUDENT_NAME, STUDENT_ADDRESS, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = (SELECT DEPARTMENT_NAME 
                         FROM TB_STUDENT 
                         JOIN TB_DEPARTMENT USING(DEPARTMENT_NO) 
                         WHERE STUDENT_NAME = '최경희');
-----------------------------------------------------------------------------------------------
--18.국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오
SELECT ROWNUM, STUDENT_NO, STUDENT_NAME, RANK(POINT)
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NO = 001
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY RANK(POINT);

SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME='국어국문학과';
-----------------------------------------------------------------------------------------------
--19.
--선생님 
SELECT DEPARTMENT_NAME 계열학과명, ROUND(AVG(POINT),1) 전공평점
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE CATEGORY = (SELECT CATEGORY
                  FROM TB_DEPARTMENT
                  WHERE DEPARTMENT_NAME='환경조경학과')
GROUP BY DEPARTMENT_NAME;




