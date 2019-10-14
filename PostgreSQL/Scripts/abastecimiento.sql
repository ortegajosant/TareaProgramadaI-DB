CREATE OR REPLACE FUNCTION ReporteAbastecimiento()
RETURNS VOID AS $$
BEGIN
	COPY (
		SELECT S.IdSucursal, P.IdProducto, COUNT(A.IdArticulo) AS Cantidad
		FROM Sucursal AS S
		INNER JOIN Articulo AS A ON A.IdSucursal = S.idsucursal
		INNER JOIN Producto AS P ON P.IdProducto = A.IdProducto
		GROUP BY S.IdSucursal, P.IdProducto
	)
	To 'C:\Users\Public\test.csv' DELIMITER ';' CSV HEADER;
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION ReporteAbastecimiento();
--SELECT ReporteAbastecimiento();


