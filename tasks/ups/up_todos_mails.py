import boto
from boto.s3.key import Key
import pandas as pd
import subprocess
import os

#pd.DataFrame(data= [1], columns=['indicador']).to_csv('/tmp/indicador_uptodosmails.csv', encoding='utf-8')

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('dpaequipo10')
k = Key(bucket)

k.key = 'todos_mails.mbox'
k.set_contents_from_filename(LOCAL_PATH+'todos_mails.mbox')
k.make_public()

print 0
subprocess.Popen('R CMD BATCH ../act_inds/ai_uptodosmails.R', shell=True)#, stdout=subprocess.PIPE)

#k2 = Key(bucket)
#k2.key = 'indicadores/indicador_uptodosmails.csv'
#k2.set_contents_from_filename('/tmp/indicador_uptodosmails.csv')
#k2.make_public()
print 3