#!/bin/bash

# Deploy to Hostinger via FTP

echo "Deploying to Hostinger via FTP..."

# Check if required tools are installed
if ! command -v curl &> /dev/null; then
  echo "❌ Error: curl is not installed. Please install curl and try again."
  exit 1
fi

# Configuration
FTP_HOST="your-ftp-host.hostinger.com"
FTP_USER="your-ftp-username"
FTP_PASS="your-ftp-password"
FTP_DIR="/public_html"
LOCAL_DIR="./build"

# Check if configuration is set
if [ "$FTP_HOST" == "your-ftp-host.hostinger.com" ]; then
  echo "⚠️ Warning: FTP configuration not set. Please edit this script with your Hostinger FTP details."
  echo "Would you like to enter your FTP details now? (y/n)"
  read -r setup_now
  
  if [[ $setup_now =~ ^[Yy] ]]; then
    echo "Enter your Hostinger FTP host (e.g., ftp.yourdomain.com):"
    read -r FTP_HOST
    
    echo "Enter your FTP username:"
    read -r FTP_USER
    
    echo "Enter your FTP password:"
    read -rs FTP_PASS
    echo ""
    
    echo "Enter the remote directory (default: /public_html):"
    read -r temp_dir
    if [ -n "$temp_dir" ]; then
      FTP_DIR="$temp_dir"
    fi
    
    # Save configuration for future use
    echo "Would you like to save these settings for future deployments? (y/n)"
    read -r save_config
    
    if [[ $save_config =~ ^[Yy] ]]; then
      # Create a config file with the FTP details
      cat > ./.ftp-config << EOL
FTP_HOST="$FTP_HOST"
FTP_USER="$FTP_USER"
FTP_PASS="$FTP_PASS"
FTP_DIR="$FTP_DIR"
EOL
      chmod 600 ./.ftp-config
      echo "✅ FTP configuration saved to .ftp-config"
    fi
  else
    echo "Deployment aborted. Please edit the script with your FTP details and try again."
    exit 1
  fi
fi

# Load configuration from file if it exists
if [ -f "./.ftp-config" ]; then
  source ./.ftp-config
fi

# Check if build directory exists
if [ ! -d "$LOCAL_DIR" ]; then
  echo "❌ Error: Build directory not found. Run 'npm run build:prod' first."
  exit 1
fi

# Create a temporary file for FTP commands
FTP_COMMANDS=$(mktemp)

# Write FTP commands to the temporary file
cat > "$FTP_COMMANDS" << EOL
open $FTP_HOST
user $FTP_USER $FTP_PASS
cd $FTP_DIR
mkdir css
mkdir js
mkdir media
mkdir static
mkdir static/css
mkdir static/js
mkdir static/media
EOL

# Add commands to upload files
find "$LOCAL_DIR" -type f | while read -r file; do
  # Get the relative path
  rel_path="${file#$LOCAL_DIR/}"
  echo "put \"$file\" \"$rel_path\"" >> "$FTP_COMMANDS"
done

echo "quit" >> "$FTP_COMMANDS"

# Execute FTP commands
echo "Uploading files to Hostinger..."
ftp -n < "$FTP_COMMANDS"

# Check if FTP command was successful
if [ $? -ne 0 ]; then
  echo "❌ Error: FTP upload failed."
  rm "$FTP_COMMANDS"
  exit 1
fi

# Clean up
rm "$FTP_COMMANDS"

echo "✅ Deployment to Hostinger complete!"