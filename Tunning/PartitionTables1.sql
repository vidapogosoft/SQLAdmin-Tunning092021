USE [musicallyapp]
GO
BEGIN TRANSACTION
CREATE PARTITION FUNCTION [FuncionFechaEmisionPartition](datetime) AS RANGE LEFT FOR VALUES (N'2018-07-01T00:00:00', N'2019-07-01T00:00:00', N'2020-07-01T00:00:00')


CREATE PARTITION SCHEME [EsquemaFechaEmisionPartition] AS PARTITION [FuncionFechaEmisionPartition] TO ([PRIMARY], [PRIMARY], [musicallyapp_data_2], [PRIMARY])






ALTER TABLE [dbo].[Factura] DROP CONSTRAINT [pkFactura] WITH ( ONLINE = OFF )


ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [pkFactura] PRIMARY KEY NONCLUSTERED 
(
	[IdFactura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


CREATE CLUSTERED INDEX [ClusteredIndex_on_EsquemaFechaEmisionPartition_637304432220834075] ON [dbo].[Factura]
(
	[FechaEmision]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [EsquemaFechaEmisionPartition]([FechaEmision])


DROP INDEX [ClusteredIndex_on_EsquemaFechaEmisionPartition_637304432220834075] ON [dbo].[Factura]








COMMIT TRANSACTION


