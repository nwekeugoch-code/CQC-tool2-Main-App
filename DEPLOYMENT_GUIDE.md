# Qualistat Auditor Deployment Guide

## Deploying to Hostinger

This guide provides step-by-step instructions for deploying the Qualistat Auditor application to Hostinger shared hosting.

### Prerequisites

- A Hostinger hosting account
- Node.js and npm installed on your local development machine
- FTP client (like FileZilla) or access to Hostinger's File Manager

### Step 1: Prepare Your Application

1. Ensure all your code changes are committed and working correctly in your local environment.
2. Update the API URL in `.env.production` to point to your backend API:
   ```
   REACT_APP_API_URL=https://your-api-domain.com/api
   ```

### Step 2: Build the Application

1. Run the build script to create an optimized production build:
   ```bash
   npm run build
   ```
   This will create a `build` folder with all the static files needed for deployment.

2. Alternatively, use the provided deployment script:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```
   This script will build the application and prepare the files for deployment.

### Step 3: Upload to Hostinger

#### Option 1: Using File Manager

1. Log in to your Hostinger control panel
2. Navigate to the File Manager
3. Go to the `public_html` directory
4. Upload all files from your local `build` directory to the `public_html` directory
5. Ensure the `.htaccess` file is uploaded correctly

#### Option 2: Using FTP

1. Connect to your Hostinger hosting using an FTP client with the credentials provided by Hostinger
2. Navigate to the `public_html` directory on the remote server
3. Upload all files from your local `build` directory to the `public_html` directory
4. Ensure the `.htaccess` file is uploaded correctly

### Step 4: Configure Domain and SSL

1. If you haven't already, set up your domain in the Hostinger control panel
2. Enable SSL for your domain to ensure secure HTTPS connections
3. If using a subdomain for your API, make sure it's properly configured

### Step 5: Test Your Deployment

1. Visit your website URL to ensure the application loads correctly
2. Test all major functionality to verify everything works in the production environment
3. Check for any console errors that might indicate issues with API connections or resources

### Troubleshooting

#### Application Shows Blank Page

- Check if all files were uploaded correctly
- Verify the `.htaccess` file is present and has the correct content
- Look for JavaScript errors in the browser console

#### API Connection Issues

- Verify the API URL in `.env.production` is correct
- Ensure your API server is running and accessible
- Check for CORS issues if your API is on a different domain

#### Routing Problems

- Make sure the `.htaccess` file is properly uploaded and configured
- Test direct navigation to different routes to ensure they work

### Automated Deployment

For more efficient deployments, you can modify the `deploy.sh` script to include FTP credentials and automate the upload process. Uncomment and configure the FTP section in the script.

### Additional Resources

- [Hostinger Knowledge Base](https://support.hostinger.com/en)
- [React Deployment Documentation](https://create-react-app.dev/docs/deployment/)

## Backend API Deployment

If you're also deploying the backend API to Hostinger:

1. Check if your hosting plan supports the backend technology (Node.js, PHP, etc.)
2. Follow the specific deployment instructions for your backend framework
3. Configure environment variables for the production environment
4. Set up any necessary databases
5. Update the frontend configuration to point to the deployed API

---

For any questions or issues with deployment, please contact the development team.