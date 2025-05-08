from dotenv import load_dotenv
import os, requests
import sys

load_dotenv()

# GitHub repository details
GITHUB_REPO = "harjeetjl/CI-CD-Pipeline-Tool-Using-Bash"  # Change this
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")  # Use a GitHub token with repo read access
# GITHUB_TOKEN = ("GITHUB_TOKEN") #For ubuntu
# Get the current user's home directory dynamically
HOME_DIR = os.path.expanduser("~")
LOCAL_COMMIT_FILE = f"{HOME_DIR}/Devops_CICD/log/latest_commit.txt"
DEPLOY_SCRIPT = f"{HOME_DIR}/Devops_CICD/deploy.sh"

def get_latest_commit():
    """Fetch the latest commit SHA from GitHub API."""
    if not GITHUB_TOKEN:
        print("ERROR: GITHUB_TOKEN is missing! Set it in your .env file.")
        sys.exit(1)  # Stop execution

    url = f"https://api.github.com/repos/{GITHUB_REPO}/branches/main"
    headers = {"Authorization": f"token {GITHUB_TOKEN}",
               "Cache-Control": "no-cache"}

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        return response.json()["commit"]["sha"]
    else:
        print("Error fetching latest commit.")
        return None

def load_saved_commit():
    if os.path.exists(LOCAL_COMMIT_FILE):
        with open(LOCAL_COMMIT_FILE, "r") as file:
            return file.read().strip()
    return None

def save_commit(commit_sha):
    with open(LOCAL_COMMIT_FILE, "w") as file:
        file.write(commit_sha)

def main():
    latest_commit = get_latest_commit()
    saved_commit = load_saved_commit()

    if latest_commit and latest_commit != saved_commit:
        print("New commit found! Deploying...")
        
        # Ensure deploy.sh is executable
        os.system(f"chmod +x {DEPLOY_SCRIPT}")
        exit_code = os.system(f"bash {DEPLOY_SCRIPT}")
        if exit_code == 0:
            save_commit(latest_commit)
            print("Deployment Completed Successfully.")
        else:
            print("Deployment failed. Check logs.")
    else:
        print("No new commits.")

if __name__ == "__main__":
    main()