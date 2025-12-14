# Setting Up GitHub Repository

## Step 1: Configure Git (One-time setup)

Run the setup script:
```powershell
.\setup_git.ps1
```

Or manually configure:
```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `agriconnect-beta` (or any name you prefer)
3. Description: "AgriConnect Beta - AR Crop Guidance and Smart Alerts"
4. Choose Public or Private
5. **IMPORTANT**: Do NOT check:
   - ❌ Add a README file
   - ❌ Add .gitignore
   - ❌ Choose a license
   
   (We already have these files)

6. Click "Create repository"

## Step 3: Push to GitHub

After creating the repository, GitHub will show you commands. Use these:

```powershell
# Navigate to project
cd "C:\Users\fenfe\Documents\Taylors BCS Programme\Sem 4\HCI GA2 BetaVersion"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/agriconnect-beta.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

## Alternative: Using SSH (if you have SSH keys set up)

```powershell
git remote add origin git@github.com:YOUR_USERNAME/agriconnect-beta.git
git branch -M main
git push -u origin main
```

## Troubleshooting

If you get authentication errors:
- Use a Personal Access Token instead of password
- Go to GitHub Settings → Developer settings → Personal access tokens → Generate new token
- Use the token as your password when pushing

