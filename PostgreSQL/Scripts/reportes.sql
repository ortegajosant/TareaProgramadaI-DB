CREATE TABLE ReporteCaja (
	IdReporteCaja SERIAL PRIMARY KEY,
	IdSucursal SERIAL,
	FechaReporte TIMESTAMP NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ReporteProducto (
	IdReporteCaja SERIAL,
	IdProducto SERIAL,
	Cantidad INTEGER NOT NULL,
	Ganancia INTEGER NOT NULL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);
--ALTER TABLE ReporteProducto RENAME TO ReporteVenta;
--ALTER TABLE ReporteProducto DROP COLUMN Cantidad;
--ALTER TABLE ReporteProducto DROP COLUMN Ganancia;
--ALTER TABLE ReporteVenta DROP COLUMN IdProducto;
--ALTER TABLE ReporteVenta ADD COLUMN IdArticulo SERIAL;
--ALTER TABLE ReporteVenta ADD FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo);

CREATE TABLE ReporteDevolucion (
	IdReporteCaja SERIAL,
	IdArticulo SERIAL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);