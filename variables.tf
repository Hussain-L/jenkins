variable "ami_id" {
  type    = string
  default = "ami-02d5619017b3e5162"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "azs" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}