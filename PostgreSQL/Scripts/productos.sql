CREATE TABLE Marca (
	IdMarca SERIAL PRIMARY KEY,
	NombreMarca VARCHAR(20) NOT NULL
);

CREATE TABLE TipoArticulo (
	IdTipoArticulo SERIAL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Producto (
	IdProducto SERIAL PRIMARY KEY,
	IdMarca SERIAL,
	IdTipoArticulo SERIAL,
	Nombre VARCHAR(20) NOT NULL,
	Codigo VARCHAR(20) NOT NULL,
	Peso INTEGER NOT NULL,
	TiempoGarantia INTEGER NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	Medida VARCHAR(3) NOT NULL,
	FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca),
	FOREIGN KEY (IdTipoArticulo) REFERENCES TipoArticulo(IdTipoArticulo)
);

CREATE TABLE DetalleProducto (
	IdProducto SERIAL,
	Detalle VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);