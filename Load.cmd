@ECHO OFF
IF "%1" == "" goto Fin
IF "%2" == "" goto Fin
IF "%3" == "" goto Fin
IF "%4" == "" goto Fin

REM Se obtiene la ruta de los archivos con datos de la conexi¢n
IF %1 == 1 SET archivoSQL=conn\sql\conexionLocal.txt
IF %1 == 2 SET archivoSQL=conn\sql\conexionQAS.txt
IF %1 == 3 SET archivoSQL=conn\sql\conexionPPR.txt
IF %2 == 1 SET archivoMongo=conn\mongo\conexionLocal.txt
IF %2 == 2 SET archivoMongo=conn\mongo\conexionQAS.txt

SET fuente=%3
SET destino=%4
SET limpiar="%5"

ECHO %fuente%
ECHO %destino%
ECHO %archivoSQL%
ECHO %archivoMongo%


ECHO ===================================================================================
ECHO.%time:~0,8% Inicia proceso de carga de datos de %fuente% a %destino% 
REM Actualizaci¢n de SPs
start /I /MIN /WAIT sp.bat %archivoSQL%,%fuente%
ECHO.%time:~0,8% Se actualizaron los procedimientos almacenados en %fuente%
IF %limpiar% == "1" (
    ECHO ===================================================================================
    REM Limpiar bibliotema mongoDB
    ECHO.%time:~0,8% Inicio: Limpiar biblioteca mongoDB
    start /I /MIN /WAIT batchs\import\LimpiarBibliotecas.cmd %archivoMongo%,%destino%
    ECHO.%time:~0,8% Se limpiaron las bibliotecas mongoDB de %destino%
)
for /F "tokens=*" %%a in (input\colecciones.txt) do (
        ECHO ===================================================================================
        ECHO.%time:~0,8% Inicio: carga de %%a
        IF "%%a"=="OfertaPersonalizada" (
            for /F "tokens=*" %%a in (input\campanias.txt) do (
                for /F "tokens=*" %%b in (input\palancas.txt) do (
                    ECHO ====================================
                    ECHO %%b -- %%a
                    start /I /MIN /WAIT batchs\import\OfertaPersonalizada.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%,%%a,%%b        
                )
            )
        ) ELSE IF "%%a"=="Evento" (
            for /F "tokens=*" %%a in (input\campanias.txt) do (
                ECHO ====================================
                ECHO Evento -- %%a
                start /I /MIN /WAIT batchs\import\Evento.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%,%%a        
            )
        ) ELSE IF "%%a"=="ProductoFaltanteZona" (
            start /I /MIN /WAIT batchs\import\%%a.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
            ECHO ====================================
            REM Fragmentar campo "zona" de coleccion ProductoFaltanteZona
            ECHO.%time:~0,8% Inicio: Fragmentar Producto Faltante Zona
            start /I /MIN /WAIT batchs\import\SpliProductoFaltanteZona.cmd %archivoMongo%,%destino%
            ECHO.%time:~0,8% Se fragmento Producto Faltante Zona Zonas de %destino%
            ECHO ====================================
        ) ELSE (
            start /I /MIN /WAIT batchs\import\%%a.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%  
        )          
        ECHO.%time:~0,8% Fin: carga de %%a    
    )
pause
exit
:Fin
ECHO Error los par metros enviados
pause
exit