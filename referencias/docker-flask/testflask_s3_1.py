from flask import Flask, request
from flask_cloudy import Storage

app = Flask(__name__)

# Update the config 
app.config.update({
	"STORAGE_PROVIDER": "S3", # Can also be S3, GOOGLE_STORAGE, etc... 
	"STORAGE_KEY": "",
	"STORAGE_SECRET": "",
	"STORAGE_CONTAINER": "dpabusquedas",  # a directory path for local, bucket name of cloud
	"STORAGE_SERVER": True,
	"STORAGE_SERVER_URL": "/files" # The url endpoint to access files on LOCAL provider
})

# Setup storage
storage = Storage()
storage.init_app(app) 

# Pretending the file uploaded is "my-picture.jpg"    
# it will return a url in the format: http://domain.com/files/my-picture.jpg


# A download endpoint, to download the file
@app.route("/download/<path:object_name>")
def download(object_name):
    my_object = storage.get(object_name)
    if my_object:
    	download_url = my_object.download()
    	return download_url
    else:	
    	abort(404, "File doesn't exist")