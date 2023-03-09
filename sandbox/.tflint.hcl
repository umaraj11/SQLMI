config {
  module = true
  deep_check = true
  force = false

  aws_credentials = {
    aws_profile = "sandbox"
  }
}

rule "aws_instance_invalid_type" {
  enabled = false
}

rule "aws_instance_previous_type" {
  enabled = false
}