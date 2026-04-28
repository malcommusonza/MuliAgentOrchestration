#!/bin/bash
set -euxo pipefail
exec > >(tee /var/log/openclaw-install.log) 2>&1

echo "[OpenClaw] Installing via official script: $(date)"

# -----------------------------------------------------------------------------
# Run the official installer non‑interactively
# -----------------------------------------------------------------------------
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-prompt --no-onboard

# -----------------------------------------------------------------------------
# Ensure openclaw command is in PATH for ec2-user
# -----------------------------------------------------------------------------
export PATH="$PATH:$(npm prefix -g)/bin"

echo "🎉 OpenClaw is installed. You can now complete onboarding manually."