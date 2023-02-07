
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.66"
      #credentials             = "as-new@kubectl-373710.iam.gserviceaccount.com"
      #region  = "us-west2"
    }
  }
}