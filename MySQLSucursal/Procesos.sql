-- ______________________________ INSERCIONES ______________________________
-- Stored Procedure que inserta los articulos actualizados para la sucursal
DELIMITER //
CREATE PROCEDURE InsercionArticulos(IN nArticulos JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nArticulos, '$' );
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nArticulos, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdArticulo, IdProducto, Estado, EstadoArticulo, Costo)
		SELECT CONVERT(JSON_EXTRACT(@temp, '$.IdArticulo'), UNSIGNED), CONVERT(JSON_EXTRACT(@temp, '$.IdProducto'), UNSIGNED), 
				JSON_EXTRACT(@temp, '$.Estado'), JSON_EXTRACT(@temp, '$.EstadoArticulo'), 
                CONVERT(JSON_EXTRACT(@temp, '$.Costo'), UNSIGNED);
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

-- Stored Procedure que almacena los productos nuevo que se ingresen en el inventario
DELIMITER //
CREATE PROCEDURE InsercionProductos(IN nProductos JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    DECLARE largoDetalles INT DEFAULT 0;
    DECLARE contDetalles INT DEFAULT 0;
    SET largo = JSON_LENGTH( nProductos, '$' );
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nProductos, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdProducto, IdMarca, IdTipoArticulo, Codigo, Nombre, Peso, TiempoGarantia, Sexo, Medida)
		SELECT CONVERT(JSON_EXTRACT(@temp, '$.IdProducto'), UNSIGNED), CONVERT(JSON_EXTRACT(@temp, '$.IdMarca'), UNSIGNED), 
				CONVERT(JSON_EXTRACT(@temp, '$.IdTipoArticulo'), UNSIGNED), CONVERT(JSON_EXTRACT(@temp, '$.Codigo'), UNSIGNED), 
                JSON_EXTRACT(@temp, '$.Nombre'), JSON_EXTRACT(@temp, '$.Peso'), 
                CONVERT(JSON_EXTRACT(@temp, '$.TiempoGarantia'), UNSIGNED), JSON_EXTRACT(@temp, '$.Sexo'), 
                JSON_EXTRACT(@temp, '$.Medida');
		CALL InsercionDetalleProducto(JSON_EXTRACT(@temp, '$.detalles'), CONVERT(JSON_EXTRACT(@temp, '$.IdProducto'), UNSIGNED));
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE InsercionDetalleProducto(IN nDetalle JSON, IN IdProducto INT)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nDetalle, '$' );
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nDetalle, CONCAT('$[',cont,']'));
        INSERT INTO DetalleProducto (IdProducto, Detalle, Descripcion)
		SELECT IdProducto, JSON_EXTRACT(@temp, '$.Detalle'), JSON_EXTRACT(@temp, '$.Descripcion');
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsercionMarca(IN nMarca JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nMarca, '$' );
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nMarca, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdMarca, NombreMarca)
		SELECT CONVERT(JSON_EXTRACT(@temp, '$.IdMarca'), UNSIGNED), CONVERT(JSON_EXTRACT(@temp, '$.NombreMarca'), UNSIGNED);
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsercionActualizacionArticuloPunto(IN nActualizacion JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
	DECLARE largo INT DEFAULT 0;
    DECLARE jsontemp JSON;
	INSERT INTO ActualizacionArticuloPunto (IdActualizacionArticuloPunto, FechaInicio, FechaFin)
    SELECT JSON_EXTRACT(nActualizacion, '$.IdActualizacionArticuloPunto'),
			CONVERT(JSON_EXTRACT(nActualizacion,'$.FechaInicio'), DATE), CONVERT(JSON_EXTRACT(nActualizacion, "$.FechaFin"), DATE);
	-- Inserta los productos que corresponden a los puntos
    SET largo = JSON_LENGTH(JSON_EXTRACT(nAtualizacion, '$.Productos'), '$' );
    WHILE (cont < largo) DO
		SET jsontemp = JSON_EXTRACT(JSON_EXTRACT(nAtualizacion, '$.Productos'), CONCAT('$[', cont, ']'));
		INSERT INTO ArticuloPunto (IdProducto, IdActualizacionArticuloPunto, Puntos)
        SELECT CONVERT(JSON_EXTRACT(jsontemp, '$.IdProduto'), UNSIGNED), CONVERT(JSON_EXTRACT(nActualizacion, '$.IdActualizacionArticuloPunto'), UNSIGNED),
				CONVERT(JSON_EXTRACT(jsontemp, '$.Puntos'), UNSIGNED);
        SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

-- Stored Procedure que inserta los empleado actualizados para la sucursal
DELIMITER //
CREATE PROCEDURE InsercionEmpleados(IN nEmpleados JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nEmpleados, '$' );
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nEmpleados, CONCAT('$[',cont,']'));
        CALL InsertarUsuario (JSON_EXTRACT(@temp, '$.Usuario'));
        SET @empleado = JSON_EXTRACT(@temp, 'empleado');
        INSERT INTO Empleado (IdUsuario, FechaIngreso, CuentaBancaria, Estado)
		SELECT U.IdUsuario, JSON_EXTRACT(@empleado, '$.FechaIngreso'), JSON_EXTRACT(@empleado, '$.CuentaBancaria'),
                JSON_EXTRACT(@empleado, '$.Estado') FROM Usuario U
		WHERE U.Identificacion = JSON_EXTRACT(JSON_EXTRACT(@temp, '$.Usuario'), '$.Identificacion');
        INSERT INTO PuestoEmpleado (IdEmpleado, IdPuesto, FechaInicio)
		SELECT E.IdEmpleado, CONVERT(JSON_EXTRACT(@empleado, '$.IdPuesto'), UNSIGNED), CONVERT(JSON_EXTRACT(@empleado, '$.FechaIngreso'), DATE)
        FROM Empleado E
        INNER JOIN Usuario U ON U.IdUsuario = E.IdUsuario
        WHERE U.Identificacion = JSON_EXTRACT(JSON_EXTRACT(@temp, '$.Usuario'), '$.Identificacion');
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarClientes(IN nClientes JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nClientes, '$' );
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nClientes, CONCAT('$[',cont,']'));
        CALL InsertarUsuario (JSON_EXTRACT(@temp, '$.Usuario'));
        INSERT INTO Cliente (IdUsuario, Punto)
		SELECT U.IdUsuario, CONVERT(JSON_EXTRACT(@temp, '$.Puntos'), UNSIGNED) FROM Usuario U
		WHERE U.Identificacion = JSON_EXTRACT(JSON_EXTRACT(@temp, '$.Usuario'), '$.Identificacion');
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

