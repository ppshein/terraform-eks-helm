variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "provider_role" {
  type = string
}

variable "business_unit" {
  type        = string
  description = "The name of the business unit."
}

variable "project" {
  type        = string
  description = "The name of the project."
}

variable "environment" {
  type        = string
  description = "The name of the environment."
}

# declare VPC attribute here
variable "vpc" {
  description = "The attribute of VPC information"
  type        = string
}

# declare EKS attribute here
variable "eks" {
  type = object({
    name                   = string
    version                = string
    min_capacity           = number
    max_capacity           = number
    instance_type          = string
    fluentd_image_location = string
    map_accounts           = list(string)
    map_users = list(object({
      userarn  = string
      username = string
      groups   = list(string)
    }))
    map_roles = list(object({
      rolearn  = string
      username = string
      groups   = list(string)
    }))
  })
}
