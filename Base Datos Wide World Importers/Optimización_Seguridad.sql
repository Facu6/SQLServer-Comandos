USE WideWorldImporters;

-- VISUALIZAMOS LA FRAGMENTACIÓN DE ÍNDICES DE LA TABLA "Sales.Orders"
SELECT 
    OBJECT_NAME(ps.object_id) AS TableName,
    i.name AS IndexName,
    ps.index_id,
    ps.index_type_desc,
    ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Sales.Orders'), NULL, NULL, 'LIMITED') ps
JOIN sys.indexes i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
ORDER BY ps.avg_fragmentation_in_percent DESC;


-- REALIZAMOS LA REORGANIZACIÓN DE ÍNDICES "IDX_Orders_CustomerDate" --> 14.28%
ALTER INDEX IDX_Orders_CustomerDate ON Sales.Orders REORGANIZE;

-- AHORA LA RECONSTRUCCIÓN DE "FK_Sales_Orders_PickedByPersonID (99.57%), FK_Sales_Orders_ContactPersonID (97.88%), FK_Sales_Orders_CustomerID (97.88%), FK_Sales_Orders_SalespersonPersonID (97.05%)"
ALTER INDEX FK_Sales_Orders_PickedByPersonID ON Sales.Orders REBUILD;
ALTER INDEX FK_Sales_Orders_ContactPersonID ON Sales.Orders REBUILD;
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders REBUILD;
ALTER INDEX FK_Sales_Orders_SalespersonPersonID ON Sales.Orders REBUILD;

-- VEMOS LOS ÍNDICES DE UNA TABLA EN ESPECÍFICA
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = ic.column_id
WHERE i.object_id = OBJECT_ID('Sales.Orders'); 

-- ============================================0
--			= SEGURIDAD Y PERMISOS =

-- 1) Crear usuario de solo lectura para "Sales.Customers"

-- Crear un inicio de sesión a nivel servidor
CREATE LOGIN LoginReadOnly WITH PASSWORD = 'Contraseña123';

-- Crear un usuario dentro de la base de datos y asociarlo al login
CREATE USER UserReadOnly FOR LOGIN LoginReadOnly;

-- Conceder permisos sólo de lectura a Sales.Customer
GRANT SELECT ON Sales.Customers TO UserReadOnly;


-- CONSTATAR CREACIÓN EXITOSA Y PERMISOS DE LECTURA

CREATE TABLE Application.UserAccess(
	UserReadOnly NVARCHAR(100) NOT NULL,
	DeliveryCityID INT NOT NULL,
	PRIMARY KEY (UserReadOnly, DeliveryCityID)
);

INSERT INTO Application.UserAccess (UserReadOnly, DeliveryCityID)
SELECT 'UserReadOnly', CityID FROM Application.Cities;


-- ENTENDER POR QUÉ DA ERROR AL EJECUTAR MODIFICACIÓN DE FUNCIÓN
ALTER FUNCTION [Application].DetermineCustomerAccess
(
	@CityID INT
)
RETURNS TABLE
WITH SCHEMABINDING
AS 
RETURN (
	
	SELECT 1 AS AccessResult
	WHERE 
		-- Permitir acceso si el usuario es db_owner
		IS_ROLEMEMBER(N'db_owner') <> 0

		-- Permitir acceso si el usuario pertenece a SalesTerritory de la ciudad
		OR IS_ROLEMEMBER(
			(SELECT sp.SalesTerritory
			FROM Application.Cities AS c
			INNER JOIN Application.StateProvinces AS sp
				ON c.StateProvinceID = sp.StateProvinceID
			WHERE c.CityID = @CityID) + N' Sales'
		) <> 0

		-- Permitir el acceso si el usuario está en UserAccess
		OR EXISTS (
			SELECT 1
			FROM Application.UserAccess
			WHERE UserReadOnly = USER_NAME() AND DeliveryCityID = @CityID
		)

		-- Permitir el acceso si el usuario Website tiene el mismo SalesTerritory
		OR (ORIGINAL_LOGIN() = N'Website'
			AND EXISTS (
				SELECT 1 
				FROM Application.Cities AS c
				INNER JOIN Application.StateProvinces AS sp
					ON c.StateProvinceID = sp.StateProvinceID
				WHERE c.CityID = @CityID
				AND sp.SalesTerritory = SESSION_CONTEXT(N'SalesTerritory')
			))
);

SELECT sp.name AS Usuario, sp.type_desc AS TipoUsuario, sp.is_disabled, dp.name AS Rol
FROM sys.server_principals sp
LEFT JOIN sys.database_principals dp
    ON sp.sid = dp.sid
WHERE sp.type IN ('S', 'U', 'G')
AND dp.name IN ('db_owner', 'sysadmin');

-- Ver login y usuario actual 
SELECT SUSER_NAME(), USER_NAME();

-- Cambiar de login
EXECUTE AS LOGIN = 'Facu\dispe';

-- Cambiar de usuario
EXECUTE AS USER = 'dbo';

-- Ver todos los usuarios creados
SELECT name AS Usuario, type_desc AS Tipo 
FROM sys.database_principals
WHERE type IN ('S', 'U');

SELECT * FROM sys.server_principals WHERE name = 'Facu\dispe';


-- Ver logins asociados a cada usuario
SELECT dp.name AS UsuarioBD, sp.name AS LoginAsociado
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
WHERE dp.name IN ('dbo', 'guest', 'INFORMATION_SCHEMA', 'sys', 'UserReadOnly');