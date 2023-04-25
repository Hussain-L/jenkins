resource "aws_iam_role" "Jenkins-ec2-role" {
  name = "Jenkins-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ])

  role       = aws_iam_role.Jenkins-ec2-role.name
  policy_arn = each.value
}
resource "aws_iam_instance_profile" "test_profile" {
  name = "Jenkins-ec2-role"
  role = aws_iam_role.Jenkins-ec2-role.name
}