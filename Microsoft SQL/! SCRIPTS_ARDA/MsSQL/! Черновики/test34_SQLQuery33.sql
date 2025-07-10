--SELECT distinct(compgrid2), count(compgrid2) FROM r_Comps group by compgrid2 ORDER BY count(compgrid2) DESC
create table test_trigger (ComdAdd varchar(256), CompGrId2 int)
insert into test_trigger (ComdAdd, CompGrId2) VALUES ('’мельницкого, 12', 2030)
insert into test_trigger (ComdAdd, CompGrId2) VALUES ('’мельницкого, 13', 0)
insert into test_trigger (ComdAdd, CompGrId2) VALUES ('’мельницкого, 15', 100)
insert into test_trigger (ComdAdd) VALUES ('’мельницкого, 14')

SELECT * FROM test_trigger
SELECT * FROM test34
SELECT * FROM test_trigger WHERE CompGrId2 = 2030
update test_trigger set CompGrId2 = 2030 WHERE CompGrId2 = 0
update test_trigger set CompGrId2 = 0 WHERE CompGrId2 = 2030


--alter table test_trigger drop constraint CK_test_trigger check (CompGrID2 > -1)
--alter table r_CompsAdd add constraint CK_test_trigger_comp check (CompGrID2 > -1)
--alter table r_CompsAdd drop constraint CK_test_trigger_comp check (CompGrID2 > -1)

