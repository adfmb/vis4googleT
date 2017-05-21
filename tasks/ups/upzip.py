import boto
import sys, os
from boto.s3.key import Key

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('dpaequipo10')
k = Key(bucket)

k.key = 'todogoogleto.zip'
k.set_contents_from_filename(LOCAL_PATH+'todogoogleto.zip')
k.make_public()