# Supabase Backend Setup Guide

This guide will help you set up your Supabase backend for the CQC Assessment application.

## Prerequisites

- Node.js and npm installed
- A Supabase account (free tier is sufficient)
- Basic understanding of SQL and database concepts

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: CQC Assessment App
   - **Database Password**: Choose a strong password
   - **Region**: Select closest to your users
5. Click "Create new project"
6. Wait for the project to be ready (usually 2-3 minutes)

## Step 2: Configure Environment Variables

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL**
   - **anon public key**

3. Update your `.env` file:
```env
REACT_APP_SUPABASE_URL=your_project_url_here
REACT_APP_SUPABASE_ANON_KEY=your_anon_key_here
```

## Step 3: Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy and paste the contents of `database/schema.sql`
4. Click "Run" to execute the schema
5. Verify tables are created in **Table Editor**

## Step 4: Seed Initial Data

1. In the **SQL Editor**, create another new query
2. Copy and paste the contents of `database/seed-data.sql`
3. Click "Run" to populate quality statements and templates
4. Verify data in **Table Editor** → **quality_statements**

## Step 5: Configure Storage

1. Go to **Storage** in your Supabase dashboard
2. Create the following buckets:
   - **evidence** (for assessment evidence files)
   - **report-exports** (for generated reports)
   - **user-avatars** (for user profile pictures)

3. Set bucket policies:
   - For **evidence** bucket:
     ```sql
     -- Allow authenticated users to upload files
     CREATE POLICY "Users can upload evidence" ON storage.objects
     FOR INSERT WITH CHECK (auth.role() = 'authenticated');
     
     -- Allow users to view evidence for their assessments
     CREATE POLICY "Users can view evidence" ON storage.objects
     FOR SELECT USING (auth.role() = 'authenticated');
     ```
   
   - For **report-exports** bucket:
     ```sql
     -- Allow authenticated users to upload reports
     CREATE POLICY "Users can upload reports" ON storage.objects
     FOR INSERT WITH CHECK (auth.role() = 'authenticated');
     
     -- Allow users to download their reports
     CREATE POLICY "Users can download reports" ON storage.objects
     FOR SELECT USING (auth.role() = 'authenticated');
     ```

## Step 6: Configure Authentication

1. Go to **Authentication** → **Settings**
2. Configure the following:
   - **Site URL**: `http://localhost:3000` (for development)
   - **Redirect URLs**: Add `http://localhost:3000/auth/callback`

3. Enable email confirmation (recommended):
   - Go to **Authentication** → **Settings** → **Email**
   - Enable "Confirm email"
   - Customize email templates if desired

## Step 7: Set Up Row Level Security (RLS)

The schema includes RLS policies, but verify they're active:

1. Go to **Authentication** → **Policies**
2. Ensure policies are enabled for all tables
3. Test policies work correctly

## Step 8: Configure Real-time (Optional)

1. Go to **Database** → **Replication**
2. Enable real-time for the following tables:
   - `assessments`
   - `assessment_responses`
   - `evidence`
   - `collaborations`

## Step 9: Test Your Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start the development server:
   ```bash
   npm start
   ```

3. Run the integration tests:
   ```javascript
   // In browser console or create a test page
   import backendTests from './src/tests/backendIntegration.test.js';
   backendTests.runAllTests();
   ```

## Step 10: Production Configuration

When deploying to production:

1. Update environment variables:
   ```env
   REACT_APP_SUPABASE_URL=your_production_url
   REACT_APP_SUPABASE_ANON_KEY=your_production_key
   ```

2. Update authentication settings:
   - **Site URL**: Your production domain
   - **Redirect URLs**: Your production callback URLs

3. Review and tighten RLS policies if needed

4. Set up database backups in Supabase dashboard

## Troubleshooting

### Common Issues

**1. "Invalid API key" error**
- Check your environment variables are correct
- Ensure `.env` file is in the project root
- Restart your development server after changing `.env`

**2. "Table doesn't exist" error**
- Verify the schema was applied correctly
- Check for SQL errors in the Supabase logs
- Ensure you're connected to the right project

**3. "Permission denied" error**
- Check RLS policies are configured correctly
- Verify user authentication is working
- Review table permissions in Supabase dashboard

**4. Real-time not working**
- Ensure real-time is enabled for relevant tables
- Check browser console for WebSocket errors
- Verify authentication is working

**5. File upload issues**
- Check storage buckets are created
- Verify storage policies are configured
- Ensure file size limits are appropriate

### Getting Help

- Check the [Supabase Documentation](https://supabase.com/docs)
- Visit the [Supabase Community](https://github.com/supabase/supabase/discussions)
- Review application logs in browser console
- Check Supabase project logs in dashboard

## Security Best Practices

1. **Never expose service role keys** in client-side code
2. **Use RLS policies** to secure data access
3. **Validate user input** before database operations
4. **Regularly review** authentication and authorization settings
5. **Monitor** database activity and user access patterns
6. **Keep dependencies updated** for security patches

## Performance Optimization

1. **Add database indexes** for frequently queried columns
2. **Use connection pooling** for high-traffic applications
3. **Implement caching** for static data like quality statements
4. **Optimize queries** to reduce database load
5. **Use CDN** for file storage in production

## Backup and Recovery

1. **Enable automatic backups** in Supabase dashboard
2. **Export data regularly** for additional safety
3. **Test restore procedures** periodically
4. **Document recovery processes** for your team

---

## Next Steps

Once your Supabase backend is set up and tested:

1. Customize the quality statements for your specific needs
2. Configure user roles and permissions
3. Set up monitoring and alerting
4. Plan for scaling as your user base grows
5. Implement additional features like audit logging

Your CQC Assessment application backend is now ready for development and testing!