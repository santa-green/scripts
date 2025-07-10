--drop table t
CREATE TABLE T
(
B1 BIT NOT NULL default 1,
B2 BIT NOT NULL default 1,
CHECK (B1 = 1 OR B2 =1)
)
alter table t add B3 nvarchar(20) NOT NULL
alter table t alter column B3 int
alter table t add constraint ck_b3_null check (b3 is not null)
SELECT * FROM t
--update t set b3 = 1 WHERE b3 is not null

insert into t values (1,0)
insert into t values (1,1)
insert into t values (0,0)
insert into t (b3) values ('f')
insert into t (b3) values ('פûגא')
insert into t (b3) values (23432423432)
insert into t (b3) values (0)

alter table t add constraint cn_1 check (B3 between 1 and 100)
alter table t drop constraint cn_1
alter table t drop constraint ck_b3_null
