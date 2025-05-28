#관리자 계정으로 진행 - root
#DB 생성
create database student DEFAULT CHARACTER SET utf8mb4 collate utf8mb4_general_ci;
drop database student;
#DB 문자코드 변경
ALTER DATABASE 디비명 DEFAULT CHARACTER SET utf8mb4 collate utf8mb4_general_ci;

#계정 생성 방법
create user 'nam2626'@'%' identified by '123456';
#모든 권한 부여
grant all privileges on nam2626.* to 'nam2626'@'%';
#권한 회수 방법
revoke all privileges on nam2626.* from 'nam2626'@'%';

#데이터 베이스 목록 확인
show databases;

#데이터 베이스 선택
use nam2626;

#데이터 타입
#숫자 : INT,BIGINT, DECIMAL, FLOAT, DOUBLE
#문자열 : CHAR, VARCHAR, TEXT, BLOB
#날짜 : DATE, TIME, TIMESTAMP

#학생 테이블
#학번 이름 학과번호 평점
create table student(
	std_no char(8) primary key,
	std_name varchar(30),
	major_no decimal(2) default 0,
	std_score float(3,2)
);
#학과 테이블
#학과번호 학과명
create table major(
	major_no decimal(2) primary key,
	major_name varchar(50) not null
);
#과목 테이블
#과목번호, 과목명, 교수번호, 최대수강인원수
create table subject(
	subject_no decimal(2) primary key,
	subject_name varchar(50) not null,
	professor_no char(8) not null,
	total_count int(3) default 0
);
#교수 테이블
create table professor(
	professor_no char(8) primary key,
	professor_name varchar(30) not null,
	major_no decimal(2) default 0
);
#수강 테이블
create table subject_sugang(
	su_no int auto_increment primary key,
	student_no char(8) not null,
	subject_no decimal(2) not null,
	add_time timestamp default current_timestamp
);
#학생 테이블에 학과번호를 외래키로 지정, 학과 테이블에 있는 학과번호를 참조
alter table student add constraint sdt_fk_majro_no
foreign key(major_no) references major(major_no) on update cascade;
#과목 테이블에서 교수번호를 외래키로 지정, 교수 테이블에 있는 교수번호를 참조
alter table subject add constraint subject_fk_professor_no
foreign key(professor_no) 
references professor(professor_no) on delete cascade on update cascade;
#교수 테이블에서 학과번호를 외래키로 지정, 학과 테이블에 있는 학과번호를 참조
alter table professor add constraint professor_fk_major_no
foreign key(major_no) references major(major_no);
#수강 테이블에서 학생번호,과목번호를 외래키로 지정, 
#학생 테이블에 있는 학생번호를 참조, 과목 테이블에 있는 과목번호를 참조
alter table subject_sugang add constraint sugang_fk_std_no
foreign key(student_no) references student(std_no)
on delete cascade on update cascade;
alter table subject_sugang add constraint sugang_fk_subject_no
foreign key(subject_no) references subject(subject_no)
on delete cascade on update cascade;

#학생테이블의 평점은 0.0~4.5로 제약조건 추가
alter table student add constraint std_check_score 
check(std_score between 0.0 and 4.5);
#과목테이블의 총수강인원은 0 이상 입력되게끔 제약조건을 추가
alter table subject add constraint subject_check_total_count
check(total_count >= 0);

#각 테이블에 데이터 5건씩 추가하는 insert문 작성
insert into major values(1,'컴퓨터공학과');
insert into major values(2,'경영학과');
insert into major values(3,'경제학과');
insert into major values(4,'생명공학과');
insert into major values(5,'생활체육학과');

insert into student values('20201111','홍길동',3,2.4);
insert into student values('20202222','김철수',1,3.4);
insert into student values('20203333','황보원',4,4.4);
insert into student values('20204444','이인수',5,1.5);
insert into student values('20205555','박철수',2,3.6);

insert into professor values('20101111','김교수', 1);
insert into professor values('20102222','이교수', 2);
insert into professor values('20103333','박교수', 3);
insert into professor values('20104444','천교수', 4);
insert into professor values('20105555','황교수', 5);

insert into subject values(1,'대학수학','20101111',30);
insert into subject values(2,'해부학','20102222',22);
insert into subject values(3,'미시경제학','20103333',30);
insert into subject values(4,'운동학개론','20104444',10);
insert into subject values(5,'경영학개론','20105555',50);

insert into subject_sugang(student_no, subject_no) values('20201111', 1);
insert into subject_sugang(student_no, subject_no) values('20202222', 1);
insert into subject_sugang(student_no, subject_no) values('20203333', 1);
insert into subject_sugang(student_no, subject_no) values('20201111', 2);
insert into subject_sugang(student_no, subject_no) values('20201111', 3);

#테이블 삭제
drop table student;
drop table subject;
drop table major;
drop table professor;
drop table subject_sugang;

#학생 평점이 3.0 ~ 3.5인 학생만 조회
select * from student where std_score between 3.0 and 3.5;
#학생 이름 중 김씨, 이씨 성인 학생만 조회
select * from student 
where std_name like '김%' or std_name like '이%';
#학과번호가 1, 3, 5, 7, 9인 학생만 조회
select * from student where major_no in(1,3,5,7,9); 

#학생정보 출력시 학생 이름, 학생 이름의 글자 개수만 조회
select std_name, length(std_name) / 3 as std_name_length from student;
#학생정보 출력시 학번, 이름 학번은 뒤에 4자리만 조회, 앞에 4자리는 *로 마스킹
select concat('****', right(std_no,4)), std_name  from student;

