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

bcp "usp_SBMicroservicios_Personalizacion" queryout csv/Personalizacion.csv -c -C 65001 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection Personalizacion --type tsv --columnsHaveTypes --fields "PersonalizacionId.int32(),TipoAplicacion.string(),Atributo.string(),TextoAyuda.string(),TipoAtributo.string(),TipoPersonalizacion.string(),Orden.int32(),Estado.boolean()" --file csv/Personalizacion.csv --numInsertionWorkers 4 --ignoreBlanks
exit

:Fin
ECHO Error los parámetros enviados
pause
exit




