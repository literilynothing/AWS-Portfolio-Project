terraform {
  required_version = ">= 1.5.0"
}

# Establishes an IAM role for the EC2 instance to assume-----------------------------------
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attaches the AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Creates an IAM instance profile for the EC2 instance to use
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Establishes an IAM OpenID Connect provider for GitHub Actions----------------------------
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

# Creates an IAM role for GitHub Actions to use when deploying to AWS
resource "aws_iam_role" "github_actions_deploy" {
  name = "github-actions-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_actions.arn
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:literilynothing@307273757/AWS-Portfolio-Project@1432595243:ref:refs/heads/main"
        }
      }
    }]
  })
}

# Outputs the ARN of the GitHub Actions role to use in the workflow
output "github_actions_deploy_role_arn" {
  value = aws_iam_role.github_actions_deploy.arn
}

# Configures an IAM policy for GitHub Actions to let it deploy ssm-agent-------------------
resource "aws_iam_role_policy" "github_actions_ssm_deploy_policy" {
  name = "github-actions-ssm-deploy-policy"
  role = aws_iam_role.github_actions_deploy.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ssm:SendCommand",
        Resource = [
          "arn:aws:ec2:us-east-1:${data.aws_caller_identity.current.account_id}:instance/${aws_instance.app_server_1.id}",
          "arn:aws:ssm:us-east-1::document/AWS-RunShellScript"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "ssm:GetCommandInvocation",
        Resource = "*"
      }
    ]
  })
}