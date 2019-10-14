DELIMITER //
CREATE PROCEDURE GenerarAdministradorSucursal(IN IdEmpleado INT, OUT jsonAS JSON)
BEGIN
	SELECT JSON_OBJECT('Identificacion', U.Identificacion, 'Fecha', AD.Fecha, 'IdSucursal', S.IdSucursal) INTO jsonAS
    FROM InfoSucursal S
    INNER JOIN Empleado E ON E.IdEmpleado = IdEmpleado
    INNER JOIN Usuario U ON U.IdUsuario = E.IdUsuario
    INNER JOIN AdministradorSucursal AD ON AD.IdEmpleado = E.IdEmpleado;
END//
DELIMITER ;


DROP PROCEDURE GenerarCliente;
CALL GenerarCliente(1, @cliente);
SELECT @cliente;

DELIMITER //
CREATE PROCEDURE GenerarCliente(IN IdCliente INT, OUT jsonCliente JSON)
BEGIN
	SELECT JSON_ARRAYAGG(JSON_OBJECT('usuario', 
										JSON_OBJECT('Nombre', U.Nombre, 'Identificacion', U.Identificacion,
													'ApellidoPat', U.ApellidoPat, 'ApellidoMat', U.ApellidoMat,
                                                    'FechaNacimiento', U.FechaNacimiento, 'NumeroTelefonico', U.NumeroTelefonico,
                                                    'direccion', JSON_OBJECT('direccion', D.Descripcion, 
                                                                             'ciudad', CD.Nombre,
                                                                             'canton', C.Nombre,
                                                                             'provincia', PR.Nombre,
                                                                             'pais', P.Nombre)),
									'puntos', CL.Punto, 'IdSucursal', IFS.IdSucursal))
	INTO jsonCliente
	FROM InfoSucursal IFS
    INNER JOIN Cliente CL ON CL.IdCliente = IdCliente
    INNER JOIN Usuario U ON CL.IdUsuario = U.IdUsuario
    INNER JOIN Direccion D ON D.IdDireccion = U.IdDireccion
    INNER JOIN Ciudad CD ON CD.IdCiudad = D.IdCiudad
    INNER JOIN Canton C ON C.IdCanton = CD.IdCanton
    INNER JOIN Provincia PR ON PR.IdProvincia = C.IdProvincia
    INNER JOIN Pais P ON P.IdPais = PR.IdPais;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarPuntos (IN IdCliente INT, OUT jsonPuntos JSON)
BEGIN
	SELECT JSON_OBJECT('Puntos', CL.Punto, 'Identificacion', U.Identificacion)
    INTO jsonPuntos
    FROM Cliente CL
    INNER JOIN Usuario U ON CL.IdUsuario = U.IdUsuario
    WHERE CL.IdCliente = IdCliente;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarPuestoEmpleado(OUT jsonPE JSON)
BEGIN
	SELECT JSON_ARRAYAGG(JSON_OBJECT('Identificacion', U.Identificacion, 'IdPuesto', EP.IdPuesto, 'FechaInicio', EP.FechaInicio))
    INTO jsonPE
    FROM PuestoEmpleado EP
    INNER JOIN Empleado E ON E.IdEmpleado = EP.IdEmpleado
    INNER JOIN Usuario U ON U.IdUsuario = E.IdUsuario
    WHERE EP.FechaInicio = curdate();
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarPromocion(OUT jsonPromo JSON)
BEGIN
	SELECT JSON_ARRAYAGG(PD.IdProducto)
    INTO @productos
    FROM Producto PD
    INNER JOIN PromocionProducto PP ON PP.IdProducto = PD.IdProducto
    INNER JOIN Promocion PM ON PM.IdPromocion = PP.IdPromocion
    WHERE DATE(PM.FechaHoraInicio) = curdate();
    
	SELECT JSON_OBJECT('IdPromocion', PM.IdPromocion, 'IdSucursal', IFS.IdSucursal, 'FechaHoraInicio', PM.FechaHoraInicio,
						'FechaHoraFin', PM.FechaHoraFin, 'Porcentaje', PM.Porcentaje, 'Productos', @productos)
    INTO jsonPromo FROM Promocion PM, InfoSucursal IFS
    WHERE DATE(PM.FechaHoraInicio) = curdate();
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GenerarReporte(OUT jsonReporte JSON)
BEGIN
	SELECT JSON_ARRAYAGG(RV.IdArticulo)
    INTO @ventas 
    FROM ReporteVenta RV
    INNER JOIN ReporteCaja RC ON RC.IdReporteCaja = RV.IdReporteCaja
    WHERE RC.FechaReporte = curdate();
    
    SELECT JSON_ARRAYAGG(RD.IdArticulo)
    INTO @devoluciones
    FROM ReporteDevolucion RD
    INNER JOIN ReporteCaja RC ON RC.IdReporteCaja = RD.IdReporteCaja
    WHERE RC.FechaReporte = curdate();
    
    SELECT JSON_OBJECT('caja', JSON_OBJECT(), 
						'ventas', @ventas,
                        'devoluciones', @devoluciones)
    INTO jsonReporte
    FROM ReporteCaja RC
    WHERE RC.FechaReporte = curdate();
END //
DELIMITER ;
