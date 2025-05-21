select 
    standard_hash('1.2!3','SHA512'),
    length(standard_hash('1.2!3','SHA512'))

from dual;

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

