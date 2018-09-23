/*    ==Scripting Parameters==
    Source Server Version : SQL Server 2012 (11.0.6020)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server
    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
----------------------------------------------------------------------------------------------------------------------
PROPÓSITO            | Generar información de la tabla OfertasPersonalizadasCuv para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| 
                     | 
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | Yaniré Romero
FECHA CREACIÓN       | 02/07/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 02/07/2018 Yaniré Romero        Creación de script
                     | 
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_OfertaPersonalizadaCuv
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_OfertaPersonalizadaCuv', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_OfertaPersonalizadaCuv
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_OfertaPersonalizadaCuv] 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
    LTRIM(RTRIM(TipoPersonalizacion)) AS TipoPersonalizacion, 
	LTRIM(RTRIM(AnioCampanaVenta)) AS AnioCampanaVenta,  
	LTRIM(RTRIM(CUV)) AS CUV, 
	LimUnidades, 
	FlagUltMinuto
	FROM ods.OfertasPersonalizadasCuv WITH (NOLOCK)
END
