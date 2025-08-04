#!/bin/bash
set -e
# Update system
yum update -y
# Install Python 3.9+ and pip
yum install -y python3.11 python3-pip git
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Start Ollama service
systemctl enable ollama
systemctl start ollama

# Wait for Ollama to be ready
echo "Waiting for Ollama to start..."
sleep 10

# Pull the required model
ollama pull llama3.2:1b

# Install AWS CLI if not already present
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    rm -rf aws awscliv2.zip
fi

# Create application directory
mkdir -p /opt/aws-mcp-app
cd /opt/aws-mcp-app

# Clone the application (replace with your actual repository)
# git clone <your-repo-url> .

# Install uv/uvx for MCP server
curl -LsSf https://astral.sh/uv/install.sh | sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/ec2-user/.bashrc

# Set up environment variables (adjust as needed)
cat << 'EOF' >> /etc/environment
AWS_DEFAULT_REGION=us-east-1
OLLAMA_ENDPOINT=http://localhost:11434
EOF

# Create systemd service for the application (optional)
cat << 'EOF' > /etc/systemd/system/aws-mcp-app.service
[Unit]
Description=AWS MCP Ollama App
After=network.target ollama.service
Requires=ollama.service

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/aws-mcp-app
Environment=PATH=/home/ec2-user/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/usr/bin/python3 -m aws_mcp_app.app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable the service (but don't start it yet)
systemctl enable aws-mcp-app

echo "EC2 setup complete!"
echo "Ollama is running with llama3.2:1b model"
echo "AWS MCP App service is ready to start"
echo ""
echo "To start the application:"
echo "  systemctl start aws-mcp-app"
echo ""
echo "To check status:"
echo "  systemctl status aws-mcp-app"
echo "  journalctl -u aws-mcp-app -f
