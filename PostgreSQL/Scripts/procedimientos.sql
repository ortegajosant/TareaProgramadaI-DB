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


CREATE OR REPLACE FUNCTION FragmentarProductos()
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


CREATE FUNCTION FragmentarEmpleados()
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_AGG(JSON_BUILD_OBJECT(
	    'Usuario', JSON_BUILD_OBJECT(
	        'Nombre', U.Nombre,
	        'Identificacion', U.Identificacion,
	        'ApellidoPat', U.ApellidoPat,
	        'ApellidoMat', U.ApellidoMat,
	        'FechaNacimiento', U.FechaNacimiento,
	        'NumeroTelefonico', U.NumeroTelefonico,
	        'Direccion', JSON_BUILD_OBJECT(
	            'Direccion', D.Nombre,
	            'Ciudad', Ci.Nombre,
	            'Canton', Ca.Nombre,
	            'Provincia', Pr.Nombre,
	            'Pais', Pa.Nombre
	        )
	    ),
	    'Empleado', JSON_BUILD_OBJECT(
	        'FechaIngreso', E.FechaIngreso,
	        'CuentaBancaria', E.CuentaBancaria,
	        'Estado', E.Estado,
	        'IdPuesto', EP.IdPuesto
	    )
	))
	FROM Usuario AS U
	INNER JOIN Direccion AS D ON D.IdDireccion = U.IdDireccion
	INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad
	INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
	INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
	INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
	INNER JOIN Empleado AS E ON E.IdUsuario = U.IdUsuario
	INNER JOIN PuestoEmpleado AS EP ON EP.IdEmpleado = E.IdEmpleado
	WHERE EP.FechaInicio = NOW()::TIMESTAMP::DATE;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarEmpleados();
--SELECT * FROM FragmentarEmpleados();
	

CREATE OR REPLACE FUNCTION FragmentarCliente(IN id INTEGER)
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_BUILD_OBJECT(
	    'Usuario', JSON_BUILD_OBJECT(
	        'Nombre', U.Nombre,
	        'Identificacion', U.Identificacion,
	        'ApellidoPat', U.ApellidoPat,
	        'ApellidoMat', U.ApellidoMat,
	        'FechaNacimiento', U.FechaNacimiento,
	        'NumeroTelefonico', U.NumeroTelefonico,
	        'Direccion', JSON_BUILD_OBJECT(
	            'Direccion', D.Nombre,
	            'Ciudad', Ci.Nombre,
	            'Canton', Ca.Nombre,
	            'Provincia', Pr.Nombre,
	            'Pais', Pa.Nombre
	        )
	    ),
	    'Puntos', C.Puntos
	)
	FROM Usuario AS U
	INNER JOIN Direccion AS D ON D.IdDireccion = U.IdDireccion
	INNER JOIN Ciudad AS Ci ON Ci.IdCiudad = D.IdCiudad
	INNER JOIN Canton AS Ca ON Ca.IdCanton = Ci.IdCanton
	INNER JOIN Provincia AS Pr ON Pr.IdProvincia = Ca.IdProvincia
	INNER JOIN Pais AS Pa ON Pa.IdPais = Pr.IdPais
	INNER JOIN Cliente AS C ON C.IdUsuario = U.IdUsuario
	WHERE U.IdUsuario = id;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarCliente(INTEGER);
--SELECT * FROM FragmentarCliente(1);


CREATE FUNCTION FragmentarPuntos(IN cedula VARCHAR)
RETURNS TABLE (J JSON) AS $$
BEGIN
	RETURN QUERY
	SELECT JSON_BUILD_OBJECT(
	    'Identificación', U.Identificacion,
	    'Puntos', C.Puntos
	)
	FROM Usuario AS U
	INNER JOIN Cliente AS C ON C.IdUsuario = U.IdUsuario
	WHERE U.Identificacion = cedula;
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION FragmentarPuntos(VARCHAR);
--SELECT * FROM FragmentarPuntos('305210664');


-- Inserciones


