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
				exit 3
			fi
			contra="$2"	#Guardo el -p y la contraseña para tirar la variable entera al useradd
			shift 2
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
        echo "Error, no ingreso ningun archivo" >&2
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
        if ! [[ "$linea" =~ ^[a-z_][a-z0-9_-]*:[^:]*:.*:([Ss][Ii]|[Nn][Oo]|):.*$ ]];then
                #Controlamos que el campo usuario no este vacio y que se respeten los espacios
                echo Estructura del archivo incorrecta, revise la linea $cont
		echo Consulte la documentacion para revisar casos erroneos
                exit 8
        fi
done

#-----------------------------RECORRIDO PRINCIPAL---------------------
contcreado=0
cont=0
errorfatal="false"
for linea in $(cat $archivo);do
        cont=$((cont+1)) #Doble parentesis para que haga una suma y no acepte strings raros
	gsh="$(echo $linea | cut -d":" -f5)" #| cut -d:"/" -f3)" #Esta variable es la del shell
        Vsh="$(find /usr/bin -maxdepth 1 -wholename "/usr$gsh")" 2> /dev/null #Busca que el shell exista
	if [ -z "$Vsh" ];then #Si no encuentra la shell
		errorfatal="true"
	fi #Si va el verificador del shell se deja si no no
	#--------------------------------------------------------
	usuario=$(echo "$linea" | cut -d":" -f1)
	comentario="$(echo "$linea" | cut -d":" -f2)" 2> /dev/null
	home=$(echo "$linea" | cut -d":" -f3)
	crear=$(echo "$linea" | cut -d":" -f4)
	#---------------------------------------------------------
	if [[ "$crear" = "SI" ]];then 
        	creard="-m"
        else
                creard="-M" #Con control previo en el Regex que recibe NO,no,No,nO o campo vacio
        fi
	#----------------------CAMPOS POR DEFECTO---------------------------------------
        usuariocreado=$(cat /etc/passwd | cut -d":" -f1 | grep "^$usuario$") #Ese grep busca una linea vacia si esta vacio
        if [ -n "$usuariocreado" ] || [[ $errorfatal == "true"  ]];then #Si encontro algo tire error o viene con error
                errorfatal="true"
        else
                armocomand=() #Creo el array hace todo mucho mas simple
                if [ -n "$comentario" ];then #Si no esta vacio agrega al array, igual con los demas
                       	armocomand+=(-c "$comentario")
                fi
                if [  -n "$home" ] && [[ "$crear" = "SI" ]];then
                       	armocomand+=(-d "$home")
                fi
                if [ -n "$gsh" ];then
                       	armocomand+=(-s "$gsh")
                fi
                
		if [ ${#armocomand[@]} -eq 0 ];then #comparo si la longitud del array es 0, en vez del -z ""
                       	sudo useradd $creard "$usuario" 2> /dev/null
                       	#echo "useradd $creard $usuario" #TEST
                else
                       	sudo useradd "${armocomand[@]}" $creard "$usuario" 2> /dev/null
                       	#echo "useradd ${armocomand[@]} $creard $usuario" #TEST
		fi
		if ! [ -z "$contra" ];then
                       	echo $usuario:$contra | sudo chpasswd 2> /dev/null
                fi
        fi

	if [[ "$desplegar" = "1" ]];then #Desplegar es el -i para mostrar informacion
		usuariocreado=$(cat /etc/passwd | cut -d":" -f1 | grep "^$usuario$")
		if [ -z "$usuariocreado" ] || [[ $errorfatal == "true" ]] ;then # Si esta vacio o arrastra error, variable error
			errorfatal="true"
			if [ -z "$Vsh" ];then #Si la Bash no la encontro como arriba tire mensaje de error
				echo La shell de la linea $cont no es correcta
			fi
			echo ATENCION: el usuario $usuario de la linea $cont no pudo ser creado
                        echo -------------------------------------------------------------------
		else			
			contcreado=$(($contcreado + 1))
			CASA="$(grep "^$usuario:" /etc/passwd | cut -d":" -f6)"
			DEFBASH="$(grep "^$usuario:" /etc/passwd | cut -d":" -f7)"
			echo Usuario $usuario creado con éxito con datos indicados:
			echo "	Comentario: $comentario"
			echo "	Dir home: $CASA"
			echo "	Asegurado existencia de directorio home: $crear"
			echo "	Shell por defecto: $DEFBASH"
			echo -------------------------------------------------------------------
		fi
	fi #Aca termina el -i que despliega informacion
	
	#---------------Reseteo de variables por ciclo-----------------
	errorfatal="false" #Seteo la variable preparandola para el siguente recorrido
	usuariocreado=""
	usuario=""
	gsh=""
	Vsh=""
	comentario=""
	home=""
	crear=""
	DEFBASH=""
	CASA=""
	#---------------FIN DE SETEO----------------------------------
done #Fin del for de recorrida USERADD linea a linea----------------------------------
if [[ "$desplegar" = "1" ]];then #Si esta el -i que tire la cantidad de usuarios creados fuera de la recorrida
	echo Cantidad de usuarios creados $contcreado usuarios
fi
