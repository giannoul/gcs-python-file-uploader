from flask import Flask, request
from google.oauth2 import service_account
from google.cloud import storage
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)

def upload_blob_from_stream(bucket_name, file_obj, destination_blob_name):
    """Uploads bytes from a stream or other file-like object to a blob."""
    storage_client = storage.Client.from_service_account_json('/app/key.json')
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)
    file_obj.seek(0)
    blob.upload_from_file(file_obj)
    print(
        f"Stream data uploaded to {destination_blob_name} in bucket {bucket_name}."
    )

@app.route("/api/health")
def health():
    return { "status": "ok" }


@app.route("/api/upload-random", methods=["POST"])
def upload_random():
    file = request.files['file']
    print(request.files)
    upload_blob_from_stream("thisisacompletelyrandombucket324232s", file, secure_filename(file.filename))
    return {"status" : secure_filename(file.filename)}


if __name__ == "__main__":
    app.run(host='0.0.0.0')