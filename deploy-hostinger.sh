#!/bin/bash

# Deploy CQC Assessment Tool to Hostinger via FTP

echo "🚀 Deploying CQC Assessment Tool to Hostinger..."

# Hostinger FTP Configuration
FTP_HOST="82.25.113.100"
FTP_USER="u753569314"
FTP_PORT="21"
FTP_DIR="/public_html"
LOCAL_DIR="./build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if required tools are installed
if ! command -v lftp &> /dev/null; then
  echo -e "${YELLOW}⚠️  lftp not found. Attempting to install...${NC}"
  
  # Try to install lftp based on the system
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
      echo "Installing lftp via Homebrew..."
      brew install lftp
    else
      echo -e "${RED}❌ Error: Homebrew not found. Please install lftp manually: brew install lftp${NC}"
      exit 1
    fi
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt-get &> /dev/null; then
      sudo apt-get update && sudo apt-get install -y lftp
    elif command -v yum &> /dev/null; then
      sudo yum install -y lftp
    else
      echo -e "${RED}❌ Error: Please install lftp manually${NC}"
      exit 1
    fi
  else
    echo -e "${RED}❌ Error: Unsupported OS. Please install lftp manually${NC}"
    exit 1
  fi
fi

# Check if build directory exists
if [ ! -d "$LOCAL_DIR" ]; then
  echo -e "${RED}❌ Error: Build directory not found at $LOCAL_DIR${NC}"
  echo "Building the project first..."
  npm run build:prod
  
  if [ ! -d "$LOCAL_DIR" ]; then
    echo -e "${RED}❌ Error: Build failed. Please check the build process.${NC}"
    exit 1
  fi
fi

# Prompt for FTP password
echo "Enter your Hostinger FTP password:"
read -s FTP_PASS
echo ""

# Validate password is not empty
if [ -z "$FTP_PASS" ]; then
  echo -e "${RED}❌ Error: Password cannot be empty${NC}"
  exit 1
fi

echo "📁 Uploading files from $LOCAL_DIR to $FTP_HOST:$FTP_DIR"
echo "📊 This may take a few minutes depending on your connection speed..."

# Use lftp for more reliable FTP transfer
lftp -c "
set ftp:list-options -a;
set ftp:passive-mode true;
set ftp:ssl-allow no;
open ftp://$FTP_USER:$FTP_PASS@$FTP_HOST:$FTP_PORT;
cd $FTP_DIR;
lcd $LOCAL_DIR;
mirror --reverse --delete --verbose --exclude-glob .DS_Store --exclude-glob .git* .
bye
"

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Deployment to Hostinger completed successfully!${NC}"
  echo -e "${GREEN}🌐 Your CQC Assessment Tool should now be available at your domain${NC}"
  echo ""
  echo "📋 Post-deployment checklist:"
  echo "   1. Visit your website to verify it's working"
  echo "   2. Test the login functionality"
  echo "   3. Ensure all static assets are loading correctly"
  echo "   4. Check that routing works for all pages"
  echo ""
  echo "💡 Note: If you encounter issues, check:"
  echo "   - Your domain DNS settings"
  echo "   - Hostinger file permissions"
  echo "   - Environment variables configuration"
else
  echo -e "${RED}❌ Deployment failed. Please check your FTP credentials and try again.${NC}"
  exit 1
fi