@ECHO OFF
:Inicio
CLS
ECHO -----------------------------------------------------------------------------------
ECHO --------------------  MIGRACION DE DATOS SQL A MONGODB  ---------------------------
ECHO -----------------------------------------------------------------------------------
REM Ingreso de cadena de conexi¢n SQL
ECHO Seleccione la cadena de conexi¢n SQL:
ECHO 1. Conexi¢n Local.
ECHO 2. Conexi¢n QAS.
ECHO 3. Conexi¢n PPR.
SET /P optSQL=Seleccion:
REM Ingreso de cadena de conexi¢n MongoDB
ECHO Seleccione la cadena de MongoDB:
ECHO 1. Conexi¢n Local.
ECHO 2. Conexi¢n QAS.
SET /P optMongo=Seleccion:
SET archivoSQL=""
SET archivoMongo=""

REM Se obtiene la ruta de los archivos con datos de la conexi¢n
IF %optSQL% == 1 SET archivoSQL=conn\sql\conexionLocal.txt
IF %optSQL% == 2 SET archivoSQL=conn\sql\conexionQAS.txt
IF %optSQL% == 3 SET archivoSQL=conn\sql\conexionPPR.txt
IF %optMongo% == 1 SET archivoMongo=conn\mongo\conexionLocal.txt
IF %optMongo% == 2 SET archivoMongo=conn\mongo\conexionQAS.txt

IF %archivoSQL%=="" GOTO ErrorParametros 
IF %archivoMongo%=="" GOTO ErrorParametros 

REM Ingreso de bases de datos
SET /P fuente=Ingrese el nombre de la base de datos SQL: 
SET /P destino=Ingrese el nombre de la base de datos MongoDB: 
ECHO ===================================================================================
ECHO.%time:~0,8% Inicia proceso de carga de datos de %fuente% a %destino% 
REM Actualizaci¢n de SPs
REM start /I /MIN /WAIT sp.bat %archivoSQL%,%fuente%
ECHO.%time:~0,8% Se actualizaron los procedimientos almacenados en %fuente%
ECHO ===================================================================================
REM Carga de datos ProductoComercial
ECHO.%time:~0,8% Inicio: carga de producto comercial
REM start /I /MIN /WAIT batchs\import\ProductoComercial.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
ECHO.%time:~0,8% Fin: carga de producto comercial
ECHO ===================================================================================
REM Carga de datos ProductFaltanteZona
ECHO.%time:~0,8% Inicio: carga de producto faltante zona
REM start /I /MIN /WAIT batchs\import\ProductoFaltanteZona.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
ECHO.%time:~0,8% Fin: carga de producto faltante
ECHO ===================================================================================
REM Carga de datos OfertaPersonalizadaCuv
ECHO.%time:~0,8% Inicio: carga de oferta personalizada cuv
REM start /I /MIN /WAIT batchs\import\OfertaPersonalizadaCuv.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
ECHO.%time:~0,8% Fin: carga de oferta personalizada cuv
ECHO ===================================================================================
REM Carga de datos Componente
ECHO.%time:~0,8% Inicio: carga de componente
REM start /I /MIN /WAIT batchs\import\componente.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
ECHO.%time:~0,8% Fin: carga de componente
ECHO ===================================================================================
REM Carga de datos TipoEstrategia
ECHO.%time:~0,8% Inicio: carga de tipo estrategia
REM start /I /MIN /WAIT batchs\import\TipoEstrategia.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
ECHO.%time:~0,8% Fin: carga de tipo estrategia
ECHO ===================================================================================
REM Carga de personalizacion
ECHO.%time:~0,8% Inicio: carga de personalizacion
REM start /I /MIN /WAIT batchs\import\Personalizacion.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%
ECHO.%time:~0,8% Fin: carga de personalizacion
ECHO ===================================================================================
REM Carga de datos OfertaPersonalizada
ECHO.%time:~0,8% Inicio: carga de ofertas personalizadas 
for /F "tokens=*" %%a in (input\campanias.txt) do (
    for /F "tokens=*" %%b in (input\palancas.txt) do (
        ECHO %%b -- %%a
        start /I /MIN /WAIT batchs\import\OfertaPersonalizada.cmd %archivoSQL%,%archivoMongo%,%fuente%,%destino%,%%a,%%b        
    )
)
ECHO.%time:~0,8% Fin: carga de ofertas personalizadas 
ECHO ===================================================================================
pause
exit

:Fin 
ECHO Proceso finalizado 
pause
exit

:ErrorParametros
ECHO Par metro ingresado para la cadena de conexi¢n es incorrecto 
pause 
GOTO Init

