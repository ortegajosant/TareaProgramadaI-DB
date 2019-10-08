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