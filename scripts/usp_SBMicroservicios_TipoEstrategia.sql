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
PROPÓSITO            | Generar información de TipoEstrategia para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| NO APLICA
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE SALIDA | NO APLICA
----------------------------------------------------------------------------------------------------------------------
CREADO POR           | César Cárdenas
FECHA CREACIÓN       | 03/08/2018
----------------------------------------------------------------------------------------------------------------------
HISTORIAL DE CAMBIOS | FECHA      RESPONSABLE         MOTIVO
                     | ---------- ------------------- ----------------------------------------------------------------
                     | 30/08/2018 César Cárdenas       Creación de script
                     |  
----------------------------------------------------------------------------------------------------------------------
PRUEBA:               
	EXEC usp_SBMicroservicios_TipoEstrategia
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_TipoEstrategia', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_TipoEstrategia
GO

CREATE PROCEDURE [dbo].[usp_SBMicroservicios_TipoEstrategia] 
AS
BEGIN
	SET NOCOUNT ON;

    SELECT 
    Codigo AS CodigoTipoEstrategia, 
    TipoEstrategiaID, 
    (CASE Codigo WHEN '001' THEN 'OPT' 
        WHEN '009' THEN 'ODD' 
        WHEN '005' THEN 'LAN' 
        WHEN '007' THEN 'OPM' 
        WHEN '008' THEN 'PAD' 
        WHEN '010' THEN 'GND' 
        WHEN '011' THEN 'HV' 
        WHEN '030' THEN 'SR' END) as TipoPersonalizacion,
    DescripcionEstrategia AS DescripcionTipoEstrategia ,
    ImagenEstrategia, 
    Orden, 
    FlagActivo, 
    FlagNueva, 
    FlagRecoProduc ,
    FlagRecoPerfil, 
    CodigoPrograma, 
    FlagMostrarImg, 
    MostrarImgOfertaIndependiente,
    ImagenOfertaIndependiente, 
    Codigo, 
    FlagValidarImagen, 
    PesoMaximoImagen,
    UsuarioRegistro AS UsuarioCreacion, 
    UsuarioModificacion ,
    FechaRegistro AS FechaCreacion, 
    FechaModificacion 
    FROM TipoEstrategia WITH (NOLOCK)
END
GO