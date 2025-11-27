# Ejecución del Ejercicio 2 - Obligatorio


## Requisitos Previos:
- Maquina virtual con la distribución de Centos9 actualizada (sudo dnf update -y / sudo dnf upgrade -y).
- Conexión a internet.
- Cuenta en AWS activa.
- Usuario con permisos para crear cosas en IAM
- Agregar al repo de git el archivo .zip con los archivos de la aplicación para poder levantarla desde el código

## Instalar herramientas necesarias.

- sudo dnf install git
- git --version (para saver que version tenemos)

- Descargamos el paquete de instalacion con el comando curl:

  curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip

- Descomprimimos el paquete:

  unzip awscliv2.zip

- Ejecutamos el instalador

  sudo ./aws/install

- Verificamos la versión que nos quedo instalada:

  aws --version

- Instalamos Python

  sudo dnf install python3

- Instalamos Pip

  sudo dnf install python3-pip
