# ABC Campsite Booking System

A comprehensive campsite booking and management system built with Java EE (JSP, Servlets), MySQL, and modern web technologies.

> 📚 **[View Complete Documentation Index](DOCUMENTATION_INDEX.md)** | **[Quota Update Guide](ANSWER_QUOTA_UPDATE.md)**

## 🌟 Features

### Guest Features
- ✅ User registration
- ✅ Secure login
- ✅ Password reset functionality
- ✅ Browse available campsites and rooms
- ✅ Book campsites with multiple room options
- ✅ Secure payment processing
- ✅ View booking history with status tracking
- ✅ Cancel bookings (with conditions)
- ✅ Download/print booking receipts

### Admin Features
- ✅ Secure admin login (separate from guest)
- ✅ Comprehensive dashboard with charts and statistics
- ✅ Manage all bookings (view, update status, cancel)
- ✅ Manage campsites (add, edit, delete, toggle active)
- ✅ Manage rooms (add, edit, delete, quota management)
- ✅ Filter and search capabilities
- ✅ View customer history and reports

## 🏗️ Architecture

### Technology Stack
- **Backend:** Java 8+, Java EE (Servlets, JSP)
- **Database:** MySQL 8.0+
- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5
- **Charts:** Chart.js
- **Icons:** Font Awesome 6

### Project Structure
```
abccampsite/
├── database/
│   ├── schema.sql              # Complete database schema
│   ├── sample_data.sql         # Sample/test data
│   └── migration_from_old.sql  # Migration script
├── src/main/
│   ├── java/
│   │   ├── dao/               # Data Access Objects
│   │   │   ├── GuestDAO.java
│   │   │   ├── AdminDAO.java
│   │   │   ├── BookingDAO.java
│   │   │   ├── PaymentDAO.java
│   │   │   ├── CampsiteDAO.java
│   │   │   ├── RoomDAO.java
│   │   │   └── PasswordResetDAO.java
│   │   ├── model/             # Java Beans
│   │   │   ├── Guest.java
│   │   │   ├── Admin.java
│   │   │   ├── Booking.java
│   │   │   ├── Payment.java
│   │   │   ├── Campsite.java
│   │   │   ├── AvailableRoom.java
│   │   │   └── PasswordReset.java
│   │   ├── servlet/           # Controllers
│   │   │   ├── RegisterServlet.java
│   │   │   ├── LoginServlet.java
│   │   │   ├── AdminLoginServlet.java
│   │   │   ├── BookingServlet.java
│   │   │   ├── PaymentServlet.java
│   │   │   ├── UpdateBookingServlet.java
│   │   │   ├── PasswordResetServlet.java
│   │   │   ├── ResetPasswordServlet.java
│   │   │   └── admin/
│   │   │       ├── DashboardServlet.java
│   │   │       ├── ManageBookingServlet.java
│   │   │       ├── ManageCampsiteServlet.java
│   │   │       └── ManageRoomServlet.java
│   │   ├── filter/            # Security Filters
│   │   │   ├── AuthenticationFilter.java
│   │   │   └── AdminAuthFilter.java
│   │   └── utils/             # Utilities
│   │       ├── DBConnection.java
│   │       ├── EmailUtil.java
│   │       ├── ValidationUtil.java
│   │       ├── BookingIdGenerator.java
│   │       └── SessionUtil.java
│   └── webapp/
│       ├── admin/             # Admin panel pages
│       │   ├── login.jsp
│       │   ├── dashboard.jsp
│       │   ├── manageBooking.jsp
│       │   ├── manageCampsite.jsp
│       │   ├── manageRoom.jsp
│       │   └── ...
│       ├── register.jsp
│       ├── login.jsp
│       ├── forgot-password.jsp
│       ├── reset-password.jsp
│       ├── receipt.jsp
│       └── ...
└── README.md
```

## 📊 Database Schema

The system uses 8 main tables:

1. **guests** - Guest/customer accounts
2. **admins** - Admin/staff accounts
3. **campsites** - Campsite locations
4. **available_rooms** - Rooms/areas within campsites
5. **bookings** - Booking records
6. **payments** - Payment transactions
7. **password_resets** - Password reset tokens
8. **booking_rooms** - Junction table for booking-room relationships

See `database/schema.sql` for complete schema details.

## 🚀 Setup Instructions

### Prerequisites
- Java Development Kit (JDK) 8 or higher
- Apache Tomcat 9.0 or higher
- MySQL 8.0 or higher
- XAMPP (optional, includes MySQL and Apache)

