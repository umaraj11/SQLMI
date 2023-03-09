terraform {
  backend "s3" {
    bucket  = "terraform-state-axiamed-staging-us-west-2"
    region  = "us-west-2"
    key     = "staging-axiamed-(insert unique service type here)"
    profile = "staging"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "staging"
  version = "= v2.70.0"
}
