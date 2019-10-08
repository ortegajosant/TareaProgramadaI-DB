CREATE TABLE Promocion
(
	IdPromocion INT AUTO_INCREMENT PRIMARY KEY,
	IdProducto INT NOT NULL,
    FechaHoraInicio DATETIME NOT NULL,
    FechaHoraFin DATETIME NOT NULL,
    Porcentaje SMALLINT,
    FOREIGN KEY (IdProducto) REFERENCES Producto (IdProducto)
);

CREATE TABLE ActualizacionArticuloPunto
(
	IdActualizacionArticuloPunto INT AUTO_INCREMENT PRIMARY KEY,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL
);

CREATE TABLE ArticuloPunto
(
	IdProducto INT NOT NULL,
    IdActualizacionArticuloPunto INT NOT NULL,
    Puntos SMALLINT NOT NULL,
    FOREIGN KEY (IdActualizacionArticuloPunto) REFERENCES ActualizacionArticuloPunto (IdActualizacionArticuloPunto)
);