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
PROPÓSITO            | Generar información de tonos para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| NO APLICA
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | Yaniré Romero
FECHA CREACIÓN       | 03/07/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 03/07/2018 Yaniré Romero        Creación de script
                     | 24/08/2018 César Cárdenas	   Adecuación para evitar duplicados 
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_Componente
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_Componente', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_Componente
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_Componente] 
AS
BEGIN
	SET NOCOUNT ON;

	WITH cte_ProductoComercial(CAMPANIAID,CUV,CUV2,CODIGO_ESTRATEGIA,GRUPO,CODIGO_SAP)
	AS
	(
		SELECT
		PMO.AnoCampania AS CAMPANIAID
		,PMO.CUV AS CUV
		,PM.CUV AS CUV2
		,PM.EstrategiaIDSicc AS CODIGO_ESTRATEGIA
		,ISNULL(PMO.NUMEROGRUPO,0) AS GRUPO
		,PMO.CodigoProducto AS CODIGO_SAP
		FROM ods.ProductoComercial PM WITH (NOLOCK)
			INNER JOIN ods.ProductoComercial PMO
			ON PM.EstrategiaIDSicc = PMO.EstrategiaIDSicc
			AND PM.AnoCampania =PMO.AnoCampania
			AND PM.CodigoOferta = PMO.CodigoOferta
		GROUP BY
		PMO.AnoCampania
		,PMO.CUV 
		,PM.CUV
		,PM.EstrategiaIDSicc
		,PMO.NUMEROGRUPO
		,PMO.CodigoProducto
	)
	SELECT
		 EPT.CUV2 AS CuvPadre
		,EPT.CAMPANIAID AS CampaniaId
		,EPT.CUV AS CUV
		,EPT.CODIGO_ESTRATEGIA AS CodigoEstrategia
		,EPT.Grupo
		,EPT.CODIGO_SAP AS CodigoSap
		,ISNULL(PCT.FactorRepeticion,1) AS Cantidad
		,PCT.PrecioUnitario AS PrecioUnitario
		,PCT.PrecioValorizado AS PrecioValorizado
		,PCT.NumeroLineaOferta AS Orden
		,PCT.IndicadorDigitable AS Digitable
		,CAST(ISNULL(PCT.CodigoFactorCuadre,1) AS INT) AS FactorCuadre
		,PCT.DESCRIPCION AS NombreProducto
		,PCT.MarcaID AS IdMarca
		FROM cte_ProductoComercial EPT
		INNER JOIN  ods.ProductoComercial PCT ON EPT.CAMPANIAID = PCT.AnoCampania 
			AND EPT.CUV = PCT.CUV
			AND EPT.CODIGO_ESTRATEGIA = PCT.EstrategiaIDSicc
END
GO