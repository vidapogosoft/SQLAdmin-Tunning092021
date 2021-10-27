
CREATE TABLE TestTable_1
(ID INT IDENTITY(1,1), Name VARCHAR(20))
GO
 
CREATE TABLE TestTable_2
(ID INT IDENTITY(1,1), Name VARCHAR(20))
GO
 
INSERT INTO TestTable_1(Name) VALUES ('Victor')
Go 100
 
INSERT INTO TestTable_2(Name) VALUES ('Portugal')
Go 100


select * from TestTable_1
select * from TestTable_2

DBCC traceon(1222,-1)


DBCC traceoff(1222,-1)

sp_who2



BEGIN TRAN
UPDATE TestTable_2 SET Name = 'Daniel' WHERE ID=10
UPDATE TestTable_1 SET Name = 'Victor' WHERE ID=10

---en otra ventana de SQL corremos este script
UPDATE TestTable_1 SET Name = 'Victor' WHERE ID=10


---en otra ventana de SQL corremos este script
UPDATE TestTable_2 SET Name = 'Portugal' WHERE ID=10
