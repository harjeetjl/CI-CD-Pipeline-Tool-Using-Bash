#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y nginx git python3 python3-pip pipx python3-dotenv
pipx ensurepath

# Set up SSH (User should manually configure SSH keys if needed)
echo "Set up your SSH keys if not already done."

# Create project directory and set permissions
cd $HOME
mkdir -p ~/Devops_CICD
chmod 755 ~/Devops_CICD
cd ~/Devops_CICD

git clone reponame
mkdir -p log
chmod 755 log

# Create required files
touch check_commits.py deploy.sh
touch ~/askpass.sh
chmod 755 check_commits.py deploy.sh
chmod +x ~/askpass.sh

# Add sudo password script
echo '#!/bin/bash' > ~/askpass.sh
echo 'echo "your_sudo_password"' >> ~/askpass.sh  # Replace with actual sudo password

# Set up cron job for commit checking
echo "* * * * * /usr/bin/python3 $HOME/Devops_CICD/check_commits.py >> $HOME/Devops_CICD/log/check_commits.log 2>&1" | crontab -

# Validate installation
python3 --version
git --version

# Start and validate nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx

# Allow user to restart nginx without password
echo "$(whoami) ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx" | sudo tee /etc/sudoers.d/nginx_restart

# Configure Nginx
sudo bash -c 'cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    root /home/$(whoami)/Devops_CICD/;
    index index.html index.htm;
}
EOF'
sudo systemctl restart nginx

# Start cron service
sudo systemctl start cron
sudo systemctl enable cron

echo "Setup completed successfully!"
