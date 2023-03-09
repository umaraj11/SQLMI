terraform {
  backend "s3" {
    bucket  = "terraform-state-axiamed-production-us-west-2"
    region  = "us-west-2"
    key     = "production-axiamed-(insert unique service type here)"
    profile = "production"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "production"
  version = "= v2.70.0"
}
