# Get files from Main
echo "Get files from Main"
echo ${{ github.workspace }}
echo $GITHUB_WORKSPACE

# Replace file on VPS  
#scp -r [path]main.py root@68.183.15.232:/home/farm

# Restart the application after we've pulled in new code, otherwise we can be looking for what went wrong for quite a while..
# systemctl restart farm
