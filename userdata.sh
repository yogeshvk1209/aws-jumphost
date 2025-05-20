#!/bin/bash
log_file=/var/log/user_data.log
exec >> $log_file 2>&1
yum update -y
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform git
