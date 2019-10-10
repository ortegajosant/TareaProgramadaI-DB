DELIMITER //
CREATE TRIGGER AumentarPuntos AFTER INSERT
ON Venta FOR EACH ROW
BEGIN
	IF NEW.Puntos = FALSE THEN
		UPDATE Cliente C
        INNER JOIN VentaArticulo VA ON VA.IdVenta = NEW.IdVenta
        INNER JOIN Articulo A ON VA.IdArticulo = A.IdArticulo
        SET C.Puntos = TRUNCATE(A.Costo / 5000, 0) + C.Puntos
        WHERE C.IdCliente = NEW.IdCliente;
	END IF;
END//
DELIMITER ;