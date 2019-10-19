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
DECLARE idS INTEGER;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		SELECT INTO idS S.IdSucursal
		FROM Sucursal AS S
		INNER JOIN Envio AS Env ON Env.IdSucursal = S.IdSucursal
		INNER JOIN EnvioArticulo AS Ar ON Ar.IdEnvio = Env.IdEnvio
		WHERE Ar.IdArticulo = NEW.IdArticulo;
		UPDATE Articulo SET IdSucursal = idS WHERE IdArticulo = NEW.IdArticulo;
		UPDATE Articulo SET EstadoArticulo = 'En Sucursal' WHERE IdSucursal = idS;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$EnvioArticulo$ LANGUAGE plpgsql;

CREATE FUNCTION ArticuloEnDevolucion()
RETURNS TRIGGER AS $DevolucionArticulo$
DECLARE idA INTEGER;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		SELECT INTO idA IdArticulo
		FROM DevolucionArticulo
		WHERE IdArticulo = NEW.IdArticulo;
		UPDATE Articulo SET EstadoArticulo = 'En Devolucion' WHERE IdArticulo = idA;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$DevolucionArticulo$ LANGUAGE plpgsql;

CREATE FUNCTION ArticuloEnGarantia()
RETURNS TRIGGER AS $ReporteVenta$
DECLARE idA INTEGER;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		SELECT INTO idA IdArticulo
		FROM ReporteVenta
		WHERE IdArticulo = NEW.IdArticulo;
		UPDATE Articulo SET EstadoArticulo = 'En Garantia' WHERE IdArticulo = idA;
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