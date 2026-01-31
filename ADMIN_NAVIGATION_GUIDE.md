# Admin Navigation Guide

## Overview
This guide explains the admin navigation system and how to troubleshoot any issues.

## Admin Navigation Architecture

### Authentication Flow
1. Admin navigates to `/admin/login.jsp`
2. Submits credentials to `/AdminLoginServlet`
3. `AdminLoginServlet` validates credentials using `AdminDAO.login(username, password)`
4. If successful, sets admin session via `SessionUtil.setAdminSession()`
5. Redirects to `/admin/DashboardServlet`

### Session Management
The admin session is managed through `SessionUtil` which sets the following session attributes:
- `userType`: "admin"
- `adminId`: Admin's ID from database
- `adminUsername`: Admin's username
- `adminName`: Admin's full name
- `adminRole`: Admin's role

### Security Filter
`AdminAuthFilter` protects all `/admin/*` URLs except:
- `/admin/login.jsp` (public)

The filter checks if:
1. Admin is logged in via `SessionUtil.isAdminLoggedIn(request)`
2. If not, redirects to `/admin/login.jsp?msg=login_required`

## Admin Pages and Servlets

### Dashboard
- **URL**: `/admin/DashboardServlet`
- **Servlet**: `servlet.admin.DashboardServlet`
- **Mapping**: `@WebServlet("/admin/DashboardServlet")`
- **JSP**: `/admin/dashboard.jsp`
- **Features**: Statistics, charts, recent bookings

### Manage Bookings
- **URL**: `/admin/ManageBookingServlet`
- **Servlet**: `servlet.admin.ManageBookingServlet`
- **Mapping**: `@WebServlet("/admin/ManageBookingServlet")`
- **JSP**: `/admin/manageBooking.jsp`
- **Features**: View, filter, update booking status

### Manage Campsites
- **URL**: `/admin/ManageCampsiteServlet`
- **Servlet**: `servlet.admin.ManageCampsiteServlet`
- **Mapping**: `@WebServlet("/admin/ManageCampsiteServlet")`
- **JSP**: `/admin/manageCampsite.jsp`
- **Features**: Add, edit, delete, toggle active status

### Manage Rooms
- **URL**: `/admin/ManageRoomServlet`
- **Servlet**: `servlet.admin.ManageRoomServlet`
- **Mapping**: `@WebServlet("/admin/ManageRoomServlet")`
- **JSP**: `/admin/manageRoom.jsp`
- **Features**: Add, edit, delete rooms for campsites

## Sidebar Navigation

The sidebar is implemented in `/admin/sidebar.jsp` and included in all admin pages. It contains:

```jsp
<a href="${pageContext.request.contextPath}/admin/DashboardServlet">Dashboard</a>
<a href="${pageContext.request.contextPath}/admin/ManageBookingServlet">Manage Bookings</a>
<a href="${pageContext.request.contextPath}/admin/ManageCampsiteServlet">Manage Campsites</a>
<a href="${pageContext.request.contextPath}/admin/ManageRoomServlet">Manage Rooms</a>
```

## Common Issues and Solutions

### Issue 1: "Only Dashboard Works, Other Links Don't"

**Possible Causes:**
1. **Database Connection Issue**: Management pages require database access
   - Check if MySQL is running
   - Verify database credentials in `DBConnection.java`
   - Check if database `abccampsite` exists and has data

2. **Servlet Compilation Issue**: Servlets might not be compiled
   - Clean and rebuild the project
   - Check Tomcat logs for compilation errors
   - Verify all servlet files are in correct package structure

3. **Browser Console Errors**: JavaScript or resource loading issues
   - Open browser developer tools (F12)
   - Check Console tab for JavaScript errors
   - Check Network tab for failed resource requests

4. **Session Issues**: Admin session might not be properly set
   - Clear browser cookies and cache
   - Try logging out and logging back in
   - Check browser developer tools → Application → Cookies

### Issue 2: Links Show Login Page Instead

**Solution:**
- Admin session has expired (30 minute timeout)
- Login again to refresh session

### Issue 3: 404 Error on Servlet URLs

**Possible Causes:**
1. **Servlets Not Deployed**: 
   - Redeploy the application to Tomcat
   - Clear Tomcat work directory: `{TOMCAT_HOME}/work/Catalina/localhost/abccampsite`
   - Restart Tomcat

2. **Incorrect Context Path**:
   - Verify application is deployed at correct context path
   - Check `${pageContext.request.contextPath}` resolves correctly

