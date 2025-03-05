# ``` | ADMINISTRACIÓN Y OPTIMIZACIÓN EN SQL SERVER | ```

## 📝``` Descripción del Proyecto ```
Este repositorio documenta la administración, optimización y seguridad de bases de datos en SQL Server, utilizando tanto una base de datos de ejemplo (Wide World Importers) como una creada desde cero (MiNegocioDB).
Se han trabajado temas clave como modelado de datos, procedimientos almacenados, triggers, vistas, funciones, optimización de consultas, seguridad.

## 🚀 ``` Tecnologías Utilizadas ```
✅ Microsoft SQL Server 2022 Developer Edition

✅ SQL Server Management Studio (SSMS)

✅ T-SQL (Transact-SQL)

## 🔍 ``` Áreas de Trabajo ```
✔  **Modelado y Administración de Datos**
  - Exploración y análisis de la estructura de tablas y relaciones.
  - Creación de una base de datos propia con Customers, Products, Orders y OrderDetails.
  - Definición de claves primarias, foráneas e índices para mejorar la integridad.

✔  **Optimización de Consultas y Rendimiento**
  - Uso de índices para mejorar tiempos de respuesta.
  - Análisis del Plan de Ejecución para detectar cuellos de botella.
  - Comparación de Index Seek vs Index Scan para evaluar rendimiento.
  - Monitoreo del uso de CPU y memoria en consultas pesadas.

✔ **Procedimientos Almacenados (Stored Procedures)**
      
  🔹 Se desarrollaron procedimientos almacenados para manejar operaciones recurrentes y garantizar la integridad de los datos. Entre sus usos principales se encuentran:
  - Inserción y validación de datos
  
  - Manejo de transacciones

  - Consultas optimizadas
  
✔ **Triggers (Disparadores) para Control y Auditoría**

   🔹Los triggers permiten reaccionar automáticamente ante cambios en la base de datos. Se implementaron para:

  - Control de stock
  
  - Auditoría de cambios en órdenes

  - Restricción de eliminaciones

✔ **Vistas (Views) para Agilizar Consultas**

  🔹Las vistas permiten estructurar consultas predefinidas y optimizar el acceso a la información. Se crearon vistas para:

  - Resumen de pedidos por cliente

  - Historial de pedidos por producto

  - Vista con seguridad integrada (Row-Level Security - RLS)

✔ **Funciones (Scalar y Table-Valued Functions)**

  🔹Se implementaron funciones escalares y de tabla para encapsular lógica reutilizable.

  -  Cálculo de impuestos y montos totales:
  
  - Cantidad de pedidos por cliente:

✔ **Seguridad y Permisos**
  - Creación de usuarios con accesos restringidos (solo lectura, solo inserción).
  - Implementación de Row-Level Security (RLS) para controlar la visibilidad de datos.
  - Uso de roles personalizados para segmentar permisos en el sistema.

🔗 Recursos

📌 Linkedin: [Linkedin](https://www.linkedin.com/in/facundo-dispenza-2ab560298/)

📌 Correo: [Email](mailto:dispenzafacu6@gmail.com)
