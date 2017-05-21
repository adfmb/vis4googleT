import boto
from boto.s3.key import Key

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('dpaequipo10')
k = Key(bucket)

k.key = 'recomendaciones.csv'
k.set_contents_from_filename(LOCAL_PATH+'recomendaciones.csv')
k.make_public()