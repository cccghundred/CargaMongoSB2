/*    ==Scripting Parameters==
    Source Server Version : SQL Server 2012 (11.0.6020)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server
    Target Server Version : SQL Server 2012
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
----------------------------------------------------------------------------------------------------------------------
PROPÓSITO            | Generar información de producto comercial para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| 
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | César Cárdenas
FECHA CREACIÓN       | 13/06/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 13/06/2018 César Cárdenas       Creación de script
                     | 06/07/2018 Yaniré Romero        Precarga Tonos
					 | 10/07/2018 Yaniré Romero        Precarga Niveles
					 | 01/08/2018 Yaniré Romero        Indicador Digitable
					 | 21/09/2018 Mijael Palomino      Actualización de precio por EstrategiaIdSicc
					 | 16/10/2018 Mijael Palomino      Se agrega campos CodigoCatalogo, Categoria, GrupoArticulo y Linea
					 | 23/10/2018 César Cárdenas       Adecuación para cálculo de ganancia en EstrategiaIdSicc 2003 
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_ProductoComercial
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_ProductoComercial', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_ProductoComercial
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_ProductoComercial] 
AS
BEGIN	
	SET NOCOUNT ON;
	
	CREATE TABLE #ProductoTemporal (  
		 CampaniaId   int  
		 ,CodigoCampania int
		 ,CUV    varchar(50)  
		 ,DescripcionCUV varchar(100)
		 ,CodigoProducto varchar(10)
		 ,PrecioUnitario  numeric(12,2)  
		 ,IndicadorPreUni numeric(12,2)
		 ,PrecioPublico  numeric(12,2) 
		 ,PrecioOferta  numeric(12,2)  
		 ,PrecioTachado  numeric(12,2)   
		 ,Ganancia  numeric(12,2)   
		 ,IndicadorMontoMinimo int 
		 ,IndicadorDigitable int 
		 ,EstrategiaIdSicc int  
		 ,CodigoOferta  int  
		 ,NumeroGrupo  int  
		 ,NumeroNivel  int  
		 ,MarcaId int
		 ,MarcaDescripcion varchar(50)
		 ,IdMatrizComercial int
		 ,ImagenURL varchar(150)
		 ,Niveles varchar(200)
		 ,CodigoCatalogo varchar(6)
		 ,Categoria varchar(200)
		 ,GrupoArticulo varchar(200)
		 ,Linea varchar(200)
		 ,PrecioCatalogo  numeric(12,2)
		 ,PrecioValorizado  numeric(12,2)
	 ) 
	 INSERT INTO #ProductoTemporal
	 SELECT 
		p.CampaniaID,
		p.AnoCampania,
		p.CUV,
		REPLACE(COALESCE(mci.DescripcionComercial, pd.Descripcion,p.Descripcion),'"',char(39)) as DescripcionCUV, 
		p.CodigoProducto,
		p.PrecioUnitario,
		p.IndicadorPreUni,
		0,
		0,
		0,
		0,
		p.IndicadorMontoMinimo,
		p.IndicadorDigitable,   
		p.EstrategiaIdSicc,  
		p.CodigoOferta,  
		p.NumeroGrupo,  
		p.NumeroNivel,  
		p.MarcaID, 
		m.Descripcion, 
		mc.IdMatrizComercial,
		mci.Foto AS ImagenURL,
		'',
		RTRIM(p.CodigoCatalago) AS CodigoCatalago,
		fb.Nombre,
		ga.DescripcionCorta,
		sl.DescripcionLarga,
		p.PrecioCatalogo,
		p.PrecioValorizado
	FROM ods.ProductoComercial p WITH (NOLOCK) 
		INNER JOIN dbo.Marca m WITH (NOLOCK) on m.MarcaId = p.MarcaID 
		LEFT JOIN ods.SAP_PRODUCTO sp WITH (NOLOCK) ON p.CodigoProducto = sp.CodigoSap
		LEFT JOIN ods.SAP_LINEA sl WITH (NOLOCK) on sp.CodigoLinea = sl.Codigo
		LEFT JOIN ods.SAP_GRUPOARTICULO ga WITH (NOLOCK) on sp.CodigoGrupoArticuloSAP = ga.Codigo
		LEFT JOIN dbo.FiltroBuscadorGrupoArticulo fbga WITH (NOLOCK) on ga.Codigo = fbga.CodigoGrupoArticulo
		LEFT JOIN dbo.FiltroBuscador fb WITH (NOLOCK) on fbga.CodigoFiltroBuscador = fb.Codigo
		LEFT JOIN dbo.ProductoDescripcion pd WITH (NOLOCK) on p.AnoCampania = pd.CampaniaID and p.CUV = pd.CUV 
		LEFT JOIN dbo.MatrizComercial mc WITH (NOLOCK) on p.CodigoProducto = mc.CodigoSAP 
		LEFT JOIN dbo.MatrizComercialImagen mci WITH (NOLOCK) on mci.IdMatrizComercial = mc.IdMatrizComercial AND mci.NemoTecnico IS NOT NULL 

	CREATE TABLE #ProductoComercial(  
		CampaniaID   int  
		,CUV    varchar(50)  
		,PrecioUnitario  numeric(12,2)  
		,FactorRepeticion int  
		,IndicadorDigitable bit  
		,AnoCampania  int  
		,IndicadorPreUni numeric(12,2)  
		,CodigoFactorCuadre numeric(12,2)  
		,EstrategiaIdSicc int  
		,CodigoOferta  int  
		,NumeroGrupo  int  
		,NumeroNivel  int  
	)  
	INSERT INTO #ProductoComercial  
	SELECT  
		PC.CampaniaID  
		,PC.CUV  
		,PC.PrecioUnitario  
		,PC.FactorRepeticion  
		,PC.IndicadorDigitable  
		,PC.AnoCampania  
		,PC.IndicadorPreUni  
		,PC.CodigoFactorCuadre  
		,PC.EstrategiaIdSicc  
		,PC.CodigoOferta  
		,PC.NumeroGrupo  
		,PC.NumeroNivel  
	FROM ods.ProductoComercial PC  
	
	CREATE TABLE #ProductoNivel(  
		CUV   varchar(5)  
		,Nivel  int  
		,Precio  numeric(12,2)  
	)  
	INSERT INTO #ProductoNivel  
	SELECT  
		PC.CUV  
		,Nivel = PN.FactorCuadre  
		,Precio = PN.PrecioUnitario  
	FROM #ProductoComercial PC   
		JOIN ods.ProductoNivel PN  	ON PC.NumeroNivel = PN.NumeroNivel AND PN.FactorCuadre > 1  
	GROUP BY  
		PC.CUV  
		,PN.FactorCuadre  
		,PN.PrecioUnitario 
	 
	CREATE TABLE #ProductoTemporal_2001(  
		CampaniaID   int  
		,CUV    varchar(50)  
		,PrecioPublico   decimal(18,2)  
		,Ganancia    decimal(18,2)  
	)  
	INSERT INTO #ProductoTemporal_2001  
	SELECT  
		PC.CampaniaID, PC.CUV
		,PrecioPublico = PC.PrecioUnitario * PC.FactorRepeticion  
		,Ganancia = (PC.IndicadorPreUni - PC.PrecioUnitario) * PC.FactorRepeticion  
	FROM #ProductoComercial PC  
		WHERE (PC.EstrategiaIdSicc = 2001 OR PC.EstrategiaIdSicc IS NULL)
		AND PC.FactorRepeticion >= 1  
	 
	CREATE TABLE #ProductoTemporal_2002(  
		CodigoOferta	int
		,CampaniaId		int 
		,PrecioPublico	decimal(18,2)
		,Ganancia		decimal(18,2)
	)
	 INSERT INTO #ProductoTemporal_2002  
	 SELECT
			PC.CodigoOferta
			,PC.CampaniaId
			,PrecioPublico = SUM(PC.PrecioUnitario * PC.FactorRepeticion)
			,Ganancia =  SUM((PC.IndicadorPreUni - PC.PrecioUnitario) * PC.FactorRepeticion)
	FROM  #ProductoComercial PC
	WHERE PC.EstrategiaIdSicc = 2002
	GROUP BY PC.CampaniaId, PC.CodigoOferta
	ORDER BY PC.CampaniaId, PC.CodigoOferta  
	 
	 CREATE TABLE #ProductoTemporal_2003(  
	 CodigoOferta	int
			,CampaniaId		int 
			,PrecioPublico	decimal(18,2)
			,Ganancia		decimal(18,2)
	 )  
	 INSERT INTO #ProductoTemporal_2003  
	 SELECT
		PC.CodigoOferta
		,PC.CampaniaId
		,PrecioPublico = SUM(PC.PrecioUnitario * PC.FactorRepeticion * PC.CodigoFactorCuadre)
		,Ganancia =  SUM((PC.IndicadorPreUni - PC.PrecioUnitario) * PC.FactorRepeticion * PC.CodigoFactorCuadre)
	FROM (SELECT CampaniaId, CodigoOferta, NumeroGrupo, PrecioUnitario, MAX(IndicadorPreUni) AS IndicadorPreUni,  FactorRepeticion, CodigoFactorCuadre 
			FROM #ProductoComercial 
			WHERE EstrategiaIdSicc = 2003
			GROUP BY CampaniaId, CodigoOferta, NumeroGrupo, PrecioUnitario,  FactorRepeticion, CodigoFactorCuadre) PC
	GROUP BY PC.CampaniaId, PC.CodigoOferta
	ORDER BY PC.CampaniaId, PC.CodigoOferta 
  
	UPDATE PT 
	SET  
		PT.PrecioPublico = PT_GAN.PrecioPublico  
		,PT.Ganancia = PT_GAN.Ganancia  
	FROM #ProductoTemporal PT
		JOIN #ProductoTemporal_2001   PT_GAN ON PT_GAN.CampaniaID = PT.CampaniaID 
		AND PT_GAN.CUV = PT.CUV 
		AND EstrategiaIdSicc = 2001

	UPDATE PT 
	SET  
		PT.PrecioPublico = PT_GAN.PrecioPublico  
		,PT.Ganancia = PT_GAN.Ganancia  
	FROM #ProductoTemporal PT
		JOIN #ProductoTemporal_2002   PT_GAN ON PT_GAN.CampaniaID = PT.CampaniaID 
		AND PT_GAN.CodigoOferta = PT.CodigoOferta 
		AND EstrategiaIdSicc = 2002

	UPDATE PT 
	SET  
		PT.PrecioPublico = PT_GAN.PrecioPublico  
		,PT.Ganancia = PT_GAN.Ganancia  
	FROM #ProductoTemporal PT
		JOIN #ProductoTemporal_2003  PT_GAN ON PT_GAN.CampaniaID = PT.CampaniaID 
		AND PT_GAN.CodigoOferta = PT.CodigoOferta 
		AND EstrategiaIdSicc = 2003

	UPDATE PT  
	SET PT.Ganancia = 0  
	FROM #ProductoTemporal PT
	WHERE PT.Ganancia < 0  
  
	UPDATE PT  
	SET PT.PrecioOferta = PT.PrecioPublico  
	FROM #ProductoTemporal PT 
	WHERE PT.PrecioPublico > 0  

	UPDATE PT  
	SET PT.PrecioTachado = PT.PrecioPublico + PT.Ganancia  
	FROM #ProductoTemporal PT 
	WHERE PT.Ganancia > 0  
	UPDATE PN  
	SET Precio = PN.Nivel * PN.Precio  
	FROM #ProductoNivel PN  
	
	CREATE TABLE #ProductoNiveles(  
	CUV   varchar(5)  
	,Niveles varchar(200)  
	)  
	INSERT INTO #ProductoNiveles  
	SELECT  
		PN.CUV,  
		Niveles = ( SELECT STUFF( (SELECT '|' + CONVERT(varchar, Nivel)  + 'X' + '-' + CONVERT(varchar, Precio)  
				FROM #ProductoNivel  
				WHERE CUV = PN.CUV  
				FOR XML PATH(''), TYPE).value('.[1]', 'varchar(200)'),  
				1,  
				1,  
				''  
				)  
			)  
	FROM #ProductoNivel PN  
	GROUP BY PN.CUV  
	UPDATE PT  
	SET  
		PT.Niveles = PNS.Niveles  
	FROM #ProductoTemporal PT  
		JOIN #ProductoNiveles PNS ON PT.CUV = PNS.CUV  
	SELECT * FROM #ProductoTemporal
	DROP TABLE #ProductoComercial  
	DROP TABLE #ProductoNivel  
	DROP TABLE #ProductoNiveles 
  
	DROP TABLE #ProductoTemporal_2001  
	DROP TABLE #ProductoTemporal_2002  
	DROP TABLE #ProductoTemporal_2003  
	DROP TABLE #ProductoTemporal
END