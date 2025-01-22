terraform {
  required_version = ">= 0.12"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.63"
    }
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.0.0"
    }
  }
}

