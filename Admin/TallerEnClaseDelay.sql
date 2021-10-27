
select * from musicallyapp..Factura


USE master
GO
EXEC dbo.usp_FindErrorsInDefTrace
GO	


use AdventureWorks2014
go
declare @x integer
set @x=1
while (@x < 10)
begin 
   select * from [Person].[Person]
   select * from [Production].[Product]
   select * from [Sales].[SalesOrderHeader] H inner join [Sales].[SalesOrderDetail] D
    on H.SalesOrderID=D.SalesOrderID
   alter index [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] on [Sales].[SalesOrderDetail] REBUILD
   alter index [PK_Person_BusinessEntityID] on [Person].[Person] REBUILD
   waitfor delay '00:00:05'
   set @x=@x+1
end


select * FROM sys.traces


