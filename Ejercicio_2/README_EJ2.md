# Ejercicio 2 - Obligatorio


## Requisitos Previos:
- Maquina virtual con la distribución de Centos9 actualizada (sudo dnf update -y / sudo dnf upgrade -y).
- Conexión a internet.
- Cuenta en AWS activa.
- Usuario con permisos para crear cosas en IAM
- Agregar al repo de git el archivo .zip con los archivos de la aplicación para poder levantarla desde el código

## Instalar herramientas necesarias.
```bash
  sudo dnf install git
  git --version 
```
- Descargamos el paquete de instalacion con el comando curl:
```bash
  curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
```
- Descomprimimos el paquete:
```bash
  unzip awscliv2.zip
```
- Ejecutamos el instalador
```bash
  sudo ./aws/install
```
- Verificamos la versión que nos quedo instalada:
```bash
  aws --version
```
- Instalamos Python
```bash
  sudo dnf install python3
```
- Instalamos Pip
```bash
  sudo dnf install python3-pip
```

## Pasos previos a la ejecución

- Clonamos el repositorio a nuestra VM:

  Para SSH:
```bash
git clone git@github.com:Plaga34/Obligatorio-DevOPs.git
```

  Para HTTP:
```bash
git clone https://github.com/Plaga34/Obligatorio-DevOPs.git
```

  Para la Cli de git:
```bash
gh repo clone Plaga34/Obligatorio-DevOPs
```
- Nos posicionamos sobre la carpeta donde se encuentra /Obligatorio-DevOps/Ejercicio 2/Ej_2.py
```bash
  /Obligatorio-DevOps/Ejercicio 2/Ej_2.py
```
## Ejecutamos el programa

- Ejecutamos el archivo
```bash
  python Ej2_.py
```

## Anexo con prompts de chatGPT

1- Estoy intentando automatizar la creación de un bucket S3 y la subida de un archivo con Boto3. Ya hice el codigo y funciona pero no estoy seguro si algo esta funcionando mal. podras fijarte si la forma en que uso try/except esta bien?

Respuesta: 

Sí, la estructura del try/except está bien planteada: intenta crear el bucket y, si ocurre un error, lo captura y lo clasifica antes de decidir qué hacer. La forma general es correcta.

Lo único que conviene ajustar es la condición del if dentro del except: el acceso a e.response['Error']['Code'] funciona, pero sería más seguro usar get para evitar que falle si la clave no existe:
```bash
code = e.response.get('Error', {}).get('Code')
if code == 'BucketAlreadyOwnedByYou':
    print(f"El bucket {bucket_name} ya existe.")
else:
    print(f"Error creando bucket: {e}")
    exit(1)
```

Fuera de ese detalle, el patrón que estás usando es apropiado y funciona como debería.

2- Quiero manejar el error cuando intento agregar una regla repetida a un Security Group pero no estoy encontrandolo en la documentación de aws. https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html

Respuesta: 

Para manejar ese caso, la API devuelve el código de error InvalidPermission.Duplicate, y podés capturarlo así:

```bash
except ClientError as e:
    if e.response['Error']['Code'] == 'InvalidPermission.Duplicate' :
        print("La regla ya existe en el Security Group")
    else:
        raise
```

Ese es exactamente el error que envía AWS cuando intentás agregar una regla que ya está configurada.

3- Se le paso el codigo final ya que teniamos un error en el userdata, no encontramos en el chat cuando se lo preguntamos pero nos detecto los siguientes errores que solucionaron el problema.

```bash
cp /tmp/obligatorio-main/app.css /var/www/html/app.css
cp /tmp/obligatorio-main/app.js /var/www/html/app.js
cp /tmp/obligatorio-main/config.php /var/www/html/config.php
cp /tmp/obligatorio-main/index.html /var/www/html/index.html
cp /tmp/obligatorio-main/index.php /var/www/html/index.php
cp /tmp/obligatorio-main/login.css /var/www/html/login.css
cp /tmp/obligatorio-main/login.html /var/www/html/login.html
cp /tmp/obligatorio-main/login.js /var/www/html/login.js
cp /tmp/obligatorio-main/login.php /var/www/html/login.php
cp /tmp/obligatorio-main/login.php /var/www/init_db.sql
```

en esto la ultima linea estaba mal donde dice login.php deberia decir init_db.sql

y tambien teniamos un echo que dejaba vacio el archivo index.html


#Documentacion:

#EC2
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html

#Crear Instancias EC2
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/run_instances.html

#Crear Tags
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/create_tags.html

#Waiter para EC2
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/waiter/InstanceStatusOk.html

#-----------------------------------------------------------------------------------------------

#S3
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html

#Crear Bucket S3
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/create_bucket.html

#Subir archivos S3
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3/client/upload_file.html


#-----------------------------------------------------------------------------------------------

#RDS
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/rds.html

#Creamos instancia de RDS
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/rds/client/create_db_instance.html



#Documentacion de Security Group
#https://boto3.amazonaws.com/v1/documentation/api/latest/guide/ec2-example-security-group.html

#Crear Security Groups
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/create_security_group.html

#Autorizar Security Groups
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/authorize_security_group_ingress.html

#Instancias EC2
#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/client/run_instances.html

