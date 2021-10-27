--Cursor que contiene todos los objetos que ocupan espacio 
DECLARE objects_cursor CURSOR LOCAL FAST_FORWARD READ_ONLY for 
      SELECT s.name + '.' + o.name from sys.schemas s 
      INNER JOIN sys.objects o 
      ON o.schema_id = s.schema_id 
      WHERE 
            o.type = 'S' or --Tablas de sistema 
            o.type = 'U' or --Tablas de usuario 
            o.type = 'V' or --Vistas (solo las indexadas devuelven tama�o) 
            o.type = 'SQ' or --Cola de servicio 
            o.type = 'IT' -- Tablas internas usadas p.e. por el Service Broker o los 

--Tabla temporal para albergar los resultados 
CREATE TABLE #results 
      (name SYSNAME, rows CHAR(11), 
      reserved VARCHAR(18), data VARCHAR(18), 
      index_size VARCHAR(18),Unused VARCHAR(18)) 

--Recorremos el cursor obteniendo la informaci�n de espacio ocupado 
DECLARE @object_name AS SYSNAME 
OPEN objects_cursor 

FETCH NEXT FROM objects_cursor 
INTO @object_name; 
WHILE @@FETCH_STATUS = 0 
BEGIN 
      INSERT INTO #results 
            EXEC sp_spaceused @object_name 
 

      FETCH NEXT FROM objects_cursor 
            INTO @object_name;     
END; 

CLOSE objects_cursor; 
DEALLOCATE objects_cursor; 

-- Quitamos "KB" para poder ordenar 
UPDATE 
  #results 
SET 
  reserved = LEFT(reserved,LEN(reserved)-3),
  data = LEFT(data,LEN(data)-3),
  index_size = LEFT(index_size,LEN(index_size)-3),
  Unused = LEFT(Unused,LEN(Unused)-3) 

--Ordenamos la informaci�n por el tama�o ocupado 
SELECT 
  Name,
  reserved AS [Tama�o en Disco (KB)],
  data AS [Datos (KB)],
  index_size AS [Indices (KB)],
  Unused AS [No usado (KB)],
  Rows AS Filas FROM #results 
ORDER BY 
  CONVERT(bigint, reserved) DESC 


--Eliminar la tabla temporal 
DROP TABLE #results 
