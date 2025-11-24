#!/bin/bash

#Definimos las variables a utilizar, sabemos que estan aca
desplegar=0	#Siempre es bueno saber donde estan estas variables
contra=""	
IFS="
" #Sin esto los espacios en el cat del for se los re come, como tu hermana se la re come, aclaro

if [ $# -gt 4 ];then
	echo Solo se admiten 4 parametros -i -c seguido de la contraseña y el archivo
	exit 1 #Esto hay que ordenarlo, por experiencia al final
fi
#Menos de dos paramentros aca no che
if [ $# -lt 2 ];then
	echo Como minimo se admite el archivo como parametro
	exit 2
fi

#Creamos un while para recorrer los parametros
while [ $# -gt 1 ];do	#Recorremos los parametros
	case "$1" in	
		-i) 	#COMENTAR
			desplegar=1
			shift
			;;
		-c)	#COMENTAR
			if [ -z "$2" ]; then
				echo "Error, Falta agregar la contraseña luego del parametro" >&2
				exit 2
			fi
			contra="$2"	#Guardo el -p y la contraseña para tirar la variable entera al useradd
			shift 3
			;;
		-*)	#COMENTAR
			echo "Error, el parametro $1 no es valido" >&2
			exit 4
			;;
	esac
done

archivo="$1"	#Descarte todo, solo me queda el archivo lo guardo
#Archivo ingresado igual a vacio
if [ -z "$archivo" ];then
        echo "Error, no ingreso ningun archivo o " >&2
        exit 5
fi
#El archivo no es un archivo.. si pasa este exit tambien existe
if ! [ -f "$archivo" ];then
        echo Esto no es un archivo
        exit 6
fi
#Permiso de lectura sobre el archivo?
if ! [ -r "$archivo" ];then
        echo No tiene permisos de lectura sobre el archivo
        exit 7
fi
cont=0
#reviso el archivo linea a linea si es correcto
for linea in $(cat $archivo);do
         cont=$((cont+1))
        if ! [[ "$linea" =~ ^[a-z_][a-z0-9_-]*:[^:]*:.*:(SI|NO):.*$ ]];then
                #Campo usuario no vacio y que se respeten los espacios
                echo Estructura del archivo incorrecta, revise la linea $cont
                exit 8
        fi
done

