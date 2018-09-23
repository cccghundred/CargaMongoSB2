@ECHO OFF
IF "%1" == "" goto Fin
IF "%2" == "" goto Fin

ECHO Params 1 %1
ECHO Params 2 %2

for /F "tokens=*" %%a in (%1) do (
    SET connSQL=%%a
    )

ECHO Conexion: %connSQL%
REM sqlcmd %connSQL% -d %2 -i scripts\ejemplo.sql
sqlcmd %connSQL% -d %2 -i scripts\usp_SBMicroservicios_Componente.sql
sqlcmd %connSQL% -d %2 -i scripts\usp_SBMicroservicios_TipoEstrategia.sql
sqlcmd %connSQL% -d %2 -i scripts\usp_SBMicroservicios_ProductoFaltanteZona.sql
sqlcmd %connSQL% -d %2 -i scripts\usp_SBMicroservicios_ProductoComercial.sql
sqlcmd %connSQL% -d %2 -i scripts\usp_SBMicroservicios_OfertaPersonalizadaCuv.sql
sqlcmd %connSQL% -d %2 -i scripts\usp_SBMicroservicios_OfertaPersonalizada.sql
exit

:Fin
pause
exit