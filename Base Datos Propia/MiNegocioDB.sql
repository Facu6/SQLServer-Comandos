USE MiNegocioDB;

-- (1) - CREACIÓN DE BASE DE DATOS "MiNegocioDB"
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MiNegocioDB')
BEGIN 
	CREATE DATABASE MiNegocioDB
	ON PRIMARY (
		NAME = MiNegocio_Data,
		FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MiNegocioDB.mdf',
		SIZE = 10MB,
		MAXSIZE = 100MB,
		FILEGROWTH = 5MB
	)
	LOG ON (
		NAME = MiNegocioDB_Log,
		FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MiNegocioDB.ldf',
		SIZE = 5MB,
		MAXSIZE = 50MB,
		FILEGROWTH = 2MB
	);
END;

-- 1.1 - CREAR UN ESQUEMA PARA UN SISTEMA DE PEDIDOS CON LAS TABLAS: 
--		-Customers	-Orders	-Products	-OrderDetails -> Para la relación muchos a muchos / Orders y Products

CREATE SCHEMA Customers;
CREATE SCHEMA Products;
CREATE SCHEMA Orders;

CREATE TABLE Customers.Customers (
	CustomerID INT IDENTITY(1,1) PRIMARY KEY,
	FullName NVARCHAR(100) NOT NULL,
	DNI INT,
	Email NVARCHAR(50) NOT NULL,
	PhoneNumber NVARCHAR(30),
	Address NVARCHAR(50),
	CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Products.Products (
	ProductID INT IDENTITY(1,1) PRIMARY KEY,
	ProductName NVARCHAR(50) NOT NULL,
	Description NVARCHAR(200),
	Price DECIMAL(10,2) NOT NULL,
	StockQuantity INT DEFAULT 0
);

CREATE TABLE Orders.Orders (
	OrdersID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT NOT NULL,
	OrderDate DATETIME DEFAULT GETDATE(),
	Status NVARCHAR(50) DEFAULT 'Pending',
	TotalAmount DECIMAL(10,2) DEFAULT 0,
	FOREIGN KEY (CustomerID) REFERENCES Customers.Customers(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Orders.OrderDetails (
	OrderDetailsID INT IDENTITY(1,1) PRIMARY KEY,
	OrdersID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL CHECK (Quantity > 0),
	UnitPrice DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (ProductID) REFERENCES Products.Products(ProductID) ON DELETE CASCADE,
	FOREIGN KEY (OrdersID) REFERENCES Orders.Orders(OrdersID) ON DELETE CASCADE
);

-- 1.2 - INSERTAR LOS DATOS EN LAS TABLAS
INSERT INTO Customers.Customers (FullName, DNI, Email, PhoneNumber, Address, CreatedAt) 
VALUES 
('Carlos Bouchier', 35125141, 'carlos.bouchier@email.com', '(608)-361-4085', 'Calle 298, Ciudad 34', NULL),
('Javier Northfield', 45331241, 'javier.northfield@email.com', '(449)-375-9490', 'Calle 72, Ciudad 17', '2020-07-01'),
('Carlos González', 84756566, 'carlos.gonzález@email.com', '(921)-232-3043', 'Calle 460, Ciudad 12', '2020-03-20'),
('Ana Martínez', 87519286, 'ana.martínez@email.com', '(652)-751-3411', 'Calle 422, Ciudad 30', '2022-05-02'),
('Sofía Martínez', 47596883, 'sofía.martínez@email.com', '(376)-174-1217', 'Calle 13, Ciudad 13', '2024-11-12'),
('Ana López', 68402031, 'ana.lópez@email.com', '(600)-931-3124', 'Calle 363, Ciudad 47', '2021-02-24'),
('Javier López', 79996015, 'javier.lópez@email.com', '(947)-261-3262', 'Calle 113, Ciudad 6', '2021-05-11'),
('Ana Northfield', 54814270, 'ana.northfield@email.com', '(823)-517-1381', 'Calle 462, Ciudad 48', '2024-06-12'),
('Isac Díaz', 71941846, 'isac.díaz@email.com', '(683)-880-2645', 'Calle 374, Ciudad 1', '2021-02-27'),
('Isac González', 86825246, 'isac.gonzález@email.com', '(979)-817-7039', 'Calle 188, Ciudad 31', '2021-07-02'),
('Isac Martínez', 53326408, 'isac.martínez@email.com', '(898)-859-1838', 'Calle 311, Ciudad 18', '2023-08-11'),
('María Bouchier', 70925321, 'maría.bouchier@email.com', '(226)-232-6679', 'Calle 344, Ciudad 9', '2024-03-07'),
('Benito Martínez', 17180198, 'benito.martínez@email.com', '(937)-536-9481', 'Calle 290, Ciudad 45', '2021-11-14'),
('Luis López', 98638997, 'luis.lópez@email.com', '(299)-841-7010', 'Calle 40, Ciudad 2', '2022-12-06'),
('Cesar Ramírez', 69947320, 'cesar.ramírez@email.com', '(744)-439-6244', 'Calle 153, Ciudad 4', '2022-06-20'),
('Luis Martínez', 45548254, 'luis.martínez@email.com', '(478)-491-2949', 'Calle 313, Ciudad 7', '2023-03-25'),
('Cesar González', 18871560, 'cesar.gonzález@email.com', '(858)-783-7942', 'Calle 13, Ciudad 50', '2024-06-23'),
('Sofía Bouchier', 20020497, 'sofía.bouchier@email.com', '(334)-949-8392', 'Calle 373, Ciudad 12', '2023-07-10'),
('Isac Northfield', 22882782, 'isac.northfield@email.com', '(337)-238-9707', 'Calle 134, Ciudad 43', '2021-08-09'),
('Fernando Herrera', 31254789, 'fernando.herrera@email.com', '(321)-569-7124', 'Calle 555, Ciudad 25', '2024-02-20'),
('Liliana Gómez', 45236147, 'liliana.gómez@email.com', '(642)-371-5932', 'Calle 121, Ciudad 8', '2020-09-15'),
('Marcos Díaz', 84631754, 'marcos.díaz@email.com', '(741)-935-2617', 'Calle 229, Ciudad 14', '2023-01-30'),
('Daniela Morales', 78456231, 'daniela.morales@email.com', '(999)-234-5647', 'Calle 88, Ciudad 40', '2021-07-08'),
('Rafael Mendez', 67543218, 'rafael.mendez@email.com', '(853)-392-4728', 'Calle 14, Ciudad 9', '2022-03-12'),
('Eliana Peralta', 92461385, 'eliana.peralta@email.com', '(624)-572-1938', 'Calle 91, Ciudad 19', '2023-05-19'),
('Gabriel Soto', 73546219, 'gabriel.soto@email.com', '(875)-349-6271', 'Calle 77, Ciudad 21', '2024-04-27'),
('Andrea Luna', 84721934, 'andrea.luna@email.com', '(642)-190-3485', 'Calle 36, Ciudad 11', '2022-09-23'),
('Lucas Fernández', 31478526, 'lucas.fernández@email.com', '(732)-561-8923', 'Calle 287, Ciudad 33', '2021-12-06'),
('Valeria Castro', 64792351, 'valeria.castro@email.com', '(658)-749-0923', 'Calle 19, Ciudad 23', '2020-05-10'),
('Juan Espinoza', 49513278, 'juan.espinoza@email.com', '(472)-392-8475', 'Calle 78, Ciudad 46', '2023-10-01'),
('Manuel Vargas', 51279346, 'manuel.vargas@email.com', '(312)-789-4725', 'Calle 82, Ciudad 28', '2024-01-15'),
('Santiago Rojas', 89314526, 'santiago.rojas@email.com', '(548)-672-1937', 'Calle 114, Ciudad 44', '2023-07-29'),
('Camila Medina', 63712985, 'camila.medina@email.com', '(428)-341-7892', 'Calle 41, Ciudad 35', '2021-04-22'),
('Diego Paredes', 87124359, 'diego.paredes@email.com', '(519)-247-1938', 'Calle 30, Ciudad 29', '2022-11-13'),
('Natalia Ortega', 51789634, 'natalia.ortega@email.com', '(349)-472-8093', 'Calle 95, Ciudad 24', '2023-02-14'),
('Patricio Silva', 79153462, 'patricio.silva@email.com', '(612)-372-5489', 'Calle 49, Ciudad 32', '2024-08-21'),
('Lorena Navarro', 93628514, 'lorena.navarro@email.com', '(752)-892-3641', 'Calle 58, Ciudad 39', '2021-09-28'),
('Carlos Valenzuela', 86472931, 'carlos.valenzuela@email.com', '(871)-592-4876', 'Calle 73, Ciudad 42', '2022-07-04'),
('Ricardo Herrera', 61538472, 'ricardo.herrera@email.com', '(748)-392-6415', 'Calle 81, Ciudad 27', '2023-06-18'),
('Diana Solís', 35624819, 'diana.solis@email.com', '(621)-485-3976', 'Calle 101, Ciudad 15', '2023-08-11'),
('Miguel Araya', 78961234, 'miguel.araya@email.com', '(475)-289-1365', 'Calle 75, Ciudad 48', '2021-10-09'),
('Rosa Figueroa', 95123487, 'rosa.figueroa@email.com', '(862)-392-4851', 'Calle 87, Ciudad 37', '2022-12-30'),
('Alberto Ibáñez', 64125987, 'alberto.ibañez@email.com', '(519)-173-8426', 'Calle 69, Ciudad 26', '2024-03-21'),
('Esteban Vega', 49875236, 'esteban.vega@email.com', '(398)-726-4519', 'Calle 96, Ciudad 14', '2022-06-18'),
('Laura Cárdenas', 73984512, 'laura.cardenas@email.com', '(682)-491-2736', 'Calle 58, Ciudad 43', '2020-04-14'),
('Gonzalo Villalobos', 54129384, 'gonzalo.villalobos@email.com', '(543)-872-6491', 'Calle 33, Ciudad 49', '2023-09-05'),
('Daniela Fuentes', 87234129, 'daniela.fuentes@email.com', '(831)-923-1475', 'Calle 54, Ciudad 10', '2024-01-19'),
('Rodrigo Pino', 63478192, 'rodrigo.pino@email.com', '(628)-145-3971', 'Calle 23, Ciudad 38', '2021-07-28'),
('Clara Espinoza', 51928374, 'clara.espinoza@email.com', '(318)-642-9853', 'Calle 19, Ciudad 29', '2020-10-11'),
('Luciano Montes', 87641239, 'luciano.montes@email.com', '(679)-548-2931', 'Calle 37, Ciudad 44', '2023-05-24'),
('Patricia Méndez', 54789123, 'patricia.méndez@email.com', '(578)-319-2468', 'Calle 82, Ciudad 40', '2022-11-17'),
('Joaquín Bustos', 93851246, 'joaquin.bustos@email.com', '(713)-927-8435', 'Calle 14, Ciudad 32', '2021-09-06'),
('Fernanda Lagos', 41329876, 'fernanda.lagos@email.com', '(849)-372-6812', 'Calle 29, Ciudad 41', '2024-07-09'),
('Carlos Núñez', 64128753, 'carlos.núñez@email.com', '(582)-647-3194', 'Calle 48, Ciudad 28', '2020-02-23'),
('Antonia Castro', 74938251, 'antonia.castro@email.com', '(926)-783-5149', 'Calle 20, Ciudad 31', '2021-12-14'),
('Sebastián Paredes', 36587412, 'sebastián.paredes@email.com', '(329)-647-2813', 'Calle 65, Ciudad 19', '2023-01-26'),
('Victoria Herrera', 84127653, 'victoria.herrera@email.com', '(798)-341-7592', 'Calle 30, Ciudad 20', '2024-05-11'),
('Maximiliano Vidal', 57891423, 'maximiliano.vidal@email.com', '(684)-925-4731', 'Calle 90, Ciudad 36', '2022-04-15'),
('Romina Figueroa', 73924581, 'romina.figueroa@email.com', '(315)-497-2369', 'Calle 27, Ciudad 17', '2023-03-28'),
('Emiliano Salas', 91472853, 'emiliano.salas@email.com', '(643)-872-1954', 'Calle 51, Ciudad 26', '2020-08-16'),
('Isidora Peña', 47389126, 'isidora.peña@email.com', '(519)-381-4762', 'Calle 39, Ciudad 45', '2024-09-20'),
('Nicolás Contreras', 85173924, 'nicolás.contreras@email.com', '(826)-157-2493', 'Calle 35, Ciudad 50', '2021-06-10'),
('Constanza Aguirre', 78431956, 'constanza.aguirre@email.com', '(732)-948-6721', 'Calle 71, Ciudad 24', '2022-02-12'),
('Tomás Navarro', 61738249, 'tomás.navarro@email.com', '(471)-295-3178', 'Calle 26, Ciudad 30', '2023-11-08'),
('Francisca Espinoza', 84621739, 'francisca.espinoza@email.com', '(932)-675-4812', 'Calle 13, Ciudad 27', '2024-03-05'),
('Martín Arriagada', 92731845, 'martín.arriagada@email.com', '(754)-491-2736', 'Calle 99, Ciudad 23', '2020-01-30'),
('Camila Morales', 51792384, 'camila.morales@email.com', '(319)-627-1489', 'Calle 22, Ciudad 46', '2021-05-18'),
('Jorge Herrera', 63291847, 'jorge.herrera@email.com', '(768)-924-5813', 'Calle 60, Ciudad 15', '2022-08-25'),
('Josefa Torres', 81247395, 'josefa.torres@email.com', '(415)-832-9641', 'Calle 56, Ciudad 13', '2023-10-14'),
('Vicente Álvarez', 94127835, 'vicente.álvarez@email.com', '(527)-139-8475', 'Calle 47, Ciudad 25', '2024-06-17'),
('Carolina Díaz', 75124896, 'carolina.díaz@email.com', '(694)-372-9485', 'Calle 50, Ciudad 38', '2021-03-22'),
('Pablo Saavedra', 68391247, 'pablo.saavedra@email.com', '(826)-491-2753', 'Calle 42, Ciudad 47', '2020-09-28'),
('Renata Urrutia', 91782364, 'renata.urrutia@email.com', '(518)-297-3624', 'Calle 44, Ciudad 11', '2023-12-09'),
('Felipe Cáceres', 52479831, 'felipe.cáceres@email.com', '(741)-982-4736', 'Calle 32, Ciudad 22', '2022-05-21'),
('Gabriela Vera', 81749235, 'gabriela.vera@email.com', '(928)-731-6472', 'Calle 21, Ciudad 49', '2021-08-04'),
('Matías Sepúlveda', 74318952, 'matías.sepulveda@email.com', '(673)-241-8395', 'Calle 63, Ciudad 33', '2024-07-16'),
('Rafael Parra', 64192835, 'rafael.parra@email.com', '(843)-572-4918', 'Calle 74, Ciudad 21', '2022-06-29'),
('Ignacia Soto', 78531942, 'ignacia.soto@email.com', '(947)-138-4795', 'Calle 15, Ciudad 16', '2020-11-11'),
('Daniel Zambrano', 91247835, 'daniel.zambrano@email.com', '(513)-294-6871', 'Calle 88, Ciudad 18', '2021-04-27'),
('Bárbara Montes', 67512438, 'bárbara.montes@email.com', '(829)-674-1239', 'Calle 97, Ciudad 48', '2023-10-31'),
('Esteban Cifuentes', 83741592, 'esteban.cifuentes@email.com', '(478)-915-6372', 'Calle 66, Ciudad 10', '2022-01-13'),
('Alicia Leiva', 52749831, 'alicia.leiva@email.com', '(319)-874-5293', 'Calle 79, Ciudad 36', '2024-02-22');

INSERT INTO Products.Products (ProductName, Description, Price, StockQuantity)
VALUES
('Wireless Mouse', 'Ergonomic design with 2.4GHz wireless connection', 25.99, 150),
('Laptop Stand', 'Adjustable aluminum stand for laptops and tablets', 45.50, 80),
('Bluetooth Speaker', 'Portable speaker with deep bass and 12-hour battery life', 59.99, 60),
('USB-C Charging Cable', 'Fast charging cable for smartphones and tablets', 12.99, 200),
('Office Chair', 'Ergonomic office chair with lumbar support', 129.99, 30),
('Standing Desk', 'Adjustable height standing desk', 249.99, 10),
('Noise Cancelling Headphones', NULL, 199.99, 40),
('Smartwatch', 'Water-resistant smartwatch with heart rate monitor', 149.99, 25),
('LED Desk Lamp', 'Dimmable LED lamp with USB charging port', 39.99, 50),
('Mechanical Keyboard', 'RGB mechanical keyboard with blue switches', 89.99, 75),
('Gaming Mousepad', 'Extended mousepad with anti-slip base', 19.99, 90),
('Fitness Tracker', 'Lightweight fitness tracker with step counter', 79.99, 35),
('Electric Kettle', '1.7L stainless steel electric kettle', 34.99, 60),
('Air Purifier', 'HEPA air purifier for large rooms', 199.99, 15),
('Wireless Earbuds', NULL, 69.99, 45),
('Coffee Maker', 'Programmable drip coffee maker with 12-cup capacity', 99.99, 20),
('Smart Light Bulb', 'Wi-Fi LED bulb compatible with Alexa & Google Home', 14.99, 150),
('Robot Vacuum', 'Automatic vacuum cleaner with smart navigation', 249.99, 12),
('Portable Power Bank', '10,000mAh fast-charging power bank', 29.99, 80),
('Graphic Tablet', 'Professional drawing tablet with pen pressure sensitivity', 219.99, 10),
('Wireless Charger', 'Qi-compatible wireless charging pad', 22.99, 120),
('External Hard Drive', '2TB USB 3.0 external storage drive', 89.99, 50),
('Smart Doorbell', NULL, 179.99, 18),
('Smart Thermostat', 'Energy-saving thermostat with Wi-Fi control', 129.99, 25),
('HDMI Cable', '6ft high-speed HDMI cable for 4K UHD', 9.99, 200),
('Noise Cancelling Earplugs', 'Reusable silicone earplugs for noise reduction', 15.99, 90),
('Smart Security Camera', 'Wi-Fi security camera with night vision', 109.99, 30),
('Leather Wallet', NULL, 49.99, 45),
('Men’s Wristwatch', 'Stainless steel analog wristwatch with leather strap', 79.99, 38),
('Wireless Gaming Controller', 'Bluetooth gaming controller compatible with PC & PS5', 59.99, 25),
('Sunglasses', 'Polarized sunglasses with UV protection', 19.99, 100),
('Travel Backpack', 'Waterproof backpack with multiple compartments', 64.99, 60),
('Cordless Drill', '18V cordless drill with two batteries', 129.99, 35),
('Multi-Tool Kit', 'Stainless steel multi-tool with 12 functions', 39.99, 80),
('Adjustable Dumbbells', 'Pair of adjustable dumbbells (5-50 lbs each)', 299.99, 15),
('Yoga Mat', 'Non-slip yoga mat with carrying strap', 24.99, 120),
('Running Shoes', 'Lightweight and breathable running shoes', 79.99, 50),
('LED Flashlight', 'Rechargeable high-lumen LED flashlight', 27.99, 70),
('Camping Tent', '4-person waterproof camping tent', 149.99, 20),
('Portable Grill', 'Compact charcoal grill for outdoor cooking', 59.99, 30),
('Electric Scooter', NULL, 349.99, 8),
('E-Book Reader', '6-inch e-ink display with adjustable brightness', 129.99, 25),
('Streaming Media Player', '4K streaming device with voice control', 49.99, 60),
('Car Phone Mount', 'Magnetic dashboard mount for smartphones', 14.99, 150),
('Smart Scale', 'Body composition scale with Bluetooth tracking', 39.99, 90),
('Wireless Printer', 'All-in-one inkjet printer with Wi-Fi', 159.99, 20),
('Dash Cam', 'Full HD dashboard camera with night vision', 89.99, 30),
('Digital Photo Frame', 'Wi-Fi digital frame with cloud storage', 129.99, 18),
('Gourmet Coffee Beans', 'Organic whole bean coffee, 1lb', 14.99, 100),
('Electric Toothbrush', 'Rechargeable electric toothbrush with 3 modes', 49.99, 45),
('Facial Cleansing Brush', 'Waterproof electric facial brush', 29.99, 60),
('Luxury Scented Candles', 'Set of 3 handmade scented candles', 39.99, 80),
('Essential Oil Diffuser', NULL, 44.99, 50),
('Dog Bed', 'Orthopedic pet bed for small and medium dogs', 59.99, 40),
('Cat Scratching Post', 'Tall scratching post with sisal rope', 39.99, 55),
('Hair Dryer', 'Professional ionic hair dryer with attachments', 89.99, 30),
('Electric Shaver', 'Cordless waterproof shaver for men', 69.99, 45),
('Professional Chef’s Knife', '8-inch stainless steel kitchen knife', 34.99, 90),
('Non-Stick Frying Pan', '12-inch non-stick pan with ergonomic handle', 29.99, 100),
('Glass Food Storage Containers', 'Set of 5 airtight glass containers', 49.99, 75),
('Hand Mixer', '5-speed hand mixer with stainless steel beaters', 39.99, 50),
('Vacuum Sealer', 'Food vacuum sealer with starter bags', 99.99, 30),
('Air Fryer', '4-quart digital air fryer with preset functions', 129.99, 25),
('Portable Blender', 'USB rechargeable blender for smoothies', 34.99, 90),
('Cocktail Shaker Set', 'Complete bartender set with shaker and accessories', 44.99, 65),
('Wine Aerator', 'Red wine aerator and pourer', 19.99, 120),
('Smart TV 55”', 'Ultra HD 4K Smart TV with streaming apps', 699.99, 12),
('Video Doorbell', 'Wireless video doorbell with motion detection', 149.99, 20),
('Home Projector', NULL, 179.99, 15),
('Gaming Monitor', '27-inch 144Hz gaming monitor with FreeSync', 299.99, 18),
('Smart Plug', 'Wi-Fi smart plug with app control', 15.99, 150),
('USB Desk Fan', 'Compact USB-powered desk fan', 12.99, 200),
('Anti-Theft Backpack', 'Travel backpack with hidden compartments', 79.99, 50),
('Compact Hair Straightener', 'Mini hair straightener for travel', 29.99, 80);

INSERT INTO Orders.Orders (CustomerID, OrderDate, Status, TotalAmount)
VALUES
(5, '2024-01-15', 'Pending', NULL),
(12, '2024-02-10', 'Shipped', 189.99),
(8, '2024-01-28', 'Delivered', 89.50),
(15, '2023-12-22', 'Cancelled', 0.00),
(21, '2024-03-01', 'Pending', NULL),
(30, '2024-02-17', 'Delivered', 342.79),
(7, '2024-02-14', 'Shipped', 49.99),
(3, '2024-01-05', 'Returned', 74.25),
(18, '2023-12-30', 'Pending', NULL),
(22, '2024-02-26', 'Delivered', 199.99),
(14, '2024-01-12', 'Shipped', 125.50),
(29, '2023-12-05', 'Cancelled', 0.00),
(33, '2024-02-20', 'Delivered', 58.75),
(9, '2024-01-27', 'Pending', NULL),
(11, '2024-02-07', 'Shipped', 412.50),
(4, '2024-01-02', 'Delivered', 120.00),
(17, '2024-03-04', 'Pending', NULL),
(27, '2024-01-18', 'Shipped', 99.99),
(20, '2023-12-28', 'Delivered', 309.25),
(6, '2024-02-22', 'Cancelled', 0.00),
(32, '2024-03-06', 'Shipped', 239.75),
(10, '2024-01-08', 'Delivered', 182.00),
(25, '2024-02-04', 'Pending', NULL),
(1, '2024-02-14', 'Returned', 65.99),
(34, '2024-01-21', 'Shipped', 378.99),
(16, '2024-02-29', 'Delivered', 45.50),
(2, '2024-02-10', 'Pending', NULL),
(26, '2024-01-11', 'Cancelled', 0.00),
(13, '2023-12-15', 'Delivered', 98.75),
(31, '2024-02-28', 'Shipped', 147.00),
(19, '2023-12-31', 'Returned', 74.25),
(24, '2024-03-02', 'Pending', NULL),
(28, '2024-01-03', 'Shipped', 89.50),
(35, '2024-02-25', 'Delivered', 125.00),
(23, '2024-01-14', 'Cancelled', 0.00),
(5, '2024-01-25', 'Shipped', 199.99),
(9, '2024-02-18', 'Delivered', 63.20),
(12, '2024-03-05', 'Pending', NULL),
(15, '2023-12-20', 'Shipped', 212.49),
(22, '2024-02-12', 'Delivered', 79.99),
(8, '2024-01-31', 'Pending', NULL),
(14, '2024-02-06', 'Returned', 112.00),
(29, '2024-01-19', 'Shipped', 285.75),
(7, '2023-12-27', 'Cancelled', 0.00),
(3, '2024-02-01', 'Delivered', 98.75),
(17, '2024-02-23', 'Shipped', 74.25),
(27, '2024-01-26', 'Pending', NULL),
(21, '2024-03-08', 'Delivered', 124.99),
(20, '2024-01-09', 'Cancelled', 0.00),
(11, '2024-02-19', 'Shipped', 175.99),
(10, '2024-02-08', 'Delivered', 45.99),
(4, '2024-03-09', 'Pending', NULL),
(26, '2023-12-18', 'Shipped', 67.89),
(30, '2024-02-16', 'Returned', 91.25),
(1, '2024-02-24', 'Delivered', 102.30);

INSERT INTO Orders.OrderDetails (OrdersID, ProductID, Quantity, UnitPrice)
VALUES
(5, 3, 2, 59.99),
(12, 8, 1, 149.99),
(8, 14, 3, 34.99),
(15, 1, 1, 25.99),
(21, 22, 2, 89.99),
(30, 5, 4, 129.99),
(7, 7, 1, 199.99),
(3, 12, 2, 79.99),
(18, 4, 5, 12.99),
(22, 10, 1, 89.99),
(14, 16, 3, 99.99),
(29, 18, 2, 249.99),
(33, 9, 1, 39.99),
(9, 24, 2, 179.99),
(11, 28, 4, 58.75),
(4, 2, 3, 45.50),
(17, 6, 1, 249.99),
(27, 15, 2, 69.99),
(20, 11, 5, 19.99),
(6, 19, 3, 29.99),
(32, 21, 1, 22.99),
(10, 25, 2, 129.99),
(25, 30, 3, 79.99),
(1, 26, 1, 9.99),
(34, 31, 2, 64.99),
(16, 13, 4, 79.99),
(2, 29, 5, 147.00),
(26, 20, 3, 309.25),
(13, 27, 1, 39.99),
(31, 17, 2, 249.99),
(19, 23, 3, 79.99),
(24, 32, 1, 59.99),
(28, 33, 4, 34.99),
(35, 34, 2, 24.99),
(23, 35, 3, 79.99),
(5, 36, 1, 27.99),
(9, 37, 2, 149.99),
(12, 38, 3, 59.99),
(15, 39, 4, 49.99),
(22, 40, 1, 14.99),
(8, 41, 5, 249.99),
(14, 42, 2, 69.99),
(29, 43, 1, 14.99),
(7, 44, 3, 79.99),
(3, 45, 2, 19.99),
(17, 46, 4, 64.99),
(27, 47, 1, 129.99),
(21, 48, 2, 99.99),
(6, 49, 3, 39.99),
(32, 50, 4, 89.99),
(10, 51, 1, 27.99),
(25, 52, 2, 59.99),
(1, 53, 3, 129.99),
(34, 54, 1, 179.99),
(16, 55, 2, 199.99),
(2, 56, 3, 19.99),
(26, 57, 4, 125.99),
(13, 58, 1, 98.75),
(31, 59, 2, 74.25),
(19, 60, 3, 412.50),
(24, 61, 4, 29.99),
(28, 62, 1, 102.30),
(35, 63, 2, 45.50),
(23, 64, 3, 78.99),
(5, 65, 4, 309.99),
(9, 66, 1, 17.99),
(12, 67, 2, 249.99),
(15, 68, 3, 182.00),
(22, 69, 4, 125.99),
(8, 70, 1, 58.75),
(14, 71, 2, 98.75),
(29, 72, 3, 74.25),
(7, 73, 4, 239.75),
(3, 74, 1, 99.99),
(17, 75, 2, 67.89),
(27, 76, 3, 91.25),
(21, 77, 4, 175.99),
(6, 78, 1, 45.99),
(32, 79, 2, 124.99),
(10, 80, 3, 239.99),
(25, 81, 4, 125.00),
(1, 82, 1, 89.50),
(34, 83, 2, 199.99),
(16, 84, 3, 63.20),
(2, 85, 4, 212.49),
(26, 86, 1, 79.99),
(13, 87, 2, 112.00),
(31, 88, 3, 285.75),
(19, 89, 4, 74.25),
(24, 90, 1, 98.75),
(28, 91, 2, 74.25),
(35, 92, 3, 412.50),
(23, 93, 4, 29.99),
(5, 94, 1, 102.30),
(9, 95, 2, 45.50),
(12, 96, 3, 78.99),
(15, 97, 4, 309.99),
(22, 98, 1, 17.99),
(8, 99, 2, 249.99),
(14, 100, 3, 182.00);


-- (2) - AGREGAR COLUMNA A CUSTOMERS
ALTER TABLE Customers.Customers 
ADD DateBirth DATE;

UPDATE Customers.Customers 
SET DateBirth = 
	CASE
		WHEN CustomerID = 1 THEN '1952-03-21'
		WHEN CustomerID = 2 THEN '1987-07-12'
		WHEN CustomerID = 3 THEN '1990-05-30'
		WHEN CustomerID = 4 THEN '1978-11-08'
		WHEN CustomerID = 5 THEN '2000-06-25'
		WHEN CustomerID = 6 THEN '1963-09-14'
		WHEN CustomerID = 7 THEN '1995-12-04'
		WHEN CustomerID = 8 THEN '1981-01-20'
		WHEN CustomerID = 9 THEN '2002-04-15'
		WHEN CustomerID = 10 THEN '1956-08-09'
		WHEN CustomerID = 11 THEN '1974-10-31'
		WHEN CustomerID = 12 THEN '1989-02-22'
		WHEN CustomerID = 14 THEN '1998-07-29'
		WHEN CustomerID = 15 THEN '1968-05-03'
		WHEN CustomerID = 16 THEN '1950-12-11'
		WHEN CustomerID = 20 THEN '1993-03-27'
		WHEN CustomerID = 27 THEN '1995-08-03'
		WHEN CustomerID = 22 THEN '2000-08-03'
		WHEN CustomerID = 40 THEN '2002-02-01'
		WHEN CustomerID = 54 THEN '1976-10-14'
		WHEN CustomerID = 65 THEN '1999-12-12'
		WHEN CustomerID = 71 THEN '2001-04-27'
		ELSE DateBirth
	END;

-- 2.1 - MODIFICAR EL TAMAÑO DE LA COLUMNA "Description" EN "Products"
ALTER TABLE Products.Products
ALTER COLUMN Description NVARCHAR(150);	

-- (3) - PROCEDIMIENTOS ALMACENADOS: 
-- 3.1 - CREAR UN PROCEDIMIENTO "sp_InsertOrder" PARA INSERTAR UNA NUEVA ORDEN Y DEVOLVER EL ID GENERADO

CREATE PROCEDURE sp_InsertOrder
	@CustomerID INT,
	@OrderDate DATETIME = NULL,
	@Status NVARCHAR(50),
	@TotalAmount DECIMAL(10,2)
AS
BEGIN
	SET NOCOUNT ON;

	IF @OrderDate IS NULL
		SET @OrderDate = GETDATE();

	BEGIN TRY
		
		--INSERTA LA NUEVA ORDEN EN LA TABLA 
		INSERT INTO Orders.Orders (CustomerID, OrderDate, Status, TotalAmount)
		VALUES (@CustomerID, @OrderDate, @Status, @TotalAmount)

		-- RETORNA EL ID DE LA  ORDEN RECIEN INSERTADA
		SELECT SCOPE_IDENTITY() AS NewOrderID;
	
	END TRY

	BEGIN CATCH
		
		-- EN CASO DE ERROR CAPTURA Y DEVUELVE EL ERROR
		DECLARE @ErrorMessage NVARCHAR(4000),
				@ErrorSeverity INT,
				@ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		RETURN;
	
	END CATCH
END;
GO

EXEC sp_InsertOrder
	@CustomerID = 6,
	@Status = 'Delivered',
	@TotalAmount = 155.50 



-- 3.2 -*CREAR UN PROCEDIMIENTO ALMACENADO QUE PERMITA AGREGAR UN NUEVO CLIENTE A LA TABLA "Customers"
--		* SI DateBirth NO ES PROPORCIONADO, DEBE SER NULL
--		* RETORNAR EL CustomerID GENERADO
CREATE PROCEDURE sp_InsertCustomer
	@FullName NVARCHAR(100),
	@DNI INT,
	@Email NVARCHAR(50),
	@PhoneNumber NVARCHAR(30),
	@Address NVARCHAR(50),
	@CreatedAt DATETIME = NULL,
	@DateBirth DATE = NULL
AS 
BEGIN
	
	SET NOCOUNT ON;

	IF @FullName IS NULL OR @Email IS NULL
	BEGIN
		RAISERROR ('FullName y Email son obligatorios', 16, 1);
		RETURN;
	END;

	IF @CreatedAt IS NULL
		SET @CreatedAt = GETDATE();

	BEGIN TRY
		
		INSERT INTO Customers.Customers(FullName, DNI, Email, PhoneNumber, Address, CreatedAt, DateBirth)
		VALUES (@FullName, @DNI, @Email, @PhoneNumber, @Address, @CreatedAt, @DateBirth)

		SELECT SCOPE_IDENTITY()  AS NewCustomerID

	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000),
				@ErrorSeverity INT,
				@ErrorState INT;
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();
		
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		RETURN;
	END CATCH
END;
GO

EXEC sp_InsertCustomer
	@FullName = 'Pepe Honguito',
	@DNI = 12264898,
	@Email = 'pepeelhongo@gmail.com',
	@PhoneNumber = '2614557645',
	@Address = 'Calle Falsa 123 - La City'



-- 3.3 - LISTAR TODOS LOS PEDIDOS DE UN CLIENTE DADO SU "CustomerID"
--		* CREAR EL SP "sp_GetCustomersOrders"
--		* DEBE RECIBIR EL "CustomerID" COMO PARÁMETRO
--		* RETORNAR TODOS LOS PEDIDOS DE ESE CLIENTE ORDENADOS POR FECHA DESCENDENTE

CREATE PROCEDURE sp_GetCustomersOrders
	@CustomerID INT
AS
BEGIN
	
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM Customers.Customers WHERE CustomerID = @CustomerID)
	BEGIN 
		RAISERROR ('El cliente no existe', 16, 1)
		RETURN;
	END;

	BEGIN TRY
		
		SELECT c.FullName, c.CustomerID, (od.Quantity * od.UnitPrice) AS Total, o.OrderDate, p.ProductName, p.Description
		FROM Customers.Customers AS c
		INNER JOIN Orders.Orders AS o
			ON c.CustomerID = o.CustomerID
		INNER JOIN Orders.OrderDetails AS od
			ON o.OrdersID = od.OrdersID
		INNER JOIN Products.Products AS p
			ON od.ProductID = p.ProductID
		WHERE c.CustomerID = @CustomerID
		ORDER BY o.OrderDate DESC;

	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000),
				@ErrorSeverity INT,
				@ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	
	END CATCH
