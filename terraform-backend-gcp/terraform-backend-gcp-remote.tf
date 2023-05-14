provider "google" {
  project = "your-project-id"
  region  = "EUROPE-SOUTHWEST1"
}
resource "google_storage_bucket" "terraform-bucket-for-state" {
  name                        = "bucket-dev-eu"
  location                    = "EUROPE-SOUTHWEST1"
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  labels = {
    "environment" = "jorgebernhnardt"
  }
}
terraform {
  backend "gcs" {
    bucket  = "bucket-dev-eu"
    prefix  = "terraform/state"
  }
}