
CREATE DATABASE AppleStoreEcommerce;
GO
USE AppleStoreEcommerce;
GO

CREATE TABLE Usuario (
    IdUsuario INT IDENTITY PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(200) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Activo BIT DEFAULT 1
);

CREATE TABLE Categoria (
    IdCategoria INT IDENTITY PRIMARY KEY,
    Codigo NVARCHAR(10) UNIQUE NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200),
    Activo BIT DEFAULT 1
);

CREATE TABLE Producto (
    IdProducto INT IDENTITY PRIMARY KEY,
    SKU NVARCHAR(30) UNIQUE NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NOT NULL,
    Precio DECIMAL(10,2) CHECK (Precio > 0),
    Stock INT CHECK (Stock >= 0),
    ImagenUrl NVARCHAR(300),
    IdCategoria INT NOT NULL,
    Activo BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria)
);

CREATE TABLE Carrito (
    IdCarrito INT IDENTITY PRIMARY KEY,
    IdUsuario INT NOT NULL,
    Estado NVARCHAR(20) DEFAULT 'Activo',
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
    CONSTRAINT UQ_Carrito UNIQUE (IdUsuario, Estado)
);

CREATE TABLE CarritoDetalle (
    IdCarritoDetalle INT IDENTITY PRIMARY KEY,
    IdCarrito INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT CHECK (Cantidad > 0),
    FOREIGN KEY (IdCarrito) REFERENCES Carrito(IdCarrito),
    FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto),
    CONSTRAINT UQ_CarritoProducto UNIQUE (IdCarrito, IdProducto)
);

CREATE TABLE Orden (
    IdOrden INT IDENTITY PRIMARY KEY,
    IdUsuario INT NOT NULL,
    FechaOrden DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2),
    Estado NVARCHAR(20),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