END;
GO

EXEC sp_GetCustomersOrders
	@CustomerID = 1


-- 3.4 - CREAR UN PROCEDIMIENTO "sp_UpdateOrderStatus" QUE PERMITA CAMBIAR EL ESTADO DE UNA ORDEN
--		* DEBE RECIBIR: "@OrderID" (ORDEN A MODIFICAR), @NewStatus (EL NUEVO ESTADO DE LA ORDEN)
--		* DEBE VALIDAR: "@OrderID" EXISTA EN Orders.Orders, @NewStatus SEA UN VALOR VÁLIDO
--		* SI LA ORDEN NO EXISTE DEBE LANZAR UN "RAISERROR"

CREATE PROCEDURE sp_UpdateOrderStatus
	@OrderID INT,
	@NewStatus NVARCHAR(50)

AS
BEGIN 
	
	SET NOCOUNT ON; 
	
	-- VALIDAR QUE "OrderID" EXISTE
	IF NOT EXISTS (SELECT 1 FROM Orders.Orders WHERE OrdersID = @OrderID)
	BEGIN
		RAISERROR ('El N° de Orden no existe.', 16, 1)
		RETURN;
	END;

	-- VALIDAR QUE "NewStatus" SEA UN VALOR VÁLIDO
	IF @NewStatus NOT IN ('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Returned')
	BEGIN
		RAISERROR ('El estado "NewStatus" no es un valor válido.', 16, 1)
		RETURN;
	END;

	BEGIN TRY
		
		UPDATE Orders.Orders
		SET Status = @NewStatus
		WHERE OrdersID = @OrderID;

		PRINT 'Estado actualizado correctamente. OrderID: ' + CAST(@OrderID AS NVARCHAR(15));

	END TRY
	BEGIN CATCH
		
		DECLARE @MessageError NVARCHAR(4000),
				@MessageSeverity INT,
				@MessageState INT;

		SELECT @MessageError = ERROR_MESSAGE(),
				@MessageSeverity = ERROR_SEVERITY(),
				@MessageState = ERROR_STATE();
		RAISERROR (@MessageError, @MessageSeverity, @MessageState);

	END CATCH
