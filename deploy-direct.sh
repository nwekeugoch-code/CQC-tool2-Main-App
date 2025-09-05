#!/bin/bash

# Deploy CQC Assessment Tool to Hostinger via FTP using curl (non-interactive)

echo "🚀 Deploying CQC Assessment Tool to Hostinger using curl..."

# Hostinger FTP Configuration
FTP_HOST="82.25.113.100"
FTP_USER="u753569314"
FTP_PASS="Isilove@12"
FTP_PORT="21"
FTP_DIR="public_html"
LOCAL_DIR="./build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if build directory exists
if [ ! -d "$LOCAL_DIR" ]; then
  echo -e "${RED}❌ Error: Build directory not found at $LOCAL_DIR${NC}"
  exit 1
fi

echo -e "${BLUE}📁 Uploading files from $LOCAL_DIR to $FTP_HOST/$FTP_DIR${NC}"
echo -e "${YELLOW}📊 This may take a few minutes depending on your connection speed...${NC}"
echo ""

# Upload all files
failed_uploads=0
total_files=0

# Count total files
total_files=$(find "$LOCAL_DIR" -type f | wc -l | tr -d ' ')
echo -e "${BLUE}📊 Total files to upload: $total_files${NC}"
echo ""

current_file=0

# Upload files recursively
find "$LOCAL_DIR" -type f | while read -r file; do
  current_file=$((current_file + 1))
  
  # Get the relative path
  rel_path="${file#$LOCAL_DIR/}"
  
  echo -e "${BLUE}[$current_file/$total_files]${NC} Uploading: $rel_path"
  
  # Upload the file
  curl -T "$file" \
    --ftp-create-dirs \
    --user "$FTP_USER:$FTP_PASS" \
    --silent \
    --show-error \
    "ftp://$FTP_HOST:$FTP_PORT/$FTP_DIR/$rel_path"
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Success: $rel_path${NC}"
  else
    echo -e "${RED}❌ Failed: $rel_path${NC}"
    failed_uploads=$((failed_uploads + 1))
  fi
  
  # Small delay to avoid overwhelming the server
  sleep 0.1
done

echo ""
echo -e "${BLUE}📋 Upload Summary:${NC}"
echo -e "${GREEN}✅ Total files: $total_files${NC}"

if [ $failed_uploads -eq 0 ]; then
  echo -e "${GREEN}🎉 All files uploaded successfully!${NC}"
  echo ""
  echo -e "${GREEN}✅ Deployment to Hostinger completed successfully!${NC}"
  echo -e "${GREEN}🌐 Your CQC Assessment Tool should now be available at your domain${NC}"
  echo ""
  echo -e "${BLUE}📋 Post-deployment checklist:${NC}"
  echo "   1. Visit your website to verify it's working"
  echo "   2. Test the login functionality (configure Supabase first)"
  echo "   3. Ensure all static assets are loading correctly"
  echo "   4. Check that routing works for all pages"
  echo ""
  echo -e "${YELLOW}💡 Important Notes:${NC}"
  echo "   - Update .env.production with your actual Supabase credentials"
  echo "   - Configure your domain DNS settings if needed"
  echo "   - Set up SSL certificate in Hostinger control panel"
  echo "   - Test all functionality before going live"
else
  echo -e "${RED}❌ $failed_uploads files failed to upload${NC}"
  echo -e "${YELLOW}⚠️  Please check your FTP credentials and try again${NC}"
  exit 1
fi