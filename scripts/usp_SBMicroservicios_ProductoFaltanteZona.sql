SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
----------------------------------------------------------------------------------------------------------------------
PROPÓSITO            | Generar información de productos faltantes para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| 
                     | 
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | Eder Lázaro
FECHA CREACIÓN       | 24/07/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 24/07/2018 Eder Lázaro		   Creación de script
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_ProductoFaltanteZona
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_ProductoFaltanteZona', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_ProductoFaltanteZona
GO

CREATE PROCEDURE usp_SBMicroservicios_ProductoFaltanteZona
    @CampaniaCodigo varchar(6) = NULL
AS
BEGIN

SET NOCOUNT ON;
DECLARE @TempTable TABLE (
		CodigoCampania VARCHAR(6),
		CodigoZona VARCHAR(8),
		CUV VARCHAR(20)
	)
	
	INSERT INTO @TempTable -- Pais
	SELECT 
		C.Codigo AS CodigoCampania,
		'AGOTADO' AS CodigoZona,
		RTRIM(FA.CodigoVenta) AS Cuv
	FROM ods.FaltanteAnunciado FA WITH(NOLOCK)
	INNER JOIN ODS.Campania C WITH(NOLOCK) ON FA.CampaniaID = C.CampaniaID
	WHERE 
		(@CampaniaCodigo IS NULL OR C.Codigo = @CampaniaCodigo)
		AND  FA.CodigoRegion IS NULL AND FA.CodigoZona IS NULL

	INSERT INTO @TempTable -- Region	
	SELECT A.* FROM (
		SELECT 
		C.Codigo AS CodigoCampania,
		RTRIM(Z.Codigo) AS CodigoZona,
		RTRIM(FA.CodigoVenta) AS CUV
		from ods.FaltanteAnunciado FA WITH(NOLOCK)
		INNER JOIN ODS.Campania C WITH(NOLOCK) ON FA.CampaniaID = C.CampaniaID
		INNER JOIN ODS.REGION R WITH(NOLOCK) ON FA.CodigoRegion = R.Codigo
		INNER JOIN ODS.ZONA Z WITH(NOLOCK) ON R.RegionID = Z.RegionId
		WHERE 
		(@CampaniaCodigo IS NULL OR C.Codigo = @CampaniaCodigo)
		AND  FA.CodigoZona IS NULL AND FA.CodigoRegion IS NOT NULL) A	
	LEFT JOIN @TempTable TEMP ON A.CodigoCampania = TEMP.CodigoCampania AND A.CUV = TEMP.CUV
	WHERE TEMP.CodigoCampania IS NULL AND TEMP.CodigoZona IS NULL AND TEMP.CUV IS NULL

	INSERT INTO @TempTable -- Zona	
	SELECT A.* FROM (
		SELECT 
		C.Codigo AS CodigoCampania,
		RTRIM(FA.CodigoZona) AS CodigoZona,
		RTRIM(FA.CodigoVenta) AS CUV
		FROM ods.FaltanteAnunciado FA WITH(NOLOCK)
		INNER JOIN ODS.Campania C WITH(NOLOCK) ON FA.CampaniaID = C.CampaniaID
		WHERE 
		(@CampaniaCodigo IS NULL OR C.Codigo = @CampaniaCodigo)
		AND  FA.CodigoZona IS NOT NULL		
		UNION
		SELECT  
		PF.CampaniaID AS CodigoCampania,
		RTRIM(Z.Codigo) AS CodigoZona,
		RTRIM(PF.CUV) AS CUV
		FROM dbo.ProductoFaltante PF WITH(NOLOCK)
		INNER JOIN ods.Zona Z WITH(NOLOCK) ON PF.ZonaID = Z.ZonaID
		WHERE 
		(@CampaniaCodigo IS NULL OR PF.CampaniaID = @CampaniaCodigo)
		) A	
	LEFT JOIN @TempTable TEMP ON A.CodigoCampania = TEMP.CodigoCampania AND A.CUV = TEMP.CUV
	WHERE TEMP.CodigoCampania IS NULL AND TEMP.CodigoZona IS NULL AND TEMP.CUV IS NULL	

	-- Formatear para devolver
	SELECT CodigoCampania, CUV,
		STUFF((SELECT '|' + CodigoZona
              FROM   @TempTable AS T1
              WHERE T1.CUV = T2.CUV AND T1.CodigoCampania = T2.CodigoCampania
              FOR XML PATH('')), 1, 1, '') Zonas
	FROM @TempTable AS T2
    GROUP BY CodigoCampania, CUV

END
GO