END;
GO


EXEC sp_UpdateOrderStatus
	@OrderID = 6,
	@NewStatus = 'Shipped'


-- 3.5 - CREAR UN PROCEDIMIENTO "sp_InsertOrderWithDetails" QUE INSERTE UN NUEVO PEDIDO EN Orders.Orders Y MÚLTIPLES PRODUCTOS EN Orders.OrdersDetails
--		* DEBE RECIBIR: "@CustomerID", "@OrderDate", "Products" (LISTA DE PRODUCTOS Y CANTIDADES EN FORMATO "TABLE TYPE")
--		* DEBE VALIDAR: "@CustomerID" EXISTA EN Customers.Customers / LOS PRODUCTOS EN @Products EXISTAN EN Products.Products / LA CANTIDAD DE CADA PRODUCTO SEA MAYOR A 0
--		* DEBE DEVOLVER: EL "OrderID" GENERADO


-- CREAMOS LA TABLE TYPE
CREATE TYPE ProductListType AS TABLE (
	ProductID INT NOT NULL,
	Quantity INT NOT NULL CHECK (Quantity > 0)
);
GO

CREATE PROCEDURE sp_InsertOrderWithDetails
	@CustomerID INT,
	@OrderDate DATETIME = NULL,
	@Products ProductListType READONLY
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @OrderID INT; -- ¿QUÉ HACE?

	-- VALIDAR QUE EL CLIENTE EXISTE
	IF NOT EXISTS (SELECT 1 FROM Customers.Customers WHERE CustomerID = @CustomerID)
	BEGIN 
		RAISERROR ('El cliente con ID %d no existe.', 16, 1, @CustomerID)
		RETURN;
	END;

	-- VALIDAR QUE TODOS LOS PRODUCTOS EXISTEN EN Products.Products
	IF EXISTS (
		SELECT p.ProductID
		FROM @Products p
		LEFT JOIN Products.Products pp ON p.ProductID = pp.ProductID
		WHERE pp.ProductID IS NULL
	)
	BEGIN 
		RAISERROR ('Uno o más productos no existen en la base de datos.', 16, 1);
		RETURN;
	END;

	-- SI @OrderDate ES NULL, ASIGNAR LA FECHA ACTUAL
	IF @OrderDate IS NULL
		SET @OrderDate = GETDATE();

	BEGIN TRANSACTION; --¿QUÉ HACE?
	BEGIN TRY
	
		-- INSERTAR LA ORDEN EN Orders.Orders
		INSERT INTO Orders.Orders (CustomerID, OrderDate, Status, TotalAmount) 
		VALUES (@CustomerID, @OrderDate, 'Pending', 0); --¿POR QUÉ SE ESPECIFICA "Pending" Y "0"?

		-- OBTENER EL ID DE LA ORDEN RECIÉN CREADA
		SET @OrderID = SCOPE_IDENTITY()

		-- INSERTAR LOS PRODUCTOS EN "OrderDetails"
		INSERT INTO Orders.OrderDetails (OrdersID, ProductID, Quantity, UnitPrice)
		SELECT @OrderID, p.ProductID, p.Quantity, pr.Price
		FROM @Products p
		INNER JOIN Products.Products pr ON p.ProductID = pr.ProductID;

		-- CONFIRMAR TRANSACCIÓN
		COMMIT TRANSACTION;

		-- DEVOLVER EL ID DE LA ORDEN CREADA
		SELECT @OrderID AS NewOrderID;

		END TRY
		BEGIN CATCH
			
			DECLARE @MessageError NVARCHAR(4000),
				@MessageSeverity INT,
				@MessageState INT;

		SELECT @MessageError = ERROR_MESSAGE(),
				@MessageSeverity = ERROR_SEVERITY(),
				@MessageState = ERROR_STATE();
		RAISERROR (@MessageError, @MessageSeverity, @MessageState);

	END CATCH
