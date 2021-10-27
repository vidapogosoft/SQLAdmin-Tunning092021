
---Planes de mantenimiento


select FechaEmision,* from musicallyapp..Factura where NumeroIdentificacion = '0104300850'

select NumeroIdentificacion from musicallyapp..Factura where NumeroIdentificacion = '0104300850'

select NumeroIdentificacion,FechaEmision from musicallyapp..Factura where NumeroIdentificacion = '0104300850' 
and FechaEmision >= '2020-01-01 00:00:00.000'

select NumeroIdentificacion from musicallyapp..Factura where NumeroIdentificacion = '0104300850'

select NumeroIdentificacion from musicallyapp..Factura where NumeroIdentificacion = '1205561135'

select NumeroIdentificacion, FechaEmision from musicallyapp..Factura where NumeroIdentificacion = '0104300850' 
and FechaEmision >= '2020-01-01 00:00:00.000'

---Create index

Create nonclustered index iNumeroIdentificacion
on Factura (Numeroidentificacion)

--Index con campos incluidos (include)

create nonclustered index iNumeroIdentificacion2
on Factura (Numeroidentificacion) INCLUDE(FechaEmision)


create nonclustered index iNumeroIdentificacion3
on Factura (Numeroidentificacion,FechaEmision)


--inideces filtrados (condicional)
create nonclustered index iNumeroIdentificacion4
on Factura (Numeroidentificacion,FechaEmision) where Numeroidentificacion = '0104300850' 


