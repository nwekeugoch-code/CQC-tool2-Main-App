#!/bin/bash

# Upload .htaccess file to fix 403 error
echo "Uploading .htaccess file to Hostinger..."

# FTP credentials
FTP_HOST="82.25.113.100"
FTP_USER="u753569314"
FTP_PASS="Isilove@12"
REMOTE_DIR="public_html"

# Check if .htaccess file exists
if [ ! -f ".htaccess" ]; then
    echo "Error: .htaccess file not found!"
    exit 1
fi

echo "Uploading .htaccess to $FTP_HOST..."

# Upload .htaccess file
curl -T ".htaccess" "ftp://$FTP_HOST/$REMOTE_DIR/" --user "$FTP_USER:$FTP_PASS" --ftp-create-dirs

if [ $? -eq 0 ]; then
    echo "✅ .htaccess file uploaded successfully!"
    echo ""
    echo "The .htaccess file has been uploaded to fix the 403 error."
    echo "This file configures:"
    echo "- URL rewriting for React Router"
    echo "- Security headers"
    echo "- Caching rules"
    echo "- Gzip compression"
    echo ""
    echo "Please try accessing your website again."
else
    echo "❌ Failed to upload .htaccess file"
    exit 1
fi