CREATE TABLE OrdenDetalle (
    IdOrdenDetalle INT IDENTITY PRIMARY KEY,
    IdOrden INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    FOREIGN KEY (IdOrden) REFERENCES Orden(IdOrden),
    FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Pago (
    IdPago INT IDENTITY PRIMARY KEY,
    IdOrden INT NOT NULL,
    FechaPago DATETIME DEFAULT GETDATE(),
    Monto DECIMAL(10,2),
    Metodo NVARCHAR(50),
    Estado NVARCHAR(20),
    FOREIGN KEY (IdOrden) REFERENCES Orden(IdOrden)
);
GO


--Arreglos de UNIQUE
ALTER TABLE Carrito
DROP CONSTRAINT UQ_Carrito;
GO

CREATE UNIQUE INDEX UQ_Carrito_Activo
ON Carrito (IdUsuario)
WHERE Estado = 'Activo';
GO




USE AppleStoreEcommerce;
GO

-- Categorías
INSERT INTO Categoria (Codigo, Nombre, Descripcion) VALUES
('IPH','iPhone','Smartphones Apple'),
('MAC','MacBook','Laptops Apple'),
('WAT','Apple Watch','Relojes inteligentes'),
('IPD','iPad','Tablets Apple'),
('AIR','AirPods','Audífonos Apple'),
('ACC','Accesorios','Accesorios Apple');

-- Productos
INSERT INTO Producto (SKU, Nombre, Descripcion, Precio, Stock, IdCategoria) VALUES
-- iPhone
('IPH-15PRO','iPhone 15 Pro','Chip A17 Pro',1299.99,10,1),
('IPH-14','iPhone 14','Chip A16 Bionic',899.99,15,1),

-- MacBook
('MAC-AIR-M2','MacBook Air M2','Ultraligera y potente',1499.99,6,2),
('MAC-PRO-M3','MacBook Pro M3','Alto rendimiento',2499.99,3,2),

-- Apple Watch
('WAT-S9','Apple Watch Series 9','Salud y deporte',499.99,20,3),

-- iPad
('IPD-PRO','iPad Pro','Pantalla XDR',1099.99,6,4),
('IPD-AIR','iPad Air','Ligero y potente',799.99,8,4),

-- AirPods
('AIR-PRO','AirPods Pro','Cancelación de ruido',299.99,12,5),
('AIR-MAX','AirPods Max','Audio premium',549.99,5,5),

-- Accesorios
('ACC-MAGSAFE','Cargador MagSafe','Carga rápida',49.99,25,6),
('ACC-USB-C','Cable USB-C','Cable original',29.99,30,6);

-- Usuarios
INSERT INTO Usuario (Nombre, Email, PasswordHash) VALUES
('Juan Perez','juan@mail.com','123'),
('Ana Torres','ana@mail.com','456');
GO


USE AppleStoreEcommerce;
GO

/* =========================================================
   USUARIO
========================================================= */

CREATE OR ALTER PROCEDURE sp_Usuario_Insertar
@Nombre NVARCHAR(100),
@Email NVARCHAR(100),
@PasswordHash NVARCHAR(200)
AS
BEGIN
    INSERT INTO Usuario (Nombre, Email, PasswordHash)
    VALUES (@Nombre, @Email, @PasswordHash);
END
GO

CREATE OR ALTER PROCEDURE sp_Usuario_Login
@Email NVARCHAR(100),
@PasswordHash NVARCHAR(200)
AS
BEGIN
    SELECT IdUsuario, Nombre, Email
    FROM Usuario
    WHERE Email = @Email
      AND PasswordHash = @PasswordHash
      AND Activo = 1;
END
GO

CREATE OR ALTER PROCEDURE sp_Usuario_Listar
AS
BEGIN
    SELECT IdUsuario, Nombre, Email, FechaRegistro, Activo
    FROM Usuario;
END
GO

CREATE OR ALTER PROCEDURE sp_Usuario_Editar
@IdUsuario INT,
@Nombre NVARCHAR(100),
@Email NVARCHAR(100),
@Activo BIT
AS
BEGIN
    UPDATE Usuario
    SET Nombre = @Nombre,
        Email = @Email,
        Activo = @Activo
    WHERE IdUsuario = @IdUsuario;
END
GO

/* =========================================================
   CATEGORIA
========================================================= */

CREATE OR ALTER PROCEDURE sp_Categoria_Insertar
@Codigo NVARCHAR(10),
@Nombre NVARCHAR(100),
@Descripcion NVARCHAR(200)
AS
BEGIN
    INSERT INTO Categoria (Codigo, Nombre, Descripcion)
    VALUES (@Codigo, @Nombre, @Descripcion);
END
GO

CREATE OR ALTER PROCEDURE sp_Categoria_Listar
AS
BEGIN
    SELECT IdCategoria, Codigo, Nombre, Descripcion
    FROM Categoria
    WHERE Activo = 1;
END
GO

CREATE OR ALTER PROCEDURE sp_Categoria_Editar
@IdCategoria INT,
@Nombre NVARCHAR(100),
@Descripcion NVARCHAR(200),
@Activo BIT
AS
BEGIN
    UPDATE Categoria
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        Activo = @Activo
    WHERE IdCategoria = @IdCategoria;
END
GO

/* =========================================================
   PRODUCTO
========================================================= */

CREATE OR ALTER PROCEDURE sp_Producto_Insertar
@SKU NVARCHAR(30),
@Nombre NVARCHAR(150),
@Descripcion NVARCHAR(500),
@Precio DECIMAL(10,2),
@Stock INT,
@IdCategoria INT
AS
BEGIN
    INSERT INTO Producto (SKU, Nombre, Descripcion, Precio, Stock, IdCategoria)
    VALUES (@SKU, @Nombre, @Descripcion, @Precio, @Stock, @IdCategoria);
END
GO

CREATE OR ALTER PROCEDURE sp_Producto_Listar
AS
BEGIN
    SELECT 
        P.IdProducto,
        P.SKU,
        P.Nombre,
        P.Descripcion,
        P.Precio,
        P.Stock,
        C.Nombre AS Categoria
    FROM Producto P
    INNER JOIN Categoria C ON P.IdCategoria = C.IdCategoria
    WHERE P.Activo = 1;
END
GO

CREATE OR ALTER PROCEDURE sp_Producto_ListarPorCategoria
@IdCategoria INT
AS
BEGIN
    SELECT IdProducto, SKU, Nombre, Precio, Stock
    FROM Producto
    WHERE IdCategoria = @IdCategoria
      AND Activo = 1;
END
GO

CREATE OR ALTER PROCEDURE sp_Producto_Editar
@IdProducto INT,
@Nombre NVARCHAR(150),
@Descripcion NVARCHAR(500),
@Precio DECIMAL(10,2),
@Stock INT,
@IdCategoria INT,
@Activo BIT
AS
BEGIN
    UPDATE Producto
    SET Nombre = @Nombre,
        Descripcion = @Descripcion,
        Precio = @Precio,
        Stock = @Stock,
        IdCategoria = @IdCategoria,
        Activo = @Activo
    WHERE IdProducto = @IdProducto;
END
GO

/* =========================================================
   CARRITO
========================================================= */

CREATE OR ALTER PROCEDURE sp_Carrito_ObtenerActivo
@IdUsuario INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Carrito
        WHERE IdUsuario = @IdUsuario AND Estado = 'Activo'
    )
    BEGIN
        INSERT INTO Carrito (IdUsuario)
        VALUES (@IdUsuario);
    END

    SELECT IdCarrito
    FROM Carrito
    WHERE IdUsuario = @IdUsuario AND Estado = 'Activo';
