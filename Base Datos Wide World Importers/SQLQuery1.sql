USE WideWorldImporters;

-- (2) -  CONSULTAS BÁSICAS

-- 2.1 - CONSULTA QUE LISTE LOS 10 PRODUCTOS MAS VENDIDOS
SELECT TOP 10
sti.StockItemName, SUM(ol.Quantity) AS CantidadProducto
FROM Warehouse.StockItems sti 
INNER JOIN Sales.OrderLines ol 
	ON sti.StockItemID = ol.StockItemID
GROUP BY sti.StockItemID,  sti.StockItemName
ORDER BY CantidadProducto DESC;


-- 2.2 - CONSULTA QUE COMBINE DATOS DE CLIENTES Y ÓRDENES
SELECT c.CustomerName, p.FullName, p.LogonName, o.OrderDate, ol.Description, ol.Quantity, 
	CAST(ROUND((ol.Quantity * ol.UnitPrice), 2) AS DECIMAL(10,2)) AS Subtotal, CAST(ROUND(((ol.Quantity * ol.UnitPrice) * (ol.TaxRate / 100)), 2) AS DECIMAL(10,2)) AS Impuesto,
	CAST(ROUND(((ol.Quantity * ol.UnitPrice) + ((ol.Quantity * ol.UnitPrice) * (ol.TaxRate / 100))), 2) AS DECIMAL(10,2)) AS Total
FROM Sales.Customers c
INNER JOIN Application.People p 
	ON p.PersonID = c.PrimaryContactPersonID
INNER JOIN Sales.Orders o
	ON c.CustomerID = o.CustomerID
INNER JOIN Sales.OrderLines ol 
	ON o.OrderID = ol.OrderID
ORDER BY o.OrderDate DESC;


-- 2.3 - CONSULTA PARA AGREGAR VENTAS POR REGIÓN Y CALCULAR TOTALES Y PROMEDIOS
SELECT sp.StateProvinceName, ci.CityName, ol.Description, SUM(ol.Quantity) AS CantidadTotalProductos, SUM(ol.Quantity * ol.UnitPrice) AS Total, 
	CAST(SUM(ol.Quantity * ol.UnitPrice) / NULLIF(SUM(ol.Quantity), 0) AS DECIMAL(10,2)) AS PromedioTotal
FROM Sales.Customers cu
INNER JOIN Application.Cities ci
	ON cu.PostalCityID = ci.CityID
INNER JOIN Application.StateProvinces sp
	ON ci.StateProvinceID = sp.StateProvinceID
INNER JOIN Sales.Orders o
	ON cu.CustomerID = o.CustomerID
INNER JOIN Sales.OrderLines ol
	ON o.OrderID = ol.OrderID
GROUP BY sp.StateProvinceName, ci.CityName, ol.Description
ORDER BY sp.StateProvinceName, ci.CityName, Total DESC;


-- (3) - OPERACIONES DML (Data Manipulation Languaje)

-- 3.1 - INSERTAR UN REGISTRO EN LA TABLA CUSTOMERS
INSERT INTO Sales.Customers (CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID,
							DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber,
							FaxNumber, DeliveryRun, RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, 
							PostalAddressLine2, PostalPostalCode, LastEditedBy, ValidFrom, ValidTo)
VALUES ('Facundo Dispenza', 1, 7, 1, 1001, NULL, 3, 33475, 33475, 3000.00, '2012-12-12', 0.000, 0, 0, 7, '(261)366-8283', '(261)366-8283', NULL, NULL, 'http://www.tailspintoys.com/Facundo', 'Shop 264', 'Lisandro Torre 479', 5560,
		NULL, 'PO Box 1905', 'Brandsen', 12126, 1, DEFAULT, DEFAULT);


-- 3.2 - ACTUALIZAR DATO DE UN EMPLEADO EN LA TABLA PEOPLE
UPDATE Application.People
SET LogonName = 'stellitalamasputita@wideworldimporters.com'
WHERE PersonID = 10; 


