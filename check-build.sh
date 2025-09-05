#!/bin/bash

# Check if the production build is ready for deployment

echo "Checking build for deployment readiness..."

# Check if build directory exists
if [ ! -d "./build" ]; then
  echo "❌ Error: Build directory not found. Run 'npm run build:prod' first."
  exit 1
fi

# Check for index.html
if [ ! -f "./build/index.html" ]; then
  echo "❌ Error: index.html not found in build directory."
  exit 1
fi

# Check for .htaccess
if [ ! -f "./build/.htaccess" ]; then
  echo "⚠️ Warning: .htaccess not found in build directory. Copying from public directory..."
  if [ -f "./public/.htaccess" ]; then
    cp ./public/.htaccess ./build/
    echo "✅ .htaccess copied to build directory."
  else
    echo "❌ Error: .htaccess not found in public directory."
    exit 1
  fi
fi

# Check for static directory
if [ ! -d "./build/static" ]; then
  echo "❌ Error: static directory not found in build directory."
  exit 1
fi

# Check for JS and CSS files
JS_COUNT=$(find ./build/static/js -name "*.js" | wc -l)
CSS_COUNT=$(find ./build/static/css -name "*.css" | wc -l)

if [ "$JS_COUNT" -eq 0 ]; then
  echo "❌ Error: No JavaScript files found in build/static/js."
  exit 1
fi

if [ "$CSS_COUNT" -eq 0 ]; then
  echo "❌ Error: No CSS files found in build/static/css."
  exit 1
fi

echo "✅ Build directory structure looks good."

# Check for environment variables in the build
if grep -q "REACT_APP_API_URL" ./build/static/js/*.js; then
  echo "✅ Environment variables found in the build."
else
  echo "⚠️ Warning: Environment variables might not be properly included in the build."
fi

# Check file sizes
echo "\nLargest files in the build directory:"
find ./build -type f -exec du -h {} \; | sort -hr | head -n 5

echo "\n✅ Build check complete. Your application is ready for deployment to Hostinger!"
echo "Run './deploy.sh' to prepare the files for upload."