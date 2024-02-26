variable "ec2_ami" {
  description = "This variable will manage the ec2-ami"
  type        = string
  default     = "ami-0905a3c97561e0b69"
}

# variable "ec2_instance_type" {
#   description = "This variable will manage the instance type"
#   type        = string
#   default     = "t2.large"
# }

variable "ec2_key_name" {
  description = "This variable will manage the key name"
  type        = string
  default     = "test100"
}