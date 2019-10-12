--Pruebas

INSERT INTO Pais (Nombre) VALUES ('Costa Rica');
INSERT INTO Provincia (IdPais, Nombre) VALUES (1, 'Cartago');
INSERT INTO Canton (IdProvincia, Nombre) VALUES (1, 'Turrialba');
INSERT INTO Ciudad (IdCanton, Nombre) VALUES (1, 'Turrialba');
INSERT INTO Direccion (IdCiudad, Nombre) VALUES (1, 'Centro');
INSERT INTO Usuario (IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, FechaNacimiento, NumeroTelefonico) VALUES
(1, '305210664', 'Esteban', 'Campos', 'Granados', '11-01-1999', '84473498');
INSERT INTO Usuario (IdDireccion, Identificacion, Nombre, ApellidoPat, ApellidoMat, FechaNacimiento, NumeroTelefonico) VALUES
(1, '30xxx0xxx', 'Francinni', 'Campos', 'Granados', '30-04-2001', 'xxxxxxxx');

DELETE FROM Usuario
WHERE IdUsuario = 4;

CREATE TRIGGER cambiar_t AFTER INSERT ON Usuario
	FOR EACH ROW
    EXECUTE PROCEDURE cambiar();
DROP TRIGGER cambiar_t ON Usuario;


--

CREATE TRIGGER EstadoArticuloBodegaTrigger AFTER INSERT ON Articulo
	FOR EACH ROW
    EXECUTE PROCEDURE ArticuloEnBodega();
--DROP TRIGGER EstadoArticuloBodegaTrigger ON Articulo;

CREATE TRIGGER EstadoArticuloSucursalTrigger AFTER INSERT ON EnvioArticulo
	FOR EACH ROW
    EXECUTE PROCEDURE ArticuloEnSucursal();
--DROP TRIGGER EstadoArticuloSucursalTrigger ON EnvioArticulo;

CREATE TRIGGER EstadoArticuloDevolucionTrigger AFTER INSERT ON DevolucionArticulo
	FOR EACH ROW
    EXECUTE PROCEDURE ArticuloEnDevolucion();
--DROP TRIGGER EstadoArticuloDevolucionTrigger ON DevolucionArticulo;
   
CREATE TRIGGER EstadoArticuloGarantiaTrigger AFTER INSERT ON ReporteVenta
	FOR EACH ROW
    EXECUTE PROCEDURE ArticuloEnGarantia();
--DROP TRIGGER EstadoArticuloGarantiaTrigger ON ReporteVenta;
   
   
