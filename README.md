# DevOps CI/CD Pipeline Tool

A production-grade **CI/CD pipeline** for automatically detecting changes in a GitHub repository and deploying updates to an Nginx web server. Designed using Python and shell scripting, this project demonstrates a modular and automated approach to infrastructure-as-code for modern DevOps workflows.

## Project Structure

```
CI-CD-Pipeline-Tool-Using-Bash/
├── deployment/
│   ├── check_commits.py       # Script to check for new GitHub commits
│   ├── deploy.sh              # Deployment automation script
├── log_sample/
│   ├── check_commits.log      # Log output of commit checker
│   ├── deploy.log             # Deployment log details
│   ├── latest_commit.txt      # Stores latest deployed commit ID
├── .gitignore                 # Specifies untracked files
├── index.html                 # Static HTML page to be served
├── README.md                  # Project documentation
```

## Key Features

- Commit Detection: Auto-checks for new GitHub commits via REST API
- Automated Deployment: Deploy changes instantly using Bash
- Cron Integration: Scheduled execution every 5 minutes
- GitHub Token Authentication: Secure commit access via `.env`
- Nginx Integration: Serves updated `index.html` after deployment
- Logging: Tracks actions via timestamped logs
- Sudo Automation (Optional): Enables passwordless `systemctl` restarts

## System Requirements

Ensure the following dependencies are installed:

```bash
sudo apt update
sudo apt install -y nginx git python3 pipx
pipx ensurepath
```

## Project Setup

1. Clone the Repository
   ```bash
   mkdir -p ~/Devops_CICD && cd ~/Devops_CICD
   git clone <your_repo_url>
   cd CI-CD-Pipeline-Tool-Using-Bash
   ```

2. Prepare Log Directory
   ```bash
   mkdir log && chmod 755 log
   ```

3. Copy and Set Executable Permissions
   ```bash
   cp deployment/check_commits.py deployment/deploy.sh .
   chmod 755 check_commits.py deploy.sh
   ```

## GitHub Token Configuration

### On Ubuntu
1. Install dotenv support:
   ```bash
   sudo apt install -y python3-dotenv
   ```
2. Create a `.env` file:
   ```ini
   GITHUB_TOKEN="your_github_token"
   ```
3. Ensure `.env` is in `.gitignore`

### On Windows
1. Install dotenv:
   ```bash
   pip install python-dotenv
   ```
2. Same `.env` setup as above

## Nginx Configuration

1. Edit the default site configuration:
   ```bash
   sudo nano /etc/nginx/sites-available/default
   ```

2. Update the root path:
   ```nginx
   root /home/<your_username>/Devops_CICD/CI-CD-Pipeline-Tool-Using-Bash/;
   ```

3. Restart nginx:
   ```bash
   sudo systemctl restart nginx
   ```

Optional: Allow restart without password
```bash
echo "$(whoami) ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx" | sudo tee /etc/sudoers.d/nginx_restart
```

## Cron Job Integration (Every 5 Minutes)

1. Open crontab editor:
   ```bash
   crontab -e
   ```

2. Start and enable cron:
   ```bash
   sudo systemctl enable cron
   sudo systemctl start cron
   ```

3. Add the job:
   ```cron
   */5 * * * * /usr/bin/python3 $HOME/Devops_CICD/check_commits.py >> $HOME/Devops_CICD/log/check_commits.log 2>&1
   ```

4. Validate:
   ```bash
   crontab -l
   systemctl status cron
   sudo journalctl -u cron --since "1 hour ago"
   ```

## Optional: Askpass for Secure Sudo

1. Create script:
   ```bash
   nano ~/askpass.sh
   ```

2. Script content:
   ```bash
   #!/bin/bash
   echo "your_sudo_password"
   ```

3. Make it executable:
   ```bash
   chmod +x ~/askpass.sh
   ```

## Snapshots


