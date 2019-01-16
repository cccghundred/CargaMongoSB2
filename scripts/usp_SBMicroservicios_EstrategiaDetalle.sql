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
PROPÓSITO            | Generar información de EstrategiaDetalle para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| @vEstrategiaId - Código de camapaña
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | Rodolfo Pérez
FECHA CREACIÓN       | 03/12/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 03/12/2018 Rodolfo Pérez    Creación de script
                     | 
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_EstrategiaDetalle
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_EstrategiaDetalle', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_EstrategiaDetalle
GO

CREATE PROCEDURE dbo.usp_SBMicroservicios_EstrategiaDetalle
	@vEstrategiaId INT
AS
BEGIN
	SET NOCOUNT ON

	SELECT TablaLogicaDatosID, Valor
		FROM EstrategiaDetalle WHERE EstrategiaID = @vEstrategiaId
END
GO