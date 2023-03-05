data "aws_caller_identity" "current" {}

module "iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  create_role = true

  role_name         = "ecs-full-access-assume-role"
  role_requires_mfa = true

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
  ]
  number_of_custom_role_policy_arns = 1
}

module "s3_full_access_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "s3-full-access"
  path        = "/"
  description = "s3-full-access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
    EOF
}

module "iam_assumable_role_custom" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role = true

  role_name         = "tf-s3-full-access-role-for-ec2"
  role_requires_mfa = false

  custom_role_policy_arns = [
    module.s3_full_access_policy.arn
  ]
}
