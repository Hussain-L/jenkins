resource "aws_instance" "this" {
  ami                     = "ami-02d5619017b3e5162"
  instance_type           = "t2.micro"

  tags = {
    Name = "tf-git"
  }
}