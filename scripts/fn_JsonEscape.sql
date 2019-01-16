
/*
----------------------------------------------------------------------------------------------------------------------
PROPÓSITO            | Limpiar cadena 
----------------------------------------------------------------------------------------------------------------------
PARÁMETROS DE ENTRADA| @value - Valor a limpiar
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
	SELECT dbo.fn_JsonEscape('[ {"EventoId":22,"TieneCategoria":0,"PersonalizacionNivel":[ {"EventoId":22,"NivelId":1,
        "PersonalizacionId":16}, {"EventoId":22,"NivelId":1,"PersonalizacionId":19}, {"EventoId":22,"NivelId":1,
        "PersonalizacionId":44}]}]')
*/

IF OBJECT_ID('dbo.fn_JsonEscape', 'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_JsonEscape
GO
SET QUOTED_IDENTIFIER ON  
GO

CREATE FUNCTION dbo.fn_JsonEscape(@value NVARCHAR(max) )
returns NVARCHAR(max)
as begin
 
 if (@value is null) return 'null'
 if (TRY_PARSE( @value as float) is not null) return @value

 set @value=replace(@value,CHAR(92),CHAR(92)+CHAR(92))
 set @value=replace(@value,CHAR(34),CHAR(92)+CHAR(34))

 set @value=replace(@value,'/',CHAR(92)+'/')
 set @value=replace(@value,CHAR(10),CHAR(92)+'n')
 set @value=replace(@value,CHAR(13),CHAR(92)+'r')
 set @value=replace(@value,CHAR(19),CHAR(92)+'t')


 return CHAR(34)+@value+CHAR(34)

end