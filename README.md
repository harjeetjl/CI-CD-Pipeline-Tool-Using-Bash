# CI-CD-Pipeline-Tool-Using-Bash

## Need to install below on your Ubuntu/Linux 
RUN: sudo apt install -y nginx  
RUN: sudo apt install -y git 
RUN: sudo apt install -y python3 
RUN: sudo apt install pipx -y 
RUN:pipx ensurepath 
 
## Clone the repo in ubuntu 
1. RUN: Setup you ssh 
2. RUN: mdkir Devops_CICD 
3. RUN: chmod 755 log 
4. RUN: cd Devops_CICD 
5. RUN: git clone reponame 
6. RUN: mkdir log 
7. RUN: chmod 755 log 
8. you have to create 2 files name "check_commits.py" & "deploy.sh" 
9. use the code in deploy_sample fodler for your reference 
10. RUN: chmod 755 check_commits.py 
11. RUN: chmod 755 deploy.sh 
 
## For Token setup instructions in windows 
1. RUN: pip install python-dotenv 
2. Create a `.env` file in the root directory. 
3. Add the required variables ->( e.g. GITHUB_TOKEN = "your key" ) 
4. Make sure to put `.env` under `.gitignore` file so that it should remain safe from commit. 
 
## For Token setup instructions in ubuntu 
1. sudo apt install -y python3-dotenv 
2. Update "GITHUB_TOKEN" value in the "check_commits.py" under "Devops_CICD" directory. 
 
## python & git version validation steps  
RUN: python3 --version 
RUN: git --version  
 
## nginx validation status 
RUN: sudo systemctl status nginx 
 
"If not running, start it using"  
RUN: sudo systemctl start nginx 
 
##  Set Up a Cron Job to Run the Python Script 
RUN: crontab -e 
SET: * * * * * /usr/bin/python3 $HOME/Devops_CICD/Devops_CICD/check_commits.py >> $HOME/Devops_CICD/Devops_pipeline/log/check_commits.log 2>&1 
 
## Validation Steps for Cron 
RUN: crontab -l 
RUN: systemctl status cron 
 
"If not running, start it using"  
RUN: sudo systemctl start cron 
RUN: sudo systemctl restart cron 
 
## Check Cron Logs for Errors 
RUN: sudo journalctl -u cron --since "1 hour ago" 
 
## Run this command once to allow your user to restart Nginx without a password 
RUN: echo "$(whoami) ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx" | sudo tee /etc/sudoers.d/nginx_restart 
 
## Nginx Configuration 
RUN: sudo nano /etc/nginx/sites-available/default 
SET: root /home/tanujbhatia/Devops_CICD/Devops_pipeline/; 
RUN: sudo systemctl restart nginx 
 
## Steps to Create an askpass_script 
RUN: nano ~/askpass.sh 
 
## Paste the following code inside the file 
#!/bin/bash 
SET: echo "your_sudo_password" #Replace your_sudo_password with your actual sudo password 
 
## Make It Executable 
RUN: chmod +x ~/askpass.sh