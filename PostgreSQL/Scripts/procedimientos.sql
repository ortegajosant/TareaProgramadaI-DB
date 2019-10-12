--Pruebas

CREATE FUNCTION cambiar()
RETURNS TRIGGER AS $Usuario$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		UPDATE Usuario SET NumeroTelefonico = '84473498' WHERE IdUsuario = NEW.IdUsuario;
		RETURN NEW;
	END IF;
	RETURN NULL;
END;
$Usuario$ LANGUAGE plpgsql;

--

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

--SELECT NOW()::TIMESTAMP::DATE - 5;


---
---
-- FRAGMENTACION
---
---


CREATE FUNCTION FragmentarArticulo(IN nSucursal INTEGER)
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_AGG(
				JSON_BUILD_OBJECT(
					'IdArticulo', Ar.IdArticulo,
					'IdProducto', Ar.IdProducto,
					'Estado', Ar.Estado,
					'EstadoArticulo', Ar.EstadoArticulo,
					'Costo', Ar.Costo
	            )
			) AS Articulos
	FROM Articulo AS Ar
	INNER JOIN EnvioArticulo AS EnAr ON EnAr.IdArticulo = Ar.IdArticulo
	INNER JOIN Envio AS En ON En.IdEnvio = EnAr.IdEnvio
	WHERE Ar.IdSucursal = nSucursal AND 
		  En.FechaHoraSalida::DATE = NOW()::TIMESTAMP::DATE;
END;
$$ LANGUAGE plpgsql;
DROP FUNCTION FragmentarArticulo(INTEGER);
SELECT * FROM FragmentarArticulo(1);


CREATE FUNCTION FragmentarProductos()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT ROW_TO_JSON(a) FROM (SELECT IdProducto, IdMarca, IdTipoArticulo, Nombre, Codigo, 
									   Peso, TiempoGarantia, Sexo, Medida
								FROM Producto
								WHERE FechaAdicion = NOW()::TIMESTAMP::DATE) a;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarProductos();
--SELECT * FROM FragmentarProductos();


CREATE FUNCTION FragmentarMarca()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT ROW_TO_JSON(a) FROM (SELECT IdMarca, NombreMarca 
								FROM Marca
								WHERE FechaAdicion = NOW()::TIMESTAMP::DATE) a;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarMarca();
--SELECT * FROM FragmentarMarca();


CREATE FUNCTION FragmentarDetalleProducto()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT ROW_TO_JSON(a) FROM (SELECT IdProducto, Detalle, Descripcion
								FROM DetalleProducto
								WHERE FechaAdicion = NOW()::TIMESTAMP::DATE) a;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarDetalleProducto();
--SELECT * FROM FragmentarDetalleProducto();


CREATE FUNCTION FragmentarActualizacionArticuloPunto()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT ROW_TO_JSON(a) FROM (SELECT IdActualizacionArticuloPunto, FechaInicio, FechaFinal
								FROM ActualizacionArticuloPunto
								WHERE FechaInicio = NOW()::TIMESTAMP::DATE) a;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarActualizacionArticuloPunto();
--SELECT * FROM FragmentarActualizacionArticuloPunto();


CREATE FUNCTION FragmentarArticuloPunto()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT ROW_TO_JSON(a) FROM (SELECT ArP.IdActualizacionArticuloPunto, ArP.IdProducto, ArP.Puntos
								FROM ArticuloPunto AS ArP
								INNER JOIN ActualizacionArticuloPunto AS Ac
										   ON Ac.IdActualizacionArticuloPunto = ArP.IdActualizacionArticuloPunto
								WHERE Ac.FechaInicio = NOW()::TIMESTAMP::DATE) a;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarArticuloPunto();
--SELECT * FROM FragmentarArticuloPunto();


CREATE OR REPLACE FUNCTION test()
RETURNS TABLE (J JSON) AS $$
BEGIN
	--RETURN QUERY
	WITH direcciones AS
	(SELECT (json_agg(json_build_object('nombre_direccion',d.Nombre))) direcciones
	FROM Direccion AS d)
	SELECT json_build_object('users', (json_agg(json_build_object('nombre',u.Nombre,'identificacion',u.Identificacion, 'direccion', direcciones))))
			FROM Usuario AS u LEFT JOIN Direccion d ON u.IdDireccion = d.IdDireccion;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION test();
--SELECT * FROM test();


--Ejemplo JSONS
SELECT JSON_AGG(
			JSON_BUILD_OBJECT(
				'id', u.IdUsuario,
				'name', u.Nombre,
				'place', direc
            )
		) AS users
FROM Usuario AS u
LEFT JOIN (
    SELECT 
        d.IdDireccion,
        JSON_AGG(
            JSON_BUILD_OBJECT(
                'id', d.IdDireccion,    
                'lugar', d.Nombre
                )
            ) AS direc
	FROM Direccion AS d
	GROUP BY 1) AS x ON u.IdDireccion = x.IdDireccion;

SELECT ROW_TO_JSON(a) FROM (SELECT Ar.IdArticulo, Ar.IdProducto, Ar.Estado, Ar.EstadoArticulo, Ar.Costo 
FROM Articulo AS Ar 
INNER JOIN EnvioArticulo AS EnAr ON EnAr.IdArticulo = Ar.IdArticulo
INNER JOIN Envio AS En ON En.IdEnvio = EnAr.IdEnvio
WHERE Ar.IdSucursal = nSucursal AND 
	  En.FechaHoraSalida::DATE = NOW()::TIMESTAMP::DATE) a;
	 
SELECT JSON_AGG(
			JSON_BUILD_OBJECT(
				'IdArticulo', Ar.IdArticulo,
				'IdProducto', Ar.IdProducto,
				'Estado', Ar.Estado,
				'EstadoArticulo', Ar.EstadoArticulo,
				'Costo', Ar.Costo
            )
		) AS Articulos
FROM Articulo AS Ar
INNER JOIN EnvioArticulo AS EnAr ON EnAr.IdArticulo = Ar.IdArticulo
INNER JOIN Envio AS En ON En.IdEnvio = EnAr.IdEnvio
WHERE Ar.IdSucursal = nSucursal AND 
	  En.FechaHoraSalida::DATE = NOW()::TIMESTAMP::DATE;
   