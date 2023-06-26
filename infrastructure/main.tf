locals {
  gcp_bucket = {
    name   = "thisisacompletelyrandombucket324232rs"
    region = "US-CENTRAL1"
  }
}

data "google_project" "project" {
}

resource "google_project_iam_custom_role" "uploader" {
  role_id     = "CloudStorageUploader"
  title       = "Cloud Storage Uploader"
  description = "This role can create and update objects in a GCS bucket"
  permissions = [
    "storage.objects.create",
    "storage.objects.delete"
  ]
}

resource "google_service_account" "app_uploader" {
  account_id   = "app-uploader"
  display_name = "GCS Application Uploader"
}


resource "google_storage_bucket" "app_bucket" {
  name          = local.gcp_bucket.name
  location      = local.gcp_bucket.region
  force_destroy = true

  uniform_bucket_level_access = true
}


resource "google_storage_bucket_iam_member" "app_uploader_member" {
  bucket = google_storage_bucket.app_bucket.name
  role   = google_project_iam_custom_role.uploader.name
  member = "serviceAccount:${google_service_account.app_uploader.email}"
}


resource "google_service_account_key" "app_uploader" {
  service_account_id = google_service_account.app_uploader.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}


resource "local_file" "foo" {
  content  = templatefile("${path.module}/sa-secret.tftpl", { sajson = google_service_account_key.app_uploader.private_key })
  filename = "${path.module}/../manifests/1.secrets.yaml"
}




