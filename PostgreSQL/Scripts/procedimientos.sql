CREATE FUNCTION ArticuloEnBodega()
RETURNS TRIGGER AS $Articulo$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE Articulo SET EstadoArticulo = 'En Bodega' WHERE IdArticulo = NEW.IdArticulo;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$Articulo$ LANGUAGE plpgsql;

CREATE FUNCTION ArticuloEnSucursal()
RETURNS TRIGGER AS $EnvioArticulo$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE Articulo SET EstadoArticulo = 'En Sucursal' WHERE IdArticulo = NEW.IdArticulo;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$EnvioArticulo$ LANGUAGE plpgsql;

CREATE FUNCTION ArticuloEnDevolucion()
RETURNS TRIGGER AS $DevolucionArticulo$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE Articulo SET EstadoArticulo = 'En Devolucion' WHERE IdArticulo = NEW.IdArticulo;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$DevolucionArticulo$ LANGUAGE plpgsql;

CREATE FUNCTION ArticuloEnGarantia()
RETURNS TRIGGER AS $ReporteVenta$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE Articulo SET EstadoArticulo = 'En Garantia' WHERE IdArticulo = NEW.IdArticulo;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$ReporteVenta$ LANGUAGE plpgsql;

CREATE PROCEDURE ArticuloVendido()
AS $$
BEGIN
	UPDATE Articulo
	SET EstadoArticulo = 'Vendido'
	FROM ReporteCaja
	INNER JOIN ReporteVenta ON ReporteVenta.IdReporteCaja = ReporteCaja.IdReporteCaja
					 		AND ReporteVenta.IdArticulo = Articulo.IdArticulo
	INNER JOIN Producto ON Producto.IdProducto = Articulo.IdProducto
	WHERE NOW()::TIMESTAMP::DATE > ReporteCaja.FechaReporte + Producto.TiempoGarantia;
END;
$$ LANGUAGE plpgsql;