import boto
from boto.s3.key import Key
import subprocess


#subprocess.Popen(['sh','../init_inds.sh'])
#subprocess.Popen(["R --no-save < ../init_inds.R"],shell=True)
#subprocess.Popen(['sh','R CMD BATCH ../init_inds.R'])
subprocess.Popen('R CMD BATCH ../init_inds.R', shell=True, stdout=subprocess.PIPE)
#rm *.Rout

LOCAL_PATH = '/tmp/'

conn = boto.connect_s3()
bucket = conn.get_bucket('dpaequipo10')
k = Key(bucket)

k.key = 'indicadores/indicador_unzip.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_unzip.csv')
k.make_public()

k.key = 'indicadores/indicador_agruparbusquedas.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_agruparbusquedas.csv')
k.make_public()

k.key = 'indicadores/indicador_uptodosmails.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_uptodosmails.csv')
k.make_public()

k.key = 'indicadores/indicador_analisismails_fin.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_analisismails_fin.csv')
k.make_public()

k.key = 'indicadores/indicador_preprocmails_fin.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_preprocmails_fin.csv')
k.make_public()

k.key = 'indicadores/indicador_recomendaciones_fin.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_recomendaciones_fin.csv')
k.make_public()
