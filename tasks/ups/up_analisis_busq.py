import boto
from boto.s3.key import Key

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('vis4googlet')
k = Key(bucket)

k.key = 'analisis_busq.txt'
k.set_contents_from_filename(LOCAL_PATH+'analisis_busq.txt')
k.make_public()

# Con esto se tendrá disponible el archivo en la url: 
# wget https://s3-us-west-2.amazonaws.com/vis4googlet/analisis_busq.txt