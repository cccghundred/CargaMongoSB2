
 /*
----------------------------------------------------------------------------------------------------------------------
PROPÓSITO            | Convertir xml a json
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| @XmlData - estructura xml
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
	SELECT dbo.fn_XmlToJson(
		'<evento><EventoId>22</EventoId><TieneCategoria>0</TieneCategoria><PersonalizacionNivel><PersonalizacionNivel><EventoId>22</EventoId>
		<NivelId>1</NivelId><PersonalizacionId>16</PersonalizacionId></PersonalizacionNivel><PersonalizacionNivel><EventoId>22</EventoId><NivelId>1</NivelId>
		<PersonalizacionId>19</PersonalizacionId></PersonalizacionNivel><PersonalizacionNivel><EventoId>22</EventoId><NivelId>1</NivelId>
		<PersonalizacionId>44</PersonalizacionId></PersonalizacionNivel></PersonalizacionNivel></evento>'
		)
*/

IF OBJECT_ID('dbo.fn_XmlToJson', 'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_XmlToJson
GO
SET QUOTED_IDENTIFIER ON  
GO

CREATE FUNCTION dbo.fn_XmlToJson
(
	@XmlData xml
)
RETURNS NVARCHAR(max)
AS
BEGIN
	declare @m NVARCHAR(max)
	SELECT @m='['+Stuff(
		(
		
		SELECT theline from																				
	(SELECT ','+' {'+																							
				Stuff(
					(SELECT ',"'+coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'),'')+'":'+			
						case when b.c.value('count(*)','int')=0 then 
                         dbo.fn_JsonEscape(b.c.value('text()[1]','NVARCHAR(MAX)')) 
						else dbo.fn_XmlToJson(b.c.query('*'))
						end
						
					from x.a.nodes('*') b(c)																
					for xml path(''),TYPE).value('(./text())[1]','NVARCHAR(MAX)')
				,1,1,'')+'}'																				
				
			from @XmlData.nodes('/*') x(a)																
			) JSON(theLine)																					
			
			for xml path(''),TYPE).value('.','NVARCHAR(MAX)' )
			,1,1,'')+']'
	return @m
END