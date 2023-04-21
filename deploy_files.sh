# Get files from Main
echo "Get files from Main"
#echo ${{ github.workspace }}

# Replace file on VPS  
#scp -r [path]main.py root@68.183.15.232:/home/farm

# Pull github code to here
echo "Git pull"
git pull

# Restart the application after we've pulled in new code
echo "restart application"
systemctl restart farm
