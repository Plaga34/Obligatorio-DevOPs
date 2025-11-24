import boto3
from botocore.exceptions import ClientError

ec2 = boto3.client('ec2')
s3 = boto3.client('s3')

bucket_name = 'obligatorio-devops-boto3'
file_path = 'obligatorio-main.zip'
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

#Security Group para ec2

sg_name ='ec2-web-sg'
sg_desc ='Security group para la web'

resp = ec2.describe_security_groups(
    Filters=[{'Name':'group-name','Values': [sg_name]}]
)
if resp['SecurityGroups']:
    ec2_sg_id=resp['SecurityGroups'][0]['GroupId']
    print(f"El Security Group {ec2_sg_id} ya existe, lo reutilizare")
else:
    ec2_sg_id = ec2.create_security_group(
        GroupName='ec2-web-sg',
        Description='Security group para la web'
    )
    print(f"Security Group de EC2 creado con exito: {ec2_sg_id}")

#Permitimos el trafico de HTTP(Puerto 80) para la app

try:
    ec2.authorize_security_group_ingress(
        GroupId=ec2_sg_id,
        IpPermissions=[
            {
                'IpProtocol':'tcp',
                'FromPort':80,
                'ToPort':80,
                'IpRanges':[{'CidrIp': '0.0.0.0/0'}]
            }
        ]
    )
except ClientError as e:
    if e.response['Error']['Code'] == 'InvalidPermission.Duplicate' :
        print(f"La regla ya existe en el Security Group, la voy a reutilizar")
    else:
        raise
#Security Group para RDS

sg_name_rds ='rds_sg'
sg_desc_rds ='SG para la base de datos'

resp = ec2.describe_security_groups(
    Filters=[{'Name':'group-name','Values': [sg_name_rds]}]
)
if resp['SecurityGroups']:
    rds_sg_id=resp['SecurityGroups'][0]['GroupId']
    print(f"El Security Group {rds_sg_id} ya existe, lo reutilizare")
else:
    rds_sg_id = ec2.create_security_group(
        GroupName= 'rds_sg',
        Description='SG para la base de datos'
)

print(f"Security Group de RDS creado con exito: {rds_sg_id}")

#Permitimos que RDS pueda acceder a travez del puerto 3306 desde la EC2

try:
    ec2.authorize_security_group_ingress(
        GroupId=rds_sg_id,
        IpPermissions=[
            {
                'IpProtocol':'tcp',
                'FromPort':3306,
                'ToPort':3306,
                'UserIdGroupPairs':[{'GroupId': ec2_sg_id}]
            }
        ]
    )
except ClientError as e:
    if e.response['Error']['Code'] == 'InvalidPermission.Duplicate' :
        print(f"La regla ya existe en el Security Group, la voy a reutilizar")
    else:
        raise


