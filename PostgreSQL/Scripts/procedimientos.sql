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


CREATE FUNCTION FragmentarArticulos(IN nSucursal INTEGER)
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
--DROP FUNCTION FragmentarArticulos(INTEGER);
--SELECT * FROM FragmentarArticulos(1);


CREATE FUNCTION FragmentarProductos()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_AGG(
				JSON_BUILD_OBJECT(
					'IdProducto', Pd.IdProducto,
					'IdMarca', Pd.IdMarca,
					'IdTipoArticulo', Pd.IdTipoArticulo,
					'Codigo', Pd.Codigo,
					'Nombre', Pd.Nombre,
					'Peso', Pd.Peso,
					'TiempoGarantia', Pd.TiempoGarantia,
					'Sexo', Pd.Sexo,
					'Medida', Pd.Medida,
					'Detalles', Detalles
	            )
			) AS Productos
	FROM Producto AS Pd
	LEFT JOIN (
	    SELECT 
	        D.IdProducto,
	        JSON_AGG(
	            JSON_BUILD_OBJECT(
	                'Detalle', D.Detalle,    
	                'Descripcion', D.Descripcion
	                )
	            ) AS Detalles
		FROM DetalleProducto AS D
		GROUP BY 1) AS Det ON Pd.IdProducto = Det.IdProducto
	WHERE Pd.FechaAdicion = NOW()::TIMESTAMP::DATE;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarProductos();
--SELECT * FROM FragmentarProductos();


CREATE FUNCTION FragmentarMarca()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_AGG(
				JSON_BUILD_OBJECT(
					'IdMarca', M.IdMarca,
					'NombreMarca', M.NombreMarca
	            )
			) AS Marcas
	FROM Marca AS M
	WHERE M.FechaAdicion = NOW()::TIMESTAMP::DATE;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarMarca();
--SELECT * FROM FragmentarMarca();


CREATE FUNCTION FragmentarListaPuntos()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_BUILD_OBJECT(
				'IdActualizacionArticuloPunto', AcAr.IdActualizacionArticuloPunto,
				'FechaInicio', AcAr.FechaInicio,
				'FechaFinal', AcAr.FechaFinal,
				'Productos', productos
            ) AS Lista
	FROM ActualizacionArticuloPunto AS AcAr
	LEFT JOIN (
	    SELECT 
	        Pr.IdActualizacionArticuloPunto,
	        JSON_AGG(
	            JSON_BUILD_OBJECT(
	                'IdProducto', Pr.IdProducto,    
	                'Puntos', Pr.Puntos
	                )
	            ) AS Productos
		FROM ArticuloPunto AS Pr
		GROUP BY 1) AS Ars ON AcAr.IdActualizacionArticuloPunto = Ars.IdActualizacionArticuloPunto
	WHERE AcAr.FechaInicio = NOW()::TIMESTAMP::DATE;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarListaPuntos();
--SELECT * FROM FragmentarListaPuntos();


CREATE OR REPLACE FUNCTION FragmentarEmpleados()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_AGG(
				JSON_BUILD_OBJECT(
					'Usuario', JSON_AGG(
							            JSON_BUILD_OBJECT(
							                'Nombre', U.Nombre,
							                'Identificacion', U.Identificacion,
							                'ApellidoPat', U.ApellidoPat,
							                'ApellidoMat', U.ApellidoMat,
							                'FechaNacimiento', U.FechaNacimiento,
							                'NumeroTelefonico', U.NumeroTelefonico,
							                'Direccion', direcciones
							                )
							            )
					'Empleado', empleados
	            )
			) AS NuevosEmpleados
	FROM Usuario AS U
	LEFT JOIN (
	    SELECT 
	    	E.IdUsuario,
	        JSON_AGG(
	            JSON_BUILD_OBJECT(
	                'FechaIngreso', E.FechaIngreso,
	                'CuentaBancaria', E.CuentaBancaria,
	                'Estado', E.Estado,
	                'IdPuesto', EP.IdPuesto
	                )
	            ) AS empleados
		FROM Empleado AS E
		INNER JOIN PuestoEmpleado AS EP ON EP.IdEmpleado = E.IdEmpleado
		GROUP BY 1) AS Emp ON U.IdUsuario = Emp.IdUsuario
	LEFT JOIN (
	    SELECT 
	        D.IdDireccion,
	        JSON_AGG(
	            JSON_BUILD_OBJECT(
	                'Direccion', D.Nombre,
	                'Ciudad', Ci.Nombre,
	                'Canton', Ca.Nombre,
	                'Provincia', Pr.Nombre,
	                'Pais', Pa.Nombre
	                )
	            ) AS direcciones
		FROM Direccion AS D
		INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad
		INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		GROUP BY 1) AS Dir ON U.IdDireccion = Dir.IdDireccion
	WHERE Pd.FechaAdicion = NOW()::TIMESTAMP::DATE;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarEmpleados();
SELECT * FROM FragmentarEmpleados();

SELECT JSON_AGG(
			JSON_BUILD_OBJECT(
				'Usuario', usuarios,
				'Empleado', empleados
            )
		) AS NuevosEmpleados
FROM Usuario AS U1
LEFT JOIN (
    SELECT 
    	U2.IdUsuario,
        JSON_AGG(
            JSON_BUILD_OBJECT(
                'Nombre', U2.Nombre,
                'Identificacion', U2.Identificacion,
                'ApellidoPat', U2.ApellidoPat,
                'ApellidoMat', U2.ApellidoMat,
                'FechaNacimiento', U2.FechaNacimiento,
                'NumeroTelefonico', U2.NumeroTelefonico,
                'Direccion', direcciones
                )
            ) AS usuarios
	FROM Usuario AS U2
	LEFT JOIN (
	    SELECT 
	        D.IdDireccion,
	        JSON_AGG(
	            JSON_BUILD_OBJECT(
	                'Direccion', D.Nombre,
	                'Ciudad', Ci.Nombre,
	                'Canton', Ca.Nombre,
	                'Provincia', Pr.Nombre,
	                'Pais', Pa.Nombre
	                )
	            ) AS direcciones
		FROM Direccion AS D
		INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad
		INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
		INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
		INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
		GROUP BY 1) AS Dir ON U2.IdDireccion = Dir.IdDireccion
	GROUP BY 1) AS usu ON U1.IdUsuario = usu.IdUsuario
LEFT JOIN (
    SELECT 
    	E.IdUsuario,
        JSON_AGG(
            JSON_BUILD_OBJECT(
                'FechaIngreso', E.FechaIngreso,
                'CuentaBancaria', E.CuentaBancaria,
                'Estado', E.Estado,
                'IdPuesto', EP.IdPuesto
                )
            ) AS empleados
	FROM Empleado AS E
	INNER JOIN PuestoEmpleado AS EP ON EP.IdEmpleado = E.IdEmpleado
	GROUP BY 1) AS Emp ON U1.IdUsuario = Emp.IdUsuario;