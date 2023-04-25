resource "aws_s3_bucket" "example" {
  bucket = "jenkins-project-hussain"

  tags = {
    Name        = "Jenkins-Project-Hussain"
    Environment = "Test"
  }
}