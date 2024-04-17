resource "aws_instance" "appnode1" {

  ami                         = var.ec2_ami
  instance_type               = "t2.large"
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.web-traffic.id]
  user_data                   = templatefile("./install.sh", {})
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_instance" "appnode2" {

  ami                         = var.ec2_ami
  instance_type               = "t2.medium"
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.web-traffic.id]
  associate_public_ip_address = true

  tags = {
    Name = "Monitoring"
  }
}

resource "aws_instance" "appnode3" {

  ami                         = var.ec2_ami
  instance_type               = "t2.medium"
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.web-traffic.id]
  associate_public_ip_address = true

  tags = {
    Name = "Kubernetes"
  }
}

resource "aws_instance" "appnode4" {

  ami                         = var.ec2_ami
  instance_type               = "t2.medium"
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.web-traffic.id]
  associate_public_ip_address = true

  tags = {
    Name = "Kubernetes1"
  }
}