#학생이름이 4글자인 학생만 조회
select * from student where length(std_name) / 3 = 4; 
select * from student where std_name like '____'; 
#학과번호가 짝수인 학생만 조회
select * from student where mod(major_no,2) = 0;
select * from student where major_no % 2 = 0;
#수강 테이블에서 수강신청 날짜가 11월 15일~11월 20일까지의 수강신청 데이터를 조회
select * from subject_sugang where
add_time between str_to_date('2023-11-15','%Y-%m-%d') and str_to_date('2023-11-30','%Y-%m-%d');  
select * from subject_sugang where
add_time between '2023-11-15' and '2023-11-30';  

-- 학과별 평점 총합을 조회
select major_no, avg(std_score) from student
group by major_no ;
-- 학과별 평점의 평균을 조회, 소수점은 둘째 자리까지만, 컬럼명을 AVG_SCORE로 변경해서 조회
select major_no, truncate(avg(std_score),2) as avg_score from student
group by major_no ;
-- 학과별 인원수를 조회
select major_no, count(*) from student
group by major_no ;
-- 학과별 평점의 최대값/최소값 조회
select major_no, max(std_score), min(std_score) from student
group by major_no ;
-- 전체 인원을 대상으로 평점, 인원수, 최대값, 최소값
select count(*), max(std_score), min(std_score) from student;
-- 학과별 인원수를 조회, 단 평점이 3.0 이상인 학생들만 대상으로 인원수를 조회
select major_no, count(*) from student
where std_score  >= 3.0;
group by major_no ;
-- 학과별 평점을 조회. 단, 학과인원수가 3명이상인 학과만 대상으로 조회
select major_no, avg(std_score) from student
group by major_no having count(*) >= 3;
-- 학번별 인원수, 평점의 평균을 조회
select substr(std_no,1,4), avg(std_score),count(*) from student
group by substr(std_no,1,4); 
-- 학번-학과별 인원수 조회
select substr(std_no,1,4), major_no ,count(*) from student
group by substr(std_no,1,4), major_no ; 

-- 학번, 이름, 학과명, 평점
select s.std_no, s.std_name, m.major_name, s.std_score 
from student s join major m ON s.major_no = m.major_no;
-- 교수번호, 교수명, 학과명
select p.professor_no, p.professor_name, m.major_name
from professor p
join major m on p.major_no = m.major_no;
-- 과목번호, 과목명, 교수명, 수강가능한 총 인원수
select s.subject_no, s.subject_name, 
p.professor_name, s.total_count 
from subject s 
join professor p on s.professor_no = p.professor_no; 
-- 수강번호, 학생이름, 과목명, 수강신청 시간, 담당교수
select ss.su_no, s.std_name, 
sj.subject_name, ss.add_time, p.professor_name 
from subject_sugang ss 
join student s on ss.student_no = s.std_no 
join subject sj on ss.subject_no = sj.subject_no
join professor p on p.professor_no = sj.professor_no;
-- 수강신청을 하지 않은 학생들을 조회
-- 학번, 이름, 학과명, 평점
select s.std_no, s.std_name, 
m.major_name, s.std_score
from subject_sugang ss 
right outer join student s on ss.student_no = s.std_no 
join major m on s.major_no = m.major_no
where ss.su_no is null;

-- 학과별 인원수, 평점의 평균, 최고 평점, 최저 평점을 조회
select m.major_name, count(*), avg(s.std_score), 
max(s.std_score), min(s.std_score) 
from student s join major m on s.major_no = m.major_no
group by m.major_name;


-- 수강신청을 한 학생들을 기준으로 학과별, 과목별, 인원수를 조회
select m.major_name, sj.subject_name, count(*)
from student s join subject_sugang ss 
on s.std_no = ss.student_no
join major m on m.major_no = s.major_no 
join subject sj on ss.subject_no = sj.subject_no
group by m.major_name, sj.subject_name; 

-- 과목을 담당하지 않는 교수들을 조회
-- 교수번호, 교수명
select p.professor_no, p.professor_name  
from professor p 
left outer join subject s on p.professor_no = s.professor_no 
where s.subject_no is null;

-- 수강신청 안한 학생들 중 학과별로 몇명인지 조회
select m.major_name, count(*)
from subject_sugang ss right outer join student s
on ss.student_no = s.std_no
join major m on s.major_no = m.major_no
where ss.student_no is null
group by m.major_name;

-- SUB QUERY
-- 학생 정보 조회
-- 학번 이름 학과명 평점
select s.std_no, s.std_name, s.std_score,
(select m.major_name from major m where s.major_no = m.major_no)
from student s ;

-- 수강신청을 안한 학생 목록을 출력
select * from student
where std_no not in(select student_no from subject_sugang);

-- 학과별 최고점을 받은 평점을 받은 학생을 조회
select major_no, max(std_score) 
from student
group by major_no;

select s.std_no, s.std_name, s.std_score, m.major_name
from student s join major m on s.major_no = m.major_no
where (s.major_no, s.std_score) in(
select major_no, max(std_score) 
from student group by major_no);

---------------------------------------
--postgreSQL
---------------------------------------
CREATE USER scott PASSWORD 'tiger' SUPERUSER;
CREATE DATABASE SCOTT_DB WITH OWNER SCOTT ENCODING 'UTF8';

GRANT ALL PRIVILEGES ON DATABASE scott_db TO scott;

create table student(
	std_no char(8) primary key,
	std_name varchar(30),
	major_no decimal(2) default 0,
	std_score float
);

insert into student values('20201111','홍길동',3,2.4);
insert into student values('20202222','김철수',1,3.4);
insert into student values('20203333','황보원',4,4.4);
insert into student values('20204444','이인수',5,1.5);
insert into student values('20205555','박철수',2,3.6);

select * from student;























