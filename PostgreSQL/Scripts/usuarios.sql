CREATE TABLE Usuario (
	IdUsuario SERIAL PRIMARY KEY,
	IdDireccion SERIAL,
	Identificacion VARCHAR(20)  NOT NULL,
	Nombre VARCHAR(20) NOT NULL,
	ApellidoPat VARCHAR(20) NOT NULL,
	ApellidoMat VARCHAR(20) NOT NULL,
	FechaNacimiento DATE NOT NULL, 
	NumeroTelefonico VARCHAR(10) NOT NULL,
	FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

CREATE TABLE Empleado (
	IdEmpleado SERIAL PRIMARY KEY,
	IdUsuario SERIAL,
	FechaIngreso DATE NOT NULL,
	CuentaBancaria VARCHAR(20) NOT NULL,
	Estado BOOLEAN NOT NULL,
	FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