END
GO

CREATE OR ALTER PROCEDURE sp_Carrito_AgregarProducto
@IdCarrito INT,
@IdProducto INT,
@Cantidad INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM CarritoDetalle
        WHERE IdCarrito = @IdCarrito
          AND IdProducto = @IdProducto
    )
    BEGIN
        UPDATE CarritoDetalle
        SET Cantidad = Cantidad + @Cantidad
        WHERE IdCarrito = @IdCarrito
          AND IdProducto = @IdProducto;
    END
    ELSE
    BEGIN
        INSERT INTO CarritoDetalle (IdCarrito, IdProducto, Cantidad)
        VALUES (@IdCarrito, @IdProducto, @Cantidad);
    END
END
GO

CREATE OR ALTER PROCEDURE sp_Carrito_Ver
    @IdCarrito INT
AS
BEGIN
    SELECT 
        P.Nombre,
        P.Precio,
        CD.Cantidad,
        (P.Precio * CD.Cantidad) AS SubTotal
    FROM CarritoDetalle CD
    INNER JOIN Producto P ON CD.IdProducto = P.IdProducto
    WHERE CD.IdCarrito = @IdCarrito;
END
GO

/* =========================================================
   ORDEN
========================================================= */

CREATE OR ALTER PROCEDURE sp_Orden_Generar
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IdCarrito INT;
    DECLARE @Total DECIMAL(10,2);
    -- Obtener carrito activo
    SELECT @IdCarrito = IdCarrito
    FROM Carrito
    WHERE IdUsuario = @IdUsuario
      AND Estado = 'Activo';
    IF @IdCarrito IS NULL
    BEGIN
        RAISERROR('El usuario no tiene un carrito activo.',16,1);
        RETURN;
    END
    -- Calcular total
    SELECT @Total = SUM(P.Precio * CD.Cantidad)
    FROM CarritoDetalle CD
    JOIN Producto P ON CD.IdProducto = P.IdProducto
    WHERE CD.IdCarrito = @IdCarrito;

    IF @Total IS NULL
    BEGIN
        RAISERROR('El carrito está vacío.',16,1);
        RETURN;
    END
    -- Crear orden
    INSERT INTO Orden (IdUsuario, Total, Estado)
    VALUES (@IdUsuario, @Total, 'Pendiente');
    DECLARE @IdOrden INT = SCOPE_IDENTITY();
    -- Detalle de orden
    INSERT INTO OrdenDetalle (IdOrden, IdProducto, Cantidad, PrecioUnitario)
    SELECT 
        @IdOrden,
        CD.IdProducto,
        CD.Cantidad,
        P.Precio
    FROM CarritoDetalle CD
    JOIN Producto P ON CD.IdProducto = P.IdProducto
    WHERE CD.IdCarrito = @IdCarrito;
    -- Cerrar carrito
    UPDATE Carrito
    SET Estado = 'Cerrado'
    WHERE IdCarrito = @IdCarrito;
END
GO


/* =========================================================
   PAGO
========================================================= */