-- 3.3 - ELIMINAR UN REGISTRO
DELETE FROM Warehouse.Colors
WHERE ColorID = 32;

-- 3.4 - MARCAR COMO INACTIVO UN REGISTRO
ALTER TABLE Sales.Customers -- Se crea la columna "IsActive"
ADD IsActive BIT DEFAULT 1;

UPDATE Sales.Customers -- Se marca como inactivo el cliente 102
SET IsActive = 0
WHERE CustomerID = 102;



/*********				(1) VISTAS						 ********/

-- ======	1.1		* VISTA QUE MUESTRE LOS CLIENTES QUE HAN REALIZADO AL MENOS UN PEDIDO EN LOS ÚLTIMOS 132 MESES (11 AÑOS)
		--			* DEBE INCLUIR CustomerID, CustomerName, CategoryName, TotalOrders

CREATE VIEW vw_PedidosUltimoAño AS
	SELECT	cu.CustomerID, 
			cu.CustomerName, 
			ca.CustomerCategoryName, 
			COUNT(o.OrderID) AS TotalOrders, 
			MAX(o.OrderDate) AS LastDate
	FROM Sales.Customers cu
	INNER JOIN Sales.CustomerCategories ca
		ON cu.CustomerCategoryID = ca.CustomerCategoryID
	INNER JOIN Sales.Orders o
		ON cu.CustomerID = o.CustomerID
	WHERE o.OrderDate >= DATEADD(MONTH, -132, GETDATE())
	GROUP BY cu.CustomerID, cu.CustomerName, ca.CustomerCategoryName;
GO

	-- EL ORDEN SE DEBE ESPECIFICAR A LA HORA DE LLAMAR A LA VISTA, NO EN LA CREACIÓN DE ELLA
SELECT * FROM vw_PedidosUltimoAño
ORDER BY LastDate DESC;


-- ====== 1.2		* VISTA QUE MUESTRE LOS PRODUCTOS CON STOCK DISPONIBLE MENOR A 50
--					* INCLUYE StockItemID, StockItemName, QuantityOnHand

CREATE VIEW vw_StockDisponibleMenor50 AS
	SELECT sih.StockItemID, si.StockItemName, MIN(sih.QuantityOnHand) AS Min
	FROM Warehouse.StockItemHoldings sih
	INNER JOIN Warehouse.StockItems si
		ON sih.StockItemID = si.StockItemID
	GROUP BY sih.StockItemID, si.StockItemName
	HAVING MIN(sih.QuantityOnHand) < 50;
GO

SELECT * FROM vw_StockDisponibleMenor50;


/*********				(2) FUNCIONES						 ********/

-- ====== 2.1		* FUNCIÓN ESCALAR QUE OBTENGA EL NOMBRE DE UN CLIENTE
--					* RECIBE @CustomerID Y DEVUELVE CustomerName
--					* SI CLIENTE NO EXISTE DEVUELVE "Cliente no encontrado"

CREATE FUNCTION ufn_NombreCliente
(
	@CustomerID INT
)
RETURNS NVARCHAR(50)
BEGIN
	
	IF NOT EXISTS (SELECT 1 FROM Sales.Customers WHERE CustomerID = @CustomerID)
	BEGIN 
		RETURN CONCAT('El cliente con ID "', @CustomerID, '" no existe.')
	END;

	DECLARE @CustomerName NVARCHAR(50)

	SELECT @CustomerName = CustomerName
	FROM Sales.Customers
	WHERE CustomerID = @CustomerID;

	RETURN @CustomerName
END;
GO

SELECT dbo.ufn_NombreCliente(12) AS CustomerName;


-- ====== 2.2		* FUNCIÓN ESCALAR QUE CALCULE EL TOTAL CON IMPUESTOS
--					* RECIBE EL OrderID Y DEVUELVE EL TOTAL CON IMPUESTOS

