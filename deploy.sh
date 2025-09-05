#!/bin/bash

# Qualistat Auditor Deployment Script for Hostinger

echo "Starting deployment process for Qualistat Auditor..."

# Build the React application
echo "Building React application..."
npm run build

if [ $? -ne 0 ]; then
  echo "Build failed! Aborting deployment."
  exit 1
fi

echo "Build successful!"

# Prepare for deployment
echo "Preparing files for deployment..."

# Create a deployment directory if it doesn't exist
DEPLOY_DIR="./deploy"
mkdir -p $DEPLOY_DIR

# Copy build files to deployment directory
cp -r ./build/* $DEPLOY_DIR/

# Copy .htaccess to deployment directory if not already included
if [ ! -f "$DEPLOY_DIR/.htaccess" ]; then
  cp ./public/.htaccess $DEPLOY_DIR/
fi

echo "Files prepared for deployment."

# Instructions for manual upload to Hostinger
echo ""
echo "=== DEPLOYMENT INSTRUCTIONS ==="
echo "To deploy to Hostinger:"
echo "1. Log in to your Hostinger account"
echo "2. Navigate to File Manager or use FTP"
echo "3. Upload all files from the '$DEPLOY_DIR' directory to your public_html folder"
echo "4. Ensure .htaccess file is properly uploaded"
echo "5. Set proper permissions (usually 644 for files and 755 for directories)"
echo ""
echo "For automated deployment, configure FTP credentials in this script."
echo "=== END INSTRUCTIONS ==="

# Uncomment and configure for automated FTP deployment
# echo "Uploading files to Hostinger via FTP..."
# HOST="your-ftp-host.hostinger.com"
# USER="your-ftp-username"
# PASS="your-ftp-password"
# REMOTE_DIR="/public_html"
# 
# ftp -n $HOST << EOF
# quote USER $USER
# quote PASS $PASS
# binary
# cd $REMOTE_DIR
# mput $DEPLOY_DIR/*
# quit
# EOF
# 
# if [ $? -ne 0 ]; then
#   echo "FTP upload failed!"
#   exit 1
# fi
# 
# echo "Files successfully uploaded to Hostinger!"

echo "Deployment preparation complete!"