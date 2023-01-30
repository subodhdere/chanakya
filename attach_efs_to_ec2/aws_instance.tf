resource "aws_instance" "testinstance" {
  depends_on = [aws_efs_mount_target.efs-mt]
  ami                         = "ami-06984ea821ac0a879"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = "demo-mumbai"
  tags = {
    Name = "testinstance"
  }
  user_data = <<EOF
#!/bin/bash -x
set -e
mkdir sd
apt install nfs-kernel-server -y
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  sd
EOF
}