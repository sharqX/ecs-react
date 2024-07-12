resource "aws_instance" "strapi-server" {
  ami           = "ami-05e00961530ae1b55"
  instance_type = "t3.small"
  subnet_id = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.auto-sg.id]
  associate_public_ip_address = true

  key_name = "awskey"

  tags = {
    Name = "AutoStrapi-[sharq]"
  }
}