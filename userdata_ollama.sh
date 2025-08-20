#!/bin/bash
log_file=/var/log/user_data.log
exec >> $log_file 2>&1
yum update -y
yum install -y yum-utils
yum -y install git docker bash-completion python3.11 python3-pip npm gcc python3-devel
npm install mcp-remote@0.1.18
# Enable bash-completion system-wide
if [ -f /etc/profile.d/bash_completion.sh ]; then
  source /etc/profile.d/bash_completion.sh
fi
#Docker Config
systemctl enable docker
systemctl start docker
## Ollama related setup
# Running Ollama and Ollama Web UI on Docker (for ease of maintenance)
#docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama --restart always ollama/ollama
#sleep 30
#docker exec ollama ollama pull gemma3:1b
#docker exec ollama ollama pull qwen2.5:0.5b
#docker run -d -p 8080:8080 --add-host=host.docker.internal:host-gateway -v ollama-webui:/app/backend/data --name ollama-webui --restart always ghcr.io/ollama-webui/ollama-webui:main

# Running Ollama locally and Ollama Web UI on Docker
curl -fsSL https://ollama.com/install.sh | sh
sleep 30
echo "Install complete"
systemctl enable ollama
systemctl start ollama
ps -eaf| grep -i ollama
#ollama pull qwen3:1.7b
#docker run -d --network=host -v ollama-webui:/app/backend/data -e OLLAMA_API_BASE_URL=http://localhost:11434/api --name ollama-webui --restart always ghcr.io/ollama-webui/ollama-webui:main
#docker run -d --network=host -v open-webui-data:/app/backend/data -e OLLAMA_API_BASE_URL=http://localhost:11434/api --restart always ghcr.io/open-webui/open-webui:main
