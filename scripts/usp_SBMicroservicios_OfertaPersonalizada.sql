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
PROPÓSITO            | Generar información de oferta personalizada para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| @vAnioCampania - Código de camapaña
                     | @vTipoPersonalizacion - Código del tipo de personalización
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | César Cárdenas
FECHA CREACIÓN       | 19/06/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 19/06/2018 César Cárdenas       Creación de script
                     | 06/07/2018 César Cárdenas       Trim al campo CodSap
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_OfertaPersonalizada '201809', 'ODD'
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_OfertaPersonalizada', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_OfertaPersonalizada
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_OfertaPersonalizada] 
	@vAnioCampania as VARCHAR(6),
	@vTipoPersonalizacion as VARCHAR(4)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	LTRIM(RTRIM(TipoPersonalizacion)) AS TipoPersonalizacion, 
	LTRIM(RTRIM(CodConsultora)) AS CodConsultora, 
	LTRIM(RTRIM(AnioCampanaVenta)) AS AnioCampanaVenta, 
	LTRIM(RTRIM(CUV)) AS CUV, 
	CUC, 
	LTRIM(RTRIM(CodSap)) AS CodSap, 
	ZonasPortal, 
	DiaInicio, 
	DiaFin, 
	Orden, 
	CodVinculo, 
	PPU, 
	LimUnidades, 
	FlagUltMinuto,
	FlagRevista,
	MaterialGanancia
	FROM ods.OfertasPersonalizadas WITH (NOLOCK)
	WHERE AnioCampanaVenta = @vAnioCampania AND TipoPersonalizacion = @vTipoPersonalizacion;
END
