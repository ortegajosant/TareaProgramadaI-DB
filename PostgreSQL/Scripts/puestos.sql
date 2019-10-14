CREATE TABLE Puesto (
	IdPuesto SERIAL PRIMARY KEY,
	SalarioBase INTEGER NOT NULL, 
	Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE PuestoEmpleado (
	IdPuesto SERIAL,
	IdEmpleado SERIAL,
	FechaInicio DATE NOT NULL,
	FOREIGN KEY (IdPuesto) REFERENCES Puesto (IdPuesto),
	FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);