variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
    tags     = map(string)
  }))
  default     = {}
  description = "Resource group infrastructure will be deployed to"
}