CREATE OR ALTER PROCEDURE sp_Pago_Registrar
@IdOrden INT,
@Monto DECIMAL(10,2),
@Metodo NVARCHAR(50)
AS
BEGIN
    INSERT INTO Pago (IdOrden, Monto, Metodo, Estado)
    VALUES (@IdOrden, @Monto, @Metodo, 'Exitoso');

    UPDATE Orden
    SET Estado = 'Pagado'
    WHERE IdOrden = @IdOrden;
END
GO

CREATE OR ALTER PROCEDURE sp_Pago_Listar
AS
BEGIN
    SELECT 
        P.IdPago,
        P.IdOrden,
        O.IdUsuario,
        P.Monto,
        P.Metodo,
        P.Estado,
        P.FechaPago
    FROM Pago P
    INNER JOIN Orden O ON P.IdOrden = O.IdOrden;
END
GO

CREATE OR ALTER PROCEDURE sp_Pago_ListarDetallado
AS
BEGIN
    SELECT 
        P.IdPago,
        P.IdOrden,
        U.Nombre       AS Usuario,
        PR.Nombre      AS Producto,
        OD.Cantidad,
        OD.PrecioUnitario,
        (OD.Cantidad * OD.PrecioUnitario) AS SubTotal,
        P.Monto,
        P.Metodo,
        P.Estado,
        P.FechaPago
    FROM Pago P
    INNER JOIN Orden O        ON P.IdOrden = O.IdOrden
    INNER JOIN Usuario U      ON O.IdUsuario = U.IdUsuario
    INNER JOIN OrdenDetalle OD ON O.IdOrden = OD.IdOrden
    INNER JOIN Producto PR    ON OD.IdProducto = PR.IdProducto
    ORDER BY P.FechaPago DESC;
END
GO

CREATE PROCEDURE sp_Pago_ListarPorUsuario
    @IdUsuario INT
AS
BEGIN
    SELECT
        P.IdPago,
        U.IdUsuario,
        U.Nombre AS Usuario,
        O.IdOrden,
        P.Monto,
        P.Metodo,
        P.Estado,
        P.FechaPago,
        PR.Nombre AS Producto,
        OD.Cantidad,
        OD.PrecioUnitario,
        (OD.Cantidad * OD.PrecioUnitario) AS SubTotal
    FROM Pago P
    INNER JOIN Orden O ON P.IdOrden = O.IdOrden
    INNER JOIN Usuario U ON O.IdUsuario = U.IdUsuario
    INNER JOIN OrdenDetalle OD ON O.IdOrden = OD.IdOrden
    INNER JOIN Producto PR ON OD.IdProducto = PR.IdProducto
    WHERE U.IdUsuario = @IdUsuario
    ORDER BY P.FechaPago DESC;
END
GO



--Registrar usuario
EXEC sp_Usuario_Insertar 
    'Carlos Ruiz',
    'carlos@mail.com',
    '123456';

-- Iniciar Sesion
EXEC sp_Usuario_Login 
    'juan@mail.com',
    '123';

--Listar los usuarios
EXEC sp_Usuario_Listar;

--Editar usuario
EXEC sp_Usuario_Editar 
    1,
    'Juan Perez',
    'juan_nuevo@mail.com',
    1;

--Crear una categoria
EXEC sp_Categoria_Insertar 
    'TV',
    'Apple TV',
    'Dispositivos de streaming Apple';

--Listar las categorias
EXEC sp_Categoria_Listar;

--Editar categoria
EXEC sp_Categoria_Editar 
    1,
    'iPhone',
    'Smartphones Apple actualizados',
    1;

--Crear producto 
EXEC sp_Producto_Insertar
    'IPH-16',
    'iPhone 16',
    'Nuevo iPhone generación 2026',
    1399.99,
    10,
    1;

-- Listar productos
EXEC sp_Producto_Listar;


--Listar productos x categoria
EXEC sp_Producto_ListarPorCategoria 1;

--Editar producto
EXEC sp_Producto_Editar
    1,
    'iPhone 15 Pro Max',
    'Versión mejorada',
    1499.99,
    8,
    1,
    1;

--Recuperar o crear carrito del usuario
EXEC sp_Carrito_ObtenerActivo 1;

