#!/bin/bash

# Get the current user's home directory
USER_HOME=$(eval echo ~$(whoami))
PROJECT_DIR="$USER_HOME/Devops_CICD"
REPO_DIR="$PROJECT_DIR/CI-CD-Pipeline-Tool-Using-Bash"
LOG_FILE="$PROJECT_DIR/log/deploy.log"
ASKPASS_SCRIPT="$USER_HOME/askpass.sh"

# Ensure the log directory exists
mkdir -p "$PROJECT_DIR/log"

# Log function
log_message() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log_message "Starting deployment..."

# Pull latest changes or clone if missing
if [ -d "$REPO_DIR/.git" ]; then
    cd "$REPO_DIR" || { log_message "Failed to change directory to $REPO_DIR"; exit 1; }
    if ! git pull origin main; then
        log_message "Git pull failed!"
        exit 1
    fi
else
    if ! git clone https://github.com/harjeetjl/CI-CD-Pipeline-Tool-Using-Bash.git "$REPO_DIR"; then
        log_message "Git clone failed!"
        exit 1
    fi
fi

# Restart Nginx using askpass
export SUDO_ASKPASS="$ASKPASS_SCRIPT"
if ! sudo -A systemctl restart nginx; then
    log_message "Failed to restart Nginx!"
    exit 1
fi

log_message "Deployment completed successfully!"
