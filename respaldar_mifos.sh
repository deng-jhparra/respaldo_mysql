#!/bin/sh
#Descripción: Tarea que hace los respaldos diarios de la bd novosalud
#Autor: Ricardo Alvarado
#Fecha de Desarrollo: 08/06/2017

## CONSTANTE
HOST="localhost"

## BASE DE DATOS
BD1="mifosplatform-tenants"
BD2="mifostenant-default"
BD_BK1="mifosplatform-tenants"
BD_BK2="mifostenant-default"

## USUARIO DE RESPALDO
USUARIO="root"
PASSWORD="mysql"

## VARIABLES DE RESPALDO
FECHA_ACTUAL=`date +%d%m%Y`;
HORA_ACTUAL=`date +%H_%M`;
ARC_RESP="$FECHA_ACTUAL-$HORA_ACTUAL"
MES_ACTUAL=`date +%m`;
YEAR_ACTUAL=`date +%Y`;

## SITIO DONDE SE GUARDARA LOS ARCHIVOS
mkdir -p /backup/Mysql/mifos/"$YEAR_ACTUAL"
mkdir -p /backup/Mysql/mifos/"$YEAR_ACTUAL"/"$MES_ACTUAL"

ARCHIVO1=/backup/Mysql/mifos/"$YEAR_ACTUAL"/"$MES_ACTUAL"/"$BD_BK1"_$ARC_RESP.sql
ARCHIVO2=/backup/Mysql/mifos/"$YEAR_ACTUAL"/"$MES_ACTUAL"/"$BD_BK2"_$ARC_RESP.sql 

#APLICACION PARA GENERAR EL RESPALDO
mysqldump -u "$USUARIO" -p"$PASSWORD" -h "$HOST" --lock-tables=false "$BD1" > "$ARCHIVO1"
mysqldump -u "$USUARIO" -p"$PASSWORD" -h "$HOST" --lock-tables=false "$BD2" > "$ARCHIVO2"

## ACCEDER A LA CARPETA
cd /backup/Mysql/mifos/"$YEAR_ACTUAL"/"$MES_ACTUAL"/

## CREACION DE ARCHIVO
touch salida.txt

## CALCULO DEL ARCHIVO EN SQL
du -sch "$BD_BK1"_$ARC_RESP.sql >> salida.txt
du -sch "$BD_BK2"_$ARC_RESP.sql >> salida.txt


############################################################### CONFIGURACÍON DE CUERP DEL CORREO ###########################################################################
echo "Estatus de respaldo" >> /backup/Tarea_programada/correo/enviar_correo.txt

## BD_BK1
echo "\n Servidor: $HOST  Base de datos:$BD1  Fecha: $FECHA_ACTUAL  Hora: $HORA_ACTUAL" >> /backup/Tarea_programada/correo/enviar_correo.txt
echo "\n Tamaño del archivo .sql \n" >> /backup/Tarea_programada/correo/enviar_correo.txt 
du -sch "$BD_BK1"_$ARC_RESP.sql >> /backup/Tarea_programada/correo/enviar_correo.txt 

## BD_BK2
echo "\n Servidor: $HOST  Base de datos:$BD2  Fecha: $FECHA_ACTUAL  Hora: $HORA_ACTUAL" >> /backup/Tarea_programada/correo/enviar_correo.txt
echo "\n Tamaño del archivo .sql \n" >> /backup/Tarea_programada/correo/enviar_correo.txt 
du -sch "$BD_BK2"_$ARC_RESP.sql >> /backup/Tarea_programada/correo/enviar_correo.txt 

## COMPRIMIR ARCHIVO BACKUP
7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m "$BD_BK1"_$ARC_RESP.7z "$BD_BK1"_$ARC_RESP.sql
echo "\n Tamaño del archivo comprimido \n" >> /backup/Tarea_programada/correo/enviar_correo.txt
du -sch "$BD_BK1"_$ARC_RESP.7z >> /backup/Tarea_programada/correo/enviar_correo.txt 
echo "\n --------------------------------------------------------------------------------- \n" >> /backup/Tarea_programada/correo/enviar_correo.txt

## COMPRIMIR ARCHIVO BACKUP
7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m "$BD_BK2"_$ARC_RESP.7z "$BD_BK2"_$ARC_RESP.sql
echo "\n Tamaño del archivo comprimido \n" >> /backup/Tarea_programada/correo/enviar_correo.txt
du -sch "$BD_BK2"_$ARC_RESP.7z >> /backup/Tarea_programada/correo/enviar_correo.txt 
echo "\n --------------------------------------------------------------------------------- \n" >> /backup/Tarea_programada/correo/enviar_correo.txt


## BORRAR ARCHIVO CON EXTENSION .SQL
#rm  "$BD_BK1"_$ARC_RESP.sql
#rm  "$BD_BK2"_$ARC_RESP.sql

## CALCULO DEL ARCHIVO EN 7ZIP
du -sch "$BD_BK1"_$ARC_RESP.7z >> salida.txt
du -sch "$BD_BK2"_$ARC_RESP.7z >> salida.txt


