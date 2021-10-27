use master
go

alter database musicallyapp add filegroup musicallyapp_Data4


alter database musicallyapp
add file(

	name = musicallyapp4,
	filename = 'E:\SQLdata4\musicallyapp4.ndf' ,
	size = 5MB,
	maxsize = 800MB,
	FILEGROWTH = 700MB
)to filegroup musicallyapp_Data4



----Creo una tabla
use musicallyapp
go

create table RptHistoricoventas
(
	idventas int,
	idusuario int
)on  musicallyapp_Data4 --- Por defecto se van al primary


-----cambio el storage de la tabla
CREATE UNIQUE CLUSTERED INDEX PK_IdDisco
ON Discos(IdDisco)
WITH (DROP_EXISTING=ON,ONLINE=ON) ON musicallyapp_Data4

---CBO_CAB_COMPROBANTE
CREATE UNIQUE CLUSTERED INDEX PK_INV_PROVEEDOR
ON INV_PROVEEDOR(ID_PROVEEDOR)
WITH (DROP_EXISTING=ON,ONLINE=OFF) ON musicallyapp_Data4

