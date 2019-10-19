CREATE OR REPLACE FUNCTION ReporteAbastecimiento()
RETURNS VOID AS $$
DECLARE variable text;
BEGIN
	variable := NOW()::DATE;
	EXECUTE format ('	COPY (
		SELECT S.IdSucursal, P.IdProducto, COUNT(A.IdArticulo) AS Cantidad
		FROM Sucursal AS S
		INNER JOIN Articulo AS A ON A.IdSucursal = S.idsucursal
		INNER JOIN Producto AS P ON P.IdProducto = A.IdProducto
		GROUP BY S.IdSucursal, P.IdProducto
	)
	TO ''C:\Users\Public\reporte_%s.csv'' DELIMITER '';'' CSV HEADER;',--  // %s will be replaced by string variable
        variable -- File name
    );
END;
$$ LANGUAGE plpgsql;

--DROP FUNCTION ReporteAbastecimiento();
--SELECT ReporteAbastecimiento();


