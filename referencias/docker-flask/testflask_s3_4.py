import json
from flask import Flask, jsonify, abort, request, make_response, url_for
from flask_s3 import FlaskS3
import os
import boto3

s3 = boto3.resource('s3')

app = Flask(__name__)

@app.route('/busquedas', methods = ['GET'])                                                  
#@auth.login_required
def query():
	object = s3.Object('dpabusquedas','json1.json')
	bb2=object.get()["Body"].read().decode('utf-8')
	x=json.loads(bb2)
	return json.dumps(x)


@app.route('/busquedas2', methods = ['GET'])                                                  
#@auth.login_required
def query2():
	object = s3.meta.client('dpabusquedas','json1.json','/t21.json')
	return 

if __name__ == "__main__":
    port = int(os.environ.get("API_PORT", 5000))
    app.run(host="0.0.0.0", port = port)