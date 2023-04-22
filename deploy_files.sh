# Navigate to repository on droplet
echo "Navigating to repository"
cd /home/cd_assignment

# Print current location
pwd

# Pull github code to here
echo "Git pull"
git pull

# Restart the application after we've pulled in new code
echo "restart application"
systemctl restart cd_assignment
