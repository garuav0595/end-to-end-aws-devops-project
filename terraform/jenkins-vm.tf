resource "aws_key_pair" "devops_key" {
  key_name   = "devops-keypair"
  public_key = file("~/.ssh/devops-keypair.pub")
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-ci-sg"
  description = "Security Group for Jenkins CI VM"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Web UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_vm" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type          = "t3.xlarge"             # 4 vCPU, 16 GB RAM
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins-CI-Server"
  }
}
