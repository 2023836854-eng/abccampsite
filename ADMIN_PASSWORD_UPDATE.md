# Admin Password Update Notice

## Important: Admin Password Storage Changed

As per requirements, admin passwords are now stored in **plain text** (not encrypted) in the database.

### Default Admin Credentials

- **Username:** admin
- **Password:** admin123

- **Username:** staff1  
- **Password:** staff123

### Database Update Required

If you have an existing database, you need to update the admin passwords to plain text:

```sql
-- Update existing admin passwords to plain text
UPDATE admins SET password = 'admin123' WHERE username = 'admin';
UPDATE admins SET password = 'staff123' WHERE username = 'staff1';
```

### Login Process

1. Navigate to the main login page
2. Click on the "Admin Login" button below the login form
3. Enter your admin username and password
4. Access the admin dashboard and management features

### Security Note

**WARNING:** Storing passwords in plain text is a security risk and is NOT recommended for production environments. This implementation follows the specific requirements provided but should be reconsidered for any real-world deployment.
