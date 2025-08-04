#!/bin/bash
log_file=/var/log/user_data.log
exec >> $log_file 2>&1
yum update -y
yum install -y yum-utils
#yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install git docker bash-completion python3.11 python3-pip
# Enable bash-completion system-wide
if [ -f /etc/profile.d/bash_completion.sh ]; then
  source /etc/profile.d/bash_completion.sh
fi
#Docker Config
systemctl enable docker
systemctl start docker
## MCP related setup
#python3.11 -m venv ~/mcp-venv
#source ~/mcp-venv/bin/activate
#pip3 install --upgrade pip
#pip3 install awslabs.aws-api-mcp-server
