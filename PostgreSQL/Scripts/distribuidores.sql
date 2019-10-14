CREATE TABLE Distribuidor (
	IdDistribuidor SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
);

CREATE TABLE DistribuidorProducto (
	IdDistribuidorProducto SERIAL PRIMARY KEY,
	IdDistribuidor SERIAL,
	Costo INTEGER NOT NULL,
	IdProducto SERIAL,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor),
	ADD FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);


CREATE TABLE DistribuidorArticulo (
	IdDistribuidorProducto SERIAL,
	IdArticulo SERIAL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidorProducto) REFERENCES DistribuidorProducto(IdDistribuidorProducto),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);

CREATE TABLE Devolucion (
	IdDevolucion SERIAL PRIMARY KEY,
	IdDistribuidor SERIAL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdDistribuidor) REFERENCES Distribuidor(IdDistribuidor)
);

CREATE TABLE DevolucionArticulo (
	IdDevolucion SERIAL,
	IdArticulo SERIAL,
	FOREIGN KEY (IdDevolucion) REFERENCES Devolucion(IdDevolucion),
	FOREIGN KEY (IdArticulo) REFERENCES Articulo(IdArticulo)
);