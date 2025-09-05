#!/bin/bash

# Fix 403 Forbidden Error on Hostinger
# This script addresses common causes of 403 errors for React apps

echo "🔧 Hostinger 403 Error Troubleshooting Tool"
echo "============================================"
echo ""

# Hostinger FTP Configuration
FTP_HOST="82.25.113.100"
FTP_USER="u753569314"
FTP_PASS="Isilove@12"
FTP_DIR="public_html"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Common causes of 403 errors on Hostinger:${NC}"
echo "1. Missing or incorrect .htaccess file"
echo "2. Wrong file permissions (should be 644 for files, 755 for directories)"
echo "3. Missing index.html file"
echo "4. Incorrect domain DNS settings"
echo "5. CDN caching issues"
echo ""

echo -e "${YELLOW}🔍 Step 1: Checking if .htaccess exists locally...${NC}"
if [ -f ".htaccess" ]; then
    echo -e "${GREEN}✅ .htaccess file found locally${NC}"
else
    echo -e "${RED}❌ .htaccess file missing locally${NC}"
    echo "Creating .htaccess file..."
    cat > .htaccess << 'EOF'
# Apache configuration for React SPA
RewriteEngine On

# Handle React Router
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]

# Security headers
<IfModule mod_headers.c>
    Header always set X-Content-Type-Options nosniff
    Header always set X-XSS-Protection "1; mode=block"
    Header always set X-Frame-Options DENY
</IfModule>

# Cache static assets
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 week"
    ExpiresByType application/javascript "access plus 1 week"
    ExpiresByType image/png "access plus 1 month"
    ExpiresByType text/html "access plus 0 seconds"
</IfModule>

# Set default charset
AddDefaultCharset UTF-8
EOF
    echo -e "${GREEN}✅ .htaccess file created${NC}"
fi

echo ""
echo -e "${YELLOW}🔍 Step 2: Uploading/Re-uploading .htaccess file...${NC}"
curl -T ".htaccess" "ftp://$FTP_HOST/$FTP_DIR/" --user "$FTP_USER:$FTP_PASS" --ftp-create-dirs

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ .htaccess uploaded successfully${NC}"
else
    echo -e "${RED}❌ Failed to upload .htaccess${NC}"
fi

echo ""
echo -e "${YELLOW}🔍 Step 3: Checking if index.html exists in build...${NC}"
if [ -f "build/index.html" ]; then
    echo -e "${GREEN}✅ index.html found in build directory${NC}"
    echo "Re-uploading index.html to ensure it's properly deployed..."
    curl -T "build/index.html" "ftp://$FTP_HOST/$FTP_DIR/" --user "$FTP_USER:$FTP_PASS"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ index.html uploaded successfully${NC}"
    else
        echo -e "${RED}❌ Failed to upload index.html${NC}"
    fi
else
    echo -e "${RED}❌ index.html missing in build directory${NC}"
    echo "You need to run 'npm run build:prod' first"
fi

echo ""
echo -e "${BLUE}📋 Manual Steps to Check:${NC}"
echo ""
echo "1. ${YELLOW}Check File Permissions in Hostinger File Manager:${NC}"
echo "   - Log into your Hostinger hPanel"
echo "   - Go to File Manager"
echo "   - Navigate to public_html"
echo "   - Right-click on files and set permissions:"
echo "     • Files: 644 (rw-r--r--)"
echo "     • Directories: 755 (rwxr-xr-x)"
echo ""
echo "2. ${YELLOW}Verify Domain DNS Settings:${NC}"
echo "   - In hPanel, go to DNS Zone Editor"
echo "   - Ensure A record points to correct IP"
echo "   - Check if domain is properly connected"
echo ""
echo "3. ${YELLOW}Clear CDN Cache (if enabled):${NC}"
echo "   - In hPanel, go to Speed > CDN"
echo "   - Temporarily disable CDN or purge cache"
echo ""
echo "4. ${YELLOW}Check Error Logs:${NC}"
echo "   - In hPanel, go to Advanced > Error Logs"
echo "   - Look for specific error messages"
echo ""
echo "5. ${YELLOW}Test Direct File Access:${NC}"
echo "   - Try accessing: yourdomain.com/index.html"
echo "   - Try accessing: yourdomain.com/static/css/"
echo ""
echo -e "${GREEN}🎯 Most Common Solution:${NC}"
echo "The issue is usually file permissions. In Hostinger File Manager:"
echo "1. Select all files in public_html"
echo "2. Right-click > Permissions"
echo "3. Set to 644 for files, 755 for folders"
echo "4. Apply recursively"
echo ""
echo -e "${BLUE}💡 If still not working:${NC}"
echo "Contact Hostinger support with these details:"
echo "- Domain name"
echo "- Error: 403 Forbidden"
echo "- Mention it's a React SPA with .htaccess for routing"
echo "- Ask them to check file permissions and DNS settings"