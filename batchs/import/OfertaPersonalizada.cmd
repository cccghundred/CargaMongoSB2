@ECHO OFF
IF "%1" == "" goto Fin
IF "%2" == "" goto Fin
IF "%3" == "" goto Fin
IF "%4" == "" goto Fin
IF "%5" == "" goto Fin
IF "%6" == "" goto Fin

ECHO Ruta del archivo sql: %1
for /F "tokens=*" %%a in (%1) do (
    SET connSQL=%%a
    )

ECHO Ruta del archivo mongo: %2
for /F "tokens=*" %%a in (%2) do (
    SET connMongoDB=%%a
    )

bcp "exec usp_SBMicroservicios_OfertaPersonalizada '%5', '%6'" queryout csv/OfertasPersonalizadas%6%5.csv -c -C 65001 -b 10000 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection OfertaPersonalizada --type tsv --columnsHaveTypes --fields "TipoPersonalizacion.string(),CodConsultora.string(),AnioCampanaVenta.string(),CUV.string(),CUC.string(),CodSap.string(),ZonasPortal.string(),DiaInicio.int32(),DiaFin.int32(),Orden.int32(),CodVinculo.int32(),PPU.decimal(),LimUnidades.int32(),FlagUltMinuto.boolean(),CodMandanteOF.string(),FlagRevista.int32()" --file csv/OfertasPersonalizadas%6%5.csv --numInsertionWorkers 8 --ignoreBlanks
exit

:Fin
ECHO Error los parámetros enviados
pause
exit