END;
GO

-- DECLARAR LA VARIABLE DEL TIPO TABLA 
DECLARE @OrderProducts ProductListType;

-- INSERTAR PRODUCTOS EN LA VARIABLE
INSERT INTO @OrderProducts (ProductID, Quantity)
VALUES	(1,2),
		(3,1),
		(5,1);

-- LLAMAR AL PROCEDIMIENTO
EXEC sp_InsertOrderWithDetails
	@CustomerID = 6,
	@OrderDate = NULL,
	@Products = @OrderProducts




-- (4) FUNCIONES ESCALARES

-- 4.1 - OBTENER EL NOMBRE COMPLETO DE UN CLIENTE
--		* RECIBE "CustomerID" Y DEVUELVE "FullName"
--		* LA FUNCIÓN DEBE SER ESCALAR 
--		* SI EL "CustomerID" NO EXISTE, DEBE DEVOLVER "Cliente no encontrado"


CREATE FUNCTION ufn_CustomerName
(
	@CustomerID INT
)
RETURNS NVARCHAR(50)
BEGIN
	
	IF NOT EXISTS (SELECT 1 FROM Customers.Customers WHERE CustomerID = @CustomerID)
	BEGIN
		RETURN CONCAT('El cliente con el ID ', @CustomerID, ' no existe.')
	END;
	
	DECLARE @CustomerName NVARCHAR(50)

	SELECT @CustomerName = FullName 
	FROM Customers.Customers
	WHERE CustomerID = @CustomerID;

	RETURN @CustomerName;
