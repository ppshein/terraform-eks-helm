business_unit = "digital"
project       = "sre"
environment   = "nonprod"
provider_role = "arn:aws:iam::xxxxxxxxxxxx:role/this-is-where-to-be-deployed"

# I would use existing VPC instead
vpc = "vpc-xxxxxx"

eks = {
  name                   = "pp-cluster"
  version                = "1.20"
  min_capacity           = 1
  max_capacity           = 2
  map_users              = []
  instance_type          = "t3.medium"
  fluentd_image_location = "fluent/fluentd-kubernetes-daemonset:v1.14.6-debian-cloudwatch-1.0"
  map_accounts           = []
  map_roles              = []
}
