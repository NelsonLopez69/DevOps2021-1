
resource "aws_instance" "G4_DevOps_jenkins" {
  ami           = var.ami_id
  instance_type      = var.instance_type
  # Security group assign to instance
  vpc_security_group_ids = [aws_security_group.allow_ssh_jenkins.id]
  subnet_id = "subnet-086d80cc0d3b06c82"

  # key name
  key_name = var.key_name

  user_data = base64encode(templatefile("./jenkins.sh"))


  tags = {
    Name = "JenkinsEC2_G4",
    responsible = var.key_name
  }
  
}
