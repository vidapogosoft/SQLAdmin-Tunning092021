

select * from musicallyapp..ComprobanteFactura
select * from musicallyapp..Clientes

select * from musicallyapp..Clientes where IdCliente = 11006

--update musicallyapp..Clientes 
--set NombreCliente = 'VPR - AUDIT'
--where IdCliente = 11006

select * from fn_get_audit_file ('E:\Audit-*.sqlaudit', default, default)


