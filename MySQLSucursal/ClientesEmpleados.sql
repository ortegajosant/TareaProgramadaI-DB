CREATE TABLE Usuario
(
	IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    IdDireccion INT NOT NULL,
    Nombre VARCHAR(20) NOT NULL,
    Identificacion VARCHAR(20) NOT NULL,
    ApellidoPat VARCHAR(20) NOT NULL,
    ApellidoMat VARCHAR(20) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    NumeroTelefonico VARCHAR(10) NOT NULL,
    FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);


CREATE TABLE Empleado 
(
	IdEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    CuentaBancaria VARCHAR(20) NOT NULL,
    Estado BOOLEAN NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario (IdUsuario)
);

CREATE TABLE Cliente
(
	IdCliente INT AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT NOT NULL,
	Punto INT NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario (IdUsuario)
);