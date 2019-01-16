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
PROPÓSITO            | Generar información de Estrategia Detalle desde TablaLogicaDatos
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| NO APLICA
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | Rodolfo Pérez
FECHA CREACIÓN       | 07/12/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 07/12/2018 Rodolfo Pérez       Creación de script
                     |  
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_TablaLogicaDatos_EstrategiaDetalle
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_TablaLogicaDatos_EstrategiaDetalle', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_TablaLogicaDatos_EstrategiaDetalle
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_TablaLogicaDatos_EstrategiaDetalle] 
AS
BEGIN

	SET NOCOUNT ON;
	select td.TablaLogicaDatosID, td.TablaLogicaID, td.Codigo, td.Descripcion 
	from dbo.TablaLogicaDatos td WITH (NOLOCK) where td.TablaLogicaID = 102 and td.Codigo not in ('02')

END
GO 