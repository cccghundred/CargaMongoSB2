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

bcp "exec usp_SBMicroservicios_Componente" queryout csv/Componentes.csv -c -C 65001 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection Componente --type tsv --columnsHaveTypes --fields "CuvPadre.string(),CampaniaId.string(),Cuv.string(),CodigoEstrategia.int32(),Grupo.int32(),CodigoSap.string(),Cantidad.int32(),PrecioUnitario.double(),PrecioValorizado.double(),Orden.int32(),IndicadorDigitable.boolean(),FactorCuadre.int32(),NombreProducto.string(),MarcaId.int32()" --file csv/Componentes.csv --numInsertionWorkers 4 --ignoreBlanks
exit

:Fin
ECHO Error los parámetros enviados
pause
exit