CREATE OR REPLACE FUNCTION InsertarCliente(IN client TEXT)
RETURNS VOID AS $$
DECLARE clientJson JSON;
DECLARE Usu JSON;
DECLARE Pun INTEGER;
DECLARE Dir JSON;
DECLARE IdD INTEGER;
DECLARE IdU INTEGER;
BEGIN
	SELECT INTO clientJson CAST(client AS JSON);
	SELECT INTO Usu clientJson->'Usuario';
	SELECT INTO Pun CAST(clientJson->>'Puntos' AS INTEGER);
	SELECT INTO Dir Usu->'Direccion';

	IF NOT EXISTS(
		SELECT 1
		FROM Pais
		WHERE Nombre = Dir->>'Pais'
	) THEN
		INSERT INTO Pais (Nombre) VALUES
		(Dir->>'Pais');
	END IF;

	IF NOT EXISTS(
		SELECT 1
		FROM Provincia
		WHERE Nombre = Dir->>'Provincia'
	) THEN
		INSERT INTO Provincia (Nombre) VALUES
		(Dir->>'Provincia');
	END IF;

	IF NOT EXISTS(
		SELECT 1
		FROM Canton
		WHERE Nombre = Dir->>'Canton'
	) THEN
		INSERT INTO Canton (Nombre) VALUES
		(Dir->>'Canton');
	END IF;

	IF NOT EXISTS(
		SELECT 1
		FROM Ciudad
		WHERE Nombre = Dir->>'Ciudad'
	) THEN
		INSERT INTO Ciudad (Nombre) VALUES
		(Dir->>'Ciudad');
	END IF;

	IF NOT EXISTS(
		SELECT 1
		FROM Direccion
		WHERE Nombre = Dir->>'Direccion'
	) THEN
		INSERT INTO Direccion (Nombre) VALUES
		(Dir->>'Direccion');
	END IF;

	SELECT INTO IdD IdDireccion
	FROM Direccion
	WHERE Nombre = Dir->>'Direccion';

	IF NOT EXISTS(
		SELECT 1
		FROM Usuario
		WHERE Identificacion = Usu->>'Identificacion'
	) THEN
		INSERT INTO Usuario (Nombre,Identificacion,ApellidoPat,ApellidoMat,FechaNacimiento,NumeroTelefonico,IdDireccion)
		VALUES
		(Usu->>'Nombre',Usu->>'Identificacion',Usu->>'ApellidoPat',Usu->>'ApellidoMat',CAST(Usu->>'FechaNacimiento' AS DATE),Usu->>'NumeroTelefonico',IdD);
	END IF;

	SELECT INTO IdU IdUsuario
	FROM Usuario
	WHERE Identificacion = Usu->>'Identificacion';

	INSERT INTO Cliente (IdUsuario, Puntos) VALUES
	(IdU, Pun);
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION InsertarCliente(TEXT);
--SELECT InsertarCliente('{"Usuario":{"Nombre":"Francinni","Identificacion":"302440254","ApellidoPat":"Campos","ApellidoMat":"Granados","FechaNacimiento":"30-04-2001","NumeroTelefonico":"privado","Direccion":{"Direccion":"Centro","Ciudad":"Turrialba","Canton":"Turrialba","Provincia":"Cartago","Pais":"Nicaragua"}},"Puntos":0}'::TEXT);
--
--SELECT ARRAY(SELECT json_array_elements_text(j->'x2')::int
--FROM cast('{"x1":"1","x2":["2","3","4","5"]}' AS json) AS j);


CREATE OR REPLACE FUNCTION InsertarAdministrador(IN administrador TEXT)
RETURNS VOID AS $$
DECLARE administradorJson JSON;
DECLARE ide TEXT;
DECLARE fec DATE;
DECLARE idS INTEGER;
DECLARE idEm INTEGER;
BEGIN
	SELECT INTO administradorJson CAST(administrador AS JSON);
	SELECT INTO ide administradorJson->>'Identificacion';
	SELECT INTO fec CAST(administradorJson->>'Fecha' AS DATE);
	SELECT INTO idS CAST(administradorJson->>'IdSucursal' AS INTEGER);
	SELECT INTO idEm IdEmpleado
	FROM Empleado AS E
	INNER JOIN Usuario AS U ON U.IdUsuario = E.idusuario
	WHERE U.Identificacion = ide;
	INSERT INTO AdministradorSucursal (IdEmpleado, Fecha, IdSucursal) VALUES
	(idEm, fec, idS);
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION InsertarAdministrador(TEXT);
--SELECT InsertarAdministrador('{"Identificacion":"305210664","Fecha":"13-10-2019","IdSucursal":"1"}');


CREATE OR REPLACE FUNCTION InsertarPuesto(IN emple TEXT)
RETURNS VOID AS $$
DECLARE empleadoJson JSON;
DECLARE ide TEXT;
DECLARE idP INTEGER;
DECLARE fec DATE;
DECLARE idEm INTEGER;
BEGIN
	SELECT INTO empleadoJson CAST(emple AS JSON);
	SELECT INTO ide empleadoJson->>'Identificacion';
	SELECT INTO idP CAST(empleadoJson->>'IdPuesto' AS INTEGER);
	SELECT INTO fec CAST(empleadoJson->>'FechaInicio' AS DATE);
	SELECT INTO idEm IdEmpleado
	FROM Empleado AS E
	INNER JOIN Usuario AS U ON U.IdUsuario = E.idusuario
	WHERE U.Identificacion = ide;
	INSERT INTO PuestoEmpleado (IdEmpleado, IdPuesto, FechaInicio) VALUES
	(idEm, idP, fec);
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION InsertarPuesto(TEXT);
--SELECT InsertarPuesto('{"Identificacion":"305210664","IdPuesto":"1","FechaInicio":"13-10-2019"}');


