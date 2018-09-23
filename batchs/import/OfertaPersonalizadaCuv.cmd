@ECHO OFF
IF "%1" == "" goto Fin
IF "%2" == "" goto Fin
IF "%3" == "" goto Fin
IF "%4" == "" goto Fin

ECHO Ruta del archivo sql: %1
for /F "tokens=*" %%a in (%1) do (
    SET connSQL=%%a
    )

ECHO Ruta del archivo mongo: %2
for /F "tokens=*" %%a in (%2) do (
    SET connMongoDB=%%a
    )

bcp "exec usp_SBMicroservicios_OfertaPersonalizadaCuv" queryout csv/OfertasPersonalizadasCuv.csv -c -C 65001 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection OfertaPersonalizadaCuv --type tsv --columnsHaveTypes --fields "TipoPersonalizacion.string(),AnioCampanaVenta.string(),CUV.string(),LimUnidades.int32(),FlagUltMinuto.string()" --file csv/OfertasPersonalizadasCuv.csv --numInsertionWorkers 4 --ignoreBlanks
exit

:Fin
ECHO Error los parámetros enviados
pause
exit