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
   
   