CREATE FUNCTION ufn_CalcularImpuesto
(
	@OrderID INT
)
RETURNS DECIMAL(10,2)
BEGIN

	DECLARE @Total DECIMAL(10,2);

	SELECT @Total = SUM(Quantity * UnitPrice * (1 + TaxRate / 100.0))
	FROM Sales.OrderLines
	WHERE OrderID = @OrderID;

	RETURN @Total;
END;
GO

SELECT dbo.ufn_CalcularImpuesto(45) AS Total;


-- ====== 2.3		* FUNCIÓN EN LÍNEA QUE DEVUELVA LA CANTIDAD ORDENES DE UN CLIENTE
CREATE FUNCTION ufn_ClientesOrdenes
(
	@CustomerID INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT CustomerID, COUNT(OrderID) AS TotalOrdenes
	FROM Sales.Orders
	WHERE CustomerID = @CustomerID
	GROUP BY CustomerID
);
GO

SELECT * FROM dbo.ufn_ClientesOrdenes(6);



/*********				(3) PROCEDIMIENTOS ALMACENADOS						 ********/

-- ====== 3			* INSERTAR UN NUEVO PEDIDO
--					* RECIBE CustomerID, OrderDate, ExpectedDeliveryDate
--					* INSERTA LA ORDEN EN Sales.Orders
--					* DEVUELVE EL OrderID GENERADO


-- CREAMOS "SEQUENCE" PARA DEVOLVER EL "NewOrderID" YA QUE CON "SCOPE_IDENTITY()" NO LO DEVUELVE AL NO ESTAR DEFINIDA LA COLUMNA COMO TAL
-- Paso 1: Calcular el valor máximo de "OrderID" en "Sales.Orders"
DECLARE @MaxOrderID INT;
SELECT @MaxOrderID = ISNULL(MAX(OrderID), 0) FROM Sales.Orders;

-- Paso 2: Si la secuencia ya existe, eliminarla
IF OBJECT_ID('dbo.OrderID_Sequence', 'SO') IS NOT NULL
BEGIN			
	DROP SEQUENCE OrderID_Sequence;
END;

-- Paso 3: Crear la secuencia usando SQL dinámico
DECLARE @SQL NVARCHAR(MAX);
SET @SQL = N'CREATE SEQUENCE dbo.OrderID_Sequence
			AS INT
			START WITH ' + CAST(@MaxOrderID + 1 AS NVARCHAR(20)) + '
			INCREMENT BY 1;';
EXEC sp_executesql @SQL;


CREATE PROCEDURE sp_NuevoPedido
(
	@CustomerID INT,
	@SalespersonPersonID INT = NULL,
	@PickedByPersonID INT = NULL,
	@ContactPersonID INT = NULL,
	@BackorderOrderID INT = NULL,
	@OrderDate DATE = NULL,
	@ExpectedDeliveryDate DATE,
	@CustomerPurchaseOrderNumber INT = NULL,
	@IsUndersupplyBackordered INT = NULL,
	@Comments NVARCHAR(50) = NULL,
	@DeliveryInstructions NVARCHAR(50) = NULL,
	@InternalComments NVARCHAR(100) = NULL,
	@PickingCompletedWhen DATETIME = NULL,
	@LastEditedBy INT = NULL,
	@LastEditedWhen DATETIME = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @OrderID INT;

	IF @OrderDate IS NULL AND @LastEditedWhen IS NULL
		BEGIN
			SET @OrderDate = GETDATE();
			SET @LastEditedWhen = GETDATE();
		END;
	

	BEGIN TRY
		
		INSERT INTO Sales.Orders (CustomerID, SalespersonPersonID, PickedByPersonID, ContactPersonID, BackorderOrderID, OrderDate, ExpectedDeliveryDate, CustomerPurchaseOrderNumber, 
								  IsUndersupplyBackordered, Comments, DeliveryInstructions, InternalComments, PickingCompletedWhen, LastEditedBy, LastEditedWhen)
		VALUES (@CustomerID, @SalespersonPersonID, @PickedByPersonID, @ContactPersonID, @BackorderOrderID, @OrderDate, @ExpectedDeliveryDate, 
				@CustomerPurchaseOrderNumber, @IsUndersupplyBackordered, @Comments, @DeliveryInstructions, @InternalComments, @PickingCompletedWhen, @LastEditedBy, @LastEditedWhen);

		SET @OrderID = NEXT VALUE FOR dbo.OrderID_Sequence;
	
	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000),
				@ErrorSeverity INT,
				@ErrorState INT;
		SELECT	@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		RETURN;
	
	END CATCH
