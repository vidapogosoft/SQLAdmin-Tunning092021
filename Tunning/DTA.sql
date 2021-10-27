
select * from musicallyapp..INV_PRODUCTO
select * from musicallyapp..INV_PROVEEDOR
select * from musicallyapp..Clientes

--substring
--convert
--len
--replicate
--replace

--JOIN = RELACION DIRECTA ENTRE TABLAS POR ELEMENTO COMUN

--ventas
select top 2 SUBSTRING(NumeroFactura,1,3) from musicallyapp..ComprobanteFactura
select top 2 len(NumeroFactura) from musicallyapp..ComprobanteFactura
select top 2 * from musicallyapp..ComprobanteFactura
select top 2 * from musicallyapp..Factura

select top 2 * from musicallyapp..ComprobanteComprobanteRetencion
select top 2 * from musicallyapp..CuentasXPagar

select
comprobante.ClienteIdentificacion as Identificacion,
comprobante.ClienteNombre as Cliente,
SUBSTRING(comprobante.NumeroFactura,1,3) as Establecimiento,
SUBSTRING(comprobante.NumeroFactura,5,3) as PuntoEmision,
SUBSTRING(comprobante.NumeroFactura,9,len(comprobante.NumeroFactura)) as SecuencialComprobante,
CONVERT(date,comprobante.FechaAutorizacion) as FechaAutorizacion,
YEAR(comprobante.FechaAutorizacion) as AnioAutorizacion,
Month(comprobante.FechaAutorizacion) as MesAutorizacion,
comprobante.NumeroFactura as NumeroComprobante,
'VENTAS' as TipoComprobante
from musicallyapp..ComprobanteFactura comprobante
inner join musicallyapp..Factura factura on factura.NumeroFactura = comprobante.NumeroFactura 
union all
--compras
select
comprobante.ClienteIdentificacion as Identificacion,
comprobante.ClienteNombre as Cliente,
SUBSTRING(comprobante.NumeroComprobanteRetencion,1,3) as Establecimiento,
SUBSTRING(comprobante.NumeroComprobanteRetencion,5,3) as PuntoEmision,
SUBSTRING(comprobante.NumeroComprobanteRetencion,9,len(comprobante.NumeroComprobanteRetencion)) as SecuencialComprobante,
CONVERT(date,comprobante.FechaAutorizacion) as FechaAutorizacion,
YEAR(comprobante.FechaAutorizacion) as AnioAutorizacion,
Month(comprobante.FechaAutorizacion) as MesAutorizacion,
comprobante.NumeroComprobanteRetencion as NumeroComprobante,
'COMPRAS' as TipoComprobante
from musicallyapp..ComprobanteComprobanteRetencion comprobante
join  musicallyapp..CuentasXPagar cp on cp.IdCuentasXPagar = comprobante.IdCuentasXPagar


----- Compras

--001-002-000006565
--001001000559

select top 2 * from musicallyapp..ComprobanteComprobanteRetencion
select top 2 * from musicallyapp..CuentasXPagar order by FechaCreacion desc

select top 2 REPLICATE('0',3)+NumeroDocumento from musicallyapp..CuentasXPagar order by FechaCreacion desc

select top 2 REPLACE(NumeroDocumento,'0','*') from musicallyapp..CuentasXPagar order by FechaCreacion desc


select
comprobante.ClienteIdentificacion as Identificacion,
comprobante.ClienteNombre as Cliente,
SUBSTRING(comprobante.NumeroComprobanteRetencion,1,3) as Establecimiento,
SUBSTRING(comprobante.NumeroComprobanteRetencion,5,3) as PuntoEmision,
SUBSTRING(comprobante.NumeroComprobanteRetencion,9,len(comprobante.NumeroComprobanteRetencion)) as SecuencialComprobante,
CONVERT(date,comprobante.FechaAutorizacion) as FechaAutorizacion,
YEAR(comprobante.FechaAutorizacion) as AnioAutorizacion,
Month(comprobante.FechaAutorizacion) as MesAutorizacion,
comprobante.NumeroComprobanteRetencion as NumeroComprobante,
SUBSTRING(replace(cp.NumeroDocumento,'-',''),7,15) + REPLICATE('0',15-len(replace(cp.NumeroDocumento,'-',''))) as NumeroDocumentoRetenido,
'COMPRAS' as TipoComprobante
from musicallyapp..ComprobanteComprobanteRetencion comprobante
join  musicallyapp..CuentasXPagar cp on cp.IdCuentasXPagar = comprobante.IdCuentasXPagar


----
select top 2 * from musicallyapp..ComprobanteFactura
select top 2 * from musicallyapp..Factura
select top 2 * from musicallyapp..FacturaDetalle


