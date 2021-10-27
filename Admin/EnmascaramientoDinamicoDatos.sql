use master
go

Create database DBADemo1
go

use DBADemo1
go


CREATE TABLE Membership(
    MemberID        int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName        varchar(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName        varchar(100) NOT NULL,
    Phone            varchar(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email            varchar(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode    smallint MASKED WITH (FUNCTION = 'random(1, 100)') NULL
    );


INSERT INTO Membership (FirstName, LastName, Phone, Email, DiscountCode)
VALUES   
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10),  
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5),  
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50),  
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40);  


select * from Membership
go

CREATE SCHEMA DataMask
go

alter schema DataMask transfer dbo.Membership
go

select * from DataMask.Membership
go

--- creo el usuario

CREATE USER MaskingTestUser WITHOUT LOGIN;  

---permisos

GRANT SELECT ON SCHEMA::DataMask TO MaskingTestUser;  


EXECUTE AS USER = 'MaskingTestUser';  

SELECT * FROM DataMask.Membership;  

REVERT;  

----funciona en los alter table

ALTER TABLE DataMask.Membership  
ALTER COLUMN LastName varchar(100) MASKED WITH (FUNCTION = 'default()'); 


---anula las mascaras
ALTER TABLE DataMask.Membership   
ALTER COLUMN LastName DROP MASKED;  


----columnas con mascaras en las base de datos

SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  FROM sys.masked_columns AS c  JOIN sys.tables AS tbl       ON c.[object_id] = tbl.[object_id]  WHERE is_masked = 1;

