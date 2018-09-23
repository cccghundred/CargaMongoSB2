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

ECHO Conexion SQL: %connSQL%
ECHO Conexion Mongo: %connMongoDB%
bcp "exec usp_SBMicroservicios_ProductoComercial" queryout csv/ProductoComercial.csv -c -C 65001 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection ProductoComercial --type tsv --columnsHaveTypes --fields "CampaniaId.int32(),CodigoCampania.string(),CUV.string(),DescripcionCUV.string(),CodigoProducto.string(),PrecioUnitario.double(),IndicadorPreUni.double(),PrecioPublico.double(),PrecioOferta.double(),PrecioTachado.double(),Ganancia.double(),IndicadorMontoMinimo.boolean(),IndicadorDigitable.boolean(),EstrategiaIdSicc.int32(),CodigoOferta.int32(),NumeroGrupo.int32(),NumeroNivel.int32(),MarcaId.int32(),MarcaDescripcion.string(),MatrizComercialId.int32(),ImagenURL.string(),Niveles.string()" --file csv/ProductoComercial.csv --numInsertionWorkers 4 --ignoreBlanks
exit

:Fin
ECHO Error los parámetros enviados
pause
exit