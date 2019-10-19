INSERT INTO Marca (NombreMarca, FechaAdicion) VALUES
('Quiksilver', NOW()::TIMESTAMP::DATE);

INSERT INTO TipoArticulo (Nombre) VALUES
('Camisa');

INSERT INTO Producto (IdMarca, IdTipoArticulo, Nombre, Codigo, Peso, TiempoGarantia, Sexo, Medida, FechaAdicion) VALUES
(1, 1, 'Camisa Playera QS', '4DG-227U39-3', '100', 90, 'H', 'XS', NOW()::TIMESTAMP::DATE);

INSERT INTO DetalleProducto (IdProducto, Detalle, Descripcion) VALUES
(1, 'Color', 'Azul');

INSERT INTO Articulo (IdProducto, Estado, EstadoArticulo, Costo) VALUES
(1, TRUE, 'En Bodega', 30000);