terraform {
  backend "s3" {
    skip_region_validation = true
    bucket                 = "moodle-tf-backend"
    key                    = "states/terraform.json"
    region                 = "ap-south-2"
    profile                = "moodle"
  }
}
