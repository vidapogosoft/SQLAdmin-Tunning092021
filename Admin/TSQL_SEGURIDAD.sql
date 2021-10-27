
---SCHEMAS

---CREATE SCHEMA NOMBRE_ESQUEMA

use musicallyapp
go

CREATE SCHEMA RecursosHumanos
go

CREATE SCHEMA Ventas

go

create table RecursosHumanos.Empleado
(
	IdEmpleado int identity(1,1) primary key,
	IdPersona int,
	FechaCreacion datetime
)

---cambio de esquema
--alter schema RecursosHumanos transfer dbo.GEN_PERSONA_23

--alter schema RecursosHumanos transfer dbo.GEN_PERSONA

---LOGIN

create login Director_RH
with password = '12345'

create login Gerente_ventas
with password = 'abcd'


---usuarios de bases de datos

use musicallyapp
go

create user VPR for login Director_RH
with default_SCHEMA = RecursosHumanos

create user ventas for login Gerente_ventas
with default_SCHEMA = Ventas

---GRANT
---GRANT OPTION

GRANT SELECT
ON SCHEMA :: RecursosHumanos
to VPR
with GRANT OPTION

GRANT INSERT on object :: RecursosHumanos.GEN_PERSONA_23
to VPR


---QUITAR PERMISOS
REVOKE SELECT
ON SCHEMA :: RecursosHumanos
TO VPR CASCADE









