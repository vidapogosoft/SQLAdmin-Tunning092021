
---DDL triggers
---eston enfocados a DATA DEFINITION LENGUAGE

----CREATE - DROP - ALTER DATABASE
---ALL SERVER
---ALL SQUEMAS

---SINTAXIS
/*
Create trigger Nombre
on database
for 
create_table, alter_table, drop_table
AS
BEGIN
	--CUERPO DE INSTRUCCIONES
END
*/


---BASE DE DATOS
use master
go

create trigger AuditCreateDB
on ALL SERVER
for create_database
as
begin
	print 'Database created'

	select EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','varchar(max)')

end
go

use musicallyapp
go

create trigger SafetyDB
on database
for create_table
as
begin
	print 'Create table'

	select EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','varchar(max)')

	raiserror('PROHIBIDO CREAR TABLAS',16,1)

	rollback

end
go

create trigger SafetyAlterDB
on database
for alter_table
as
begin
	print 'Alter table'

	select EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','varchar(max)')

	--raiserror('PROHIBIDO CREAR TABLAS',16,1)

	--rollback

end

Create table Test1
(
secuencial int,
descripcion varchar(10)
)


alter table Clientes add ColumTest varchar(1)
go

use master
go

create database Testvpr2






