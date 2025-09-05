# Hostinger Deployment Guide for Qualistat Auditor

## Overview

This guide provides specific instructions for deploying the Qualistat Auditor application to Hostinger shared hosting. Hostinger is a popular web hosting provider that offers affordable hosting solutions with good performance.

## Prerequisites

- A Hostinger hosting account (Premium or Business plan recommended for React applications)
- Domain name configured in Hostinger
- FTP access credentials for your Hostinger account

## Step 1: Prepare Your Hostinger Account

1. **Log in to your Hostinger control panel**

2. **Set up your domain**
   - If you haven't already, add your domain to your Hostinger account
   - Configure DNS settings if necessary

3. **Enable SSL**
   - Navigate to the SSL section in your Hostinger control panel
   - Enable SSL for your domain to ensure secure HTTPS connections
   - Choose "Let's Encrypt" for a free SSL certificate

## Step 2: Build Your Application

1. **Configure environment variables**
   - Edit the `.env.production` file to set your API URL:
     ```
     REACT_APP_API_URL=https://your-api-domain.com/api
     REACT_APP_ENV=production
     REACT_APP_VERSION=$npm_package_version
     ```

2. **Build the application**
   ```bash
   npm run build:prod
   ```
   This will create a `build` folder with all the static files needed for deployment.

## Step 3: Upload to Hostinger

### Option 1: Manual Upload via File Manager

1. **Log in to your Hostinger control panel**
2. **Navigate to the File Manager**
3. **Go to the `public_html` directory**
4. **Upload all files from your local `build` directory to the `public_html` directory**
   - You can upload files in batches or as a zip file and extract it on the server
5. **Ensure the `.htaccess` file is uploaded correctly**
   - If it's not visible, make sure to enable viewing hidden files in the File Manager

### Option 2: Upload via FTP

1. **Use the provided FTP deployment script**
   - Edit the `deploy-ftp.sh` script with your Hostinger FTP credentials
   - Run the script:
     ```bash
     ./deploy-ftp.sh
     ```

2. **Alternatively, use an FTP client like FileZilla**
   - Connect to your Hostinger server using the FTP credentials provided by Hostinger
   - Navigate to the `public_html` directory on the remote server
   - Upload all files from your local `build` directory to the `public_html` directory

## Step 4: Configure Hostinger for React Router

React applications using client-side routing need special configuration to work correctly. The `.htaccess` file included in the build handles this for Apache servers, which Hostinger uses.

Ensure the `.htaccess` file contains the following:

```apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-l
  RewriteRule . /index.html [L]
</IfModule>
```

## Step 5: Test Your Deployment

1. **Visit your website URL** to ensure the application loads correctly
2. **Test navigation** to different routes to verify that client-side routing works
3. **Test API connections** to ensure your application can communicate with your backend

## Hostinger-Specific Optimizations

### Enable Gzip Compression

Add the following to your `.htaccess` file to enable Gzip compression:

```apache
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/plain
  AddOutputFilterByType DEFLATE text/html
  AddOutputFilterByType DEFLATE text/xml
  AddOutputFilterByType DEFLATE text/css
  AddOutputFilterByType DEFLATE application/xml
  AddOutputFilterByType DEFLATE application/xhtml+xml
  AddOutputFilterByType DEFLATE application/rss+xml
  AddOutputFilterByType DEFLATE application/javascript
  AddOutputFilterByType DEFLATE application/x-javascript
  AddOutputFilterByType DEFLATE application/json
</IfModule>
```

### Configure Browser Caching

Add the following to your `.htaccess` file to enable browser caching:

```apache
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpg "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/gif "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType image/svg+xml "access plus 1 year"
  ExpiresByType text/css "access plus 1 month"
  ExpiresByType application/pdf "access plus 1 month"
  ExpiresByType text/x-javascript "access plus 1 month"
  ExpiresByType application/javascript "access plus 1 month"
  ExpiresByType application/x-javascript "access plus 1 month"
  ExpiresByType application/x-shockwave-flash "access plus 1 month"
  ExpiresByType image/x-icon "access plus 1 year"
  ExpiresDefault "access plus 2 days"
</IfModule>
```

## Troubleshooting

### 404 Errors on Page Refresh

If you get 404 errors when refreshing pages or accessing routes directly, check that:

1. The `.htaccess` file is properly uploaded to the root directory
2. Hostinger has mod_rewrite enabled (it should be by default)

### API Connection Issues

If your application cannot connect to your API:

1. Check that the API URL in `.env.production` is correct
2. Verify that your API server is running and accessible
3. Check for CORS issues if your API is on a different domain

### Performance Issues

If your application is loading slowly:

1. Consider upgrading your Hostinger plan for better performance
2. Enable Gzip compression and browser caching as described above
3. Optimize your build by analyzing bundle size with `npm run analyze`

## Additional Resources

- [Hostinger Knowledge Base](https://support.hostinger.com/en)
- [React Deployment Documentation](https://create-react-app.dev/docs/deployment/)

---

For any questions or issues with Hostinger deployment, please contact the development team.