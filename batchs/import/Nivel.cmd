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

bcp "usp_SBMicroservicios_Nivel" queryout csv/Nivel.csv -c -C 65001 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection Nivel --type tsv --columnsHaveTypes --fields "NivelId.int32(),Codigo.string(),Descripcion.string()" --file csv/Nivel.csv --numInsertionWorkers 4 --ignoreBlanks
exit

:Fin
ECHO Error los par�metros enviados
pause
exit