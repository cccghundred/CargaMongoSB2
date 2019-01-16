@ECHO OFF
IF "%1" == "" goto Fin
IF "%2" == "" goto Fin

ECHO Ruta del archivo mongo: %1
for /F "tokens=*" %%a in (%1) do (
    SET connMongoDB=%%a
    )

mongo --host  %connMongoDB% %2 scripts/RecrearBaseDatosMongoDB.js
exit 1

:Fin
ECHO Error los parametros enviados
pause
exit 1