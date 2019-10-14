CREATE TABLE ReporteCaja (
	IdReporteCaja SERIAL PRIMARY KEY,
	IdSucursal SERIAL,
	FechaReporte TIMESTAMP NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE ReporteVenta (
	IdReporteCaja SERIAL,
	IdArticulo SERIAL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE ReporteDevolucion (
	IdReporteCaja SERIAL,
	IdArticulo SERIAL,
	FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja(IdReporteCaja),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);