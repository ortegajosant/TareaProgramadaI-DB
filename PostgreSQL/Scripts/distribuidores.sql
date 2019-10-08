CREATE TABLE Distribuidor (
	IdDistribuidor SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE DistribuidorProducto (
	IdDistribuidorProducto SERIAL PRIMARY KEY,
	IdDistribuidor SERIAL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor)
);

CREATE TABLE DistribuidorArticulo (
	IdDistribuidorProducto SERIAL,
	IdArticulo SERIAL,
	Costo INTEGER NOT NULL,
	FOREIGN KEY (IdDistribuidorProducto) REFERENCES DistribuidorProducto(IdDistribuidorProducto),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);