END;
GO

-- LLAMADO A LA FUNCIÓN
SELECT dbo.ufn_CustomerName(6) AS NombreCliente


-- 4.2	- OBTENER EL CORREO ELECTRÓNICO DE UN CLIENTE DADO SU "CustomerID"
--		* RECIBE "CustomerID" Y DEVUELVE "Email"
--		* SI EL "CustomerID" NO EXISTE, DEVUELVE "Cliente no encontrado"

CREATE FUNCTION ufn_GetEmail
(
	@CustomerID INT
)
RETURNS NVARCHAR(50)
BEGIN
	
	IF NOT EXISTS (SELECT 1 FROM Customers.Customers WHERE CustomerID = @CustomerID)
	BEGIN
		RETURN CONCAT('El cliente con el ID ', @CustomerID, ' no existe.')
	END;

	DECLARE @Email NVARCHAR(50)

	SELECT @Email = Email
	FROM Customers.Customers
	WHERE CustomerID = @CustomerID;

	RETURN @Email;
END;
GO

SELECT dbo.ufn_GetEmail(6) AS EmailCliente;



-- 4.3	- CALCULAR EL DESCUENTO APLICADO A UNA ORDEN
--		* RECIBE "TotalAmount"
--		* SI "TotalAmount" > $500: 10% DESCUENTO
--		* SI "TotalAmount" > $1000: 15% DESCUENTO
--		* SI "TotalAmount" < $500: 0% DESCUENTO

