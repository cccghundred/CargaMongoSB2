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
PROPÓSITO            | Generar información de Evento para exportar a Mongo
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| @vCampaniaId - Código de camapaña
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
	EXEC usp_SBMicroservicios_Evento 201814
*/
IF OBJECT_ID('dbo.usp_SBMicroservicios_Evento', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_SBMicroservicios_Evento
GO

CREATE PROCEDURE dbo.usp_SBMicroservicios_Evento
    @vCampaniaId INT
AS
BEGIN
	SET NOCOUNT ON

select dbo.fn_XmlToJson((
	select e.EventoId, e.TieneCategoria, e.TieneCompraXcompra, e.TienePersonalizacion, e.TieneSubCampania, e.CampaniaId,
		   e.DiasAntes, e.DiasDespues, e.Estado, e.NumeroPerfiles, e.Imagen1, e.Imagen2, e.ImagenCabeceraProducto,
		   e.ImagenPestaniaShowRoom, e.ImagenPreventaDigital, e.ImagenVentaSetPopup, e.ImagenVentaTagLateral, 
		   e.Nombre, e.RutaShowRoomBannerLateral, e.RutaShowRoomPopup, e.Tema, 'MONGOIMPORT' UsuarioCreacion, 
		   (SELECT 
				e.EventoId, 1 AS 'NivelId', p.PersonalizacionId, p.TipoPersonalizacion, p.TipoAplicacion, p.TipoAtributo, p.Atributo, p.TextoAyuda, p.Orden, p.Estado,
				ISNULL((SELECT TOP 1 Valor 
					FROM showroom.PersonalizacionNivel pn
						WHERE pn.EventoId=e.EventoId
						AND p.PersonalizacionId=pn.PersonalizacionId),'') AS 'Valor'
					FROM showroom.Personalizacion p 
						WHERE p.Estado=1 AND TipoPersonalizacion='EVENTO'
			for xml path('PersonalizacionNivel'),type
		   )  PersonalizacionNivel
	from   showroom.evento e WHERE e.CampaniaID=@vCampaniaId
	for    xml path('evento'),type
))
END
GO