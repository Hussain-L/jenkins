resource "aws_launch_template" "terraform-Jenkins-lt" {
  depends_on = [
    aws_vpc.main
  ]
  name                   = "Jenkins-LT"
  image_id               = var.ami_id
  update_default_version = true
  instance_type          = var.instance_type
  key_name               = "Oregon"
  user_data              = filebase64("${path.module}/userdata.sh")
  # security_groups = [aws_security_group.lt-sg.id]
  iam_instance_profile {
    name = "Jenkins-ec2-role"
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.lt-sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "terraform-Jenkins"
    }
  }
}