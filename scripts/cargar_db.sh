#!/bin/bash
source ./env.sh
clear

# Verificar que el contenedor (docker) mysql-bunkersur se está ejecutando
if sudo docker ps | grep -q "bunkersur_mysql"; then
	echo -e "OK: El contenedor se está ejecutando"
else
	echo -e "ERROR: El contenenedor de mysql no se está ejecutando."
	echo -e "Iniciando los contenedores\n"
	source ./iniciar_contenedores.sh
	echo -e "\nOK: Los contenenes ya se están ejecutando\n"
fi

# Listar las opciones disponibles:
echo -e "Opciones disponibles:"
echo -e "1. descargar DB de desarrollos inmobiliarios."
echo -e "2. descargar DB de la fundacion de la hemofilia."
echo -e "3. descargar DB de trayan administración de consorcios."
# echo -e "4. descargar todas las DB."
echo -e "0. salir.\n"

# Se obtiene la selección del usuario:
read -p "Seleccione una opción: " seleccion

case $seleccion in

1)
	echo -e "\nSe procede a descargar la base de datos de desarrollos inmobiliarios ($HOST_DESARROLLOS).\n"
	mysqldump -u$USUARIO_REMOTO -p$PASSWORD_DESARROLLOS -h$HOST_DESARROLLOS -P$PUERTO_REMOTO $DB_DESARROLLOS >"$DB_DESARROLLOS.sql"

	echo -e "\Se elimina la base de datos local de desarrollos inmobiliarios.\n"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL -e "DROP DATABASE IF EXISTS $DB_DESARROLLOS;"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL -e "CREATE DATABASE IF NOT EXISTS $DB_DESARROLLOS;"

	echo -e "\nSe procede a cargar la base de datos de desarrollos inmobiliarios (LOCAL).\n"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL $DB_DESARROLLOS <"$DB_DESARROLLOS.sql"
	rm "$DB_DESARROLLOS.sql"
	;;

2)
	echo -e "descargar desde fundación de la hemofilia"
	echo -e "\nSe procede a descargar la base de datos de la fundacion de la hemofilia ($HOST_FUNDACION).\n"
	mysqldump -u$USUARIO_REMOTO -p$PASSWORD_FUNDACION -h$HOST_FUNDACION -P$PUERTO_REMOTO $DB_FUNDACION >"$DB_FUNDACION.sql"

	echo -e "\Se elimina la base de datos local de la fundacion de la hemofilia.\n"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL -e "DROP DATABASE IF EXISTS $DB_FUNDACION;"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL -e "CREATE DATABASE IF NOT EXISTS $DB_FUNDACION;"

	echo -e "\nSe procede a cargar la base de datos de la fundacion de la hemofilia (LOCAL).\n"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL $DB_FUNDACION <"$DB_FUNDACION.sql"
	rm "$DB_FUNDACION.sql"
	;;

3)
	echo -e "descargar desde trayanadm"
	echo -e "\nSe procede a descargar la base de datos de administración de trayan ($HOST_TRAYAN).\n"
	mysqldump --column-statistics=0 -u$USUARIO_REMOTO -p$PASSWORD_TRAYAN -h$HOST_TRAYAN -P$PUERTO_REMOTO $DB_TRAYAN >"$DB_TRAYAN.sql"

	echo -e "\Se elimina la base de datos local de administración de trayan.\n"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL -e "DROP DATABASE IF EXISTS $DB_TRAYAN;"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL -e "CREATE DATABASE IF NOT EXISTS $DB_TRAYAN;"

	echo -e "\nSe procede a cargar la base de datos de administración de trayan (LOCAL).\n"
	mysql -u$USUARIO_LOCAL -p$PASSWORD_LOCAL -h$HOST_LOCAL -P$PUERTO_LOCAL $DB_TRAYAN <"$DB_TRAYAN.sql"
	# rm "$DB_TRAYAN.sql"
	;;

0) echo -e "Se canceló la operación" ;;

*) echo -e "La opción ingresada no es una selección válida." ;;

esac