END;
GO


EXEC dbo.sp_NuevoPedido
	@CustomerID = 69,
	@SalespersonPersonID = 8,
	@ContactPersonID = 3261,
	@ExpectedDeliveryDate = '2025-02-24',
	@IsUndersupplyBackordered = 1,
	@LastEditedBy = 7;


SELECT TOP 5 * FROM Sales.Orders
ORDER BY OrderID DESC;



-- ====== 3.1		* INSERTAR UN NUEVO PEDIDO CON PRODUCTOS	
--					* INSERTAR PEDIDO EN Sales.Orders
--					* RECIBE TABLE TYPE CON LOS PRODUCTOS (StockItemID, Quantity)
--					* INSERTA LOS PRODUCTOS EN Sales.OrderLines
--					* VERIFICA QUE EL STOCK SEA SUFICIENTE ANTES DE INSERTAR

-- CREAR PROCEDIMIENTO
CREATE PROCEDURE dbo.sp_InsertarPedidoProductos
(
	@CustomerID INT,
	@SalespersonPersonID INT = NULL,
	@PickedByPersonID INT = NULL,
	@ContactPersonID INT = NULL,
	@BackorderOrderID INT = NULL,
	@OrderDate DATE = NULL,
	@ExpectedDeliveryDate DATE,
	@CustomerPurchaseOrderNumber INT = NULL,
	@IsUndersupplyBackordered INT = NULL,
	@Comments NVARCHAR(50) = NULL,
	@DeliveryInstructions NVARCHAR(50) = NULL,
	@InternalComments NVARCHAR(100) = NULL,
	@PickingCompletedWhen DATETIME = NULL,
	@LastEditedBy INT = NULL,
	@LastEditedWhen DATETIME = NULL,
	@ProductList dbo.TableTypeOrderProducts READONLY
)
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRANSACTION; -- Iniciar transacción para asegurar atomicidad

	BEGIN TRY
		IF @OrderDate IS NULL 
			SET @OrderDate = GETDATE()

		IF @LastEditedWhen IS NULL
			SET @LastEditedWhen = GETDATE()

		DECLARE @InsertedOrderIDTable TABLE (InsertedOrderID INT);

		-- 2) Insertar un nuevo pedido en Sales.Orders
		INSERT INTO Sales.Orders (CustomerID, SalespersonPersonID, PickedByPersonID, ContactPersonID, BackorderOrderID, OrderDate, ExpectedDeliveryDate, CustomerPurchaseOrderNumber, IsUndersupplyBackordered,
								  Comments, DeliveryInstructions, InternalComments, PickingCompletedWhen, LastEditedBy, LastEditedWhen) 
		OUTPUT inserted.OrderID INTO @InsertedOrderIDTable
		VALUES (@CustomerID, @SalespersonPersonID, @PickedByPersonID, @ContactPersonID, @BackorderOrderID, @OrderDate, @ExpectedDeliveryDate, @CustomerPurchaseOrderNumber, @IsUndersupplyBackordered,
								  @Comments, @DeliveryInstructions, @InternalComments, @PickingCompletedWhen, @LastEditedBy, @LastEditedWhen);
		
		-- Obtenemos el OrderID
		DECLARE @NewOrderID INT;
		SELECT @NewOrderID = InsertedOrderID FROM @InsertedOrderIDTable

		-- 3) Insertar cada línea de pedido en Sales.OrderLines utilizando la tabla de productos
		INSERT INTO Sales.OrderLines (OrderID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, PickedQuantity, PickingCompletedWhen, LastEditedBy, LastEditedWhen)
		SELECT @NewOrderID, p.StockItemID, p.Description, p.PackageTypeID, p.Quantity, si.UnitPrice, p.TaxRate, p.PickedQuantity, p.PickingCompletedWhen, p.LastEditedBy, @LastEditedWhen
		FROM @ProductList p 
		INNER JOIN Warehouse.StockItems si
			ON p.StockItemID = si.StockItemID;

		COMMIT TRANSACTION;
		SELECT @NewOrderID AS NewOrderID;

	END TRY 
	BEGIN CATCH
		
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		RAISERROR (@ErrorMessage, 16, 1);
	END CATCH
