
---DBCC FREEPROCCACHE
---DBCC DROPCLEANBUFFERS


---vista general del estado actual del uso de la memoria en SQL Server

SELECT
	physical_memory_kb,
	virtual_memory_kb,
	committed_kb,
	committed_target_kb
FROM sys.dm_os_sys_info;


---physical_memory_kb: Memoria física total instalada en el servidor.

-- virtual_memory_kb:  Cantidad total de memoria virtual disponible para SQL Server

-- Committed_kb:  La cantidad de memoria actualmente asignada por la caché del búfer para el uso por páginas de base de datos.

--Committed_target_kb:  Esta es la cantidad de memoria que la caché del búfer “quiere” usar.


-- métricas de la caché del búfer

---Bse de datos
SELECT
    databases.name AS database_name,
    COUNT(*) * 8 / 1024 AS mb_used
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.databases
ON databases.database_id = dm_os_buffer_descriptors.database_id
GROUP BY databases.name
ORDER BY COUNT(*) DESC;


----Por objetos

SELECT
	objects.name AS object_name,
	objects.type_desc AS object_type_description,
	COUNT(*) AS buffer_cache_pages,
	COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY objects.name,
		 objects.type_desc
ORDER BY COUNT(*) DESC;


---index
SELECT
	indexes.name AS index_name,
	objects.name AS object_name,
	objects.type_desc AS object_type_description,
	COUNT(*) AS buffer_cache_pages,
	COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
		 objects.name,
		 objects.type_desc
ORDER BY COUNT(*) DESC;


--- recolecatr porcentaje de cada tabla que esta en la memoria

WITH CTE_BUFFER_CACHE AS (
	SELECT
		objects.name AS object_name,
		objects.type_desc AS object_type_description,
		objects.object_id,
		COUNT(*) AS buffer_cache_pages,
		COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
	FROM sys.dm_os_buffer_descriptors
	INNER JOIN sys.allocation_units
	ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
	INNER JOIN sys.partitions
	ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
	OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
	INNER JOIN sys.objects
	ON partitions.object_id = objects.object_id
	WHERE allocation_units.type IN (1,2,3)
	AND objects.is_ms_shipped = 0
	AND dm_os_buffer_descriptors.database_id = DB_ID()
	GROUP BY objects.name,
			 objects.type_desc,
			 objects.object_id)
SELECT
	PARTITION_STATS.name,
	CTE_BUFFER_CACHE.object_type_description,
	CTE_BUFFER_CACHE.buffer_cache_pages,
	CTE_BUFFER_CACHE.buffer_cache_used_MB,
	PARTITION_STATS.total_number_of_used_pages,
	PARTITION_STATS.total_number_of_used_pages * 8 / 1024 AS total_mb_used_by_object,
	CAST((CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL) * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM CTE_BUFFER_CACHE
INNER JOIN (
	SELECT 
		objects.name,
		objects.object_id,
		SUM(used_page_count) AS total_number_of_used_pages
	FROM sys.dm_db_partition_stats
	INNER JOIN sys.objects
	ON objects.object_id = dm_db_partition_stats.object_id
	WHERE objects.is_ms_shipped = 0
	GROUP BY objects.name, objects.object_id) PARTITION_STATS
ON PARTITION_STATS.object_id = CTE_BUFFER_CACHE.object_id
ORDER BY CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL) DESC;


--- % index de buffer

SELECT
	indexes.name AS index_name,
	objects.name AS object_name,
	objects.type_desc AS object_type_description,
	COUNT(*) AS buffer_cache_pages,
	COUNT(*) * 8 / 1024  AS buffer_cache_used_MB,
	SUM(allocation_units.used_pages) AS pages_in_index,
	SUM(allocation_units.used_pages) * 8 /1024 AS total_index_size_MB,
	CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM(allocation_units.used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
		 objects.name,
		 objects.type_desc
ORDER BY CAST((CAST(COUNT(*) AS DECIMAL) / CAST(SUM(allocation_units.used_pages) AS DECIMAL) * 100) AS DECIMAL(5,2)) DESC;



-----caché del búfer, y por lo tanto provee un indicador del espacio potencial desperdiciado o la ineficiencia


WITH CTE_BUFFER_CACHE AS
( SELECT
  databases.name AS database_name,
  COUNT(*) AS total_number_of_used_pages,
  CAST(COUNT(*) * 8 AS DECIMAL) / 1024 AS buffer_cache_total_MB,
  CAST(CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes AS BIGINT)) AS DECIMAL) / (1024 * 1024) AS DECIMAL(20,2))  AS buffer_cache_free_space_in_MB
 FROM sys.dm_os_buffer_descriptors
 INNER JOIN sys.databases
 ON databases.database_id = dm_os_buffer_descriptors.database_id
 GROUP BY databases.name)
SELECT
 *,
 CAST((buffer_cache_free_space_in_MB / NULLIF(buffer_cache_total_MB, 0)) * 100 AS DECIMAL(5,2)) AS buffer_cache_percent_free_space
FROM CTE_BUFFER_CACHE
ORDER BY buffer_cache_free_space_in_MB / NULLIF(buffer_cache_total_MB, 0) DESC


----Las causantes por tablas

SELECT
	objects.name AS object_name,
	objects.type_desc AS object_type_description,
	COUNT(*) AS buffer_cache_pages,
	CAST(COUNT(*) * 8 AS DECIMAL) / 1024  AS buffer_cache_total_MB,
	CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes AS BIGINT)) AS DECIMAL) / 1024 / 1024 AS buffer_cache_free_space_in_MB,
	CAST((CAST(SUM(CAST(dm_os_buffer_descriptors.free_space_in_bytes AS BIGINT)) AS DECIMAL) / 1024 / 1024) / (CAST(COUNT(*) * 8 AS DECIMAL) / 1024) * 100 AS DECIMAL(5,2)) AS buffer_cache_percent_free_space
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY objects.name,
			objects.type_desc,
			objects.object_id
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;



---- Podemos usar esta información para contar las páginas limpias y sucias en la caché del búfer para una base de datos

----Base
SELECT
    databases.name AS database_name,
	COUNT(*) AS buffer_cache_total_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 1
				ELSE 0
		END) AS buffer_cache_dirty_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 0
				ELSE 1
		END) AS buffer_cache_clean_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 1
				ELSE 0
		END) * 8 / 1024 AS buffer_cache_dirty_page_MB,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 0
				ELSE 1
		END) * 8 / 1024 AS buffer_cache_clean_page_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.databases
ON dm_os_buffer_descriptors.database_id = databases.database_id
GROUP BY databases.name;


---X tablas

SELECT
	indexes.name AS index_name,
	objects.name AS object_name,
	objects.type_desc AS object_type_description,
	COUNT(*) AS buffer_cache_total_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 1
				ELSE 0
		END) AS buffer_cache_dirty_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 0
				ELSE 1
		END) AS buffer_cache_clean_pages,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 1
				ELSE 0
		END) * 8 / 1024 AS buffer_cache_dirty_page_MB,
    SUM(CASE WHEN dm_os_buffer_descriptors.is_modified = 1
				THEN 0
				ELSE 1
		END) * 8 / 1024 AS buffer_cache_clean_page_MB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
AND dm_os_buffer_descriptors.database_id = DB_ID()
GROUP BY indexes.name,
		 objects.name,
		 objects.type_desc
ORDER BY COUNT(*) DESC;


--- Limpiar  cache

DBCC FREESYSTEMCACHE ('ALL') WITH MARK_IN_USE_FOR_REMOVAL;  
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS



----Query store

 SELECT * FROM sys.database_query_store_options
 

