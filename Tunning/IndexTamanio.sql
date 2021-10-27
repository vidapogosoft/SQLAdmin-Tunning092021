
--Tamaño de los index con filtro

select 
i.name as Indice,
sum(s.used_page_count) * 8 as TamanioKbytes
from sys.dm_db_partition_stats s
inner join sys.indexes i on s.object_id = i.object_id
and s.index_id = i.index_id
where i.name like 'i%'
group by i.name order by 1