select
comprobante.ClienteIdentificacion as Identificacion,
comprobante.ClienteNombre as Cliente,
SUBSTRING(comprobante.NumeroFactura,1,3) as Establecimiento,
SUBSTRING(comprobante.NumeroFactura,5,3) as PuntoEmision,
SUBSTRING(comprobante.NumeroFactura,9,len(comprobante.NumeroFactura)) as SecuencialComprobante,
CONVERT(date,comprobante.FechaAutorizacion) as FechaAutorizacion,
YEAR(comprobante.FechaAutorizacion) as AnioAutorizacion,
Month(comprobante.FechaAutorizacion) as MesAutorizacion,

ROW_NUMBER() over (partition by comprobante.NumeroFactura order by comprobante.FechaEmision ) as SecuencialProducto,

fd.CodigoInterno as CodProducto,
fd.PrecioUnitario as PU,
fd.Cantidad as Cantidad,
fd.Iva as Iva,

comprobante.NumeroFactura as NumeroComprobante,
'VENTAS' as TipoComprobante
from musicallyapp..ComprobanteFactura comprobante
inner join musicallyapp..Factura factura on factura.NumeroFactura = comprobante.NumeroFactura 
inner join musicallyapp..FacturaDetalle fd on fd.IdFactura = factura.IdFactura


-----Importar Datos

--insert into -- values = select

select * from musicallyapp..Clientes

select * from musicallyapp..GEN_PERSONA

select * from musicallyapp..GEN_PERSONA  where CEDULA = '0201008406'

select max(ID_PERSONA) from musicallyapp..GEN_PERSONA  where CEDULA = '0911174787'

select * from musicallyapp..GEN_PERSONA  where CEDULA = '0911174787'

select CEDULA, COUNT(*) from musicallyapp..GEN_PERSONA  
where CEDULA = '0911174787'
group by  CEDULA
HAVING COUNT(*) > 1

select CEDULA, COUNT(*) repetidas from musicallyapp..GEN_PERSONA  
group by  CEDULA
HAVING COUNT(*) > 1


---subagrupacion de consultas

select  a.ID_PERSONA, a.CEDULA, a.NOMBRES_COMPLETO
from musicallyapp..GEN_PERSONA a  
inner join
(
	select CEDULA, COUNT(*) repetidas from musicallyapp..GEN_PERSONA  
	group by  CEDULA
	HAVING COUNT(*) > 1
)sq on sq.CEDULA = a.CEDULA

where a.ID_PERSONA = (
			
			select max(ID_PERSONA) from musicallyapp..GEN_PERSONA b
			where b.CEDULA = a.CEDULA
)
and a.CEDULA = '0201008406'


select a.CEDULA, a.NOMBRES_COMPLETO 
--into musicallyapp..GEN_PERSONA_23
from musicallyapp..GEN_PERSONA a
inner join
(
	select CEDULA, COUNT(*) repetidas from musicallyapp..GEN_PERSONA  
	group by  CEDULA
	HAVING COUNT(*) > 1
)sq on sq.CEDULA = a.CEDULA

where a.ID_PERSONA = (
			
			select max(ID_PERSONA) from musicallyapp..GEN_PERSONA b
			where b.CEDULA = a.CEDULA
)

and  len(a.CEDULA) >= 10 



insert into musicallyapp..Clientes(IdentificacionCliente, NombreCliente)
select a.CEDULA, a.NOMBRES_COMPLETO from musicallyapp..GEN_PERSONA a
inner join
(
	select CEDULA, COUNT(*) repetidas from musicallyapp..GEN_PERSONA  
	group by  CEDULA
	HAVING COUNT(*) > 1
)sq on sq.CEDULA = a.CEDULA

where a.ID_PERSONA = (
			
			select max(ID_PERSONA) from musicallyapp..GEN_PERSONA b
			where b.CEDULA = a.CEDULA
)
and not exists (select 1 from musicallyapp..Clientes b
						   where b.IdentificacionCliente = a.CEDULA)
and  len(a.CEDULA) >= 10 


-----Tablas temporales
---FISICAS

use musicallyapp
go

create table #Temporal1
(
	IdPersona int,
	Identificacion varchar(20),
	Nombres varchar(300)
)

insert into #Temporal1(IdPersona, Identificacion, Nombres)
select a.ID_PERSONA,a.CEDULA, a.NOMBRES_COMPLETO from musicallyapp..GEN_PERSONA a
inner join
(
	select CEDULA, COUNT(*) repetidas from musicallyapp..GEN_PERSONA  
	group by  CEDULA
	HAVING COUNT(*) > 1
)sq on sq.CEDULA = a.CEDULA

