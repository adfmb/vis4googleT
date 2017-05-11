import boto
import sys, os
from boto.s3.key import Key

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('vis4googlet')
for l in bucket.list(prefix='todos_mails.mbox'):
  keyString = str(l.key)
  l.get_contents_to_filename(LOCAL_PATH+keyString)

#Con esto se deberá tener guardado el archivo de mails en la carpeta /tmp/