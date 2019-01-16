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
PROPÓSITO            | Generar información de nivel para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| NO APLICA
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | Elmer Cangahuala
FECHA CREACIÓN       | 15/08/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 15/08/2018 Elmer Cangahuala    Creación de script
                     | 
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_Nivel
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_Nivel', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_Nivel
GO

CREATE PROCEDURE dbo.usp_SBMicroservicios_Nivel
AS
BEGIN
	SET NOCOUNT ON

	SELECT NivelId, Codigo, Descripcion 
		FROM showroom.nivel
END
GO