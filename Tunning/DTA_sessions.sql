

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




---recomendations

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_ComprobanteComprobanteRetencion_9_1806629479_0_K23_K7_K6_K3_10] 
ON [dbo].[ComprobanteComprobanteRetencion]
(
	[IdCuentasXPagar] ASC,
	[ClienteIdentificacion] ASC,
	[ClienteNombre] ASC,
	[NumeroComprobanteRetencion] ASC
)
INCLUDE([FechaAutorizacion]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [_dta_ps__1912]([IdCuentasXPagar])



--------------
CREATE STATISTICS [_dta_stat_1806629479_7_6_3] 
ON [dbo].[ComprobanteComprobanteRetencion]
([ClienteIdentificacion], [ClienteNombre], [NumeroComprobanteRetencion])

----
CREATE NONCLUSTERED INDEX [_dta_index_CuentasXPagar_9_1870629707__K1] ON [dbo].[CuentasXPagar]
(
	[IdCuentasXPagar] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

