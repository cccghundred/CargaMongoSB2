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

bcp "exec usp_SBMicroservicios_TipoEstrategia" queryout csv/TipoEstrategia.csv -c -C 65001 -t"\t" %connSQL% -d %3

mongoimport -v --host %connMongoDB% --db %4 --collection TipoEstrategia --type tsv --columnsHaveTypes --fields "CodigoTipoEstrategia.string(),TipoEstrategiaId.int32(),TipoPersonalizacion.string(),DescripcionTipoEstrategia.string(),ImagenEstrategia.string(),Orden.int32(),FlagActivo.boolean(),FlagNueva.boolean(),FlagRecoProduc.boolean(),FlagRecoPerfil.boolean(),CodigoPrograma.string(),FlagMostrarImg.boolean(),MostrarImgOfertaIndependiente.boolean(),ImagenOfertaIndependiente.string(),Codigo.string(),FlagValidarImagen.boolean(),PesoMaximoImagen.int32(),UsuarioCreacion.string(),UsuarioModificacion.string(),FechaCreacion.date_ms(yyyy-MM-dd H:mm:ss),FechaModificacion.date_ms(yyyy-MM-dd H:mm:ss)" --file csv/TipoEstrategia.csv --numInsertionWorkers 4 --ignoreBlanks
exit

:Fin
ECHO Error los parámetros enviados
pause
exit