#!/bin/bash
log_file=/var/log/user_data.log
exec >> $log_file 2>&1
yum update -y
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform git docker python3-pip
systemctl enable docker
systemctl start docker
mkdir -p /home/jenkins && chmod +R 777 /home/jenkins
docker run -dit -p 8080:8080 -p 50000:50000 -v /home/jenkins:/var/jenkins_home yogeshvk1209/jenkins2.504_jdk21:latest
