CREATE TABLE Transporte (
	IdTransporte SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE Envio (
	IdEnvio SERIAL PRIMARY KEY,
	IdSucursal SERIAL,
	FechaHoraLlegada TIMESTAMP NOT NULL,
	FechaHoraSalida TIMESTAMP NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);

CREATE TABLE EnvioTransporte (
	IdEnvio SERIAL,
	IdTransporte SERIAL,
	FOREIGN KEY (IdEnvio) REFERENCES Envio(IdEnvio),
	FOREIGN KEY (IdTransporte) REFERENCES Transporte(IdTransporte)
);

CREATE TABLE EnvioArticulo (
	IdEnvio SERIAL,
	IdArticulo SERIAL,
	FOREIGN KEY (IdEnvio) REFERENCES Envio(IdEnvio),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);