CREATE OR REPLACE FUNCTION InsertarPromocion(IN promo TEXT)
RETURNS VOID AS $$
DECLARE promocionJson JSON;
DECLARE idU INTEGER;
DECLARE fecI TIMESTAMP;
DECLARE fecF TIMESTAMP;
DECLARE por INTEGER;
DECLARE prods INTEGER[];
DECLARE idPromo INTEGER;
DECLARE prod INTEGER;
BEGIN
	SELECT INTO promocionJson CAST(promo AS JSON);
	SELECT INTO idU CAST(promocionJson->>'IdSucursal' AS INTEGER);
	SELECT INTO fecI CAST(promocionJson->>'FechaHoraInicio' AS TIMESTAMP);
	SELECT INTO fecF CAST(promocionJson->>'FechaHoraFin' AS TIMESTAMP);
	SELECT INTO por CAST(promocionJson->>'Porcentaje' AS INTEGER);
	SELECT INTO prods ARRAY(
		SELECT JSON_ARRAY_ELEMENTS_TEXT(promocionJson->'Productos')::INTEGER
	);
	INSERT INTO Promocion (IdSucursal, FechaHoraInicio, FechaHoraFin, Porcentaje) VALUES
	(idU, fecI, fecF, por);
	SELECT INTO idPromo IdPromocion
	FROM Promocion
	WHERE FechaHoraInicio = fecI AND FechaHoraFin = fecF AND IdSucursal = idU AND Porcentaje = por;
	FOREACH prod IN ARRAY prods LOOP
		INSERT INTO PromocionProducto (IdPromocion, IdProducto) VALUES
		(idPromo, prod);
	END LOOP;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION InsertarPromocion(TEXT);
--SELECT InsertarPromocion('{"IdSucursal":"1","FechaHoraInicio":"01-01-2000 04:05:06","FechaHoraFin":"01-01-2002 23:00:00","Porcentaje":"50","Productos":["1","2","3"]}');


CREATE OR REPLACE FUNCTION InsertarPuntos(IN points TEXT)
RETURNS VOID AS $$
DECLARE puntosJson JSON;
DECLARE ide TEXT;
DECLARE pun INTEGER;
DECLARE idC INTEGER;
DECLARE punAntes INTEGER;
BEGIN
	SELECT INTO puntosJson CAST(points AS JSON);
	SELECT INTO ide puntosJson->>'Identificacion';
	SELECT INTO pun CAST(puntosJson->>'Puntos' AS INTEGER);
	SELECT INTO idC C.IdCliente
	FROM Cliente AS C
	INNER JOIN Usuario AS U ON U.IdUsuario = C.IdUsuario
	WHERE U.Identificacion = ide;
	SELECT INTO punAntes Puntos
	FROM Cliente
	WHERE IdCliente = idC;
	UPDATE Cliente 
	SET Puntos = punAntes + pun
	WHERE IdCliente = idC;
END;
$$ LANGUAGE plpgsql;


--DROP FUNCTION InsertarPuntos(TEXT);
--SELECT InsertarPuntos('{"Identificacion":"305210664","Puntos":"-1"}');


CREATE OR REPLACE FUNCTION InsertarReporte(IN report TEXT)
RETURNS VOID AS $$
DECLARE reporteJson JSON;
DECLARE idS INTEGER;
DECLARE fec DATE;
DECLARE idC INTEGER;
DECLARE punAntes INTEGER;
DECLARE vens INTEGER[];
DECLARE devs INTEGER[];
DECLARE ven INTEGER;
DECLARE dev INTEGER;
DECLARE idR INTEGER;
BEGIN
	SELECT INTO reporteJson CAST(report AS JSON);
	SELECT INTO idS CAST(reporteJson->>'IdSucursal' AS INTEGER);
	SELECT INTO fec CAST(reporteJson->>'FechaReporte' AS DATE);
	SELECT INTO vens ARRAY(
		SELECT JSON_ARRAY_ELEMENTS_TEXT(reporteJson->'Ventas')::INTEGER
	);
	SELECT INTO devs ARRAY(
		SELECT JSON_ARRAY_ELEMENTS_TEXT(reporteJson->'Devoluciones')::INTEGER
	);
	INSERT INTO ReporteCaja (IdSucursal, FechaReporte) VALUES
	(idS, fec);
	SELECT INTO idR IdReporteCaja
	FROM ReporteCaja
	WHERE IdSucursal = idS AND FechaReporte = fec;
	FOREACH ven IN ARRAY vens LOOP
		INSERT INTO ReporteVenta (IdReporteCaja, IdArticulo) VALUES
		(idR, ven);
	END LOOP;
	FOREACH dev IN ARRAY devs LOOP
		INSERT INTO ReporteDevolucion (IdReporteCaja, IdArticulo) VALUES
		(idR, dev);
	END LOOP;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION InsertarReporte(TEXT);
--SELECT InsertarReporte('{"IdSucursal":"1","FechaReporte":"13-10-2019","Ventas":["1","4"],"Devoluciones":["2","3"]}');