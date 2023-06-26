from flask import Flask, request
from google.cloud import storage
import os
from werkzeug.utils import secure_filename

gcs_bucket = os.environ.get('GCS_BUCKET', "")
sa_key_path = os.environ.get('SA_KEY_PATH', "")
storage_client = storage.Client.from_service_account_json(sa_key_path)
app = Flask(__name__)

def upload_blob_from_stream(bucket_name, file_obj, destination_blob_name):
    """Uploads bytes from a stream or other file-like object to a blob."""
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
    upload_blob_from_stream(gcs_bucket, file, secure_filename(file.filename))
    return {"uploaded" : secure_filename(file.filename)}

if __name__ == "__main__":
    app.run(host='0.0.0.0')