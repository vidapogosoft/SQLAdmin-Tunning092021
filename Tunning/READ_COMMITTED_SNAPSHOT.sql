USE master 
 GO 
  
Create database TestDB 
 GO  
  
USE TestDB 
GO 
  
CREATE TABLE TestTable 
 (  
ID INT ,  
Val CHAR ( 1 ) 
)  
 
  
insert into TestTable ( ID , Val ) values ( 1 , 'A' ), ( 2 , 'B' ), ( 3 , 'C' )  



ALTER DATABASE TestDB SET READ_COMMITTED_SNAPSHOT ON  

--2.1 USE TestDB 
 GO
   
  
begin tran
  
  update TestTable SET Val = 'X' where Val = 'A' 
   
  waitfor delay '00:00:15' 
  
commit tran 


--2.2 USE TestDB 
---en otra consulta de sql
  
select * from TestTable

go

