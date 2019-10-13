CREATE TABLE Venta
(
	IdVenta INT AUTO_INCREMENT PRIMARY KEY,
    IdCliente INT NOT NULL,
    IdEmpleado INT NOT NULL,
    Puntos SMALLINT NOT NULL,
    Fecha DATE NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente),
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);

CREATE TABLE VentaArticulo
(
	IdVenta INT NOT NULL,
    IdArticulo INT NOT NULL,
    FOREIGN KEY (IdVenta) REFERENCES Venta (IdVenta),
    FOREIGN KEY (IdArticulo) REFERENCES Articulo (IdArticulo)
);

CREATE TABLE ReporteCaja
(
	IdReporteCaja INT AUTO_INCREMENT PRIMARY KEY,
    FechaReporte DATE NOT NULL
);

-- ALTER TABLE ReporteCaja DROP COLUMN FechaReporte;
-- ALTER TABLE ReporteCaja ADD COLUMN FechaReporte DATETIME NOT NULL;

CREATE TABLE ReporteVenta
(
	IdReporteCaja INT NOT NULL,
    IdArticulo INT NOT NULL,
    FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja (IdReporteCaja),
    FOREIGN KEY (IdArticulo) REFERENCES Articulo (IdArticulo)
);

CREATE TABLE ReporteDevolucion
(
	IdReporteCaja INT NOT NULL,
    IdArticulo INT NOT NULL,
    FOREIGN KEY (IdReporteCaja) REFERENCES ReporteCaja (IdReporteCaja),
    FOREIGN KEY (IdArticulo) REFERENCES Articulo (IdArticulo)
);