CREATE FUNCTION ufn_ApplyDiscount
(
	@TotalAmount DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
BEGIN
	
	DECLARE @Discount DECIMAL(10,2)

	SET @Discount = 
		CASE 
			WHEN @TotalAmount > 1000 THEN @TotalAmount * 0.15
			WHEN @TotalAmount > 500 THEN @TotalAmount * 0.10
			ELSE 0
		END;

	RETURN @Discount;
END;
GO

SELECT dbo.ufn_ApplyDiscount(1001) AS Discount;



-- (5) FUNCIONES DE TABLA EN LÍNEA

-- 5.1	- OBTENER LOS PRODUCTOS EN STOCK
--		* DEVUELVE ProductID, ProductName y StockQuantity
--		* SOLO APARECEN PRODUCTOS CON StockQuantity > 0

CREATE FUNCTION ufn_StockProducts()
RETURNS TABLE
AS
RETURN (
	
	SELECT ProductID, ProductName, StockQuantity
	FROM Products.Products
	WHERE StockQuantity > 0
);
GO

SELECT * FROM dbo.ufn_StockProducts();


-- 5.2	- LISTAR LOS PEDIDOS "Pending" DE LOS CLIENTES
--		* DEVUELVE OrdersID, CustomerID, OrderDate y TotalAmount
--		* SOLO DEBE INCLUIR ÓRDENES CON Status = 'Pending'

CREATE FUNCTION ufn_PendingOrders()
RETURNS TABLE
AS
RETURN (
	
	SELECT OrdersID, CustomerID, OrderDate, TotalAmount
	FROM Orders.Orders
	WHERE Status = 'Pending'
);
GO

SELECT * FROM dbo.ufn_PendingOrders();


-- (6) FUNCIONES DE TABLA CON MULTIPLES SENTENCIAS


-- 6.1	- OBTENER EL HISTORIAL DE COMPRAS DE UN CLIENTE
--		* RECIBE CustomerID
--		* DEVUELVE OrdersID, OrderDate, TotalAmount, ProductName, Quantity

CREATE FUNCTION ufn_GetCustomerOrderHistory
(
	@CustomerID INT
)
RETURNS @CustomersOrders TABLE
(
		OrderID INT,
		OrderDate DATE,
		TotalAmount DECIMAL(10,2),
		ProductName NVARCHAR(50),
		Quantity INT
)
AS
BEGIN

	-- INSERTAR DATOS EN LA TABLA DE RETORNO
	INSERT INTO @CustomersOrders
	SELECT o.OrdersID, o.OrderDate, SUM(od.Quantity * p.Price) AS TotalAmount, p.ProductName, od.Quantity
	FROM Orders.Orders o
	INNER JOIN Orders.OrderDetails od 
		ON o.OrdersID = od.OrdersID
	INNER JOIN Products.Products p
		ON od.ProductID = p.ProductID
	WHERE o.CustomerID = @CustomerID
	GROUP BY o.OrdersID, o.OrderDate, p.ProductName, od.Quantity;

	RETURN;
END;
GO

SELECT * FROM dbo.ufn_GetCustomerOrderHistory(6);


-- 6.2	- OBTENER CLIENTES QUE NUNCA HAN REALIZADO UNA ORDEN
--		* NO RECIBE PARÁMETROS
--		* DEVUELVE CustomerID y FullName


CREATE FUNCTION ufn_GetCustomersWithoutOrders()

	RETURNS @CustomersWithoutOrders TABLE
	(
		CustomerID INT,
		FullName NVARCHAR(50)
	)
	AS 
	BEGIN
		INSERT INTO @CustomersWithoutOrders
		SELECT cu.CustomerID, cu.FullName
		FROM Customers.Customers AS cu
		LEFT JOIN Orders.Orders AS o
			ON cu.CustomerID = o.CustomerID
		WHERE o.OrdersID IS NULL;

		RETURN;
END;
GO

SELECT * FROM dbo.ufn_GetCustomersWithoutOrders();



-- (7) FUNCIONES DE TABLA EN LÍNEA

-- 7.1	- OBTENER CLIENTES CON MAS DE X ÓRDENES
--		* RECIBE UN NÚMERO @MinOrders
--		* DEVUELVE CLIENTES CON AL MENOS ESA CANTIDAD DE ÓRDENES (@MinOrders), CustomerID, FullName, TotalOrders

CREATE FUNCTION ufn_GetCustomersWithOrders
(
	@MinOrders INT
)
RETURNS TABLE
AS 
RETURN 
(
	SELECT c.CustomerID, c.FullName, COUNT(DISTINCT o.OrdersID) AS TotalOrders
	FROM Customers.Customers AS c
	INNER JOIN Orders.Orders AS o
		ON c.CustomerID = o.CustomerID
	GROUP BY c.CustomerID, c.FullName
	HAVING COUNT(DISTINCT o.OrdersID) >= @MinOrders
);
GO

SELECT * FROM ufn_GetCustomersWithOrders(4);


-- 7.2	- LISTAR PRODUCTOS CON BAJO STOCK (MENOR A 20)
--		* DEVUELVE ProductID, ProductName, StockQuantity

CREATE FUNCTION ufn_GetLowStockProducts()
RETURNS TABLE 
AS 
RETURN 
(
	SELECT ProductID, ProductName, StockQuantity
	FROM Products.Products
	WHERE StockQuantity < 20
);
GO

SELECT * FROM ufn_GetLowStockProducts();


-- 7.3	- CREA UNA FUNCIÓN QUE DEVUELVA LOS PRODUCTOS MAS VENDIDOS
--		* RECIBE "TopN" PARA LIMITAR N° DE RESULTADOS
--		* DEVUELVE ProductID, ProductName, TotalSold (Cantidad Vendida)

CREATE FUNCTION ufn_GetoTopSellingProducts
(
	@TopN INT 
)
RETURNS TABLE -- ¿PORU QUÉ SE UTILIZAN DOS RETURNS? ¿EN QUÉ VARÍAN?
AS 
RETURN 
(
	SELECT TOP(@TopN)pr.ProductID, pr.ProductName, SUM(od.Quantity) AS TotalSold
	FROM Products.Products AS pr
	INNER JOIN Orders.OrderDetails AS od
		ON pr.ProductID = od.ProductID
	GROUP BY pr.ProductID, pr.ProductName
	ORDER BY TotalSold DESC
);
GO

SELECT * FROM ufn_GetoTopSellingProducts(10);




-- (8)	VISTAS 


-- 8.1	- VISTA QUE COMBINE INFORMACIÓN DE TABLAS Customers y Orders	
--		* DEBE MOSTRAR ID, FullName, N° Total Pedidos, Suma Total Montos de Pedidos

CREATE VIEW vw_ResumenPedidosClientes AS
	SELECT cu.CustomerID, cu.FullName, SUM(od.Quantity * od.UnitPrice) AS TotalMonto
	FROM Customers.Customers AS cu
	LEFT JOIN Orders.Orders AS o
		ON cu.CustomerID = o.CustomerID
	LEFT JOIN Orders.OrderDetails AS od
		ON o.OrdersID = od.OrdersID
	GROUP BY cu.CustomerID, cu.FullName;
GO

SELECT * FROM vw_ResumenPedidosClientes
ORDER BY TotalMonto DESC;



-- (9) TRIGGERS


-- 9.1	- REGISTRAR EN UNA TABLA DE AUDITORÍA LOS CAMBIOS REALIZADOS EN EL ESTADO DE UNA ORDEN

-- SE CREA LA TABLA AUDITORÍA
CREATE TABLE OrderAudit (
	AuditID INT IDENTITY(1,1) PRIMARY KEY,
	OrderID INT,
	OldStatus NVARCHAR(50),
	NewStatus NVARCHAR(50), 
	ChangeDate DATETIME DEFAULT GETDATE(),
	ChangedBy NVARCHAR(100)	
);

-- SE CREA EL TRIGGER
CREATE TRIGGER trg_AuditOrderStatus
ON Orders.Orders
AFTER UPDATE 
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO OrderAudit (OrderID, OldStatus, NewStatus, ChangedBy)
	SELECT d.OrdersID, d.Status AS OldStatus, i.Status AS NewStatus, SUSER_SNAME()
	FROM deleted d 
	INNER JOIN inserted i  ON d.OrdersID = i.OrdersID
	WHERE d.Status <> i.Status;
END;
GO


UPDATE Orders.Orders
SET Status = 'Pending'
WHERE CustomerID = 1;


-- 9.2	- NO PERMITIR INSERTAR UNA ORDEN SI LA CANTIDAD DE PRODUCTOS SUPERA EL STOCK
--		* CREAR UN INSTEAD OF INSERT 
--		* SI LA CANTIDAD SUPERA EL STOCK, LANZAR UN RAISERROR Y EVITAR LA INSERCIÓN

CREATE TRIGGER trg_StockProductos
	ON Orders.OrderDetails
	INSTEAD OF INSERT 
	AS 
	BEGIN
		
		SET NOCOUNT ON;

		IF EXISTS (
			SELECT 1 
			FROM inserted i
			INNER JOIN Products.Products pr
				ON i.ProductID = pr.ProductID
			WHERE i.Quantity > pr.StockQuantity
		)
		BEGIN
			RAISERROR ('No se puede insertar la órden ya que no hay stock disponible del producto', 16, 1);
			RETURN;
		END;
		
		INSERT INTO OrderDetails (OrdersID, ProductID, Quantity, UnitPrice)
		
		SELECT OrdersID, ProductID, Quantity, UnitPrice 
		FROM inserted;

		-- SE ACTUALIZA EL STOCK EN FUNCIÓN DE LA CANTIDAD DE LA ORDEN
		UPDATE Products.Products 
		SET StockQuantity = StockQuantity - i.Quantity
		FROM Products.Products pr
		INNER JOIN inserted i 
			ON pr.ProductID = i.ProductID;

	END;
	GO


INSERT INTO Orders.OrderDetails (OrdersID, ProductID, Quantity, UnitPrice)
VALUES (5, 2, 3, 1299.99);