### Database Setup

1. **Create the database:**
   ```sql
   CREATE DATABASE abccampsite;
   ```

2. **Import the schema:**
   ```bash
   mysql -u root -p abccampsite < database/schema.sql
   ```

3. **Import sample data (optional for testing):**
   ```bash
   mysql -u root -p abccampsite < database/sample_data.sql
   ```

4. **Update database connection:**
   Edit `src/main/java/utils/DBConnection.java` if needed:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/abccampsite";
   private static final String USER = "root";
   private static final String PASS = "";  // Your MySQL password
   ```

### Application Deployment

1. **Configure your IDE (Eclipse/IntelliJ):**
   - Import project as Java Web Application
   - Add Tomcat server
   - Add MySQL Connector/J library to build path

2. **Build the project:**
   - Clean and build the project
   - Ensure no compilation errors

3. **Deploy to Tomcat:**
   - Right-click project → Run on Server
   - Select Apache Tomcat
   - Access at: `http://localhost:8080/abccampsite/`

## 🔐 Default Credentials

After importing sample data:

**Admin Account:**
- Username: `admin`
- Password: `admin123`

**Sample Guest Account:**
- IC: `900101011234`
- Password: `password123`

**⚠️ IMPORTANT:** Change these credentials in production!

## 📝 Usage Guide

### For Guests

1. **Registration:**
   - Navigate to Register page
   - Fill in: Name, IC, Email, Phone, DOB, Address, Password
   - Email must be unique
   - Password minimum 6 characters

2. **Login:**
   - Enter IC and Password
   - Click Login

3. **Booking:**
   - Browse available campsites
   - Select campsite and room
   - Choose dates and number of tents
   - Proceed to payment
   - Receive booking confirmation

4. **Manage Bookings:**
   - View booking history in dashboard
   - Check booking status
   - Cancel bookings (if pending/confirmed)
   - Download receipts

5. **Password Reset:**
   - Click "Forgot Password"
   - Enter email address
   - Check email for reset code
   - Use code and new password

### For Admins

1. **Login:**
   - Navigate to `/admin/login.jsp`
   - Or select "Admin" on main login page
   - Enter username and password

2. **Dashboard:**
   - View statistics and charts
   - Monitor recent bookings
   - Track revenue and occupancy

3. **Manage Bookings:**
   - View all bookings
   - Filter by status, date, campsite
   - Update booking status
   - Cancel bookings with reason

4. **Manage Campsites:**
   - Add new campsites
   - Edit existing campsites
   - Toggle active/inactive status
   - Delete unused campsites

5. **Manage Rooms:**
   - Add rooms to campsites
   - Edit room details (price, quota, description)
   - Update maximum quota (capacity)
   - Delete unused rooms
   - For detailed information on quota management, see [Quota Update Guide](QUOTA_UPDATE_GUIDE.md)

## 🔒 Security Features

- ✅ SQL injection prevention (PreparedStatements)
- ✅ XSS prevention (input sanitization)
- ✅ Session timeout (30 minutes)
- ✅ Authentication filters for protected pages
- ✅ Role-based access control (guest vs admin)

## 🧪 Testing

### Booking Status Flow
```
Pending → Confirmed → Ongoing → Completed
   ↓
Cancelled
```

### Payment Status Flow
```
Unpaid → Paid
   ↓
Refunded (for cancelled bookings)
```

## 📧 Email Configuration

Email functionality is currently in development mode (console output).

To enable actual email sending:
1. Edit `src/main/java/utils/EmailUtil.java`
2. Configure SMTP settings
3. Uncomment JavaMail implementation
4. Add JavaMail library to classpath

## 🐛 Troubleshooting

**Database Connection Error:**
- Check MySQL is running
- Verify database credentials in DBConnection.java
- Ensure database `abccampsite` exists

**404 Error on Servlets:**
- Check servlet URL mappings
- Rebuild and redeploy application
- Clear Tomcat work directory

**Session Timeout:**
- Sessions expire after 30 minutes
- User will be redirected to login

## 📄 License

This project is created for educational purposes (university assignment).

## 👥 Contributors

- FARIS - RON HENSEM - AWEK RON
- ABC Campsite Development Team

## 📞 Support

For issues or questions, please contact the development team or refer to the project documentation:
- [Admin Navigation Guide](ADMIN_NAVIGATION_GUIDE.md) - Admin panel navigation and troubleshooting
- [Quota Update Guide](QUOTA_UPDATE_GUIDE.md) - Detailed guide on managing room quotas
- General admin features documentation