where a.ID_PERSONA = (
			
			select max(ID_PERSONA) from musicallyapp..GEN_PERSONA b
			where b.CEDULA = a.CEDULA
)

and  len(a.CEDULA) >= 10 


select * from #Temporal1

--drop table #Temporal1

---MEMORIAS

declare @Temporal1 table
(
	IdPersona int,
	Identificacion varchar(20),
	Nombres varchar(300), Flag char(1)
)

insert into @Temporal1(IdPersona, Identificacion, Nombres, Flag)
select a.ID_PERSONA,a.CEDULA, a.NOMBRES_COMPLETO, null from musicallyapp..GEN_PERSONA a
inner join
(
	select CEDULA, COUNT(*) repetidas from musicallyapp..GEN_PERSONA  
	group by  CEDULA
	HAVING COUNT(*) > 1
)sq on sq.CEDULA = a.CEDULA

where a.ID_PERSONA = (
			
			select max(ID_PERSONA) from musicallyapp..GEN_PERSONA b
			where b.CEDULA = a.CEDULA
)

and  len(a.CEDULA) >= 10 

update @Temporal1 set Flag = 'A'

select * from @Temporal1


------MERGE

/*
with (table_expression_origen)
Merge (table_expression_origen2)
	when match then update
	INSERT
	DELETE
*/

use musicallyapp
go

Create table Productos
(
	ProductId int primary key,
	ProductName varchar(100),
	Price Money
)

Create table ProductosExternos
(
	ProductId int primary key,
	ProductName varchar(100),
	Price Money
)

insert into Productos(ProductId, ProductName, Price)
values(1, 'TV', 1500),
(2, 'TV 4k', 1800),
(3, 'tv LED', 1000),
(4, 'PLAY STATIOn 5', 600)


insert into ProductosExternos(ProductId, ProductName, Price)
values(1, 'TV', 1500),
(2, 'TV 4k', 1800),
(3, 'tv LED', 1000),
(5, 'LAPTOP DELL', 800)


select * from Productos
select * from ProductosExternos

--Aplicando MERGE

MERGE Productos as target
using ProductosExternos as source
on (target.ProductID = source.ProductId)
when matched and target.ProductName <> source.ProductName or target.Price <> source.Price
then update set target.ProductName = source.ProductName, target.Price = source.Price
when not matched by target
then insert (ProductId, ProductName, Price) values (source.ProductId, source.ProductName, source.Price)
when not matched by source
then delete
OUTPUT $Action,
deleted.ProductId as TargetProductId,
deleted.ProductName as TargetProductName,
deleted.Price as TargetPrice,
inserted.ProductId as SourceProductId,
inserted.ProductName as SourceProductName,
inserted.Price as SourcePrice;



select * from Productos
select * from ProductosExternos


----OR EN LA CLAUSULA JOIN O WHERE EN VARIAS COLUMNAS

select
comprobante.ClienteIdentificacion as Identificacion,
comprobante.ClienteNombre as Cliente,
SUBSTRING(comprobante.NumeroFactura,1,3) as Establecimiento,
SUBSTRING(comprobante.NumeroFactura,5,3) as PuntoEmision,
SUBSTRING(comprobante.NumeroFactura,9,len(comprobante.NumeroFactura)) as SecuencialComprobante,
CONVERT(date,comprobante.FechaAutorizacion) as FechaAutorizacion,
YEAR(comprobante.FechaAutorizacion) as AnioAutorizacion,
Month(comprobante.FechaAutorizacion) as MesAutorizacion,
comprobante.NumeroFactura as NumeroComprobante,
'VENTAS' as TipoComprobante
from musicallyapp..ComprobanteFactura comprobante
inner join musicallyapp..Factura factura on factura.NumeroFactura = comprobante.NumeroFactura 
or Factura.IdFactura = comprobante.IdFactura

---
---0908560212



select * from musicallyapp..ComprobanteFactura comprobante 
where ClienteIdentificacion = '0908560212' or NumeroFactura = '001-004-000001948'

--EVITAR BUSQUEDAS COMODIN

select * from musicallyapp..ComprobanteFactura comprobante where ClienteNombre like '%BENG%' 

---ALTERO CONTEO DE TABLAS
SELECT
fROM TABLA
INNER JOIN TABLA1
INNER JOIN TABLA2
INNER JOIN TABLA3
INNER JOIN TABLA4
INNER JOIN TABLA5
INNER JOIN TABLA6

---- *

select
NumeroFactura, ImporteTotal, FechaEmision
from musicallyapp..ComprobanteFactura

