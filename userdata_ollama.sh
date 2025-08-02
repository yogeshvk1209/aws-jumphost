#!/bin/bash
log_file=/var/log/user_data.log
exec >> $log_file 2>&1
yum update -y
yum install -y yum-utils
yum -y install git docker bash-completion python3.11 python3-pip
# Enable bash-completion system-wide
if [ -f /etc/profile.d/bash_completion.sh ]; then
  source /etc/profile.d/bash_completion.sh
fi
#Docker Config
systemctl enable docker
systemctl start docker
## Ollama related setup
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama --restart always ollama/ollama
docker exec -it ollama ollama pull gemma3:1b
docker run -d -p 8080:8080 --add-host=host.docker.internal:host-gateway -v ollama-webui:/app/backend/data --name ollama-webui --restart always ghcr.io/ollama-webui/ollama-webui:main
