
/* Seguridad : Evitando SQL Inyeccion  */


var Shipcity;  
ShipCity = Request.form ("ShipCity");  
var sql = "select * from OrdersTable where ShipCity = '" + ShipCity + "'";  


SELECT * FROM OrdersTable WHERE ShipCity = 'Redmond'  

'Redmond'; drop table OrdersTable--  

SELECT * FROM OrdersTable WHERE ShipCity = 'Redmond';drop table OrdersTable--'  


---Validar todos los datos especificados por el usuario

/*

Si es posible, rechace los datos que contengan los siguientes caracteres.

VALIDAR TODOS LOS DATOS ESPECIFICADOS POR EL USUARIO
Car�cter de entrada	Significado en Transact-SQL
;	Delimitador de consultas.
'	Delimitador de cadenas de datos de caracteres.
--	Delimitador del comentario de una sola l�nea. El servidor no eval�a el texto siguiente -- hasta el final de esa l�nea.
/*_ ... _*/	Delimitadores de comentarios. El servidor no eval�a el texto incluido entre /* _ y _ */ .
xp_	Se usa al principio del nombre de procedimientos almacenados extendidos de cat�logo, como xp_cmdshell.

*/

--Usar par�metros SQL con seguridad de tipos  example:   @au_id   SqlDbType.VarChar, 11

--Usar una entrada con par�metros con los procedimientos almacenados
/*
SqlDataAdapter myCommand =   
new SqlDataAdapter("LoginStoredProcedure '" +   
                               Login.Text + "'", conn);  
*/


--Filtrar la entrada   example   return inputSQL.Replace("'", "''"); 


--Debe revisar todo el c�digo que llama a EXECUTE, EXECo sp_executesql

SELECT object_Name(id) FROM syscomments  
WHERE UPPER(text) LIKE '%EXECUTE (%'  
OR UPPER(text) LIKE '%EXECUTE  (%'  
OR UPPER(text) LIKE '%EXECUTE   (%'  
OR UPPER(text) LIKE '%EXECUTE    (%'  
OR UPPER(text) LIKE '%EXEC (%'  
OR UPPER(text) LIKE '%EXEC  (%'  
OR UPPER(text) LIKE '%EXEC   (%'  
OR UPPER(text) LIKE '%EXEC    (%'  
OR UPPER(text) LIKE '%SP_EXECUTESQL%';  

