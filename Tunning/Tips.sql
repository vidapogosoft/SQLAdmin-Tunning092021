
--T�cnicas para mejorar el rendimiento de las consultas SQL

1. Indexe todos los predicados en cl�usulas JOIN, WHERE, ORDER BY y GROUP BY.
Por lo general las consultas , depende en gran medida de los �ndices para mejorar 
el rendimiento y la escalabilidad de SQL. 
Sin los �ndices adecuados, las consultas SQL pueden causar exploraciones de tabla, 
lo que provoca problemas de rendimiento o de bloqueo. 
Se recomienda indexar todas las columnas de predicados. 
La excepci�n es cuando los datos de columna tienen una cardinalidad muy baja.

--FROM GEN_PERSONA P, CBO_MOVIMIENTO_CAJA MC, CBO_DET_MOVIMIENTO_CAJA DMC, CBO_TIPO_DOCUMENTO TD, CBO_FORMA_PAGO FP 
--WHERE P.ID_PERSONA = MC.ID_CLIENTE AND MC.ID_TIPO_DOCUMENTO = TD.ID_TIPO_DOCUMENTO 
--AND MC.ID_MOVIMIENTO_CAJA = DMC.ID_CAB_MOVIMIENTO_CAJA AND DMC.ID_FORMA_PAGO = FP.ID_FORMA_PAGO 
--AND MC.ID_TIPO_MOVIMIENTO = 1 AND DMC.ID_FORMA_PAGO NOT IN (3, 5) 
--AND  TD.ID_TIPO_DOCUMENTO IN (9,4,2) --(9) CUOTA SOCIAL - (4) FACTURA NP - (2) PAGO FACT
--AND MC.FECHA >= '09/01/2018' AND  MC.FECHA <= '09/30/2018' AND MC.ANULADO = 0 
----AND MC.ID_MOVIMIENTO_CAJA = 7883
--ORDER BY MC.FECHA


2. Evite el uso de funciones en los predicados.

La base de datos no utiliza el �ndice si hay una funci�n en la columna. Por ejemplo:
--SELECT * FROM TABLE1 WHERE UPPER(COL1)='ABC'


3. Evite el uso del car�cter comod�n (%) al principio de un predicado.

-- SELECT * FROM TABLE1 WHERE COL1 LIKE '%ABC'


4. Evite columnas innecesarias en la cl�usula SELECT.

Especifique las columnas en la cl�usula SELECT en lugar de utilizar 
SELECT *. Las columnas innecesarias imponen cargas adicionales en la base de datos, 
lo que ralentiza no s�lo el SQL espec�fico, sino todo el sistema.


5. Utilice la uni�n interna en lugar de la uni�n externa, si es posible.
La uni�n externa s�lo debe utilizarse si es necesario. 
La utilizaci�n de la uni�n externa limita las opciones de optimizaci�n de la base de datos, 
lo que suele dar como resultado una ejecuci�n m�s lenta del SQL.


6. DISTINCT y UNION s�lo deben utilizarse si es necesario.
Los operadores DISTINCT y UNION causan la operaci�n de clasificaci�n, lo que ralentiza la ejecuci�n de SQL. 
Utilice UNION ALL en lugar de UNION, si es posible, ya que es mucho m�s eficaz.

7. La cl�usula ORDER BY es obligatoria en SQL si el conjunto de resultados clasificados es el previsto.
La palabra clave ORDER BY se utiliza para clasificar el conjunto de resultados por las columnas 
especificadas. Sin la cl�usula ORDER BY, el conjunto de resultados se devuelve directamente 
sin ninguna clasificaci�n. El orden no queda garantizado. 
Tenga en cuenta el impacto del rendimiento que supone a�adir la cl�usula ORDER BY, 
ya que la base de datos necesita clasificar el conjunto de resultados, lo que se convierte 
en una de las operaciones m�s costosas de la ejecuci�n de SQL.

