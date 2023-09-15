terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}
