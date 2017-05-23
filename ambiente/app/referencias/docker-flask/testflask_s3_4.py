import json
from flask import Flask, jsonify, abort, request, make_response, url_for
from flask_s3 import FlaskS3
import os
import boto3
import boto

s3 = boto3.resource('s3')
conn = boto.connect_s3()

app = Flask(__name__)

@app.route('/busquedas', methods = ['GET'])                                                  
#@auth.login_required
def qbusquedas():
	object = s3.Object('dpabusquedas','todas_busquedas.json')
	bb2=object.get()["Body"].read().decode('utf-8')
	x=json.loads(bb2)
	bucket = conn.get_bucket('dpabusquedas')
	bucket_list = bucket.list()
	for key in bucket_list(prefix='todas_busquedas')
	 keyString = str(l.key)
	 if not os.path.exists(LOCAL_PATH+keyString):
	 	l.get_contents_to_filename(LOCAL_PATH+keyString)


	return json.dumps(x)

@app.route('/ubicaciones', methods = ['GET'])                                                  
#@auth.login_required
def qubicaciones():
	object = s3.Object('dpabusquedas','todas_ubicaciones.json')
	bb2=object.get()["Body"].read().decode('utf-8')
	x=json.loads(bb2)
	return json.dumps(x)

#@app.route('/correos', methods = ['GET'])                                                  
#@auth.login_required
#def qcorreo():
	#object = s3.Object('dpabusquedas','correos.mbox')
	#bb2=object.get()["Body"].read().decode('utf-8')
	#x=json.loads(bb2)
	#return json.dumps(x)




if __name__ == "__main__":
    port = int(os.environ.get("API_PORT", 5000))
    app.run(host="0.0.0.0", port = port)