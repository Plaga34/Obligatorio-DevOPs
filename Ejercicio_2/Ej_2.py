import boto3
from botocore.exceptions import ClientError

s3 = boto3.client('s3')

bucket_name = 'obligatorio-devops-boto3'
file_path = 'obligatorio.zip'
object_name = file_path.split('/')[-1]

try:
    s3.create_bucket(Bucket=bucket_name)
    print(f"Bucket creado: {bucket_name}")
except ClientError as e:
    if e.response['Error']['Code'] == 'BucketAlreadyOwnedByYou':
        print(f"El bucket {bucket_name} ya existe.")
    else:
        print(f"Error creando bucket: {e}")
        exit(1)

try:
    s3.upload_file(file_path, bucket_name,object_name)
    print(f"Archivo {file_path} subido a s3://{bucket_name}/{object_name}")
except FileNotFoundError:
    print(f"El archivo {file_path} no existe en el directorio actual.")
    exit(1)
except ClientError as e:
    print(f"Error subiendo archivo al bucket: {e}")
    exit(1)