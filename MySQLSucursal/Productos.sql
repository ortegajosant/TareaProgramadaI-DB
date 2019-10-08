CREATE TABLE Marca 
(
	IdMarca INT AUTO_INCREMENT PRIMARY KEY,
    NombreMarca VARCHAR(20) NOT NULL
);

CREATE TABLE TipoArticulo
(
	IdTipoArticulo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Producto
(
	IdProducto INT AUTO_INCREMENT PRIMARY KEY,
    IdMarca INT NOT NULL,
    IdTipoArticulo INT NOT NULL,
    Codigo VARCHAR(15) NOT NULL,
    Nombre TEXT NOT NULL,
    Peso SMALLINT NOT NULL,
    TiempoGarantia INT NOT NULL,
    Sexo CHAR NOT NULL,
    Medida VARCHAR(3) NOT NULL,
    FOREIGN KEY (IdMarca) REFERENCES Marca (IdMarca),
    FOREIGN KEY (IdTipoArticulo) REFERENCES TipoArticulo (IdTipoArticulo)
);

CREATE TABLE DetalleProducto
(
	IdProducto INT AUTO_INCREMENT PRIMARY KEY,
    Detalle VARCHAR(20) NOT NULL,
    Descripcion TEXT NOT NULL
);

CREATE TABLE Articulo
(
	IdArticulo INT AUTO_INCREMENT PRIMARY KEY,
    IdProducto INT NOT NULL,
    Estado BOOLEAN NOT NULL,
    EstadoArticulo VARCHAR(15) NOT NULL,
    Costo INT NOT NULL,
    FOREIGN KEY (IdProducto) REFERENCES Producto (IdProducto)
);