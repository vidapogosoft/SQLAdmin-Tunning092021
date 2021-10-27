

ALTER DATABASE MyDatabase  
SET ALLOW_SNAPSHOT_ISOLATION ON  
  
ALTER DATABASE MyDatabase  
SET READ_COMMITTED_SNAPSHOT ON  

---1 Lectura   10000
---2 Borre todos los datos   5000
---3 Presenta la lectura
	--- 

USE AdventureWorks2012;  
GO  


Read committed snapshot

Read uncommitted

SET TRANSACTION ISOLATION LEVEL Read committed;  
GO  
BEGIN TRANSACTION;  
GO  
SELECT *   
    FROM HumanResources.EmployeePayHistory;  
GO  
SELECT *   
    FROM HumanResources.Department;  
GO  
COMMIT TRANSACTION;  
GO 


READ UNCOMMITTED
Permite hacer "lecturas sucias" (dirty reads), 
es decir permite leer los cambios realizados en una transacci�n 
que a�n no han sido confirmados (commit). 
En el caso que una transacci�n 1 actualice una fila, l
a transacci�n 2 va a leer el valor modificado aunque la transacci�n 
inicial no haya sido "commiteada", en el caso que se haga un ROLLBACK, 
las consecuencias son importantes: podemos haber obtenido registros que ya no 
existen m�s, o datos totalmente distintos. 
Se suele usar en situaciones muy controladas.


READ COMMITTED
Asegura integridad en la lectura

REPEATABLE READ
Asegura "lecturas repetibles" e impide las "lecturas sucias", 
imaginemos el ejemplo anterior, 
la transacci�n 1 bloquear� los recursos hasta haber completado 
las dos lecturas, ambas lecturas obtendr�n los mismos datos, 
pero la transacci�n 2 quedar� a la espera de la liberaci�n de 
la 1 para poder completarse. De todas formas 
no evita el caso de las "lecturas fantasma", q
ue ocurren cuando al hacer un 
SELECT de un intervalo de datos, en el medio de la 
transacci�n otro proceso inserta registros dentro de dicho intervalo.



READ COMMITTED SNAPSHOT