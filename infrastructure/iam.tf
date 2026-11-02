terraform {
  required_version = ">= 1.5.0"
}
resource "aws_iam_user" "app_user" {
  name = "appdev"
}
resource "aws_iam_user_policy_attachment" "app_user_attachment" {
  user       = aws_iam_user.app_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}