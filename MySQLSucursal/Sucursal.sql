CREATE TABLE Puesto
(
	IdPuesto INT AUTO_INCREMENT PRIMARY KEY,
    SalarioBase INT NOT NULL,
    NombrePuesto VARCHAR (15) NOT NULL
);

CREATE TABLE PuestoEmpleado 
(
	IdEmpleado INT NOT NULL,
    IdPuesto INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado),
    FOREIGN KEY (IdPuesto) REFERENCES Puesto (IdPuesto)
);

CREATE TABLE SucursalEmpleado
(
	IdEmpleado INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);

CREATE TABLE AdministradorSucursal 
(
	IdEmpleado INT NOT NULL,
    Fecha DATE NOT NULL,
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);

CREATE TABLE EmpleadoMes
(
	IdEmpleado INT NOT NULL,
    Fecha DATE,
    FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)
);
