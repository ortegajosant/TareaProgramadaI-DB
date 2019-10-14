CREATE TABLE Pais
(
	IdPais INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(20)
);

CREATE TABLE Provincia
(	
	IdProvincia INT AUTO_INCREMENT PRIMARY KEY,
    IdPais INT NOT NULL,
    Nombre VARCHAR(20),
    FOREIGN KEY (IdPais) REFERENCES Pais(IdPais)
);

CREATE TABLE Canton
(
	IdCanton INT AUTO_INCREMENT PRIMARY KEY,
    IdProvincia INT NOT NULL,
    Nombre VARCHAR(20),
    FOREIGN KEY (IdProvincia) REFERENCES Provincia(IdProvincia)
);

CREATE TABLE Ciudad
(
	IdCiudad INT AUTO_INCREMENT PRIMARY KEY,
    IdCanton INT NOT NULL,
    Nombre VARCHAR(20),
    FOREIGN KEY (IdCanton) REFERENCES Canton(IdCanton)
);

CREATE TABLE Direccion
(
	IdDireccion INT AUTO_INCREMENT PRIMARY KEY,
    IdCiudad INT NOT NULL,
    Descripcion TEXT NOT NULL,
    FOREIGN KEY (IdCiudad) REFERENCES Ciudad(IdCiudad)
);