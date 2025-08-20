#!/bin/bash
log_file=/var/log/user_data.log
exec >> $log_file 2>&1
yum update -y
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform git docker python3-pip bash-completion
# Enable bash-completion system-wide
if [ -f /etc/profile.d/bash_completion.sh ]; then
  source /etc/profile.d/bash_completion.sh
fi
#Docker Config
systemctl enable docker
systemctl start docker
#mkdir -p /home/jenkins && chmod -R 777 /home/jenkins
#docker run -dit -p 8080:8080 -p 50000:50000 -v /home/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --group-add $(getent group docker | cut -d: -f3) yogeshvk1209/jenkins2.504_jdk21
#Kube config
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/
# kubectl bash completion setup
kubectl completion bash > /etc/bash_completion.d/kubectl
# Add kubectl completion to /etc/bashrc for all users
if ! grep -q 'source <(kubectl completion bash)' /etc/bashrc; then
  echo 'source <(kubectl completion bash)' >> /etc/bashrc
fi
# Add kubectl completion to root's .bashrc
if ! grep -q 'source <(kubectl completion bash)' /root/.bashrc; then
  echo 'source <(kubectl completion bash)' >> /root/.bashrc
fi
# Add kubectl completion to jenkins user if home exists
if [ -d /home/jenkins ]; then
  if ! grep -q 'source <(kubectl completion bash)' /home/jenkins/.bashrc 2>/dev/null; then
    echo 'source <(kubectl completion bash)' >> /home/jenkins/.bashrc
  fi
fi

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
