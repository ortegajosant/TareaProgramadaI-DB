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
		SELECT JSON_EXTRACT(@temp, '$.IdArticulo'), JSON_EXTRACT(@temp, '$.IdProducto'), 
				JSON_EXTRACT(@temp, '$.Estado'), JSON_EXTRACT(@temp, '$.EstadoArticulo'), 
                JSON_EXTRACT(@temp, '$.Costo');
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
    SET largo = JSON_LENGTH( nProductos, '$' );
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nProductos, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdProducto, IdMarca, IdTipoArticulo, Codigo, Nombre, Peso, TiempoGarantia, Sexo, Medida)
		SELECT JSON_EXTRACT(@temp, '$.IdProducto'), JSON_EXTRACT(@temp, '$.IdMarca'), 
				JSON_EXTRACT(@temp, '$.IdTipoArticulo'), JSON_EXTRACT(@temp, '$.Codigo'), 
                JSON_EXTRACT(@temp, '$.Nombre'), JSON_EXTRACT(@temp, '$.Peso'), 
                JSON_EXTRACT(@temp, '$.TiempoGarantia'), JSON_EXTRACT(@temp, '$.Sexo'), 
                JSON_EXTRACT(@temp, '$.Medida');
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
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nEmpleados, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdEmpleado, IdUsuario, FechaIngreso, CuentaBancaria, Estado)
		SELECT JSON_EXTRACT(@temp, '$.IdEmpleado'), JSON_EXTRACT(@temp, '$.IdUsuario'),
				JSON_EXTRACT(@temp, '$.FechaIngreso'), JSON_EXTRACT(@temp, '$.CuentaBancaria'),
                JSON_EXTRACT(@temp, '$.Estado');
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
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nMarca, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdMarca, NombreMarca)
		SELECT JSON_EXTRACT(@temp, '$.IdMarca'), JSON_EXTRACT(@temp, '$.NombreMarca');
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE InsercionDetalleProducto(IN nDetalle JSON)
BEGIN
	DECLARE cont INT DEFAULT 0;
    DECLARE largo INT DEFAULT 0;
    SET largo = JSON_LENGTH( nDetalle, '$' );
	SET cont = 0;
    WHILE (cont < largo) DO
		SET @temp = JSON_EXTRACT(nDetalle, CONCAT('$[',cont,']'));
        INSERT INTO Articulo (IdProducto, Detalle, Descripcion)
		SELECT JSON_EXTRACT(@temp, '$.IdMarca'), JSON_EXTRACT(@temp, '$.NombreMarca');
		SET cont = cont + 1;
    END WHILE;
END//
DELIMITER ;