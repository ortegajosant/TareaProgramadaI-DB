CREATE TABLE Articulo (
	IdArticulo SERIAL PRIMARY KEY,
	IdProducto SERIAL,
	IdSucursal SERIAL,
	Estado BOOLEAN NOT NULL,
	EstadoArticulo VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto),
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
);
ALTER TABLE Articulo ADD COLUMN Costo INTEGER NOT NULL;

CREATE TABLE ActualizacionArticuloPunto(
	IdActualizacionArticuloPunto SERIAL PRIMARY KEY,
	FechaInicio DATE NOT NULL,
	FechaFinal DATE NOT NULL
);

CREATE TABLE ArticuloPunto(
	IdActualizacionArticuloPunto SERIAL,
	IdProducto SERIAL,
	Puntos INTEGER NOT NULL,
	FOREIGN KEY (IdActualizacionArticuloPunto) REFERENCES ActualizacionArticuloPunto(IdActualizacionArticuloPunto),
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);