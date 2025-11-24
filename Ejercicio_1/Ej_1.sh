#!/bin/bash

#Definimos las variables a utilizar
desplegar=0	
contra=""	
IFS="
" #Sin el IFS el for toma los espcios como fin de linea

if [ $# -gt 4 ];then
	echo Solo se admiten 4 parametros -i -c seguido de la contraseña y el archivo
	exit 1
fi
#Esto es para que no acepte menos de dos parametros
if [ $# -lt 2 ];then
	echo Como minimo se admite el archivo como parametro
	exit 2
fi

#Creamos un while para recorrer los parametros
while [ $# -gt 1 ];do	#Recorremos los parametros
	case "$1" in	
		-i) 	
			desplegar=1
			shift
			;;
		-c)	
			if [ -z "$2" ]; then
				echo "Error, Falta agregar la contraseña luego del parametro" >&2
				exit 2
			fi
			contra="$2"	#Guardo el -p y la contraseña para tirar la variable entera al useradd
			shift 3
			;;
		-*)	
			echo "Error, el parametro $1 no es valido" >&2
			exit 4
			;;
	esac
done

archivo="$1"	#Descarte todo, solo me queda el archivo y lo guardo
#Archivo ingresado igual a vacio
if [ -z "$archivo" ];then
        echo "Error, no ingreso ningun archivo o " >&2
        exit 5
fi
#Controlamos que es un archivo
if ! [ -f "$archivo" ];then
        echo Esto no es un archivo
        exit 6
fi
#Controlamos que tenga permisos de lectura sobre el archivo
if ! [ -r "$archivo" ];then
        echo No tiene permisos de lectura sobre el archivo
        exit 7
fi
cont=0
#reviso el archivo linea a linea para evaluar si es correcto
for linea in $(cat $archivo);do
         cont=$((cont+1))
        if ! [[ "$linea" =~ ^[a-z_][a-z0-9_-]*:[^:]*:.*:(SI|NO):.*$ ]];then
                #Controlamos que el campo usuario no este vacio y que se respeten los espacios
                echo Estructura del archivo incorrecta, revise la linea $cont
                exit 8
        fi
done

#-----------------------------RECORRIDO PRINCIPAL---------------------

cont=0
errorfatal="false"
for linea in $(cat $archivo);do
        cont=$((cont+1)) #Doble parentesis para que haga una suma y no acepte strings raros
	gsh="$(echo $linea | cut -d":" -f5)" #| cut -d:"/" -f3)" #Esta variable es la del shell
        #Vsh="$(find /usr/bin -maxdepth 1 -wholename "/usr$gsh")" #Busca que el shell exista
	#if [ -z "$Vsh" ];then #Si no encuentra la shell
		#echo La shell de la linea $cont no es correcta
	#	errorfatal="true"
	#fi Si va el verificador del shell se deja si no no
	#--------------------------------------------------------
	usuario=$(echo "$linea" | cut -d":" -f1)
	comentario="$(echo "$linea" | cut -d":" -f2)" 2> /dev/null
	home=$(echo "$linea" | cut -d":" -f3)
	crear=$(echo "$linea" | cut -d":" -f4)
	#---------------------------------------------------------
	if [[ "$crear" = "SI" ]];then 
        	creard="-m"
        else
                creard="-M" #Con control previo en el Regex que recibe NO espesificamente
        fi
	#----------------------CAMPOS POR DEFECTO---------------------------------------
        usuariocreado=$(cat /etc/passwd | cut -d":" -f1 | grep "^$usuario$") #Ese grep busca una linea vacia si esta vacio
        if [ -n "$usuariocreado" ];then
                errorfatal="true"
        else
                armocomand=() #Creo que sin un array esto es imposible, lo intente
                if [ -n "$comentario" ];then #Si no esta vacio agrega al array, igual con los demas
                        armocomand+=(-c "$comentario")
                fi
                if [  -n "$home" ] && [[ "$crear" = "SI" ]];then
                        armocomand+=(-d "$home")
                fi
                if [ -n "$gsh" ];then
                        armocomand+=(-s "$gsh")
                fi
                if [ ${#armocomand[@]} -eq 0 ];then #comparo si la longitud del array es 0, en vez del -z "", 3 horas con esto
                        useradd $creard "$usuario" 2> /dev/null
                        #echo "useradd $creard $usuario" #TEST
                else
                        useradd "${armocomand[@]}" $creard "$usuario" 2> /dev/null
                        #echo "useradd ${armocomand[@]} $creard $usuario" #TEST
                fi
                if ! [ -z "$contra" ];then
                        echo $usuario:$contra | sudo chpasswd 2> /dev/null
                fi
        fi