DROP Procedure InsertarUsuario;

DELIMITER //
CREATE PROCEDURE InsertarUsuario(IN nUsuario JSON)
BEGIN
	IF NOT EXISTS(SELECT U.Identificacion FROM Usuario U 
	WHERE U.Identificacion = JSON_EXTRACT(nUsuario, '$.Identificacion')) THEN
		CALL InsertarUbicacion(JSON_EXTRACT(nUsuario, '$.direccion'));
        SELECT * FROM nUsuario;
        INSERT INTO Usuario (IdDireccion, Nombre, Identificacion, ApellidoPat, ApellidoMat, FechaNacimiento, NumeroTelefonico)
        SELECT  D.IdDireccion, JSON_EXTRACT(nUsuario, '$.Nombre'), JSON_EXTRACT(nUsuario, '$.Identificacion'), 
				JSON_EXTRACT(nUsuario, '$.ApellidoPat'), JSON_EXTRACT(nUsuario, '$.ApellidoMat'),
                CONVERT(JSON_EXTRACT(nUsuario, '$.FechaNacimiento'), DATE), JSON_EXTRACT(nUsuario, '$.NumeroTelefonico') 
		FROM Direccion D
        INNER JOIN Ciudad CD ON CD.IdCiudad = D.IdCiudad
        INNER JOIN Canton C ON C.IdCanton = CD.IdCanton
        INNER JOIN Provincia PR ON C.IdProvincia = PR.IdProvincia
        INNER JOIN Pais P ON PR.IdPais = P.IdPais
        WHERE D.Descripcion = JSON_EXTRACT(JSON_EXTRACT(nUsuario, '$.direccion'), '$.direccion');
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarUbicacion(IN nDireccion JSON)
BEGIN
	IF NOT EXISTS(SELECT P.Nombre FROM Pais P
				WHERE REPLACE(P.Nombre, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.pais'), ' ', '')) THEN
		INSERT INTO Pais (Nombre)
        SELECT JSON_EXTRACT(nDireccion, '$.pais');
    END IF;
    IF NOT EXISTS(SELECT PR.Nombre FROM Provincia PR
				INNER JOIN Pais P ON PR.IdPais = P.IdPais
				WHERE REPLACE(PR.Nombre, ' ' , '')= REPLACE(JSON_EXTRACT(nDireccion, '$.provincia'), ' ', '')) THEN
		INSERT INTO Provincia (IdPais, Nombre)
        SELECT P.IdPais, JSON_EXTRACT(nDireccion, '$.provincia')  FROM Pais P 
        WHERE REPLACE(P.Nombre, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.pais'), ' ', '');
    END IF;
    IF NOT EXISTS(SELECT C.Nombre FROM Canton C
				INNER JOIN Provincia PR ON C.IdProvincia = PR.IdProvincia
                INNER JOIN Pais P ON PR.IdPais = P.IdPais
				WHERE REPLACE(C.Nombre, ' ', '')= REPLACE(JSON_EXTRACT(nDireccion, '$.canton'), ' ', '')) THEN
		INSERT INTO Canton (IdProvincia, Nombre)
        SELECT PR.IdProvincia, JSON_EXTRACT(nDireccion, '$.canton') FROM Provincia PR
        INNER JOIN Pais P ON P.IdPais = PR.IdPais
        WHERE REPLACE(PR.Nombre, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.provincia'), ' ', '');
    END IF;
    IF NOT EXISTS(SELECT CD.Nombre FROM Ciudad CD
				INNER JOIN Canton C ON C.IdCanton= CD.IdCanton
                INNER JOIN Provincia PR ON C.IdProvincia = PR.IdProvincia
                INNER JOIN Pais P ON PR.IdPais = P.IdPais
                WHERE REPLACE(CD.Nombre, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.pais'), ' ', '')) THEN
		INSERT INTO Ciudad (IdCanton, Nombre)
        SELECT C.IdCanton, JSON_EXTRACT(nDireccion, '$.ciudad') FROM Canton C
        INNER JOIN Provincia PR ON PR.IdProvincia = C.IdProvincia
        INNER JOIN Pais P ON P.IdPais = PR.IdPais
        WHERE REPLACE(C.Nombre, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.canton'), ' ', '');
    END IF;
    IF NOT EXISTS(SELECT D.Descripcion FROM Direccion D 
				INNER JOIN Ciudad CD ON D.IdCiudad = CD.IdCiudad
				INNER JOIN Canton C ON CD.IdCanton = C.IdCanton
                INNER JOIN Provincia PR ON C.IdProvincia = PR.IdProvincia
                INNER JOIN Pais P ON PR.IdPais = P.IdPais
				WHERE REPLACE(D.Descripcion, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.direccion'), ' ', '')) THEN
		INSERT INTO Direccion (IdCiudad, Descripcion)
        SELECT CD.IdCiudad, JSON_EXTRACT(nDireccion, '$.direccion') FROM Ciudad CD
        INNER JOIN Canton C ON C.IdCanton = CD.IdCanton
        INNER JOIN Provincia PR ON C.IdProvincia = PR.IdProvincia
        INNER JOIN Pais P ON PR.IdPais = P.IdPais
        WHERE REPLACE(CD.Nombre, ' ', '') = REPLACE(JSON_EXTRACT(nDireccion, '$.ciudad'), ' ', '');
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarPuestoEmpleado(IN nPuestoEmpleado JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nEmpleados, '$' );
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nPuestoEmpleado, CONCAT('$[', cont, ']'));
		INSERT INTO PuestoEmpleado (IdEmpleado, IdPuesto, FechaInicio)
		SELECT E.IdEmpleado, CONVERT(JSON_EXTRACT(@temp, '$.IdPuesto'), UNSIGNED), CONVERT(JSON_EXTRACT(@temp, '$.FechaInicio'), DATE)
		FROM Empleado E
		INNER JOIN Usuario U ON U.IdUsuario = E.IdUsuario
		WHERE U.Identificacion = JSON_EXTRACT(@temp, '$.Identificacion');
        SET cont = cont + 1;
	END WHILE;
END //
DELMITER ;

DELIMITER // 
CREATE PROCEDURE AgregarEmpleadoMes()
BEGIN
	INSERT INTO EmpleadoMes (IdEmpleado, Fecha)
	SELECT V.IdEmpleado, CURDATE()
    FROM Venta V
	WHERE V.Fecha BETWEEN DATE(FROM_UNIXTIME(UNIX_TIMESTAMP(curdate()) - 2628000)) AND DATE(curdate()+1)
    ORDER BY COUNT(V.IdEmpleado) DESC LIMIT 1;
END//
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE AgregarAdministradorSucursal(IN empleado INT, IN fecha DATE)
BEGIN
	INSERT INTO AdministradorSucursal (IdEmpleado, Fecha) VALUES 
    (empleado, fecha);
    INSERT INTO PuestoEmpleado (IdEmpleado, IdPuesto, FechaInicio) 
    SELECT empleado, PU.IdPuesto, fecha FROM Puesto puesto
    WHERE PU.NombrePuesto = 'administrador';
END //
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE AgregarPromocion(dias INT, porcentaje SMALLINT)
BEGIN
	INSERT INTO Promocion (FechaHoraInicio, FechaHoraFin, Porcentaje)
    SELECT current_timestamp(), FROM_UNIXTIME(UNIX_TIMESTAMP(current_timestamp()) + 
						FLOOR(0 + (RAND() * (2628000-1296000)+1296000))), porcentaje;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarReporte ()
BEGIN
	INSERT INTO ReporteCaja (FechaReporte)
    SELECT curdate();
    
    INSERT INTO ReporteVenta (IdReporte, IdArticulo)
    SELECT RC.IdReporte, VA.IdArticulo FROM ReporteCaja RC
    INNER JOIN Venta V ON V.Fecha = curdate()
    INNER JOIN VentaArticulo VA ON VA.IdVenta = V.IdVenta    
    WHERE RC.FechaReporte = V.Fecha;
    
    INSERT INTO ReporteDevolucion (IdReporteCaja, IdArticulo)
    SELECT RC.IdReporteCaja, D.IdArticulo FROM ReporteCaja RC
    INNER JOIN Devolucion D ON D.Fecha = curdate()
    WHERE RC.FechaReporte = D.Fecha;
    CALL GenerarReporteCSV();
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarReporteCSV()
BEGIN
    SET @cmd = CONCAT("SELECT curdate(), RC.IdReporteCaja AS 'Reporte', RV.IdArticulo AS 'Articulo',
    RD.IdArticulo AS 'Devolucion' FROM ReporteCaja RC
    INNER JOIN ReporteDevolucion RD ON RD.IdReporteCaja = RC.IdReporteCaja
    INNER JOIN ReporteVenta RV ON RV.IdReporteCaja = RC.IdReporteCaja
    WHERE RC.FechaReporte = curdate()",
    "INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reporte", curdate(), ".csv'",
	"FIELDS TERMINATED BY ',' ",
	"ENCLOSED BY '", '"', "' ",
	"LINES TERMINATED BY '\n';");
    PREPARE statement FROM @cmd;
    EXECUTE statement;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarPuntosCliente(IN nPuntos JSON)
BEGIN
	UPDATE Cliente CL
    INNER JOIN Usuario U ON U.IdUsuario = CL.IdUsuario
    SET CL.Punto = CL.Punto + JSON_EXTRACT(nPuntos, '$.Puntos')
    WHERE JSON_EXTRACT(nPuntos, '$.Identificacion') = U.Identificacion;
END//
DELIMITER ;