END;
GO

-- 1) Declarar la variable tipo tabla 
DECLARE @ProductList dbo.TableTypeOrderProducts;

-- 2) Insertar los datos de los productos en la variable
INSERT INTO @ProductList   (StockItemID, 
							Quantity, 
							Description,
							PackageTypeID, 
							TaxRate, 
							PickedQuantity, 
							LastEditedBy)
VALUES	(193, 5, 'Black and orange glass with care despatch tape 48mmx75m', 7, 15.000, 10, 4), -- 50
		(203, 500, 'Tape dispenser (Black)', 7, 15.000, 0, 2); -- 4253

-- 3) Llamar al procedimiento pasando los demás parámetros y la variable tipo tabla
EXEC dbo.sp_InsertarPedidoProductos
	@CustomerID = 6,
	@SalespersonPersonID = 15,
	@PickedByPersonID = 1,
	@ContactPersonID = 8,
	@BackorderOrderID = 11,
	@ExpectedDeliveryDate = '2025-04-25',
	@IsUndersupplyBackordered = 19,
	@Comments = 'Excelente producto.',
	@LastEditedBy = 1,
	@ProductList = @ProductList;

DROP PROCEDURE sp_InsertarPedidoProductos;

/*********				(4) TRIGGERS					 ********/

-- ====== 4.1			* ACTUALIZAR STOCK AUTOMATICAMENTE
--						* DEBE REDUCIR LA CANTIDAD EN StockItemHoldings
--						* SI NO HAY SUFICIENTE STOCK, CANCELA LA ORDEN Y USA ROLLBACK 

CREATE TRIGGER trg_ActualizarStock
ON Sales.OrderLines
AFTER INSERT
AS
BEGIN
	
	SET NOCOUNT ON;

	-- 1) Verificar que para cada producto especificado en @ProductList hay stock suficiente
	DECLARE @ProblematicStockItemID INT,
			@RequiredQty INT,
			@AvailableQty INT;

	SELECT TOP 1 
		@ProblematicStockItemID = i.StockItemID,
		@RequiredQty = i.Quantity,
		@AvailableQty = sih.QuantityOnHand
	FROM inserted i 
	INNER JOIN Warehouse.StockItemHoldings sih
		ON i.StockItemID = sih.StockItemID
	WHERE i.Quantity > sih.QuantityOnHand;
	
	IF @ProblematicStockItemID IS NOT NULL
	BEGIN
		RAISERROR ('El stock actual para el producto con ID "%d" es insuficiente para completar el pedido. Cantidad requerida: "%d" / Cantidad disponible: "%d"',
					16, 1, @ProblematicStockItemID, @RequiredQty, @AvailableQty);
		ROLLBACK TRANSACTION;
		RETURN;
	END;

	-- Si el stock es suficiente, se actualiza la cantidad disponible
	UPDATE sih
	SET sih.QuantityOnHand = sih.QuantityOnHand - i.Quantity
	FROM Warehouse.StockItemHoldings sih
	INNER JOIN inserted i 
		ON sih.StockItemID = i.StockItemID;
END;
GO


-- HACER EJERCICIO DE FUNCIONES MULTIPLE DECLARACIÓN

