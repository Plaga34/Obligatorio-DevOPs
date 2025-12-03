# Ejercicio 1 - Obligatorio DevOps

## Requisitos Previos:

- Máquina virtual con la distribución de CentOS 9 actualizada (sudo dnf update -y / sudo dnf upgrade -y).

- Usuario con permisos para ejecutar comandos con sudo.

- Archivo de texto con la lista de usuarios a crear, con el formato indicado más abajo.

- Conexión a internet para clonar el repositorio.

## Formato del archivo de usuarios

- El script recibe un archivo de texto donde cada línea representa un usuario y sus datos, separados por : con la siguiente estructura:

```bash
NombreDeUsuario:Comentario:/ruta/home:SI|NO:/ruta/shell
```

- NombreDeUsuario: obligatorio, debe comenzar con letra o guion bajo.

- Comentario: texto descriptivo del usuario (puede estar vacío).

- /ruta/home: ruta del directorio home (puede estar vacía).

- SI / NO: indica si se debe crear el directorio home en caso de no existir.

- /ruta/shell: ruta completa de la shell por defecto (por ejemplo /bin/bash).

## Ejemplo

```bash
pepe:Este es mi amigo pepe:/home/jose:SI:/bin/bash
papanatas:Este es un usuario trucho:/trucho:NO:/bin/sh
elmaligno::::/bin/el_maligno
```

El script valida la estructura de cada línea y corta la ejecución con error si encuentra una línea mal formada.

## Pasos previos a la ejecución

- Clonamos el repositorio a nuestra VM:

- Para SSH:

```bash
git clone git@github.com:Plaga34/Obligatorio-DevOPs.git
```

- Para HTTP:

```bash
git clone https://github.com/Plaga34/Obligatorio-DevOPs.git
```

- Para la CLI de GitHub:

```bash
gh repo clone Plaga34/Obligatorio-DevOPs
```

- Nos posicionamos sobre la carpeta donde se encuentra el archivo del ejercicio 1

```bash
   /Obligatorio-DevOps/Ejercicio_1
```

## Ejecucion del Script

- Ejemplo:

sudo ./Ej_1.sh -i -c "aca va la contraseña" prueba.txt


## Anexo con prompt de ChatGPT

- Prompt:
Estoy viendo la parte del -c y quiero evitar que lo usen sin la contraseña, funciona asi?
```bash
-c)
	if [ -z "$2" ]; then
		echo "Error, Falta agregar la contraseña luego del parametro" >&2
		exit 3
	fi
	contra="$2"
	shift 2
	;;
```
- Respuesta:
```bash
-c)
	if [ -z "$2" ]; then
		echo "Error, Falta agregar la contraseña luego del parametro" >&2
		exit 3
	fi
	contra="$2"
	shift 2
	;;
```
Esto está bien, le “cortás el mambo” si ponen -c solo y evitás que el script siga con una contraseña vacía.

- Prompt:

Estoy usando este regex para chequear cada línea del archivo, decis que le falte algo?
```bash
if ! [[ "$linea" =~ ^[a-z_][a-z0-9_-]*:[^:]*:.*:([Ss][Ii]|[Nn][Oo]|):.*$ ]];then
	echo Estructura del archivo incorrecta, revise la linea $cont
	echo Consulte la documentacion para revisar casos erroneos
	exit 8
fi
```
- Respuesta:
  
Sí, esa regex es sólida para lo que estás queriendo chequear. Y si algo no coincide, cortás con un mensaje claro:
```bash
if ! [[ "$linea" =~ ^[a-z_][a-z0-9_-]*:[^:]*:.*:([Ss][Ii]|[Nn][Oo]|):.*$ ]];then
	echo Estructura del archivo incorrecta, revise la linea $cont
	echo Consulte la documentacion para revisar casos erroneos
	exit 8
fi
```

Te asegura que el archivo venga con la estructura que esperás.

