resource "aws_instance" "bastion" {
  ami                         = "ami-0cbc973f83cd12a36"
  instance_type               = "t3.micro"
  key_name                    = "bastion-key-pair"
  subnet_id                   = aws_subnet.public-1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Dimitar"
  }
}
