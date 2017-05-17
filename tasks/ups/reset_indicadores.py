import boto
from boto.s3.key import Key
import pandas as pd


pd.DataFrame(data= [0], 
	columns=['indicador']).to_csv('/tmp/indicador_unzip.csv', 
	encoding='utf-8')
pd.DataFrame(data= [0], 
	columns=['indicador']).to_csv('/tmp/indicador_agruparbusquedas.csv', 
	encoding='utf-8')
pd.DataFrame(data= [0], 
	columns=['indicador']).to_csv('/tmp/indicador_uptodosmails.csv', 
	encoding='utf-8')
pd.DataFrame(data= [0], 
	columns=['indicador']).to_csv('/tmp/indicador_analisismails_fin.csv', 
	encoding='utf-8')
pd.DataFrame(data= [0], 
	columns=['indicador']).to_csv('/tmp/indicador_preprocmails.csv', 
	encoding='utf-8')
pd.DataFrame(data= [0], 
	columns=['indicador']).to_csv('/tmp/indicador_recomendaciones_fin.csv', 
	encoding='utf-8')

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

k.key = 'indicadores/indicador_preprocmails.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_preprocmails.csv')
k.make_public()

k.key = 'indicadores/indicador_recomendaciones_fin.csv'
k.set_contents_from_filename(LOCAL_PATH+'indicador_recomendaciones_fin.csv')
k.make_public()
