# Ejercicio 1 - Obligatorio DevOps

## Requisitos Previos:

- Máquina virtual con la distribución de CentOS 9 actualizada (sudo dnf update -y / sudo dnf upgrade -y).

- Usuario con permisos para ejecutar comandos con sudo.

- Archivo de texto con la lista de usuarios a crear, con el formato indicado más abajo.

- Conexión a internet para clonar el repositorio (opcional si ya se encuentra descargado).

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

Please make sure to update tests as appropriate.

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
   /Obligatorio-DevOps/Ejercicio 2
```

## Ejecucion del Script

- Ejemplo:

sudo ./Ej_1.sh -i -c "aca va la contraseña" prueba.txt
