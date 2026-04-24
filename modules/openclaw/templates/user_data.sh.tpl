#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/openclaw-deploy.log) 2>&1

echo "[OpenClaw] Starting automated setup: $(date)"

# -----------------------------------------------------------------------------
# Install Docker & Compose
# -----------------------------------------------------------------------------
dnf update -y
dnf install -y docker git jq
systemctl enable --now docker
usermod -aG docker ec2-user

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# -----------------------------------------------------------------------------
# Create OpenClaw directories
# -----------------------------------------------------------------------------
OPENCLAW_HOME="/home/ec2-user/.openclaw"
WORKSPACE_DIR="/home/ec2-user/.openclaw/workspace"
mkdir -p "$OPENCLAW_HOME" "$WORKSPACE_DIR"
chown -R ec2-user:ec2-user /home/ec2-user/.openclaw

# -----------------------------------------------------------------------------
# Generate Gateway Token
# -----------------------------------------------------------------------------
GATEWAY_TOKEN=$(openssl rand -hex 32)

# -----------------------------------------------------------------------------
# Create openclaw.json with Native Multi-Agent Configuration
# -----------------------------------------------------------------------------
cat > "$OPENCLAW_HOME/openclaw.json" <<EOF
{
  "gateway": {
    "port": ${gateway_port},
    "token": "$GATEWAY_TOKEN"
  },
  "env": {
    "OPENROUTER_API_KEY": "${openrouter_api_key}"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "${default_model}"
      }
    },
    "list": [
      {
        "id": "orchestrator",
        "name": "Orchestrator",
        "workspace": "/home/ec2-user/.openclaw/workspace-orchestrator",
        "model": {
          "primary": "openrouter/nvidia/nemotron-super-120b"
        }
      },
      {
        "id": "developer",
        "name": "Developer",
        "workspace": "/home/ec2-user/.openclaw/workspace-developer",
        "model": {
          "primary": "openrouter/pony-alpha"
        }
      },
      {
        "id": "qa",
        "name": "QA Reviewer",
        "workspace": "/home/ec2-user/.openclaw/workspace-qa",
        "model": {
          "primary": "openrouter/meta-llama/llama-3.3-70b-instruct"
        }
      },
      {
        "id": "planner",
        "name": "Planner",
        "workspace": "/home/ec2-user/.openclaw/workspace-planner",
        "model": {
          "primary": "openrouter/hunter-alpha"
        }
      },
      {
        "id": "writer",
        "name": "Technical Writer",
        "workspace": "/home/ec2-user/.openclaw/workspace-writer",
        "model": {
          "primary": "openrouter/trinity-large-preview"
        }
      }
    ]
  }
}
EOF
chown ec2-user:ec2-user "$OPENCLAW_HOME/openclaw.json"

# -----------------------------------------------------------------------------
# Create Identity Files for Each Agent (Optional but Recommended)
# -----------------------------------------------------------------------------
# Orchestrator
mkdir -p /home/ec2-user/.openclaw/workspace-orchestrator
cat > /home/ec2-user/.openclaw/workspace-orchestrator/IDENTITY.md <<EOF
# Orchestrator Agent

You are the Orchestrator, the central coordinator of the AI dev team.
Your role is to:
- Receive high-level tasks from the user.
- Break down complex tasks into subtasks.
- Delegate subtasks to the appropriate specialist agents (Developer, QA, Planner, Writer).
- Monitor progress and consolidate results.
- Provide a final summary to the user.

You do NOT write code, run tests, or write documentation yourself. You delegate.
EOF

# Developer
mkdir -p /home/ec2-user/.openclaw/workspace-developer
cat > /home/ec2-user/.openclaw/workspace-developer/IDENTITY.md <<EOF
# Developer Agent

You are the Developer, responsible for writing and implementing code.
Your role is to:
- Receive coding tasks from the Orchestrator.
- Write clean, efficient, and well-commented code.
- Follow best practices and the specified programming language/framework.
- Provide the completed code and a brief explanation.

You ONLY respond to coding requests. Do not perform testing, planning, or writing documentation.
EOF

# QA Reviewer
mkdir -p /home/ec2-user/.openclaw/workspace-qa
cat > /home/ec2-user/.openclaw/workspace-qa/IDENTITY.md <<EOF
# QA Reviewer Agent

You are the QA Reviewer, responsible for testing and code review.
Your role is to:
- Receive code from the Orchestrator (produced by the Developer).
- Review the code for bugs, edge cases, and adherence to requirements.
- Write unit tests if appropriate.
- Provide a concise review: pass/fail with specific feedback.

You ONLY review and test. Do not write new code or plan tasks.
EOF

# Planner
mkdir -p /home/ec2-user/.openclaw/workspace-planner
cat > /home/ec2-user/.openclaw/workspace-planner/IDENTITY.md <<EOF
# Planner Agent

You are the Planner, responsible for strategic analysis and research.
Your role is to:
- Receive research or planning requests from the Orchestrator.
- Analyse the problem, gather information, and propose a step-by-step plan.
- Identify potential risks and alternatives.

You ONLY plan and research. Do not write implementation code or perform tests.
EOF

# Technical Writer
mkdir -p /home/ec2-user/.openclaw/workspace-writer
cat > /home/ec2-user/.openclaw/workspace-writer/IDENTITY.md <<EOF
# Technical Writer Agent

You are the Technical Writer, responsible for creating documentation.
Your role is to:
- Receive documentation requests from the Orchestrator.
- Write clear, concise, and well-structured documentation (READMEs, API docs, guides).
- Synthesise technical information from other agents into readable prose.

You ONLY write documentation. Do not write code or perform testing.
EOF

# Set ownership
chown -R ec2-user:ec2-user /home/ec2-user/.openclaw/workspace-*

# -----------------------------------------------------------------------------
# Pull and start OpenClaw container
# -----------------------------------------------------------------------------
docker pull ${openclaw_image}

docker run -d \
  --name openclaw \
  --restart unless-stopped \
  -v /home/ec2-user/.openclaw:/home/node/.openclaw \
  -p ${gateway_port}:${gateway_port} \
  ${openclaw_image} gateway start --foreground

# -----------------------------------------------------------------------------
# Store credentials in a file for retrieval
# -----------------------------------------------------------------------------
cat > /home/ec2-user/openclaw_credentials.txt <<EOF
OpenClaw Gateway Credentials
----------------------------
URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):${gateway_port}
Token: $GATEWAY_TOKEN
EOF
chown ec2-user:ec2-user /home/ec2-user/openclaw_credentials.txt

echo "[OpenClaw] All setup finished: $(date)"