### Issue 4: Blank Page or Error Message

**Troubleshooting Steps:**
1. Check Tomcat console/logs for stack traces
2. Check browser console for JavaScript errors
3. Verify database tables exist and have sample data
4. Check if DAO methods are working correctly

## Testing Admin Navigation

### Step-by-Step Test:

1. **Login Test**:
   ```
   URL: http://localhost:8080/abccampsite/admin/login.jsp
   Username: admin
   Password: admin123
   Expected: Redirect to Dashboard
   ```

2. **Dashboard Test**:
   ```
   URL: http://localhost:8080/abccampsite/admin/DashboardServlet
   Expected: Dashboard with statistics and charts
   Check: Do statistics load? Are charts displayed?
   ```

3. **Manage Bookings Test**:
   ```
   URL: http://localhost:8080/abccampsite/admin/ManageBookingServlet
   Expected: List of all bookings
   Check: Does the page load? Is the booking list displayed?
   ```

4. **Manage Campsites Test**:
   ```
   URL: http://localhost:8080/abccampsite/admin/ManageCampsiteServlet
   Expected: List of all campsites
   Check: Does the page load? Is the campsite list displayed?
   ```

5. **Manage Rooms Test**:
   ```
   URL: http://localhost:8080/abccampsite/admin/ManageRoomServlet
   Expected: List of all rooms
   Check: Does the page load? Is the room list displayed?
   ```

### What to Check in Browser Developer Tools:

1. **Console Tab**:
   - Look for JavaScript errors (red text)
   - Common errors: jQuery not loaded, Bootstrap not loaded

2. **Network Tab**:
   - Check if all resources load (status 200)
   - Look for 404 errors (file not found)
   - Look for 500 errors (server error)

3. **Application Tab → Cookies**:
   - Verify JSESSIONID cookie exists
   - Check cookie is for correct domain/path

## Database Requirements

All management pages require database access. Ensure:

1. **MySQL is running**:
   ```bash
   # Windows (XAMPP)
   XAMPP Control Panel → Start MySQL
   
   # Linux
   sudo service mysql start
   ```

2. **Database exists**:
   ```sql
   SHOW DATABASES;
   -- Should show 'abccampsite'
   ```

3. **Tables exist**:
   ```sql
   USE abccampsite;
   SHOW TABLES;
   -- Should show: admins, bookings, campsites, guests, etc.
   ```

4. **Sample data loaded** (for testing):
   ```bash
   mysql -u root -p abccampsite < database/sample_data.sql
   ```

## Deployment Checklist

Before testing admin navigation, ensure:

- [ ] MySQL server is running
- [ ] Database `abccampsite` exists
- [ ] Database schema is imported (`schema.sql`)
- [ ] Sample data is imported (`sample_data.sql`)
- [ ] Project is built without errors
- [ ] Tomcat server is running
- [ ] Application is deployed to Tomcat
- [ ] Context path is `/abccampsite`
- [ ] Can access main site: `http://localhost:8080/abccampsite/`
- [ ] Can access admin login: `http://localhost:8080/abccampsite/admin/login.jsp`

## Debugging Tips

### Enable Tomcat Logging:
Check Tomcat logs at:
- `{TOMCAT_HOME}/logs/catalina.out` (Linux/Mac)
- `{TOMCAT_HOME}/logs/catalina.{date}.log` (Windows)

### Add Debug Output to Servlets:
```java
System.out.println("DEBUG: ManageBookingServlet - doGet called");
System.out.println("DEBUG: Admin ID: " + SessionUtil.getAdminId(request));
System.out.println("DEBUG: Bookings found: " + bookings.size());
```

### Test Direct Servlet Access:
Instead of clicking sidebar links, try accessing servlets directly:
- `http://localhost:8080/abccampsite/admin/ManageBookingServlet`
- `http://localhost:8080/abccampsite/admin/ManageCampsiteServlet`
- `http://localhost:8080/abccampsite/admin/ManageRoomServlet`

## Conclusion

The admin navigation system is properly configured with:
- ✅ Correct servlet mappings
- ✅ Authentication filters
- ✅ Session management
- ✅ Sidebar navigation links

If management pages are not working, the issue is likely:
1. Database connectivity
2. Missing database data
3. Servlet compilation/deployment issues
4. Browser caching issues

Follow the troubleshooting steps above to diagnose and fix the specific issue.
