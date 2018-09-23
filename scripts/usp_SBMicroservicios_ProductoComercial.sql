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
PROP?SITO            | Generar informaci�n de producto comercial para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PAR?METROS DE ENTRADA| 
----------------------------------------------------------------------------------------------------------------------
PAR?METROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | C�sar C�rdenas
FECHA CREACI?N       | 13/06/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 13/06/2018 C�sar C�rdenas       Creaci�n de script
                     | 06/07/2018 Yanir� Romero        Precarga Tonos
					 | 10/07/2018 Yanir� Romero        Precarga Niveles
					 | 01/08/2018 Yanir� Romero        Indicador Digitable
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_ProductoComercial

*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_ProductoComercial','P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_ProductoComercial
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_ProductoComercial] 
AS

BEGIN
	SET NOCOUNT ON;

	/**** 1. Creando Temporales - Ini ****/
	/* #ProductoTemporal */  
	 DECLARE @ProductoTemporal TABLE (  
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
	 ) 
	 INSERT INTO @ProductoTemporal
	 select 
		p.CampaniaID,
		p.AnoCampania,
		p.CUV,
		REPLACE(COALESCE(mci.DescripcionComercial,pd.Descripcion,p.Descripcion),'"',char(39)) as DescripcionCUV, 
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
		mci.Foto as ImagenURL,
		''
		from 
		ods.ProductoComercial p WITH (NOLOCK) JOIN 
		dbo.Marca m WITH (NOLOCK) on m.MarcaId = p.MarcaID LEFT JOIN 
		dbo.ProductoDescripcion pd WITH (NOLOCK) on p.AnoCampania = pd.CampaniaID and p.CUV = pd.CUV LEFT JOIN 
		dbo.MatrizComercial mc WITH (NOLOCK) on p.CodigoProducto = mc.CodigoSAP LEFT JOIN 
		dbo.MatrizComercialImagen mci WITH (NOLOCK) on mci.IdMatrizComercial = mc.IdMatrizComercial AND mci.NemoTecnico IS NOT NULL 

	 /*#ProductoComercial*/  
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

	 /* #ProductoNivel */  
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
	JOIN ods.ProductoNivel PN  
	ON PC.NumeroNivel = PN.NumeroNivel  
	AND PN.FactorCuadre > 1  
	GROUP BY  
	PC.CUV  
	,PN.FactorCuadre  
	,PN.PrecioUnitario 
	 /**** 1. Creando Temporales - Fin ****/  

	 /**** 2. C�lculo de Ganancia - Ini ****/  
	 /* #ProductoTemporal_2001 */  
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
  
	 /* #ProductoTemporal_2002 */  
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

	 /* #ProductoTemporal_2003 */  
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
		FROM (SELECT CampaniaId, CodigoOferta, NumeroGrupo, PrecioUnitario, IndicadorPreUni,  FactorRepeticion, CodigoFactorCuadre 
				FROM #ProductoComercial 
				WHERE EstrategiaIdSicc = 2003
				GROUP BY CampaniaId, CodigoOferta, NumeroGrupo, PrecioUnitario, IndicadorPreUni,  FactorRepeticion, CodigoFactorCuadre) PC
		GROUP BY PC.CampaniaId, PC.CodigoOferta
		ORDER BY PC.CampaniaId, PC.CodigoOferta 
  
	 UPDATE PT 
	 SET  
	  PT.PrecioPublico = PT_GAN.PrecioPublico  
	 ,PT.Ganancia = PT_GAN.Ganancia  
	 FROM @ProductoTemporal PT
	  JOIN #ProductoTemporal_2001   PT_GAN  
	   ON PT_GAN.CampaniaID = PT.CampaniaID 
	   AND PT_GAN.CUV  COLLATE DATABASE_DEFAULT = PT.CUV  COLLATE DATABASE_DEFAULT

	UPDATE PT 
	 SET  
	  PT.PrecioPublico = PT_GAN.PrecioPublico  
	 ,PT.Ganancia = PT_GAN.Ganancia  
	 FROM @ProductoTemporal PT
	  JOIN #ProductoTemporal_2002   PT_GAN  
	   ON PT_GAN.CampaniaID = PT.CampaniaID 
	   AND PT_GAN.CodigoOferta = PT.CodigoOferta 

	UPDATE PT 
	 SET  
	  PT.PrecioPublico = PT_GAN.PrecioPublico  
	 ,PT.Ganancia = PT_GAN.Ganancia  
	 FROM @ProductoTemporal PT
	  JOIN #ProductoTemporal_2003  PT_GAN  
	   ON PT_GAN.CampaniaID = PT.CampaniaID 
	   AND PT_GAN.CodigoOferta = PT.CodigoOferta 

	 UPDATE PT  
	 SET PT.Ganancia = 0  
	 FROM @ProductoTemporal PT
	 WHERE PT.Ganancia < 0  
  
	 UPDATE PT  
	 SET PT.PrecioOferta = PT.PrecioPublico  
	 FROM @ProductoTemporal PT 
	 WHERE PT.PrecioPublico > 0  
	 UPDATE PT  
	 SET PT.PrecioTachado = PT.PrecioPublico + PT.Ganancia  
	 FROM @ProductoTemporal PT 
	 WHERE PT.Ganancia > 0  
	 /**** 2. C�lculo de Ganancia - Fin ****/ 

	 /**** 3. C�lculo de Niveles - Ini ****/  
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
	FROM @ProductoTemporal PT  
	JOIN #ProductoNiveles PNS  
	ON PT.CUV COLLATE DATABASE_DEFAULT = PNS.CUV COLLATE DATABASE_DEFAULT 

	select * from @ProductoTemporal
	/**** 3. C�lculo de Niveles - Fin ****/ 

     /**** 4. Limpiando Temporales - Ini ****/  
	 DROP TABLE #ProductoComercial  
	 DROP TABLE #ProductoNivel  
	 DROP TABLE #ProductoNiveles 
  
	 DROP TABLE #ProductoTemporal_2001  
	 DROP TABLE #ProductoTemporal_2002  
	 DROP TABLE #ProductoTemporal_2003  
	 /**** 4. Limpiando Temporales - Fin ****/  
	
END