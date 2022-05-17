# All data source should be defined here resuable purpose

data "aws_availability_zones" "available" {}

# To collect AWS IAM role/account information
data "aws_iam_account_alias" "current" {}

# To collect AWS Caller Identity information.
data "aws_caller_identity" "current" {}

# To collect AWS Region information
data "aws_region" "current" {}

data "aws_vpc" "main_vpc" {
  id = var.vpc
}

data "aws_subnet_ids" "all_subnet_ids" {
  vpc_id = data.aws_vpc.main_vpc.id
}

data "aws_subnet" "all_subnets" {
  count = length(data.aws_subnet_ids.all_subnet_ids.ids)
  id    = tolist(data.aws_subnet_ids.all_subnet_ids.ids)[count.index]
}
