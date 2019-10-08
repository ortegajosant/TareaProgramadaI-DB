CREATE TABLE Sucursal (
	IdSucursal SERIAL PRIMARY KEY,
	IdDireccion SERIAL,
	NumeroTelefonico VARCHAR(10) NOT NULL,
	Codigo VARCHAR(20) NOT NULL,
	Estado BOOLEAN NOT NULL,
	FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
);

CREATE TABLE SucursalEmpleado (
	IdSucursal SERIAL,
	IdEmpleado SERIAL,
	FechaInicio DATE NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE AdministradorSucursal (
	IdSucursal SERIAL,
	IdEmpleado SERIAL,
	Fecha DATE NOT NULL,
	FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);