--Añadir productos al carrito
EXEC sp_Carrito_AgregarProducto
    1,  -- IdCarrito
    3,  -- IdProducto
    2;  -- Cantidad

--Mostrar contenido del carrito
EXEC sp_Carrito_Ver 1;

--Generar orden 
EXEC sp_Orden_Generar 1;

--Listar ordenes por usuario
EXEC sp_Orden_ListarPorUsuario 1;

--Pagar una orden 
EXEC sp_Pago_Registrar
    1,
    2299.97,
    'Tarjeta';

--Listar pagos registrados
EXEC sp_Pago_Listar;

--Listar pagos registrados con detalle
EXEC sp_Pago_ListarDetallado;




-- 1. Crear usuario
EXEC sp_Usuario_Insertar 'Gino Barrena','ginobs123@gmail.com','123';

-- 2. Obtener carrito (DEVUELVE IdCarrito = #)
EXEC sp_Carrito_ObtenerActivo 4;

-- 3. Agregar productos
EXEC sp_Carrito_AgregarProducto 3, 12, 1;
EXEC sp_Carrito_AgregarProducto 3, 8, 1;

-- 4. Ver carrito (USAR IdCarrito)
EXEC sp_Carrito_Ver 3;

-- 5. Generar orden (USAR IdUsuario)
EXEC sp_Orden_Generar 4;

-- 6. Ver orden (OBTENER IdOrden)
EXEC sp_Orden_ListarPorUsuario 4;

-- 7. Pagar (USAR IdOrden)
EXEC sp_Pago_Registrar
    4,          -- IdOrden
    5099.94,    -- Monto
    'Tarjeta';


-- 8. Reportes
EXEC sp_Pago_Listar;
EXEC sp_Pago_ListarDetallado;



EXEC sp_Producto_Listar


-- 2. Obtener carrito (DEVUELVE IdCarrito = #)
EXEC sp_Carrito_ObtenerActivo 2;

-- 3. Agregar productos
EXEC sp_Carrito_AgregarProducto 4, 4, 1;
EXEC sp_Carrito_AgregarProducto 4, 9, 1;
EXEC sp_Carrito_AgregarProducto 4, 11, 1;

-- 4. Ver carrito (USAR IdCarrito)
EXEC sp_Carrito_Ver 4;


-- 5. Generar orden (USAR IdUsuario)
EXEC sp_Orden_Generar 2;

-- 6. Ver orden (OBTENER IdUsuario)
EXEC sp_Orden_ListarPorUsuario 2;

-- 7. Pagar (USAR IdOrden)
EXEC sp_Pago_Registrar
    5,          -- IdOrden
    3079.97,    -- Monto
    'Tarjeta';

-- 8. Reportes
EXEC sp_Pago_Listar;
EXEC sp_Pago_ListarDetallado;

EXEC sp_Pago_ListarPorUsuario 1;

--Genere carrito para el id usuario 1, retorna idCarrito = 6
EXEC sp_Carrito_ObtenerActivo 1;

-- Genera agregar productos con parametros IdCarrito idProducto, y la cantidad
EXEC sp_Carrito_AgregarProducto 6, 1, 1;
EXEC sp_Carrito_AgregarProducto 6, 2, 1;

--Vemos el carrito con los productos seleccionados por el id del carrito(6)
EXEC sp_Carrito_Ver 6;

--Generamos la orden de venta por el idUsuario
EXEC sp_Orden_Generar 1;

--Listamos las ordenes "Pendiente o Pagado" y usamos el idOrden para el siguiente paso
EXEC sp_Orden_ListarPorUsuario 1;

--Registramos el pago con el id de la Orden
EXEC sp_Pago_Registrar
    7,          -- IdOrden
    2399.98,    -- Monto
    'YAPE';

--Generamos el historial de pagos completados por todos los usuarios y tambien detallados
EXEC sp_Pago_Listar;
--Generar reportes para el administrador del sistema
EXEC sp_Pago_ListarDetallado;
--Generamos el historial de pagos por cliente
EXEC sp_Orden_ListarPorUsuario 1;
--Detalles del historial de pago seleccionado por cliente
EXEC sp_Pago_ListarPorUsuario 1;