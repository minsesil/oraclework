-- 1.3 의 권한부여전에는 실행하면 오류. 권한부여 후에는 생성 가능
CREATE TABLE TEST (
    ID VARCHAR2(30),
    NAME VARCHAR2(20)
);

-- 1.4 의 권한 부여 전과 후 비교
INSERT INTO TEST VALUES('user01', '홍길동');

--------------------------------------------------------
-- 2.1 의 권한 부여 전과 후 비교
SELECT * FROM AIE.EMPLOYEE;

-- 2.2 권한 부여 후
INSERT INTO AIE.DEPARTMENT VALUES('D0', '관리부', 'L2');

SELECT * FROM AIE.DEPARTMENT;
COMMIT;