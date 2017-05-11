import os
import json
import subprocess
import psycopg2
import codecs
import glob

LOCAL_PATH = '/tmp/'

localizaciones={'locations':[]}
for f in glob.glob(LOCAL_PATH+"Takeout/busquedas/*.json"):
    with open(f) as data_file:
                data = json.load(data_file)
                #i=0
                for ev in data['locations']:
                        data_locations = ev
                        localizaciones['locations'].append(data_locations)

with open(LOCAL_PATH+"todas_localizaciones.json", "w") as outfile:
     json.dump(localizaciones, outfile)