CREATE TABLE Marca (
	IdMarca SERIAL PRIMARY KEY,
	NombreMarca VARCHAR(20) NOT NULL,
	FechaAdicion DATE NOT NULL
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
	FechaAdicion DATE NOT NULL,
	FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca),
	FOREIGN KEY (IdTipoArticulo) REFERENCES TipoArticulo(IdTipoArticulo)
);

CREATE TABLE DetalleProducto (
	IdProducto SERIAL,
	Detalle VARCHAR(20) NOT NULL,
	Descripcion VARCHAR(20) NOT NULL,
	FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto)
);

CREATE TABLE Promocion (
	IdPromocion SERIAL PRIMARY KEY,
	IdSucursal SERIAL,
	FechaHoraInicio TIMESTAMP NOT NULL,
	FechaHoraFin TIMESTAMP NOT NULL,
	Porcentaje INTEGER NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal (IdSucursal)
);

CREATE TABLE PromocionProducto (
	IdPromocion SERIAL,
	IdProducto SERIAL,
	FOREIGN KEY (IdPromocion) REFERENCES Promocion (IdPromocion),
	FOREIGN KEY (IdProducto) REFERENCES Producto (IdProducto)
);