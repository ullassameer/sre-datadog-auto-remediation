data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
  tags = {
    Name = "sre-data-dog-auto-remediation"
  }

  user_data = <<EOF
#!/bin/bash

systemctl enable amazon-ssm-agent

systemctl restart amazon-ssm-agent

EOF
}