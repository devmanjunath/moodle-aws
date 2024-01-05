terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
    external = {
      source = "hashicorp/external"
      version = "2.3.2"
    }
  }
}
