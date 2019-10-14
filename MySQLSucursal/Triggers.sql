DELIMITER //
CREATE TRIGGER AumentarPuntos AFTER INSERT
ON VentaArticulo FOR EACH ROW
BEGIN
	IF NEW.Puntos = FALSE THEN
		UPDATE Cliente C
        INNER JOIN Venta V ON NEW.IdVenta = V.IdVenta
        INNER JOIN Articulo A ON NEW.IdArticulo = A.IdArticulo
        SET C.Puntos = TRUNCATE(A.Costo / 5000, 0) + C.Puntos
        WHERE C.IdCliente = V.IdCliente;
	END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER CambiarEstadoArticulo AFTER INSERT
ON VentaArticulo FOR EACH ROW
BEGIN
	UPDATE Articulo A
    INNER JOIN Producto P ON P.IdProducto = A.IdProducto
    SET A.EstadoArticulo = 
		CASE 
			WHEN P.TiempoGarantia > 0 THEN 'En Garantia'
			ELSE 'Vendido'
		END
    WHERE NEW.IdArticulo = A.IdArticulo;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER EnviarCliente AFTER INSERT
ON Cliente FOR EACH ROW
BEGIN
	DECLARE url TEXT DEFAULT "";
    DECLARE result INT(10);
    SET url = "./Scripts/eventos.py";
    SET result  = sys_exec(url);
    
END//
DELIMITER ;
