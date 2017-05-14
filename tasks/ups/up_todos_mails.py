import boto
from boto.s3.key import Key

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('vis4googlet')
k = Key(bucket)

k.key = 'todos_mails.mbox'
k.set_contents_from_filename(LOCAL_PATH+'todos_mails.mbox')
k.make_public()