-- 게시판 DB
CREATE TABLE board_member (
	id	varchar2(50)		NOT NULL,
	passwd	char(128)		NOT NULL,
	username	varchar2(50)		NOT NULL,
	nickname	varchar2(50)		NOT NULL
);

CREATE TABLE board_comment (
	cno	number		NOT NULL,
	id	varchar2(50)		NOT NULL,
	bno	number		NOT NULL,
	content	varchar2(1000)		NOT NULL,
	cdate	date	DEFAULT sysdate	NOT NULL
);

CREATE TABLE board (
	bno	number		NOT NULL,
	id	varchar2(50)		NOT NULL,
	title	varchar2(150)		NOT NULL,
	content	clob		NOT NULL,
	write_date	date	DEFAULT sysdate	NOT NULL,
	bcount	number	DEFAULT 0	NULL,
	write_update_date	date	DEFAULT sysdate	NOT NULL
);

CREATE TABLE board_content_like (
	id	varchar2(50)		NOT NULL,
	bno	number		NOT NULL
);

CREATE TABLE board_content_hate (
	id	varchar2(50)		NOT NULL,
	bno	number		NOT NULL
);

CREATE TABLE board_comment_like (
	id	varchar2(50)		NOT NULL,
	cno	number		NOT NULL
);

CREATE TABLE board_comment_hate (
	id	varchar2(50)		NOT NULL,
	cno	number		NOT NULL
);

ALTER TABLE board_member ADD CONSTRAINT PK_BOARD_MEMBER PRIMARY KEY (
	id
);

ALTER TABLE board_comment ADD CONSTRAINT PK_BOARD_COMMENT PRIMARY KEY (
	cno
);

ALTER TABLE board ADD CONSTRAINT PK_BOARD PRIMARY KEY (
	bno
);

ALTER TABLE board_content_like ADD CONSTRAINT PK_BOARD_CONTENT_LIKE PRIMARY KEY (
	id,
	bno
);

ALTER TABLE board_content_hate ADD CONSTRAINT PK_BOARD_CONTENT_HATE PRIMARY KEY (
	id,
	bno
);

ALTER TABLE board_comment_like ADD CONSTRAINT PK_BOARD_COMMENT_LIKE PRIMARY KEY (
	id,
	cno
);

ALTER TABLE board_comment_hate ADD CONSTRAINT PK_BOARD_COMMENT_HATE PRIMARY KEY (
	id,
	cno
);

ALTER TABLE board_comment ADD CONSTRAINT FK_BC_ID FOREIGN KEY (
	id
)
REFERENCES board_member (
	id
);

ALTER TABLE board_comment ADD CONSTRAINT FK_BC_BNO FOREIGN KEY (
	bno
)
REFERENCES board (
	bno
);

ALTER TABLE board ADD CONSTRAINT FK_B_ID FOREIGN KEY (
	id
)
REFERENCES board_member (
	id
);

ALTER TABLE board_content_like ADD CONSTRAINT FK_BCL_ID FOREIGN KEY (
	id
)
REFERENCES board_member (
	id
);

ALTER TABLE board_content_like ADD CONSTRAINT FK_BCL_BNO FOREIGN KEY (
	bno
)
REFERENCES board (
	bno
);

ALTER TABLE board_content_hate ADD CONSTRAINT FK_BCH_ID FOREIGN KEY (
	id
)
REFERENCES board_member (
	id
);

ALTER TABLE board_content_hate ADD CONSTRAINT FK_BCH_BNO FOREIGN KEY (
	bno
)
REFERENCES board (
	bno
);

ALTER TABLE board_comment_like ADD CONSTRAINT FK_BCML_ID FOREIGN KEY (
	id
)
REFERENCES board_member (
	id
);

ALTER TABLE board_comment_like ADD CONSTRAINT FK_BCML_CNO FOREIGN KEY (
	cno
)
REFERENCES board_comment (
	cno
);

ALTER TABLE board_comment_hate ADD CONSTRAINT FK_BCMH_ID FOREIGN KEY (
	id
)
REFERENCES board_member (
	id
);

ALTER TABLE board_comment_hate ADD CONSTRAINT FK_BCMH_CNO FOREIGN KEY (
	cno
)
REFERENCES board_comment (
	cno
);

---------------
alter table board drop column content;
alter table board add content clob;
delete from board_member;
-----------------------------------------
--3. 시퀸스 생성
--글번호 1001~
create sequence seq_board_bno
start with 1001;
--댓글번호 3001~
create sequence seq_board_comment_cno
start with 3001;

select 
    standard_hash('1.2!3','SHA512'),
    length(standard_hash('1.2!3','SHA512'))
from dual;

-- 회원 정보 1건 저장하는 insert문 작성
insert into board_member 
values('aa1100',standard_hash('123456','SHA512'),'김천수','주먹감자');

select * from board_member where id = 'aa1100';

-- 전체 게시글 조회
-- 글번호, 제목, 작성자ID, 작성자 닉네임, 조회수, 작성일, 글내용
select b.bno, b.title, b.id, bm.nickname, b.bcount, b.write_date, b.content
from board b inner join board_member bm on b.id = bm.id;
-- 글번호, 제목, 작성자ID, 작성자 닉네임, 조회수, 작성일, 글내용, 좋아요, 싫어요
-- 글번호별 좋아요 개수 조회
select bno, count(*) as blike_count
from board_content_like
group by bno;
-- 글번호별 싫어요 개수 조회
select bno, count(*) as bhate_count
from board_content_hate
group by bno;

with bcl_count as (
    select bno, count(*) as blike_count 
from board_content_like group by bno
), bch_count as (
    select bno, count(*) as bhate_count
from board_content_hate group by bno
)
select b.bno, b.title, b.id, bm.nickname, b.bcount, 
    b.write_date, b.content, 
    nvl(bcl.blike_count,0) as blike, nvl(bch.bhate_count,0) as bhate
from board b inner join board_member bm on b.id = bm.id
left outer join (select * from bcl_count) bcl on b.bno = bcl.bno
left outer join (select * from bch_count) bch on b.bno = bch.bno;






