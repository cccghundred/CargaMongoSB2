@ECHO OFF
:Inicio
CLS
ECHO -----------------------------------------------------------------------------------
ECHO --------------------  MIGRACION DE DATOS SQL A MONGODB  ---------------------------
ECHO -----------------------------------------------------------------------------------
REM Par metros:
REM 1. Ambiente SQL: (1) Local - (2) QAS - (3) PPR
REM 2. Ambiente Mongo: (1) Local - (2) QAS
REM 3. Nombre de la base de datos SQL.
REM 4. Nombre de la base de datos Mongo.
REM 5. Recrear colecciones: (1) S¡.
.\Load.cmd 2,1,BelcorpPeru,BelcorpPeru_PL50,1
:Fin 
ECHO Proceso finalizado 
pause
exit