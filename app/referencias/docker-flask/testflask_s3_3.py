from flask import Flask
from flask_s3 import FlaskS3
import os
import boto3

s3_client = boto3.resource('s3')

app = Flask(__name__)
#app.config['FLASKS3_BUCKET_NAME'] = 'dpabusquedas'
#s3 = FlaskS3(app)
#s3 = FlaskS3()

#def start_app():
 #   app = Flask(__name__)
 #   s3.init_app(app)
 #   return app


@app.route("/download/<path:object_name>")
def download(object_name):
    my_object = s3_client.meta.client.download_file('dpabusquedas',object_name,'download/t10.json')
    
    return download/t10.json
    #if my_object:
    	#download_url = my_object.download()
    #	return my_object
    #else:	
    #	abort(404, "File doesn't exist")

if __name__ == "__main__":
    port = int(os.environ.get("API_PORT", 5000))
    app.run(host="0.0.0.0", port = port)