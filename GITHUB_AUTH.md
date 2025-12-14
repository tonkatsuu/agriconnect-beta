# GitHub Authentication Guide

## Option 1: Using GitHub CLI (Recommended - Easiest)

If you have GitHub CLI installed:

```powershell
# Login to GitHub
gh auth login

# Follow the prompts:
# - Choose GitHub.com
# - Choose HTTPS or SSH
# - Authenticate via browser or token
```

After logging in, you can create and push to repos easily:
```powershell
gh repo create agriconnect-beta --public --source=. --remote=origin --push
```

## Option 2: Using Git Credential Manager (Windows)

Git Credential Manager should be installed with Git for Windows:

1. When you push for the first time, Windows will prompt for credentials
2. Use your GitHub username
3. Use a Personal Access Token (not your password)

To create a Personal Access Token:
- Go to: https://github.com/settings/tokens
- Click "Generate new token (classic)"
- Give it a name (e.g., "Flutter Projects")
- Select scopes: `repo` (full control of private repositories)
- Click "Generate token"
- Copy the token (you won't see it again!)

## Option 3: Manual Setup

1. Configure git (if not done):
```powershell
git config --global user.name "tonkatsuu"
git config --global user.email "htetaungshine.sn@gmail.com"
```

2. Create repo on GitHub.com
3. Add remote and push:
```powershell
git remote add origin https://github.com/YOUR_USERNAME/agriconnect-beta.git
git branch -M main
git push -u origin main
```

When prompted for password, use your Personal Access Token.

